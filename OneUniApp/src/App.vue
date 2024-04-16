<script setup lang="ts">
import { onLaunch, onShow, onHide } from "@dcloudio/uni-app";
onLaunch(() => {
  console.log("App Launch");
});
onShow(() => {
  console.log("App Show");
});
onHide(() => {
  console.log("App Hide");
});
</script>
<style>
@import "@/common/uni.css";
@import "@/static/styles/index.scss";
page {
  background-color: white;
  height: 100%;
  font-size: 28rpx;
  /* line-height: 1.8; */
}
</style>
