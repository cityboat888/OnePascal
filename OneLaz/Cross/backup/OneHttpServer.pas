unit OneHttpServer;

{$mode DELPHI}{$H+}

interface

uses
  Classes, SysUtils, 
  
  Net.CrossSocket.Base,Net.CrossHttpServer,
  Net.CrossHttpParams,
  Utils.Logger,
 // mormot.Net.server, mormot.Net.http, mormot.Net.async,
//  mormot.core.os, mormot.Net.sock, mormot.core.buffers,
  oneILog, httpprotocol, URIParser,
  OneHttpConst,
  OneHttpCtxtResult, OneMultipart, OneFileHelper;

type
  TOneHttpServer = class
  private
    // HTTP服务是否启动
    FStarted: boolean;
    // 拒绝请求
    FStopRequest: boolean;
    // 绑定HTTP端口，默认9090
    FPort: integer;
    // 线程池 ThreadPoolCount<0 将使用单个线程来对其进行全部规则, =0将为每个连接创建一个线程,>0将利用线程池
    // 一般设定大于0用线程池性能最好
    FThreadPoolCount: integer;
    // 默认30000毫秒，即30秒 连接保持活动的时间
    FKeepAliveTimeOut: integer;
    // 队列默认1000,请求放进队列,然后有线程消费完成
    FHttpQueueLength: integer;
    FHttpServer: ICrossHttpServer;
   // FHttpServer: THttpServerSocketGeneric;
    // 错误消息
    FErrMsg: string;
    FLog: IOneLog;
  protected
    // 重写请求事件
    procedure OnConnected(const Sender: TObject; const AConnection: ICrossConnection);
    procedure OnDisconnected(const Sender: TObject; const AConnection: ICrossConnection);
    procedure OnReceived(const Sender: TObject; const AConnection: ICrossConnection;const ABuf: Pointer; const ALen: Integer);
    procedure OnSent(const Sender: TObject; const AConnection: ICrossConnection;const ABuf: Pointer; const ALen: Integer);

    procedure OnRequest(const Sender: TObject; const Ctxt: ICrossHttpRequest;
                       const AResponse: ICrossHttpResponse; var AHandled: Boolean);



  public
    constructor Create(QLog: IOneLog); overload;
    destructor Destroy; override;
  public
    // 启动服务
    function ServerStart(): boolean;
    // 停止服务
    function ServerStop(): boolean;
    // 拒绝任何请求
    function ServerStopRequest(): boolean;
  published
    // HTTP服务是否启动
    property Started: boolean read FStarted;
    // 拒绝请求
    property StopRequest: boolean read FStopRequest;
    // 绑定HTTP端口，默认9090
    property Port: integer read FPort write FPort;
    // 线程池
    property ThreadPoolCount: integer read FThreadPoolCount write FThreadPoolCount;
    // 默认30000毫秒，即30秒 连接保持活动的时间
    property KeepAliveTimeOut: integer read FKeepAliveTimeOut write FKeepAliveTimeOut;
    // 队列默认1000,请求放进队列,然后有线程消费完成
    property HttpQueueLength: integer read FHttpQueueLength write FHttpQueueLength;
    // 错误消息
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

function CreateNewHTTPCtxt(Ctxt:ICrossHttpRequest;AResponse: ICrossHttpResponse):THTTPCtxt;

implementation

uses OneStopwatch, OneHttpRouterManage, OneHttpController, OneGlobal;

{ TOneHttpServer }


constructor TOneHttpServer.Create(QLog: IOneLog);
begin
  inherited Create;
  self.FLog := QLog;
  self.FStarted := False;
  self.FStopRequest := False;
  self.FPort := 9090;
  self.FThreadPoolCount := 32;
  self.FKeepAliveTimeOut := 30000;
  self.FHttpQueueLength := 1000;
  self.FHttpServer := nil;
  //self.FHttpsServer := nil;
end;

destructor TOneHttpServer.Destroy;
begin
  if FHttpServer <> nil then
  begin
    FHttpServer.CloseAll;
  end;
  //if FHttpsServer <> nil then
  //begin
  //  FHttpsServer.CloseAll;
  //end;
  inherited Destroy;
end;

procedure TOneHttpServer.OnRequest(const Sender: TObject; const Ctxt: ICrossHttpRequest;
                                    const AResponse: ICrossHttpResponse; var AHandled: Boolean);
