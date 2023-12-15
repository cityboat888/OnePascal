所需文件:

1.最新版的Delphi-Cross-Socket下载地址:

开源地址: https://github.com/winddriver/Delphi-Cross-Socket

2.最新版的mORMot2 
开源地址: https://github.com/synopse/mORMot2 

注意： static目录里的文件需要单独下载

 https://synopse.info/files/mormot2static.7z

3.cnpack开源地址: https://github.com/cnpack/cnvcl

4.以下文件在CnVcl_Crypto有打包,也可自行到cnpack或相关网站下载

cn*.*/zLib.inc /zlib1.dll/CnPack.inc

5.需配置路径(见主目录:lazarus-set.jpg)
![Alt text](2.png)







-------------更新说明-------------------------
日期:2023-12-13
服务端:
	1.修正SaveDatas多个保存数据集的bug
	2.增加FastApi功能
客户端:
	1.增加客户端 ClientDemoFastApi 配置界面

**************2023-12-04************
服务端:
	1.增加了RTC中间件的支持
                 修改 one.inc文件 默认 {$DEFINE ONEMORMOT}  改成 {$DEFINE ONERTC} 即可
	 当然你修改了RTC在工程Project inspector 项目所需要的Required packages也要添加对应的RTC控件包
	 当你启用 ONRRTC mormot2控件包就没用了

                2.修正服务端控制层 TActionResult返回结果异常
                3.其它优化


日期:2023-12-08
服务端:
	1.账套交互超过10分钟没交互,在次交互，会断开在重连。
	2.账套在LockZT时会判断是不是已连，未连重新连接

客户端控件包:

	1.修正TActionResultT改成TActionResult与服务端保持一至

本次升级，请控件包也要一起升级，否则会出现客户端服务端交互不了


**************2023-10-24************
服务端
	1.修正前端FormData文件上传 即Multipart上传功能
	参考单元 \httpServer\controller\unidemocontroller.pas 
                  // 文件上传
                 function PostFile(QFormData: TOneMultipartDecode): TActionResultString;
                2.修正序列化单元一些错误提示
