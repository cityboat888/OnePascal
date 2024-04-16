
import md5 from 'js-md5';
import { UserStore } from '@/store/userStore';
const HTTP_URL_TokenName = 'token';
const HTTP_URL_TokenTime = 'time';
const HTTP_URL_TokenSign = 'sign'; 

export const TActionResultCode = {
    resultInit: "0000",
    resultTrue: "0001",
    resultFail: "0002",
    resultTokenFail: "TokenFail",
    resultTokenSignFail: "TokenSignFail"
}
export interface IActionResult<T> {
    ResultSuccess: boolean;
    ResultCode: string;
    ResultMsg: string;
    ResultData: T
}
export class TActionResult {
    public ResultSuccess: boolean = false;
    public ResultCode: string = "";
    public ResultMsg: string = "";
    public ResultData: any = null;
    static createNew(): TActionResult {
        return new TActionResult();
    }
}
//定义事件类型 
type callBackHTTP = (response: TActionResult) => void; //事件回调
export enum TResultFormat { json, text, fileDown, imgPrint, pdfPrint }
//定义一个请求其相关类容
export class THTTPRequest {
    ////节流ID 底程跟据请求URL，内容算出节流ID
    //默认为空，不节流的话，自已在外面赋值GUID,否则有个问题 
    // 每次请求THTTPRequest多是一个新的对象  lockID直接赋值GUID等一每个多不一样的，无法达到节流的目的
    public lockID: string = "";
    public isThread: boolean = false;
    public url: string = "";  //请求的URL
    public method?: 'OPTIONS' | 'GET' | 'HEAD' | 'POST' | 'PUT' | 'DELETE' | 'TRACE' | 'CONNECT';
    public headers: any = { "Content-Type": "application/json" };
    public data: any = null;    //数据
    public onSuccess = function (response: TActionResult) { }; //执行成功事件
    public onFailed = function (response: TActionResult) { };  //执行失败事件
    public onError = function (response: TActionResult) { };  //执行异常事件
    public isResult = true;  //返回的是个标准接口格式
    public resultFormat: TResultFormat = TResultFormat.json;
    public fileName: string = "";//当下载文件保存成什么，如果没有的话服务端需暴露 "Access-Control-Expose-Headers", "Content-Disposition"
    //创建一个对象
    static createNew(isForm: boolean = false): THTTPRequest {
        let lRequest = new THTTPRequest();
        lRequest.isResult = true; //返回的结果是标准数据
        if (isForm) {
            //表单数据
            lRequest.headers["Content-Type"] = 'application/x-www-form-urlencoded';
            //参数形式如下
            //roleID=参数1值&indexNames=参数2值
        }
        return lRequest;
    }
    static createNewNoResult(isForm: boolean = false): THTTPRequest {
        let lRequest = new THTTPRequest();
        lRequest.isResult = false; //返回的结果自已解析
        if (isForm) {
            //表单数据
            lRequest.headers["Content-Type"] = 'application/x-www-form-urlencoded';
            //参数形式如下
            //roleID=参数1值&indexNames=参数2值
        }
        return lRequest;
    }
    //公共方法
    //"Content-Type": "application/x-www-form-urlencoded"
    public setHeadersUrlencoded() {
        this.headers = { "Content-Type": "application/x-www-form-urlencoded" }
    }
    //快捷方法
    public async httpDoAsync(): Promise<TActionResult> {
        return await THTTPClient.httpDoAsync(this);
    }

    public async getAsync(): Promise<TActionResult> {
        this.method = "GET";
        return await THTTPClient.httpGetAsync(this);
    }

    public async postAsync(): Promise<TActionResult> {
        this.method = "POST";
        return await THTTPClient.httpPostAsync(this);
    }

    public async putAsync(): Promise<TActionResult> {
        this.method = "PUT";
        return await THTTPClient.httpDoAsync(this);
    }

    public async deleteAsync(): Promise<TActionResult> {
        this.method = "DELETE";
        return await THTTPClient.httpDoAsync(this);
    }
    public async traceAsync(): Promise<TActionResult> {
        this.method = "TRACE";
        return await THTTPClient.httpDoAsync(this);
    }
}

//HTTP请求
export class THTTPClient {

    public static lockObject = new Map<string, number>();