var
  lErrMsg: string; // 错误消息
  lIsErr: boolean; // 是否产生错误
  lwatchTimer: TStopwatch; // 时间计数器
  lRequestMilSec: integer;

  lURI: TURI;
  lUrlPath: string; // URL路径
  lRouterUrlPath: TOneRouterUrlPath; // URL路径对应的路由信息
  lRouterItem: TOneRouterItem;
  lWorkObj: TObject; // 控制器对象
  lOneControllerWork: TOneControllerBase; // 控制器对象
  lEvenControllerProcedure: TEvenControllerProcedure; // 控制器是方法时回调

  lHTTPResult: THTTPResult; // HTTP执行结果，统一接口格式化
  lHTTPCtxt: THTTPCtxt; // HTTP请求相关信息,转成内部一个类处理
  // 静态文件输出
  lFileName, lFileCode, lPhy: string;
  tempI: integer;
  tempMsg: string;
  lTThreadID: string;
  lRequestSize,lResPonseSize:Integer;
  lresult:cardinal;
begin
  lErrMsg := '';
  lIsErr := False;
  lHTTPResult := nil;
  lHTTPCtxt := nil;
  lRouterUrlPath := nil;
 // Result := 0;
  if self.FStopRequest then
  begin
    // 停止请求，返回404
   // Result := HTTP_NOTFOUND;
    lHTTPResult.ResultMsg:='HTTP服务暂停中,请稍候请求';

//    Ctxt.OutContentType := 'text/plain;charset='+lHTTPCtxt.INAcceptCharset;
//    Ctxt.OutCustomHeaders := lHTTPCtxt.ResponCustHeaderList;
//    Ctxt.OutContent := lHTTPResult.msg;
    AResponse.Send(lHTTPResult.ResultToJson) ;
    AHandled:=True;
    exit;
  end;
  lURI := ParseURI('http://' + Ctxt.RawPathAndParams);
  lUrlPath := lURI.Path + lURI.Document;
  lUrlPath := OneHttpCtxtResult.FormatRootName(lUrlPath);
  lwatchTimer := TStopwatch.StartNew;
  //
  try
    try
      // 解析URL调用相关路由方法
      // lUrlPath='/'+注册RootName根路径/控制器方法名称
      lRouterUrlPath := OneHttpRouterManage.GetInitRouterManage().GetRouterUrlPath(
        lUrlPath, lErrMsg);
      if lRouterUrlPath <> nil then
      begin
        //try
        lRouterItem := lRouterUrlPath.RouterItem;
        lHTTPResult := CreateNewHTTPResult;
          lHTTPCtxt := CreateNewHTTPCtxt(Ctxt,AResponse);
          lHTTPCtxt.UrlPath := lUrlPath;
        lHTTPCtxt.ControllerMethodName := lRouterUrlPath.MethodName;
        // 跟据路由模式锁定不同模式干活
        if (lRouterItem.RouterMode = emRouterMode.pool) or
          (lRouterItem.RouterMode = emRouterMode.single) then
        begin
          lWorkObj := lRouterItem.LockWorkItem(lErrMsg);
          if lErrMsg <> '' then
          begin
	//            Ctxt.OutContent := UTF8Encode(lErrMsg);
	//            Ctxt.OutContentType := TEXT_CONTENT_TYPE;
	//            Result := 500;
	            AResponse.Send(UTF8Encode(lErrMsg)) ;
            lIsErr := True;
            exit;
          end;

          try
            if (lWorkObj = nil) then
            begin
//              Ctxt.OutContent := UTF8Encode('获取的控制器对象为nil');
//              Ctxt.OutContentType := TEXT_CONTENT_TYPE;
//              Result := 500;
              AResponse.Send(UTF8Encode('获取的控制器对象为nil')) ;
              lIsErr := True;
              exit;
            end;
            if not (lWorkObj is TOneControllerBase) then
            begin
