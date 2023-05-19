unit OneWebSocketServer;

interface

uses
  system.StrUtils, system.Classes, system.SysUtils,
  system.Generics.Collections, system.JSON,
  Net.CrossSocket.Base,
  Net.CrossHttpServer,
  Net.CrossWebSocketServer,
  oneILog, OneTokenManage, OneWebSocketConst;

type
  //TOneWebSocketProtocol = class;
  TOneWebSocketServer = class;

//  TOneWebSocketProtocol = class(TWebSocketProtocolChat)
//  private
//    FOwnerWebSocketMgr: TCBWebSocketServer;
//  protected
//    procedure DoIncomingFrame(Sender: TWebSocketProcess; const Frame: TWebSocketFrame);
//  public
//    function GetWsTokenByConnectionID(QConnectionID: int64): TWsToken;
//  end;

  TOneWebSocketServer = class
  private
    FWsTokenDict: TDictionary<string, TWsToken>;
    FWsConnectionDict: TDictionary<int64, string>;
    // HTTP服务是否启动
    FStarted: boolean;
    // 拒绝请求
    FStopRequest: boolean;
    // 绑定HTTP端口，默认9090
    FPort: integer;
    // 线程池 ThreadPoolCount<0 将使用单个线程来对其进行全部规则, =0将为每个连接创建一个线程,>0将利用线程池
    // 一般设定大于0用线程池性能最好
    FThreadPoolCount: integer;
    // 队列默认1000,请求放进队列,然后有线程消费完成
    FHttpQueueLength: integer;
    // 默认30000毫秒，即30秒 连接保持活动的时间
    FKeepAliveTimeOut: integer;
    FWebSocketServer: ICrossWebSocketServer;
    //
    FLog: IOneLog;
    // 错误消息
    FErrMsg: string;
  private
    procedure WsTokenDictOp(QConnectionID: int64; QIsClose: boolean = false);
    function GetConnectionIDByWsUserID(QWsUserID: string): int64;
    function GetWsTokenByConnectionID(QConnectionID: int64): TWsToken;
  public
    FZTMain: string;
    FPoolCount: Integer;
    FbInit: Boolean;
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
    function SendMsgAll(QMsg: RawByteString): boolean;
    function SendMsgToUser(QWsMsg: TWsMsg): boolean;
    function SendMsg(QConnectionID: int64; QMsg: string): boolean;
    procedure SendWsUserID(QConnectionID: int64);
   // function SendFrame(QConnectionID: int64; QFrame: TWebSocketFrame): boolean;
    function GetWsTokenList(): TList<TWsToken>;
    procedure OnOpen(const AConnection: ICrossWebSocketConnection);
    procedure OnClose(const AConnection: ICrossWebSocketConnection);
    procedure DoIncomingFrame(const AConnection: ICrossWebSocketConnection;
                        const ARequestType: TWsRequestType; const ARequestData: TBytes);


  published
    // HTTP服务是否启动
    property Started: boolean read FStarted;
    // 拒绝请求
    property StopRequest: boolean read FStopRequest;
    // 绑定HTTP端口，默认9090
    property Port: integer read FPort write FPort;
    // 线程池
    property ThreadPoolCount: integer read FThreadPoolCount  write FThreadPoolCount;
    // 队列默认1000,请求放进队列,然后有线程消费完成
    property HttpQueueLength: integer read FHttpQueueLength write FHttpQueueLength;
    // 默认30000毫秒，即30秒 连接保持活动的时间
    property KeepAliveTimeOut: integer read FKeepAliveTimeOut  write FKeepAliveTimeOut;
    //
    property WsTokenDict: TDictionary<string, TWsToken> read FWsTokenDict;
    // 错误消息
    property ErrMsg: string read FErrMsg write FErrMsg;
  end;

implementation

uses OneHttpRouterManage, OneHttpCtxtResult, OneHttpController, OneHttpConst,
  OneNeonHelper, OneUUID, OneGUID;

function CreateNewHTTPCtxt(Sender: ICrossWebSocketConnection; QJsonData: TJsonValue): THTTPCtxt;
begin
  Result := THTTPCtxt.Create;
 // Result.ConnectionID := Sender.Protocol.ConnectionID;
  Result.UrlParams := TStringList.Create;
  Result.HeadParamList := TStringList.Create;
  Result.ResponCustHeaderList := '';
  Result.RequestContentTypeCharset := 'UTF-8';
  Result.RequestAcceptCharset := 'UTF-8';
  // 解析
  Result.Method := 'POST';
  Result.RequestContentType := '';
 // Result.Url := Sender.Protocol.URI;
  Result.SetUrlParams();
 // Result.RequestInHeaders := '';
  Result.SetHeadParams();
