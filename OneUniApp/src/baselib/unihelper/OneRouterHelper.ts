import { UserStore } from '@/store/userStore'

export interface IOneRouterConfig {
    path: string; //"路径不代参数的"
    urlParams: any; //JSON对象
    dataParams: any; //URL的参数是有限的，当复杂的情况用此
    success: any;
    fail: any;
    complete: any;
    events: any;
    delta: number;
}
//路由守卫拦截,因为UNIAPP无拦截概念。
export default class OneRouterHelper {
    private static lockObject = new Map<string, number>(); //防斗
    private static tempUrlParams: any = undefined; //此参数用来临时保存复杂的传参情况,用完即没
    private static tempDataParams: any = undefined; //此参数用来临时保存复杂的传参情况,用完即没
    private static FJumpAuthPage: string[] = []; //不需要登陆验证的页面
    private static FMustAuthPage: string[] = []; //需要登陆验证的页面
    private static FShowTabBarPage: string[] = [];
    public static lockIDGet(qpath: string): boolean {
        if (!OneRouterHelper.lockObject.has(qpath)) {
            OneRouterHelper.lockObject.set(qpath, Date.now());
        } else {
            return false;
        }
        //处理500毫秒清掉这个key
        setTimeout(() => {
            OneRouterHelper.lockObject.delete(qpath);
        }, 500);
        return true;
    }
    public static getUrlJsonParams(): any {
        if (OneRouterHelper.tempUrlParams == undefined) {
            return {};
        }
        let lUrlParam = OneRouterHelper.tempUrlParams;
        OneRouterHelper.tempUrlParams = undefined;
        return lUrlParam;
    }
    //复杂参数获取
    public static getDataParams(): any {
        //获取参数,同时清空参数
        let lParams = OneRouterHelper.tempDataParams;
        OneRouterHelper.tempDataParams = undefined;
        return lParams
    }
    public static addJumpAuthPage(qPagePath: string) {
        //添加不需要验证的页面
        //模式，个别页面不用验证，大部份页面要验证
        let iIndex = this.FJumpAuthPage.findIndex((item) => { return item == qPagePath })
        if (iIndex == -1) {
            this.FJumpAuthPage.push(qPagePath);
        }
        //,此时FMustAuthPage无效,不可混用，不然不知道要做什么事
        this.FMustAuthPage = [];
    }
    public static addMustAuthPage(qPagePath: string) {
        //添加需要验证的页面
        //模式，个别页面要验证，大部份页面不需要要验证,
        let iIndex = this.FMustAuthPage.findIndex((item) => { return item == qPagePath })
        if (iIndex == -1) {
            this.FMustAuthPage.push(qPagePath);
        }
        //此时FJumpAuthPage无效，不然不知道要做什么事
        this.FJumpAuthPage = [];
    }
    public static addShowTabBarPage(qPagePath: string) {
        let iIndex = this.FShowTabBarPage.findIndex((item) => { return item == qPagePath })
        if (iIndex == -1) {
            this.FShowTabBarPage.push(qPagePath);
        }
    }
    private static checkAuthTrue(qPagePath: string): boolean {
        if (!qPagePath) {
            return true;
        }
        if (this.FJumpAuthPage.length > 0) {
            //模式，个别页面不用验证，大部份页面要验证，用此
            let iIndex = this.FJumpAuthPage.findIndex((item) => { return item == qPagePath });
            if (iIndex >= 0) {
                return true;
            } else {
                const lUserStore = UserStore();
                return lUserStore.userToken.isLogin;
            }
        }
        if (this.FMustAuthPage.length > 0) {
            //模式，个别页面需要验证，大部份页面不需要验证，用此
            let iIndex = this.FMustAuthPage.findIndex((item) => { return item == qPagePath });
            if (iIndex >= 0) {
                //需要验证
                const lUserStore = UserStore();
                return lUserStore.userToken.isLogin;
            } else {
                return true;
            }
        }
        //两者多为空,没有授权把控直接成功
        return true;
    }
    private static checkTabBar(qPagePath: string) {
        let iIndex = this.FShowTabBarPage.findIndex((item) => { return item == qPagePath })
        if (iIndex == -1) {
            //uni.hideTabBar();
        } else {
            // uni.showTabBar();
        }
    }
    private static configGetUrl(qConfig: IOneRouterConfig): string {
        let lUrl = qConfig.path.trimStart();
        //判断是不是/开头，不是的话加上 / ,如果以.开头也不管，说明是自已定位的路径
        let lFirst = lUrl.substring(0, 1);
        if (lFirst != "." && lFirst != "/") {
            lUrl = "/" + lUrl;
        }
        if (qConfig.urlParams != undefined) {
            let lJoin = false;
            lUrl = lUrl + "?"
            for (let lkey in qConfig.urlParams) {
                if (qConfig.urlParams[lkey] != undefined) {
                    lUrl = lUrl + lkey + "=" + qConfig.urlParams[lkey] + "&";
                    lJoin = true;
                }
            }
            //去掉最后一个 &
            if (lJoin) {
                lUrl = lUrl.slice(0, -1)
            }
        }
        return lUrl;
    }
    public static createRouterConfig(): IOneRouterConfig {
        let lConfig: IOneRouterConfig = {
            path: "",
            urlParams: {},
            dataParams: undefined,
            success: undefined,
            fail: undefined,
            complete: undefined,
            events: undefined,
            delta: 1
        };
        return lConfig;
    }
    public static navigateToLogin() {
        let lLoginPage = "/pages/login/index";
        if (!OneRouterHelper.lockIDGet(lLoginPage)) {
            return
        }
        uni.navigateTo({ url: lLoginPage });
    }
    public static navigateToHome() {
        let lLoginPage = "/pages/home/index";
        if (!OneRouterHelper.lockIDGet(lLoginPage)) {
            return
        }
        uni.navigateTo({ url: lLoginPage });
    }
    public static navigateTo(qConfig: IOneRouterConfig) {
        if (!qConfig.path) {
            console.error("路由路径为空")
            return;
        }
        if (!OneRouterHelper.lockIDGet(qConfig.path)) {
            return
        }
        if (!OneRouterHelper.checkAuthTrue(qConfig.path)) {
            //跳转到登陆界面
            //url路径 /不然会定位出错
            let lLoginPage = "/pages/login/index";
            uni.navigateTo({ url: lLoginPage });
            OneRouterHelper.checkTabBar(lLoginPage);
            return;
        }
        //url组装
        let lUrl = OneRouterHelper.configGetUrl(qConfig);
        let lObj: any = { url: lUrl, events: qConfig.events, success: qConfig.success, fail: qConfig.fail, complete: qConfig.complete };
        OneRouterHelper.tempDataParams = qConfig.dataParams;
        OneRouterHelper.tempUrlParams = qConfig.urlParams;
        uni.navigateTo(lObj);
    }
    public static redirectTo(qConfig: IOneRouterConfig) {
        if (!qConfig.path) {
            console.error("路由路径为空")
            return;
        }
        if (!OneRouterHelper.lockIDGet(qConfig.path)) {
            return
        }
        if (!OneRouterHelper.checkAuthTrue(qConfig.path)) {
            //跳转到登陆界面
            //url路径 /不然会定位出错
            let lLoginPage = "/pages/login/index";
            uni.navigateTo({ url: lLoginPage });
            OneRouterHelper.checkTabBar(lLoginPage);
            return;
        }
        //url组装
        let lUrl = OneRouterHelper.configGetUrl(qConfig);
        let lObj: any = { url: lUrl, success: qConfig.success, fail: qConfig.fail, complete: qConfig.complete };
        OneRouterHelper.tempDataParams = qConfig.dataParams;
        OneRouterHelper.tempUrlParams = qConfig.urlParams;
        uni.redirectTo(lObj);
    }
    public static reLaunch(qConfig: IOneRouterConfig) {
        if (!qConfig.path) {
            console.error("路由路径为空")
            return;
        }
        if (!OneRouterHelper.lockIDGet(qConfig.path)) {
            return
        }
        if (!OneRouterHelper.checkAuthTrue(qConfig.path)) {
            //跳转到登陆界面
            //url路径 /不然会定位出错
            let lLoginPage = "/pages/login/index";
            uni.navigateTo({ url: lLoginPage });
            OneRouterHelper.checkTabBar(lLoginPage);
            return;
        }
        //url组装
        let lUrl = OneRouterHelper.configGetUrl(qConfig);
        let lObj: any = { url: lUrl, success: qConfig.success, fail: qConfig.fail, complete: qConfig.complete };
        OneRouterHelper.tempDataParams = qConfig.dataParams;
        OneRouterHelper.tempUrlParams = qConfig.urlParams;
        uni.reLaunch(lObj);
    }
    public static switchTab(qConfig: IOneRouterConfig) {
        if (!qConfig.path) {
            console.error("路由路径为空")
            return;
        }
        if (!OneRouterHelper.lockIDGet(qConfig.path)) {
            return
        }
        if (!OneRouterHelper.checkAuthTrue(qConfig.path)) {
            //跳转到登陆界面
            //url路径 /不然会定位出错
            let lLoginPage = "/pages/login/index";
            uni.navigateTo({ url: lLoginPage });
            OneRouterHelper.checkTabBar(lLoginPage);
            return;
        }
        //url组装
        let lUrl = OneRouterHelper.configGetUrl(qConfig);
        let lObj: any = { url: lUrl, success: qConfig.success, fail: qConfig.fail, complete: qConfig.complete };
        OneRouterHelper.tempDataParams = qConfig.dataParams;
        OneRouterHelper.tempUrlParams = qConfig.urlParams;
        uni.switchTab(lObj);
    }
    public static navigateBack(qConfig: IOneRouterConfig) {
        if (!qConfig.path) {
            console.error("路由路径为空")
            return;
        }
        if (!OneRouterHelper.lockIDGet(qConfig.path)) {
            return
        }
        if (!OneRouterHelper.checkAuthTrue(qConfig.path)) {
            //跳转到登陆界面
            //url路径 /不然会定位出错
            let lLoginPage = "/pages/login/index";
            uni.navigateTo({ url: lLoginPage });
            OneRouterHelper.checkTabBar(lLoginPage);
            return;
        }
        //url组装
        let lUrl = OneRouterHelper.configGetUrl(qConfig);
        let lObj: any = { delta: qConfig.delta, success: qConfig.success, fail: qConfig.fail, complete: qConfig.complete };
        OneRouterHelper.tempDataParams = qConfig.dataParams;
        OneRouterHelper.tempUrlParams = qConfig.urlParams;
        uni.navigateBack(lObj);
    }
    public static navigateBackRefresh(qData: any) {
        if (!OneRouterHelper.lockIDGet("navigateBackRefresh")) {
            return
        }
        let pages = getCurrentPages();
        let beforePage = pages[pages.length - 2];
        uni.navigateBack({
            delta: 1,
            success: function () {
                let lBackEven = beforePage.$vm.onBackRefresh;
                if (lBackEven) {
                    lBackEven(qData)
                } else {
                    uni.showModal({
                        content: "返回刷新事件，上个页面需设定方法【onBackRefresh(qData:any)】",
                        showCancel: false,
                    });
                }
            }
        });
    }
    //往回退一格
    public static navigateBackOne() {
        if (!OneRouterHelper.lockIDGet("navigateBackOne")) {
            return
        }
        uni.navigateBack({ delta: 1 });
    }

    //获取路由参数
    public static getLocationParams(qParamName: string): string {
        if (!qParamName) {
            return '';
        }
        let pages = getCurrentPages();
        let curpag = pages[pages.length - 1];
        let lStr = curpag.$page.options[qParamName];
        if (!lStr) {
            return "";
        }
        return lStr;
    }
}

// 路由拦截
export function RouterInterceptor() {
    uni.addInterceptor('request', {
        invoke(args) {
            // request 触发事件拦截

        },
        success(args) {
            //登陆失效
            if (args.data && args.data.ResultCode && args.data.ResultCode == "tokenInvalid") {
                //已
                setTimeout(() => {
                    //弹出在次验证,在LayOutMain监听
                    OneRouterHelper.navigateToLogin();
                    setTimeout(() => {
                        uni.showToast({
                            title: '未登陆请先登陆!!!',
                            duration: 2000
                        })
                    }, 500);

                }, 200);
                //中断程序运行 
                throw "";
            }
        },
        fail(err) {
            console.error('interceptor-fail', err)
        },
        complete(res) {
            console.log('interceptor-complete', res)
        }
    })
}