//              Ctxt.OutContent := UTF8Encode('控制器请继承TControllerBase');
//              Ctxt.OutContentType := TEXT_CONTENT_TYPE;
//              Result := 500;
                AResponse.Send(UTF8Encode('控制器请继承TControllerBase')) ;
              lIsErr := True;
              exit;
            end;
            lOneControllerWork := TOneControllerBase(lWorkObj);
            lresult := lOneControllerWork.DoWork(lHTTPCtxt, lHTTPResult,
              lRouterItem);
          finally
            // 归还控制器
            lRouterItem.UnLockWorkItem(lWorkObj);
          end;
        end
        else if lRouterItem.RouterMode = emRouterMode.even then
        begin
          //lEvenControllerProcedure := lRouterItem.LockWorkEven(lErrMsg);
          //if lErrMsg <> '' then
          //begin
          //  Ctxt.OutContent := UTF8Encode(lErrMsg);
          //  Ctxt.OutContentType := TEXT_CONTENT_TYPE;
          //  lIsErr := True;
          //  Result := 500;
          //  exit;
          //end;

          //try
          //  if not Assigned(lEvenControllerProcedure) then
          //  begin
          //    Ctxt.OutContent :=
          //      UTF8Encode(lUrlPath + '相关路由回调方法已不存在');
          //    Ctxt.OutContentType := TEXT_CONTENT_TYPE;
          //    Result := 500;
          //    lIsErr := True;
          //    exit;
          //  end;
          //  // 进行调用
          //  lEvenControllerProcedure(lHTTPCtxt, lHTTPResult);
          //  // 结果处理
          //  OneHttpCtxtResult.EndCodeResultOut(lHTTPCtxt, lHTTPResult);
          //  Result := lHTTPResult.ResultStatus;
          //finally
          //  // 归还控制器
          //  lRouterItem.UnLockWorkItem(nil)
          //end;
        end
        else
        begin
            AResponse.Send(UTF8Encode('[TOneHttpServer.OnRequest]未设计的路由模式')) ;
//          Ctxt.OutContent := '[TOneHttpServer.OnRequest]未设计的路由模式';
//           Ctxt.OutContentType := TEXT_CONTENT_TYPE;
//          Result := 500;
          lIsErr := True;
          exit;
        end
        end
      else
      begin
      if (lUrlPath = '') or (lUrlPath = '/one') then
      begin
//        Ctxt.OutContent := UTF8Encode('欢迎来到OneLaz世界!!!!');
//        Ctxt.OutContentType := TEXT_CONTENT_TYPE;
//        Result := HTTP_SUCCESS;
        AResponse.Send(UTF8Encode('欢迎来到OneLaz世界')) ;
        exit;
      end
      else if lUrlPath.StartsWith('/oneweb/') then
      begin
        lFileName := lUrlPath.Substring(8, lUrlPath.Length - 8);
        // 有中文进行解码
        lFileName := HTTPDecode(lFileName);
        lFileName := OneFileHelper.CombineExeRunPathB('OnePlatform\OneWeb', lFileName);
//          Ctxt.OutContent := lFileName;
//          Ctxt.OutContentType := STATICFILE_CONTENT_TYPE;
//          Ctxt.OutCustomHeaders := GetMimeContentTypeHeader('', Ctxt.OutContent) + #13#10
//            + 'OneOutMode: OUTFILE';
//          Result := HTTP_SUCCESS;
          AResponse.SendFile(lFileName);
        exit;
      end
      else if lUrlPath.StartsWith('/onewebv/') then
      begin
        // 返回虚拟目录站点文件/onewebv/虚拟文件代码/文件路径
        lUrlPath := lUrlPath.Substring(9, lUrlPath.Length - 9);
        // 取出虚拟文件代码,和虚拟文件路径
        tempI := lUrlPath.IndexOf('/');
        lFileCode := lUrlPath.Substring(0, tempI);
        lFileName := lUrlPath.Substring(tempI, lUrlPath.Length - tempI);

        lPhy := TOneGlobal.GetInstance().VirtualManage.GetVirtualPhy(lFileCode, lErrMsg);
        if lErrMsg <> '' then
        begin
//            Ctxt.OutContent := UTF8Encode(lErrMsg);
//            Ctxt.OutContentType := TEXT_CONTENT_TYPE;
          lResult := 500;
          AResponse.Send(UTF8Encode(lErrMsg));
          exit;
        end;
        lFileName := HTTPDecode(lFileName);
        lFileName := CombinePath(lPhy, lFileName);