//  Result.SetInContent(QJsonData.ToString);
  Result.TokenUserCode := '';
end;

procedure TOneWebSocketServer.DoIncomingFrame(const AConnection: ICrossWebSocketConnection;const ARequestType: TWsRequestType; const ARequestData: TBytes);
var
  //lResultFrame: TWebSocketFrame;
  lJsonObjIn: TJsonObject;
  lJsonValueIn, lJsonData, lJsonContent: TJsonValue;
  lJsonResult: TJsonObject;
  lOneRoot: string;
  lOneMsgID: string;
  lWsMsg: TWsMsg;
  lWSToken: TWsToken;
  //
  lRouterUrlPath: TOneRouterUrlPath;
  lRouterWorkItem: TOneRouterWorkItem;
  lWorkObj: TObject; // 控制器对象
  lOneControllerWork: TOneControllerBase; // 控制器对象
  //
  iStatusCode: integer;
  lHTTPResult: THTTPResult; // HTTP执行结果，统一接口格式化
  lHTTPCtxt: THTTPCtxt; // HTTP请求相关信息,转成内部一个类处理
  lErrMsg: string;
begin

  //
  case ARequestType of
    wsrtText, wsrtBinary:
      begin
//        if Frame.payload = '' then
//        begin
//          exit;
//        end;
        // 本次交互ID
        lJsonObjIn := nil;
        lJsonValueIn := nil;
        lOneMsgID := '';
        lOneRoot := '';
        // 消息处理
        iStatusCode := 200;
        lRouterUrlPath := nil;
        lErrMsg := '';
        lRouterWorkItem := nil;
        lWsMsg := TWsMsg.Create;
        lWSToken := nil;
        lJsonResult := TJsonObject.Create;
        try
          lJsonValueIn := TJsonObject.ParseJSONValue(TEncoding.UTF8.GetString(ARequestData));
          if lJsonValueIn = nil then
          begin
            lJsonResult.AddPair('MsgData', '请输入标准的Json对象[TWsMsg]');
            exit;
          end;
          if not(lJsonValueIn is TJsonObject) then
          begin
            lJsonValueIn.Free;
            lJsonResult.AddPair('MsgData', '请输入标准的Json对象[TWsMsg]');
            exit;
          end;
          lJsonObjIn := TJsonObject(lJsonValueIn);

          if not OneNeonHelper.JsonToObject(lWsMsg, lJsonObjIn, lErrMsg) then
          begin
            exit;
          end;
          //

          lWSToken := Self.GetWsTokenByConnectionID(AConnection.UID);
          if lWSToken <> nil then
          begin
            lWsMsg.FromUserID := lWSToken.WsUserID;
            lWsMsg.FromUserName := lWSToken.UserName;
          end;
          //
          lOneRoot := lWsMsg.ControllerRoot;
{$REGION '非MVC架构'}
          if lOneRoot = '' then
          begin
            if lWsMsg.MsgCmd = WsMsg_cmd_toUserMsg then
            begin
              // 发送消息给用户
              Self.SendMsgToUser(lWsMsg);
            end;
            // 其它情况后面增加
          end;
{$ENDREGION}
{$REGION '走MVC架构'}
          if lOneRoot <> '' then
          begin
            // 走MVC架构
            lRouterUrlPath := OneHttpRouterManage.GetInitRouterManage().GetRouterUrlPath(lOneRoot, lErrMsg);
            if lRouterUrlPath = nil then
            begin
              lJsonResult.AddPair('oneMsg', '找不到相关服务路由:' + lOneRoot);
              exit;
            end;
            try
              lRouterWorkItem := lRouterUrlPath.RouterWorkItem;
              lHTTPResult := CreateNewHTTPResult;
              lHTTPCtxt := CreateNewHTTPCtxt(AConnection,  lJsonData);
              lHTTPCtxt.UrlPath := lOneRoot;
              lHTTPCtxt.ControllerMethodName := lRouterUrlPath.MethodName;
              // 跟据路由模式锁定不同模式干活
              if (lRouterWorkItem.RouterMode = emRouterMode.pool) or (lRouterWorkItem.RouterMode = emRouterMode.single) then
              begin
                lWorkObj := lRouterWorkItem.LockWorkItem(lErrMsg);
                if (lWorkObj = nil) then
                begin
                  lJsonResult.AddPair('oneMsg', '获取的控制器对象为nil');
                  exit;
                end;
                try
                  if not(lWorkObj is TOneControllerBase) then
                  begin
                    lJsonResult.AddPair('oneMsg', '控制器请继承TOneControllerBase');
                    exit;
                  end;
                  lOneControllerWork := TOneControllerBase(lWorkObj);
                  iStatusCode := lOneControllerWork.DoWork(lHTTPCtxt, lHTTPResult, lRouterWorkItem);
                finally
                  // 归还控制器
                  lRouterWorkItem.UnLockWorkItem(lWorkObj);
                end;
              end
              else
              begin
                lJsonResult.AddPair('oneMsg', '未支持的路由模式');
                exit;
              end;
            finally
              if lHTTPResult <> nil then
              begin
                if iStatusCode = 500 then
                begin
                  // 服务端异常不处理结果
                  lJsonResult.AddPair('oneMsg', lHTTPResult.ResultException);
                end
                else if iStatusCode = HTTP_Status_TokenFail then
                begin
                  // 验证Token失败
                  lJsonResult.AddPair('oneMsg', 'Token验证失败,请重新登陆!');
                end
                else if iStatusCode = 200 then
                begin
                  if lHTTPCtxt.OutContent <> '' then
                  begin
                    lJsonContent := TJsonObject.ParseJSONValue(lHTTPCtxt.OutContent);
                    if lJsonContent = nil then
                    begin
                      lJsonResult.AddPair('oneMsgData', lHTTPCtxt.OutContent);
                    end
                    else
                    begin
                      lJsonResult.AddPair('oneMsgData', lJsonContent);
                    end;
                  end;
                end;
                lHTTPResult.Free;
              end;
              if lHTTPCtxt <> nil then
                lHTTPCtxt.Free;
            end;
          end;
{$ENDREGION}
        finally
          if lJsonResult <> nil then
            lJsonResult.Free;
          if lJsonObjIn <> nil then
            lJsonObjIn.Free;
          if lWsMsg <> nil then
            lWsMsg.Free;
        end;
      end;
  end;
