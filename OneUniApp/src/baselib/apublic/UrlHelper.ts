import { UserStore } from '@/store/userStore'
export default class UrlHelper {
    //url增加参数
    public static UrlAddJsonParams(qUrl: string, qJson: any): string {
        if (qJson == undefined) {
            return qUrl;
        }
        let lUrlStr: string = qUrl;
        let lURL = new URL(qUrl);
        for (let key in qJson) {
            if (!lURL.searchParams.has(key)) {
                let tempJsonValue: any = qJson[key];
                switch (typeof tempJsonValue) {
                    case "string":
                        if (tempJsonValue != "") {
                            lURL.searchParams.append(key, tempJsonValue);
                        }
                        break;
                    case "boolean":
                        lURL.searchParams.append(key, tempJsonValue == true ? "true" : "false");
                        break;
                    case "number":
                        lURL.searchParams.append(key, tempJsonValue.toString());
                        break;
                    default:
                        break;
                }
            }
        }
        return lURL.href;
    }

    //拼接Url
    public static urlCombination(qUrlA: string, qUrlB: string): string {
        qUrlA = qUrlA.trim();
        qUrlB = qUrlB.trim();
        let lAEnd = qUrlA.charAt(qUrlA.length - 1);
        let lBStart = qUrlB.substring(0, 1);
        lAEnd = lAEnd.replace("\\", "/");
        lBStart = lBStart.replace("\\", "/");
        if (lAEnd == "/") {
            qUrlA = qUrlA.substring(0, qUrlA.length - 1);
        }
        if (lBStart == "/") {
            qUrlB = qUrlB.substring(1, qUrlB.length);
        }
        let lUrl = qUrlA + "/" + qUrlB;
        return lUrl;
    }

    public static urlCombinationApiBaseUrl(qUrlB: string): string {
        let lUserStore = UserStore();
        let qUrlA = lUserStore.apiBaseUrl;
        qUrlA = qUrlA.trim();
        qUrlB = qUrlB.trim();
        let lAEnd = qUrlA.charAt(qUrlA.length - 1);
        let lBStart = qUrlB.substring(0, 1);
        lAEnd = lAEnd.replace("\\", "/");
        lBStart = lBStart.replace("\\", "/");
        if (lAEnd == "/") {
            qUrlA = qUrlA.substring(0, qUrlA.length - 1);
        }
        if (lBStart == "/") {
            qUrlB = qUrlB.substring(1, qUrlB.length);
        }
        let lUrl = qUrlA + "/" + qUrlB;
        return lUrl;
    }
}