//          Ctxt.OutContent := lFileName;
//          Ctxt.OutContentType := STATICFILE_CONTENT_TYPE;
//          Ctxt.OutCustomHeaders := GetMimeContentTypeHeader('', Ctxt.OutContent) + #13#10
//            + 'OneOutMode: OUTFILE';
//          Result := HTTP_SUCCESS;
          AResponse.SendFile(lFileName); 
        end;
        //Ctxt.OutContent := UTF8Encode(lErrMsg);
        //Ctxt.OutContentType := TEXT_CONTENT_TYPE;
        AResponse.Send(UTF8Encode(lErrMsg));
        lIsErr := True;
        exit;
      end;
      //if lResult = 0 then
      //begin
      //  // DoWork里面也有可能返回来
      //  lResult := HTTP_SUCCESS;
      //end;
    finally
      if lHTTPResult <> nil then
      begin
        if lResult = 500 then
        begin
          // 服务端异常不处理结果
          //Ctxt.OutContent := UTF8Encode(lHTTPResult.ResultException); 
          AResponse.Send(UTF8Encode(lErrMsg));
        end
        else if lHTTPResult.ResultOutMode = THTTPResultMode.OUTFILE then
        begin
          //Ctxt.OutContent := lHTTPCtxt.OutContent;
          //Ctxt.OutContentType := STATICFILE_CONTENT_TYPE;
          //Ctxt.OutCustomHeaders :=
          //  GetMimeContentTypeHeader('', Ctxt.OutContent) + #13#10 +
          //  'OneOutMode: OUTFILE';
          //Result := HTTP_SUCCESS;  
          AResponse.SendFile(UTF8Encode(lHTTPCtxt.OutContent)) ;
        end
        else if lHTTPResult.ResultOutMode = THTTPResultMode.HTML then
        begin
          //Ctxt.OutContent := lHTTPCtxt.OutContent;
          //Ctxt.OutContentType := HTML_CONTENT_TYPE;
          //Result := HTTP_SUCCESS;
          AResponse.SendFile(UTF8Encode(lHTTPCtxt.OutContent)) ;
        end
        else
        begin
          //Ctxt.OutContentType :=
          //  'text/plain;charset=' + lHTTPCtxt.RequestAcceptCharset;
          //Ctxt.OutCustomHeaders := lHTTPCtxt.ResponCustHeaderList;
          //Ctxt.OutContent := lHTTPCtxt.OutContent; 
          AResponse.Send(UTF8Encode(lHTTPCtxt.OutContent)) ;
        end;
        lHTTPResult.Free;
      end;
      if lHTTPCtxt <> nil then
        lHTTPCtxt.Free;
      if lIsErr then
      begin
        if lResult = 500 then
        begin
          // 抛出异常到前端
          // raise Exception.Create(Ctxt.OutContent);    
         // AResponse.Send(UTF8Encode(lHTTPCtxt.OutContent)) ;
        end
        else
        begin
          //lResult := HTTP_NOTFOUND;   
          lHTTPResult.ResultMsg:='404,未找到';
          AResponse.Send(lHTTPResult.ResultToJson) ;
        end;
      end;
    end;
  finally
    lwatchTimer.Stop;
    lRequestMilSec := lwatchTimer.ElapsedMilliseconds;
    if (self.FLog <> nil) and (self.FLog.IsHTTPLog) then
    begin
      self.FLog.WriteHTTPLog('请求用时:[' + lRequestMilSec.ToString + ']毫秒');
      self.FLog.WriteHTTPLog('请求URL:[' + Ctxt.RawPathAndParams + ']');
      //if not IsMultipartForm(Ctxt.InContentType) then
      //begin
      //  self.FLog.WriteHTTPLog('请求内容:' + Ctxt.InContent);
      //  // self.FLog.WriteHTTPLog('输出内容:' + Ctxt.OutContent);
      //end;
    end;
  end;
end;

procedure TOneHttpServer.OnConnected(const Sender: TObject; const AConnection: ICrossConnection);
begin
 // AtomicIncrement(FServerStatus.OnLineCount);
//  if (FHttpsServer.ConnectionsCount > FServerStatus.FOnLineMaxCount) then
//  begin
//    AConnection.Close;
//    DoLogMessage('连接超过最大数: '+FServerStatus.FOnLineMaxCount.ToString,llWarning);
//  end;

end;

procedure TOneHttpServer.OnDisconnected(const Sender: TObject; const AConnection: ICrossConnection);
begin

end;

