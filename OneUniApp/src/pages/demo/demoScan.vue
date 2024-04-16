<template>
  <uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" :fixed="true" status-bar />
  <view>
    <uni-card margin="5px" padding="5px">
      <uni-easyinput type="textarea" v-model="FScanResult" placeholder="扫码结果"></uni-easyinput>  
    <button type="primary" @click="onScanA" style="margin-top: 5px;">
      允许从相机和相册扫码
    </button>
    <button type="primary" @click="onScanB" style="margin-top: 5px;background-color:red; ">
      只允许通过相机扫码
    </button>
    <button type="primary" @click="onScanC" style="margin-top: 5px;">
      调起条码扫描
    </button>
    <button type="primary" @click="onScanD" style="margin-top: 5px;background-color:red;">
      阻塞式调起条码扫描
    </button>
	 </uni-card>
  </view>
</template>
<script lang="ts">
import { defineComponent } from "vue";
export default defineComponent({
  name: "TFormDemoScan",
  data() {
    return {
      FScanResult: "",
    };
  },
  methods: {
    //允许从相机和相册扫码
    onScanA: function () {
      let that = this;
      uni.scanCode({
        success: function (res) {
          that.FScanResult = res.result;
        },
        fail: function (err) {
          that.FScanResult = "扫码异常:" + JSON.stringify(err);
        },
      });
    },
    //只允许通过相机扫码
    onScanB: function () {
      let that = this;
      uni.scanCode({
        onlyFromCamera: true,
        success: function (res) {
          that.FScanResult = res.result;
        },
        fail: function (err) {
          that.FScanResult = "扫码异常:" + JSON.stringify(err);
        },
      });
    },
    //调起条码扫描
    onScanC: function () {
      let that = this;
      uni.scanCode({
        scanType: ["barCode"],
        success: function (res) {
          //非阻塞的，太麻烦了。。
          that.FScanResult = res.result;
        },
        fail: function (err) {
          that.FScanResult = "扫码异常:" + JSON.stringify(err);
        },
      });
    },
    //阻塞式调起条码扫描
    onScanD: async function () {
      let lScanResult = await this.$OneUniApiHelper.ScanBarCode();
      if (!lScanResult.success) {
        this.$OneMsgHelper.showDialogMsg(lScanResult.errMsg);
        return;
      }
      this.FScanResult = lScanResult.result;
    },
    onBack: function () {
      this.$OneRouterHelper.navigateBackOne();
    },
  },
});
</script>