end;

function TOneWebSocketServer.GetWsTokenByConnectionID(QConnectionID: int64): TWsToken;
var
  lWSToken: TWsToken;
  lWsUserID: string;
begin
  Result := nil;
  lWSToken := nil;
  if Self.FWsConnectionDict.TryGetValue(QConnectionID, lWsUserID) then
  begin
    Self.FWsTokenDict.TryGetValue(lWsUserID, lWSToken);
  end;
  Result := lWSToken;
end;

//
constructor TOneWebSocketServer.Create(QLog: IOneLog);
begin
  inherited Create;
  Self.FLog := QLog;
  Self.FStarted := false;
  Self.FStopRequest := false;
  Self.FPort := 9099;
  Self.FThreadPoolCount := 32;
  Self.FHttpQueueLength := 1000;
  Self.FKeepAliveTimeOut := 30000;
  Self.FWebSocketServer := nil;
  Self.FWsTokenDict := TDictionary<string, TWsToken>.Create();
  Self.FWsConnectionDict := TDictionary<int64, string>.Create();
end;

destructor TOneWebSocketServer.Destroy;
var
  lWSToken: TWsToken;
begin
  //
  for lWSToken in FWsTokenDict.Values do
  begin
    lWSToken.Free;
  end;
  FWsTokenDict.Clear;
  FWsTokenDict.Free;
  FWsConnectionDict.Clear;
  FWsConnectionDict.Free;
  //
  if FWebSocketServer <> nil then
  begin
    try
      FWebSocketServer.Stop;
      FWebSocketServer := nil;
    except

    end;
  end;

  inherited Destroy;
end;

// 启动服务
function TOneWebSocketServer.ServerStart(): boolean;
//var
 // lWSProtocol: TCBWebSocketProtocol;
begin
  Result := false;
  // 已经启动
  if FStarted then
  begin
    Self.FErrMsg := 'WS服务已启动无需在启动';
    exit;
  end;
  if (Self.FPort <= 0) then
  begin
    Self.FErrMsg := 'WS服务端口未设置,请先设置,当前绑定端口【' + Self.FPort.ToString() + '】';
    exit;
  end;
  if Self.FThreadPoolCount > 1000 then
    Self.FThreadPoolCount := 1000;
  // 创建HTTP服务
  try
    Self.FWebSocketServer := TNetCrossWebSocketServer.Create(0, False);
  FWebSocketServer.Addr := IPv4v6_ALL;
  FWebSocketServer.Port := FPort;
  FWebSocketServer.Compressible := true;
  if FWebSocketServer.Ssl then
  begin