procedure TOneHttpServer.OnReceived(const Sender: TObject; const AConnection: ICrossConnection;const ABuf: Pointer; const ALen: Integer);
begin
  //AtomicIncrement(FServerStatus.RequestCount);
 //AtomicIncrement(FServerStatus.RequestSumByte, ALen);
end;

procedure TOneHttpServer.OnSent(const Sender: TObject; const AConnection: ICrossConnection;const ABuf: Pointer; const ALen: Integer);
begin
 // AtomicIncrement(FServerStatus.ResPonseCount);
 // AtomicIncrement(FServerStatus.ResPonseSumByte, ALen);
end;

// 启动服务
function TOneHttpServer.ServerStart(): boolean;
var
  CertificateFile, PrivateKeyFile: string;
begin
  Result := False;
  // 已经启动
  if FStarted then
  begin
    self.FErrMsg := 'HTTP服务已启动无需在启动';
    exit;
  end;
  if (self.FPort <= 0) then
  begin
    self.FErrMsg := 'HTTP服务端口未设置,请先设置,当前绑定端口【' +
      self.FPort.ToString() + '】';
    exit;
  end;
  if self.FThreadPoolCount > 1000 then
    self.FThreadPoolCount := 1000;
  if self.FHttpQueueLength <= 0 then
    self.FHttpQueueLength := 1000;
  // 创建HTTP服务
  try
    // hsoEnableTls开始ssl证书
    Self.FHttpServer :=TCrossHttpServer.Create(FThreadPoolCount,False);
    Self.FHttpServer.Addr := IPv4v6_ALL;
    Self.FHttpServer.Compressible := true;
    Self.FHttpServer.Port :=FPort ;

    Self.FHttpServer.OnRequest     :=Self.OnRequest;
    Self.FHttpServer.OnConnected   := Self.OnConnected;
    Self.FHttpServer.OnDisconnected:= Self.OnDisconnected;
    Self.FHttpServer.OnReceived    := Self.OnReceived;
    Self.FHttpServer.OnSent        := Self.OnSent;

    Self.FHttpServer.Active := true;
    // raise exception e.g. on binding issue
    self.FStopRequest := False;
    self.FStarted := True;
    Result := True;
  except
    on e: Exception do
    begin
      self.FErrMsg := '启动服务器失败,原因:' + e.Message +
        ';解决方案可偿试管理员启动程序或换个端口临听（端口重复绑定）。';
      self.FHttpServer.CloseAll;
      self.FHttpServer := nil;
    end;
  end;

end;

// 停止服务
function TOneHttpServer.ServerStop(): boolean;
begin
  Result := False;
  if self.FHttpServer <> nil then
  begin
      self.FHttpServer.CloseAll;
    self.FHttpServer := nil;
  end;
  self.FStarted := False;
  Result := True;
end;

// 拒绝任何请求
function TOneHttpServer.ServerStopRequest(): boolean;
begin
  // 返回  HTTP_NOTFOUND 404
  self.FHttpServer.CloseAll;
  Result := False;
  self.FStopRequest := True;
  Result := True;
end;

// 提到外面来底程和什么通讯无关
function CreateNewHTTPCtxt(Ctxt:ICrossHttpRequest;AResponse: ICrossHttpResponse):THTTPCtxt;
begin
  Result := THTTPCtxt.Create;
  Result.Request:=Ctxt;
  Result.Response:=AResponse;
  Result.UrlParams := TStringList.Create;
  Result.HeadParamList := TStringList.Create;
  Result.ResponCustHeaderList := '';
  Result.RequestContentTypeCharset := 'UTF-8';
  Result.RequestAcceptCharset := 'UTF-8';
  // 解析
  Result.Method := string(Ctxt.Method).ToUpper;
  Result.RequestContentType := Ctxt.ContentType;

  Result.Url := Ctxt.RawPathAndParams;
  Result.SetUrlParams();
  Result.RequestInHeaders := Ctxt.Header;
  Result.SetHeadParams();
  // String类型，不要直接等于  Ctxt.InContent 当参数传进去处理
  // 不难有可能编码会被打乱,碰到一种就加一种在  SetInContent统一处理
  // Result.RequestInContent := Ctxt.InContent;
  // 如果没有你想要的编码解析,联系群主，加上或者你搞好了，发给群主合并
  Result.SetInContent(Ctxt.Body);
  Result.TokenUserCode := '';
end;

end.