    public static getFileName(disposition: string = ""): string {
        const utf8FilenameRegex = /filename\*=UTF-8''([\w%\-\.]+)(?:; ?|$)/;
        const asciiFilenameRegex = /filename=(["']?)(.*?[^\\])\1(?:; ?|$)/;

        let fileName: string = "";
        if (utf8FilenameRegex.test(disposition)) {
            let ltemp = utf8FilenameRegex.exec(disposition);
            if (ltemp instanceof Array) {
                fileName = ltemp[1];
                fileName = decodeURIComponent(fileName);
            }
        } else {
            const matches = asciiFilenameRegex.exec(disposition);
            if (matches != null && matches[2]) {
                fileName = matches[2];
            }
        }
        return fileName;
    }
    //URL签名 加全安全性
    public static urlMakeSign(qUrl: string): string {
        let lUserStore = UserStore();
        if (!lUserStore.userToken.isLogin) {
            //未登陆,原原本本返回去
            return qUrl;
        }
        let lTimestamp = Date.now();
        if (lUserStore.userToken.isLogin) {
            lUserStore.userToken.lastTime = lTimestamp;
        }
        let lSign = lUserStore.userToken.tokenID + lTimestamp.toString() + lUserStore.userToken.privateKey;
        lSign = md5(lSign);
        let lSinParams = [];
        lSinParams.push(HTTP_URL_TokenName+"=" + lUserStore.userToken.tokenID);
        lSinParams.push(HTTP_URL_TokenTime+"=" + lTimestamp);
        lSinParams.push(HTTP_URL_TokenSign+ "=" + lSign);
        lSign = lSinParams.join("&");
        //判断有没有参数
        if (qUrl.indexOf("?") > 0) {
            //直接拼接在后面
            qUrl = qUrl + "&" + lSign;
        } else {
            qUrl = qUrl + "?" + lSign;
        }
        return qUrl;
    }
    //节流ID算出
    public static lockIDGet(qRequest: THTTPRequest): boolean {
        if (!qRequest.lockID) {
            //循环处理数据时，记得更改qRequest.lockid,交互小于500毫秒时
            // 在API接口请求 xxxxx.lockid=随机的字符串或GUID或时间轴字符串多行
            //这边为空时要跟据 URL请求内容算出来的，每次请求每个多是独立的对象 
            //如果有自已复值lockID，循环处理时记得改变lockID
            let lLockID = "";
            if (qRequest.url) {
                lLockID = qRequest.url;
                //MD5
                lLockID = md5(lLockID);
            }
            if (!lLockID) {
                lLockID = Date.UTC.toString();
            }
            qRequest.lockID = lLockID;
        }
        //防抖处理
        if (!THTTPClient.lockObject.has(qRequest.lockID)) {
            THTTPClient.lockObject.set(qRequest.lockID, Date.now());
        } else {
            return false;
        }
        //处理500毫秒清掉这个key
        setTimeout(() => {
            THTTPClient.lockObject.delete(qRequest.lockID);
        }, 500);
        return true;
    }
    //HTTP异步请求
    public static async httpDoAsync(qRequest: THTTPRequest): Promise<TActionResult> {
        //算出节流ID
        if (!THTTPClient.lockIDGet(qRequest)) {
            let lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "客户端异常消息:" + "请勿在短时间内对同一URL发起重复请求,如果要请主动改变THTTPRequest.lockID值";
            return lActionResult;
        }
        //token签名，拼接在URL上，当然你喜欢放在请求头部也行 qRequest.headers添加相关参数
        qRequest.url = THTTPClient.urlMakeSign(qRequest.url);
        let lActionResult = TActionResult.createNew();
        await new Promise<boolean>((resolve, reject) => {
            uni.request(
                {
                    url: qRequest.url,
                    data: qRequest.data,
                    header: qRequest.headers,
                    method: qRequest.method,
                    timeout: 60000,
                    responseType: (qRequest.resultFormat == TResultFormat.fileDown || qRequest.resultFormat == TResultFormat.imgPrint) ? "arraybuffer" : "text",
                    success: (response: any) => {
                        if (response.statusCode == undefined) {
                            lActionResult.ResultMsg = "异常错误【返回的数据不包含statusCode,可能取值错误！！！】";
                        }
                        else if (response.statusCode == 200) {
                            if (qRequest.isResult && response.data.ResultCode) {
                                lActionResult.ResultCode = response.data.ResultCode;
                                lActionResult.ResultMsg = response.data.ResultMsg;
                                //lActionResult.resultFormat = response.data.resultFormat;
                                lActionResult.ResultData = response.data.ResultData;
                                //lActionResult.resultTotal = response.data.resultTotal;
                                if (lActionResult.ResultCode == TActionResultCode.resultTrue) {
                                    lActionResult.ResultSuccess = true;
                                }
                            } else {
                                //非标准的Result格式
                                lActionResult.ResultData = response.data;
                            }
                        } else if (response.statusCode == 404) {
                            lActionResult.ResultMsg = "404错误,请检查API地址->[" + qRequest.url + "]是否正确?";

                        } else {
                            lActionResult.ResultMsg = "未知的错误,错误消息:" + JSON.stringify(response);
                        }
                        return resolve(true);
                    },
                    fail: (err: any) => {
                        lActionResult.ResultMsg = "异常错误【" + JSON.stringify(err) + "】";
                        return resolve(false);
                    },
                    complete: (result: any) => {
                    }
                }
            )
        })
        return lActionResult;
    }
    // async
    public static async httpGetAsync(qRequest: THTTPRequest, qUrlencoded: boolean = true): Promise<TActionResult> {
        qRequest.method = 'GET';
        if (qUrlencoded) {
            qRequest.setHeadersUrlencoded();
        }
        return await this.httpDoAsync(qRequest);
    }
    public static async httpPostAsync(qRequest: THTTPRequest): Promise<TActionResult> {
        qRequest.method = 'POST';
        return await this.httpDoAsync(qRequest);
    }
    public static async httpPutAsync(qRequest: THTTPRequest): Promise<TActionResult> {
        qRequest.method = 'PUT';
        return await this.httpDoAsync(qRequest);
    }
    public static async httpDeleteAsync(qRequest: THTTPRequest): Promise<TActionResult> {
        qRequest.method = 'DELETE';
        return await this.httpDoAsync(qRequest);
    }
}

export default THTTPClient