//   FWebSocketServer.SetCertificate(SSL_SERVER_CERT);
//   FWebSocketServer.SetPrivateKey(SSL_SERVER_PKEY);
  end;
  FWebSocketServer.OnOpen(OnOpen);
  FWebSocketServer.OnClose(OnClose);
  FWebSocketServer.OnMessage(DoIncomingFrame);
        FWebSocketServer.Start();
    Self.FStopRequest := false;
    Self.FStarted := true;
    Result := true;
  except
    on e: Exception do
    begin
      Self.FErrMsg := '启动服务器失败,原因:' + e.Message +
        ';解决方案可偿试管理员启动程序或换个端口临听（端口重复绑定）。';
    end;
  end;

end;

// 停止服务
function TOneWebSocketServer.ServerStop(): boolean;
begin
  Result := false;
  if Self.FWebSocketServer <> nil then
  begin
    Self.FWebSocketServer.CloseAll;
    Self.FWebSocketServer := nil;
  end;
  Self.FStarted := false;
  Result := true;
end;

// 拒绝任何请求
function TOneWebSocketServer.ServerStopRequest(): boolean;
begin
  // 返回  HTTP_NOTFOUND 404
  Result := false;
  Self.FStopRequest := true;
  Result := true;
end;

function TOneWebSocketServer.SendMsgAll(QMsg: RawByteString): boolean;
var
//  lFrame: TWebSocketFrame;
//  lWsConnection: TWebSocketAsyncConnection;
  LConnections: TArray<ICrossConnection>;
  LConnection: ICrossConnection;
begin
  Result := false;
//  lFrame.opcode := focText;
//  lFrame.content := [];
//  lFrame.payload := UTF8Encode(QMsg);
//  lWsConnection := nil;
//  FWebSocketServer.WebSocketBroadcast(lFrame, nil);
  try
    LConnections := FWebSocketServer.LockConnections.Values.ToArray;
  finally
    FWebSocketServer.UnlockConnections;
  end;

  for LConnection in LConnections do
  begin
    (LConnection as ICrossWebSocketConnection).WsSend(QMsg);
  end;

  Result := true;
end;

function TOneWebSocketServer.SendMsgToUser(QWsMsg: TWsMsg): boolean;
var
  lJsonObj: TJsonObject;
  lErrMsg: string;
  lToUserConnecitonID: int64;
begin
  Result := false;
  if QWsMsg.ToUserID = '' then
  begin
    exit;
  end;
  // 获取ConnectinID
  lToUserConnecitonID := Self.GetConnectionIDByWsUserID(QWsMsg.ToUserID);
  if lToUserConnecitonID <= 0 then
    exit;
  lJsonObj := nil;
  lJsonObj := OneNeonHelper.ObjectToJson(QWsMsg, lErrMsg) as TJsonObject;
  if lJsonObj = nil then
    exit;
  try
    Result := Self.SendMsg(lToUserConnecitonID, lJsonObj.ToString);
  finally
    lJsonObj.Free;
  end;
end;

function TOneWebSocketServer.SendMsg(QConnectionID: int64; QMsg: string): boolean;
var
  //lFrame: TWebSocketFrame;
  lBytes: TBytes;
  LConnections: TArray<ICrossConnection>;
  LConnection: ICrossConnection;
begin
  Result := false;
//  lFrame.opcode := focText;
//  lFrame.content := [];
//  lFrame.payload := UTF8Encode(QMsg);
  lBytes := TEncoding.UTF8.GetBytes(QMsg);
  try
    LConnections := FWebSocketServer.LockConnections.Values.ToArray;
  finally
    FWebSocketServer.UnlockConnections;
  end;

  for LConnection in LConnections do
  begin
    if LConnection.UID=QConnectionID then
    begin
      (LConnection as ICrossWebSocketConnection).WsSend(QMsg);
    end;
  end;
  Result := true;
end;

//function TCBWebSocketServer.SendFrame(QConnectionID: int64; QFrame: TWebSocketFrame): boolean;
//begin
//  Result := false;
//  FWebSocketServer.WebSocketBroadcast(QFrame, [QConnectionID]);
//  Result := true;
//end;

