<template>
  <uni-nav-bar left-icon="left" leftText="返回" title="文件上传" @clickLeft="onBack()" :fixed="true" status-bar />
  <view>
    <uni-card margin="5px" padding="5px">
      <uni-easyinput type="textarea" v-model="FPostResult" placeholder="选择文件结果" autoHeight></uni-easyinput>
    </uni-card>
    <button type="primary" @click="onFilePickB" style="margin-left: 10px; margin-right: 10px">
      阻塞式选择文件
    </button>
    <view style="height: 10px"></view>
    <button type="primary" @click="onFilePickA" style="margin-left: 10px; margin-right: 10px">
      回调式选择文件
    </button>
  </view>
</template>
<script lang="ts">
import { defineComponent } from "vue";
import md5 from "js-md5";
import UrlHelper from "@/baselib/apublic/UrlHelper";
export default defineComponent({
  name: "login",
  data() {
    return {
      FPostResult: '',
    };
  },
  methods: {
    onBack: function () {
      this.$OneRouterHelper.navigateBackOne();
    },
    onFilePickA: function () {
      let that = this;
      this.FPostResult = "";
      uni.chooseImage({
        count: 1, //默认9
        sizeType: ["original", "compressed"], //可以指定是原图还是压缩图，默认二者都有
        sourceType: ["album"], //从相册选择
        success: function (res) {
          uni.uploadFile({
            url: UrlHelper.urlCombinationApiBaseUrl("/DemoWebFile/WebPostFormData"), //仅为示例，非真实的接口地址
            filePath: res.tempFilePaths[0],
            name: "file",
            formData: {},
            success: (uploadFileRes) => {
              that.FPostResult = JSON.stringify(uploadFileRes);
            },
            fail: (result) => {
              that.FPostResult = JSON.stringify(result);
            },
          });
        },
      });
    },
    //阻塞式写法
    onFilePickB: async function () {
      //选择文件
      let lChooseResult = await this.$OneUniApiHelper.ChooseImage();
      if (!lChooseResult.sucess) {
        this.$OneMsgHelper.showDialogMsg(lChooseResult.errMsg);
        return;
      }
      //上传文件

      let lUrl = UrlHelper.urlCombinationApiBaseUrl("/DemoWebFile/WebPostFormData");
      let lPostReulst = await this.$OneUniApiHelper.UploadFilebyPath(lChooseResult.filePaths[0], {}, lUrl);
      if (!lPostReulst.sucess) {
        this.$OneMsgHelper.showDialogMsg(lPostReulst.errMsg);
        return;
      }
      this.FPostResult = JSON.stringify(lPostReulst);
    }
  },
})
</script>
<style scoped>

</style>