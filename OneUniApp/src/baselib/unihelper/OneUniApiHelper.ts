import UrlHelper from "@/baselib/apublic/UrlHelper";
import { TActionResult, type IActionResult } from "../apublic/HTTPClient";
export interface IScanResult {
    success: boolean;
    result: string;
    scanType: string;
    errMsg: string;
}
export interface IChooseFileResult {
    sucess: boolean;
    fileCount: number;
    filePaths: string[];
    files: IChooseFile[];
    errMsg: string;
}
export interface IChooseFile {
    path: string;  //本地文件路径
    size: number; //文件大小
    name: string; //包含扩展名的文件名称，仅H5支持
    type: string; //文件类型，仅H5支持
    file?: File;
}
export interface IPostFileResult {
    sucess: boolean;
    statusCode: number;
    returnData: string; //返回的数据
    errMsg: string;
}
export default class OneUniApiHelper {
    public static CreateScanResult(): IScanResult {
        let lScanResult: IScanResult = {
            success: false,
            result: "",
            scanType: "",
            errMsg: ""
        };
        return lScanResult;
    }
    public static CreateChooseFileResult(): IChooseFileResult {
        let lFileResult: IChooseFileResult = {
            sucess: false,
            fileCount: 0,
            filePaths: [],
            files: [],
            errMsg: ""
        };
        return lFileResult;
    }
    public static CreateChooseFile(): IChooseFile {
        let lChooseFile: IChooseFile = {
            path: "",
            size: 0,
            name: "",
            type: "",
            file: undefined
        };
        return lChooseFile;
    }


    //扫条码
    public static async ScanBarCode(): Promise<IScanResult> {
        let lScanResult = OneUniApiHelper.CreateScanResult();
        await new Promise<void>((resolve, reject) => {
            uni.scanCode({
                scanType: ['barCode'],
                success: function (res) {
                    lScanResult.success = true;
                    lScanResult.scanType = res.scanType;
                    lScanResult.result = res.result;
                    resolve();
                },
                fail: function (result: any) {
                    lScanResult.errMsg = JSON.stringify(result);
                    reject();
                }
            });
        })
        return lScanResult;
    }
    //选择图片
    public static async ChooseImage(iCount: number = 1): Promise<IChooseFileResult> {
        let lChooseResult = OneUniApiHelper.CreateChooseFileResult();
        await new Promise<void>((resolve, reject) => {
            uni.chooseImage({
                count: iCount,
                sizeType: ['original'],
                sourceType: ['album','camera'], //从相册选择
                success: function (res) {
                    lChooseResult.sucess = true;
                    if (typeof res.tempFilePaths == "string") {
                        lChooseResult.fileCount = 1;
                        lChooseResult.filePaths.push(res.tempFilePaths)
                    } else {
                        lChooseResult.filePaths = res.tempFilePaths;
                        lChooseResult.fileCount = lChooseResult.filePaths.length;
                    }
                    if (res.tempFiles instanceof Array) {
                        res.tempFiles.forEach((item: any) => {

                            let temp = OneUniApiHelper.CreateChooseFile();
                            if (item.path != undefined) {
                                temp.path = item.path;
                                temp.size = item.size;
                            }
                            //微信平台下没有File
                            // if (item instanceof File) {
                            //     temp.name = item.name;
                            //     temp.size = item.size;
                            //     temp.file = item;
                            // } else {
                            //     temp.path = item.path;
                            //     temp.size = item.size;
                            // }
                            lChooseResult.files.push(temp);
                        })
                    }
                    resolve();
                },
                fail: function (err) {
                    reject();
                }
            })
        })
        if (lChooseResult.fileCount == 0) {
            lChooseResult.sucess = false;
            lChooseResult.errMsg = "未选择任何文件";
        }
        return lChooseResult;
    }

    public static async UploadFile(qFilePath: string, qFormData: FormData, qUrl: string): Promise<IActionResult<string>> {
        let lActionResult: TActionResult = TActionResult.createNew();
        qUrl = UrlHelper.urlCombinationApiBaseUrl(qUrl);
        await new Promise<void>((resolve, reject) => {
            uni.uploadFile({
                url: qUrl, //仅为示例，非真实的接口地址
                filePath: qFilePath,
                name: 'file',
                formData: qFormData,
                success: (uploadFileRes) => {
                    if (uploadFileRes.statusCode == 200) {
                        lActionResult = JSON.parse(uploadFileRes.data)
                    } else if (uploadFileRes.statusCode == 404) {
                        lActionResult.ResultMsg = "404错误,请检查API地址->[" + qUrl + "]是否正确?";

                    } else {
                        lActionResult.ResultMsg = "未知的错误,错误消息:" + JSON.stringify(uploadFileRes);
                    }
                    resolve();
                },
                fail(err) {
                    lActionResult.ResultMsg = err.errMsg;
                    reject();
                },
            });
        })
        return lActionResult;
    }
    //上传图片
    public static async UploadFilebyPath(qFilePath: string, qFormData: any, qUrl: string = ""): Promise<IPostFileResult> {
        let lPostResult: IPostFileResult = {
            sucess: false,
            statusCode: 0,
            returnData: "",
            errMsg: ""
        };
        if (!qUrl) {
            //取OneNet上传文件地址
            qUrl = UrlHelper.urlCombinationApiBaseUrl("/OneService/FileUpload/PostFile");
        }
        await new Promise<void>((resolve, reject) => {
            uni.uploadFile({
                url: qUrl, //仅为示例，非真实的接口地址
                filePath: qFilePath,
                name: 'file',
                formData: qFormData,
                success: (uploadFileRes) => {
                    lPostResult.statusCode = uploadFileRes.statusCode;
                    if (lPostResult.statusCode == 200) {
                        lPostResult.sucess = true;
                        lPostResult.returnData = uploadFileRes.data;

                    } else if (lPostResult.statusCode == 404) {
                        lPostResult.errMsg = "404错误,请检查API地址->[" + qUrl + "]是否正确?";

                    } else {
                        lPostResult.errMsg = "未知的错误,错误消息:" + JSON.stringify(uploadFileRes);
                    }
                    resolve();
                },
                fail(err) {
                    lPostResult.errMsg = err.errMsg;
                    reject();
                },
            });
        })
        return lPostResult;
    }
}