//
function TOneWebSocketServer.GetWsTokenList(): TList<TWsToken>;
var
  lWSToken: TWsToken;
begin
  TMonitor.Enter(Self);
  try
    Result := TList<TWsToken>.Create;
    for lWSToken in FWsTokenDict.Values do
    begin
      Result.Add(lWSToken.Copy);
    end;
  finally
    TMonitor.exit(Self);
  end;
end;

procedure TOneWebSocketServer.WsTokenDictOp(QConnectionID: int64; QIsClose: boolean = false);
var
  lWSToken: TWsToken;
  lWsUserID: string;
begin
  TMonitor.Enter(Self);
  try
    if QIsClose then
    begin
      if Self.FWsConnectionDict.TryGetValue(QConnectionID, lWsUserID) then
      begin
        if Self.FWsTokenDict.TryGetValue(lWsUserID, lWSToken) then
        begin
          lWSToken.Free;
        end;
        Self.FWsTokenDict.Remove(lWsUserID);
      end;
      Self.FWsConnectionDict.Remove(QConnectionID);
    end
    else
    begin
      lWSToken := TWsToken.Create;
      lWSToken.WsUserID := OneUUID.GetUUIDStr;
      lWSToken.ConnectionID := QConnectionID;
      lWSToken.UserName := '游客-未登陆';
      Self.FWsTokenDict.Add(lWSToken.WsUserID, lWSToken);
      Self.FWsConnectionDict.Add(QConnectionID, lWSToken.WsUserID);
    end;
  finally
    TMonitor.exit(Self);
  end;

end;

function TOneWebSocketServer.GetConnectionIDByWsUserID(QWsUserID: string): int64;
var
  lWSToken: TWsToken;
begin
  Result := -1;
  TMonitor.Enter(Self);
  try
    if Self.FWsTokenDict.TryGetValue(QWsUserID, lWSToken) then
    begin
      Result := lWSToken.ConnectionID;
    end;
  finally
    TMonitor.exit(Self);
  end;
end;

procedure TOneWebSocketServer.SendWsUserID(QConnectionID: int64);
var
  lWsUserID, lErrMsg: string;
  lWsMsg: TWsMsg;
  lJsonObj: TJsonObject;
begin
  if not Self.FWsConnectionDict.TryGetValue(QConnectionID, lWsUserID) then
  begin
    exit;
  end;
  if lWsUserID = '' then
    exit;
  lJsonObj := nil;
  lWsMsg := TWsMsg.Create;
  try
    lWsMsg.MsgID := OneGUID.GetGUID32;
    lWsMsg.ControllerRoot := '';
    lWsMsg.FromUserID := '';
    lWsMsg.FromUserName := '';
    lWsMsg.ToUserID := lWsUserID;
    lWsMsg.MsgCode := '';
    lWsMsg.MsgCmd := WsMsg_cmd_WsUserIDGet;
    lWsMsg.MsgData := '';
    lWsMsg.MsgTime := FormatDateTime('yyyy-mm-dd hh:mm:ss', now);

    lJsonObj := OneNeonHelper.ObjectToJson(lWsMsg, lErrMsg) as TJsonObject;
    if lJsonObj = nil then
      exit;
    Self.SendMsg(QConnectionID, lJsonObj.ToString);
  finally
    if lJsonObj <> nil then
      lJsonObj.Free;
    lWsMsg.Free;
  end;
end;

procedure TOneWebSocketServer.OnOpen(const AConnection: ICrossWebSocketConnection);
var
  lTokenID:string;
  //lTokenInfo:TTokenItem;
begin
  Self.WsTokenDictOp(AConnection.UID, false);
  // 连接ID
  TThread.CreateAnonymousThread(
    procedure()
    begin
      sleep(200);
      // 发送WsUserID给用户
      Self.SendWsUserID(AConnection.UID);
    end
    ).Start;

end;
 
procedure TOneWebSocketServer.OnClose(const AConnection: ICrossWebSocketConnection);
var
  lTokenID:string;
  //lTokenInfo:TTokenItem;
begin
  // 中断连接
  Self.WsTokenDictOp(AConnection.UID, true);

//  if FConnectionList.TryGetValue(AConnection.UID,lTokenID) then
//  begin
//    FTokenManage.RemoveToken(lTokenID);
//  end;
end;

end.
