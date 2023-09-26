program CrossOneServer;
{$R *.res}
{$I Neon.inc}


uses
  Vcl.Forms,
  Winapi.Windows,
  system.IOUtils,
  OneWebSocketServer in 'Cross\OneWebSocketServer.pas',
  OneHttpServer in 'Cross\OneHttpServer.pas',
  OneHttpCtxtResult in 'Cross\OneHttpCtxtResult.pas',
  frm_main in 'OneServer\frm_main.pas' {frmMain},
  OneTokenManage in 'OneServer\basLib\token\OneTokenManage.pas',
  OneHttpController in 'OneServer\httpServer\OneHttpController.pas',
  TokenController in 'OneServer\httpServer\Controller\TokenController.pas',
  DataController in 'OneServer\httpServer\Controller\DataController.pas',
  VirtualFileController in 'OneServer\httpServer\Controller\VirtualFileController.pas',
  OneHttpControllerRtti in 'OneServer\httpServer\OneHttpControllerRtti.pas',
  OneHttpRouterManage in 'OneServer\httpServer\OneHttpRouterManage.pas',
  DemoController in 'OneServer\httpServer\Controller\Demo\DemoController.pas',
  Neon.Core.Attributes in 'OneServer\NeonSerialization\Neon.Core.Attributes.pas',
  Neon.Core.DynamicTypes in 'OneServer\NeonSerialization\Neon.Core.DynamicTypes.pas',
  Neon.Core.Nullables in 'OneServer\NeonSerialization\Neon.Core.Nullables.pas',
  Neon.Core.Persistence.JSON in 'OneServer\NeonSerialization\Neon.Core.Persistence.JSON.pas',
  Neon.Core.Persistence.JSON.Schema in 'OneServer\NeonSerialization\Neon.Core.Persistence.JSON.Schema.pas',
  Neon.Core.Persistence in 'OneServer\NeonSerialization\Neon.Core.Persistence.pas',
  Neon.Core.Serializers.DB in 'OneServer\NeonSerialization\Neon.Core.Serializers.DB.pas',
  Neon.Core.Serializers.Nullables in 'OneServer\NeonSerialization\Neon.Core.Serializers.Nullables.pas',
  Neon.Core.Serializers.RTL in 'OneServer\NeonSerialization\Neon.Core.Serializers.RTL.pas',
  Neon.Core.TypeInfo in 'OneServer\NeonSerialization\Neon.Core.TypeInfo.pas',
  Neon.Core.Types in 'OneServer\NeonSerialization\Neon.Core.Types.pas',
  Neon.Core.Utils in 'OneServer\NeonSerialization\Neon.Core.Utils.pas',
  OneZTManage in 'OneServer\DBCenter\OneZTManage.pas',
  OneILog in 'OneServer\basLib\logger\OneILog.pas',
  OneLog in 'OneServer\basLib\logger\OneLog.pas',
  OneThread in 'OneServer\basLib\thread\OneThread.pas',
  DemoOneWorkThread in 'OneServer\httpServer\Controller\Demo\DemoOneWorkThread.pas',
  OneDataInfo in 'OneServer\DBCenter\OneDataInfo.pas',
  OneSQLCrypto in 'OneServer\basLib\crypto\OneSQLCrypto.pas',
  OneStreamString in 'OneServer\basLib\crypto\OneStreamString.pas',
  OneGUID in 'OneServer\basLib\func\OneGUID.pas',
  OneFileHelper in 'OneServer\basLib\func\OneFileHelper.pas',
  OneGlobal in 'OneServer\OneGlobal.pas',
  OneDateTimeHelper in 'OneServer\basLib\func\OneDateTimeHelper.pas',
  OneNeonHelper in 'OneServer\NeonSerialization\OneNeonHelper.pas',
  OneCrypto in 'OneServer\basLib\crypto\OneCrypto.pas',
  OneRttiHelper in 'OneServer\basLib\rtti\OneRttiHelper.pas',
  DemoCustResult in 'OneServer\httpServer\Controller\Demo\DemoCustResult.pas',
  OneCompilerVersion in 'OneServer\OneCompilerVersion.pas',
  DemoJsonController in 'OneServer\httpServer\Controller\Demo\DemoJsonController.pas',
  DemoDataController in 'OneServer\httpServer\Controller\Demo\DemoDataController.pas',
  DemoZTController in 'OneServer\httpServer\Controller\Demo\DemoZTController.pas',
  DemoTestController in 'OneServer\httpServer\Controller\Demo\DemoTestController.pas',
  OneControllerResult in 'OneServer\httpServer\OneControllerResult.pas',
  OneHttpConst in 'OneServer\httpServer\OneHttpConst.pas',
  DemoLogController in 'OneServer\httpServer\Controller\Demo\DemoLogController.pas',
  OneVirtualFile in 'OneServer\basLib\virtualFile\OneVirtualFile.pas',
  OneOrm in 'OneServer\DBCenter\OneOrm.pas',
  OneOrmRtti in 'OneServer\DBCenter\OneOrmRtti.pas',
  DemoOrmController in 'OneServer\httpServer\Controller\Demo\DemoOrmController.pas',
  OneAttribute in 'OneServer\basLib\attribute\OneAttribute.pas',
  DemoMyController in 'OneServer\httpServer\Controller\Demo\DemoMyController.pas',
  DemoWebFileController in 'OneServer\httpServer\Controller\Demo\DemoWebFileController.pas',
  DemoVersionController in 'OneServer\httpServer\Controller\Demo\DemoVersionController.pas',
  OneWinReg in 'OneServer\basLib\winRegister\OneWinReg.pas',
  OneMultipart in 'OneServer\basLib\multipart\OneMultipart.pas',
  UniLoginController in 'OneServer\OneUniDemo\UniLoginController.pas',
  OneFastLoginController in 'OneServer\OneFastCleint\OneFastLoginController.pas',
  OneFastAdminController in 'OneServer\OneFastCleint\OneFastAdminController.pas',
  UniGoodsController in 'OneServer\OneUniDemo\UniGoodsController.pas',
  UniBillSendController in 'OneServer\OneUniDemo\UniBillSendController.pas',
  UniClass in 'OneServer\OneUniDemo\UniClass.pas',
  UniSendReceivController in 'OneServer\OneUniDemo\UniSendReceivController.pas',
  OneFastModuleManage in 'OneServer\OneFastCleint\OneFastModuleManage.pas',
  OneFastModuleController in 'OneServer\OneFastCleint\OneFastModuleController.pas',
  ZTManageController in 'OneServer\httpServer\Controller\ZTManageController.pas',
  DemoUrlPathController in 'OneServer\httpServer\Controller\Demo\DemoUrlPathController.pas',
  OneFastApiManage in 'OneServer\OneFastApi\OneFastApiManage.pas',
  OneFastApiController in 'OneServer\OneFastApi\OneFastApiController.pas',
  OneFastApiDo in 'OneServer\OneFastApi\OneFastApiDo.pas',
  WeiXinManage in 'OneServer\OneFastWeiXin\WeiXinManage.pas',
  WeixinApi in 'OneServer\OneFastWeiXin\WeixinApi.pas',
  WeixinAuthController in 'OneServer\OneFastWeiXin\WeixinAuthController.pas',
  WeixinAdminController in 'OneServer\OneFastWeiXin\WeixinAdminController.pas',
  WeiXinMinApi in 'OneServer\OneFastWeiXin\WeiXinMinApi.pas',
  WeixinApiPublic in 'OneServer\OneFastWeiXin\WeixinApiPublic.pas',
  uDefaultIdGenerator in 'OneServer\basLib\uuid\uDefaultIdGenerator.pas',
  uYitIdHelper in 'OneServer\basLib\uuid\uYitIdHelper.pas',
  uIdGeneratorOptions in 'OneServer\basLib\uuid\Contract\uIdGeneratorOptions.pas',
  uIIdGenerator in 'OneServer\basLib\uuid\Contract\uIIdGenerator.pas',
  uISnowWorker in 'OneServer\basLib\uuid\Contract\uISnowWorker.pas',
  uTOverCostActionArg in 'OneServer\basLib\uuid\Contract\uTOverCostActionArg.pas',
  uSnowWorkerM1 in 'OneServer\basLib\uuid\Core\uSnowWorkerM1.pas',
  uSnowWorkerM2 in 'OneServer\basLib\uuid\Core\uSnowWorkerM2.pas',
  uSnowWorkerM3 in 'OneServer\basLib\uuid\Core\uSnowWorkerM3.pas',
  OneUUID in 'OneServer\basLib\uuid\OneUUID.pas',
  OneFastLshManage in 'OneServer\OneFastLsh\OneFastLshManage.pas',
  OneFastLshController in 'OneServer\OneFastLsh\OneFastLshController.pas',
  OneFastUpdateManage in 'OneServer\OneFastUpload\OneFastUpdateManage.pas',
  OneFastUpdateController in 'OneServer\OneFastUpload\OneFastUpdateController.pas',
  OneFastFileMange in 'OneServer\OneFastFile\OneFastFileMange.pas',
  OneFastFileController in 'OneServer\OneFastFile\OneFastFileController.pas',
  OneWsChatController in 'OneServer\httpServer\Controller\OneWsChatController.pas',
  OneWebSocketConst in 'OneServer\httpServer\OneWebSocketConst.pas';

var
  lpStartupInfo: TStartupInfo;
  lpProcessInformation: TProcessInformation;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  // debug状态下弹出内存泄漏报告
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := True;
  // 设置软件系统时间格式
  Application.UpdateFormatSettings := false;
  OneDateTimeHelper.SetSystemDataTimeFormatSettings();
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
  // 添加重启代码 ，win特有的，如果移值到其它平台请剁掉
  if not Restart_Flag then
    Exit; // 不需要重启
  FillChar(lpStartupInfo, sizeof(lpStartupInfo), 0);
  FillChar(lpProcessInformation, sizeof(lpProcessInformation), 0);
  lpStartupInfo.cb := sizeof(lpStartupInfo);
  if CreateProcess(nil, PChar(Application.ExeName), nil, nil, false, 0, nil, nil, lpStartupInfo, lpProcessInformation) then
  begin
    CloseHandle(lpProcessInformation.hThread);
    CloseHandle(lpProcessInformation.hProcess);
  end;

end.
