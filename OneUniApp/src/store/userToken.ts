import { UserStore } from './userStore'
//用户信息缓存
export default class TTokenInfo {
    public static storageName = "token";
    public isLogin: boolean = false; //是否登陆
    public tokenID: string = "";  //交互token
    public privateKey: string = "";  //用户私钥 
    //
    public userID: string = "";   //用户ID
    public userName: string = "游客"; //用户名称
    public userType: string = "";
    public loginCode: string = "";
    public loginPass: string = ""; //用户密码
    //
    public loginTime: number = 0;
    public lastTime: number = 0;
    public userInfo: any = {};  //用户其它信;
    public userCookies = ""; //Cookies
    public static InitToken(qTokenInfo: TTokenInfo) {
        qTokenInfo.isLogin = false; //是否登陆
        qTokenInfo.tokenID = "";  //交互token
        qTokenInfo.privateKey = "";  //用户私钥
        qTokenInfo.userID = "";   //用户ID
        qTokenInfo.userName = "游客"; //用户名称
        qTokenInfo.userType = "";
        // qTokenInfo.loginCode = ""; //不清保留
        qTokenInfo.loginPass = ""; //用户密码
        qTokenInfo.userInfo = {};  //用户其它信息
        qTokenInfo.userCookies = ""; //Cookies
    }
    public static initTokenInfo(qTokenInfo: TTokenInfo): void {
        qTokenInfo.isLogin = false; //是否登陆
        qTokenInfo.tokenID = "";  //交互token
        qTokenInfo.privateKey = "";  //用户私钥
        //
        qTokenInfo.userID = "";   //用户ID
        qTokenInfo.userName = "游客"; //用户名称
        qTokenInfo.userType = "";
        // qTokenInfo.loginCode = ""; //不清保留
        qTokenInfo.loginPass = ""; //用户密码
        qTokenInfo.userInfo = {};  //用户其它信息
        qTokenInfo.userCookies = ""; //Cookies
        TTokenInfo.saveLocalStorage(qTokenInfo);
    }
    public static saveLocalStorage(qTokenInfo: TTokenInfo): void {
        const lUserStore = UserStore();
        if (lUserStore.appID == undefined) {
            lUserStore.appID = "";
        }
        let lKey: string = lUserStore.appID + "_" + TTokenInfo.storageName;
        uni.setStorageSync(lKey, JSON.stringify(qTokenInfo));
    }
    public static loadLocalStorage(): TTokenInfo {
        const lUserStore = UserStore();
        if (lUserStore.appID == undefined) {
            lUserStore.appID = "";
        }
        let lKey: string = lUserStore.appID + "_" + TTokenInfo.storageName;
        let lJsonStr = uni.getStorageSync(lKey);
        if (lJsonStr) {

            let lTempToken = JSON.parse(lJsonStr);
            if (!lTempToken) {
                return new TTokenInfo();
            }
            return lTempToken as TTokenInfo;
        } else {
            return new TTokenInfo();
        }
    }
}