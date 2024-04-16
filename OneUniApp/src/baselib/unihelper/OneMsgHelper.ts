export default class OneMsgHelper {
    //弹出轻提示
    public static showToast(qTitle: string,qDuration:number=2000) {
        uni.showToast({
            title: qTitle,
            icon: "none",
            duration: qDuration
        });
    }

    //弹出对话框
    public static showDialogMsg(qMsg: string) {
        uni.showModal({
            content: qMsg,
            showCancel: false,
        });
    }

    //弹出确定框
    public static async showDialogConfirm(qMsg: string) {
        let lConfirm = await new Promise<boolean>((resolve, reject) => {
            uni.showModal({
                content: qMsg,
                showCancel: true,
                success: function (res) {
                    if (res.confirm) {
                        resolve(true);
                    } else if (res.cancel) {
                        resolve(false);
                    }
                }
            });
        })
        return lConfirm;
    }
}