import { TActionResult, THTTPRequest, TResultFormat, type IActionResult } from "@/baselib/apublic/HTTPClient";
import UrlHelper from "@/baselib/apublic/UrlHelper";


export interface TGoodsDemo {
    FGoodsID: string;
    FGoodsCode: string;
    FGoodsName: string;
    FGoodsPrice: number;
    FGoodsRemark: string;
    FGoodsImgUrl: string;
}


export default class GoodsApi {
    //获取商品列表数据
    public static async GetGoodsList(qPageIndex: number, qPageSize: number, qGoodInfo: string): Promise<IActionResult<TGoodsDemo[]>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/Goods/GetGoodsList");
        lRequest.data = { pageIndex: qPageIndex, pageSize: qPageSize, goodInfo: qGoodInfo }; //没有数据放空
        lRequest.isThread = true;
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();  //Get请求 
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }

    public static async GetGoods(qGoodsID: string): Promise<IActionResult<TGoodsDemo>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/Goods/GetGoods");
        lRequest.data = { QGoodsID: qGoodsID }; //没有数据放空
        lRequest.isThread = true;
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();  //Get请求 
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }

    //保存商品资料
    public static async SaveGoods(qGoods: TGoodsDemo): Promise<IActionResult<string>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/Goods/SaveGoods");
        lRequest.data = qGoods; //没有数据放空
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();  //Get请求 
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }


    public static GetGoodsImgUrl(qImgUrl: string): string {
        return UrlHelper.urlCombinationApiBaseUrl("/UniDemo/Goods/OneGetGoodsImg?imgid=" + qImgUrl);
    }

}