
import { TActionResult, THTTPRequest, type IActionResult } from "@/baselib/apublic/HTTPClient";
import UrlHelper from "@/baselib/apublic/UrlHelper";

export interface TLoginInfo {
    loginCode: string;
    loginPass: string;
    loginZTCode: string;
    tokenID: string;
    privateKey: string;
    userName: string;
}

export default class LoginApi {
    public static async Login(QLoginInfo: TLoginInfo): Promise<IActionResult<TLoginInfo>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/Login/Login");
        lRequest.data = QLoginInfo; //没有数据放空
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();  //Get请求 
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }

    public static async LoginOut(QLoginInfo: TLoginInfo): Promise<IActionResult<TLoginInfo>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/Login/LoginOut");
        lRequest.data = QLoginInfo; //没有数据放空
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();  //Get请求 
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }
}