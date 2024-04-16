import { TActionResult, THTTPRequest, type IActionResult } from "@/baselib/apublic/HTTPClient";
import UrlHelper from "@/baselib/apublic/UrlHelper";

export interface TSendReceiv {
    FCustomerID: string;
    FCustomerCode: string;
    FCustomerName: string;
    FCustomerType: string;
    FCustomerLXR: string;
    FCustomerTel: string;
    FCustomerRemark: string;
    FCreateID: string;
    FCreateName: string;
    FCreateTime: string;
}


export interface TBillSend {
    FBillID: string;
    FBillNo: string;
    FBillType: string;
    FBillDate: string;
    FBillSenderID: string;
    FBillSenderCode: string;
    FBillSenderName: string;
    FBillSenderLXR: string;
    FBillSenderTel: string;
    FBillSenderAddress: string;
    FBillReceivID: string;
    FBillReceivCode: string;
    FBillReceivName: string;
    FBillReceivLXR: string;
    FBillReceivTel: string;
    FBillReceivAddress: string;
    FBillAmount: number;
    FBillRemark: string;
    FIsCFM: boolean;
    FCFMName: string;
    FCFMTime: string;
    FCreateID: string;
    FCreateName: string;
    FCreateTime: string;
}


export interface TBillDetail {
    FDetailID: string;
    FBillID: string;
    FOrderNumber: number;
    FGoodsID: string;
    FGoodsCode: string;
    FGoodsName: string;
    FGoodsQuantity: number;
    FGoodsPrice: number;
    FGoodsAmount: number;
    FDetailRemark: string;
}

export interface TBillSendInfo {
    BillSend: TBillSend;
    BillDetails: TBillDetail[];
    Dels: string[];
}

export default class SendReciveApi {

    //获取发货方 
    public static async GetSendCustomerList(qPageIndex: number, qPageSize: number, qcusttype: string, qCustInfo: string): Promise<IActionResult<TSendReceiv[]>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/SendReceiv/GetSendReceivList");
        lRequest.data = { pageIndex: qPageIndex, pageSize: qPageSize, custtype: qcusttype, custInfo: qCustInfo }; //没有数据放空
        lRequest.isThread = true;
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();  //Get请求 
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }

    //获取客户资料
    public static async GetSendReceiv(qCustomerID: string): Promise<IActionResult<TSendReceiv>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/SendReceiv/GetSendReceiv");
        lRequest.data = { QCustomerID: qCustomerID }; //没有数据放空
        lRequest.isThread = true;
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }

    //保存客户资料,返回客户ID
    public static async SaveSendReceiv(qCusomter: TSendReceiv): Promise<IActionResult<string>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/SendReceiv/SaveSendReceiv");
        lRequest.data = qCusomter; //没有数据放空
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }


    //获取发货单列表
    public static async GetBillSendList(qPageIndex: number, qPageSize: number, qStarTime: string, qEndTime: string, qCMFStatus: string): Promise<IActionResult<TBillSend[]>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/BillSend/GetBillSendList");
        lRequest.data = { pageIndex: qPageIndex, pageSize: qPageSize, QStarTime: qStarTime, QEndTime: qEndTime, QCMFStatus: qCMFStatus }; //没有数据放空
        lRequest.isThread = true;
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }

    //获取发货单信息
    public static async GetBillSendInfo(qBillID: string): Promise<IActionResult<TBillSendInfo>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/BillSend/GetBillSendInfo");
        lRequest.data = { QBillID: qBillID }; //没有数据放空
        lRequest.isThread = true;
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }

    //保存发货单
    public static async SaveBillSendInfo(qBillInfo: TBillSendInfo): Promise<IActionResult<string>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/BillSend/SaveBillSendInfo");
        lRequest.data = qBillInfo; //没有数据放空
        lRequest.isThread = true;
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }

    //发货单操作命令-删除
    public static async BillSendDel(qBillID: string): Promise<IActionResult<string>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/BillSend/BillSendCmd");
        lRequest.data = { QBillID: qBillID, QCmd: '删除' }; //没有数据放空
        lRequest.isThread = true;
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }

    //发货单操作命令-审核
    public static async BillSendCFM(qBillID: string): Promise<IActionResult<string>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/BillSend/BillSendCmd");
        lRequest.data = { QBillID: qBillID, QCmd: '审核' }; //没有数据放空
        lRequest.isThread = true;
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }
    //发货单操作命令-去审
    public static async BillSendCFMCancle(qBillID: string): Promise<IActionResult<string>> {
        let lActionResult: TActionResult;
        let lRequest = THTTPRequest.createNew();
        lRequest.url = UrlHelper.urlCombinationApiBaseUrl("/UniDemo/BillSend/BillSendCmd");
        lRequest.data = { QBillID: qBillID, QCmd: '去审' }; //没有数据放空
        lRequest.isThread = true;
        //GET,POST多行，服务端这个方法支持GET也支持POST ，有的只支持GET 有的只支持POST 注意
        lActionResult = await lRequest.postAsync();
        if (lActionResult == null) {
            lActionResult = TActionResult.createNew();
            lActionResult.ResultMsg = "异常消息:结果为null"
        }
        return lActionResult;
    }

}