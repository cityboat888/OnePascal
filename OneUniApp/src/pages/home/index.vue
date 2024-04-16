<template>
  <view class="app-container" style="background-color: white">
    <swiper circular indicator-dots autoplay>
      <swiper-item v-for="(item, index) in FSwiperList" :key="index">
        <view>
          <img :src="item" alt="" style="width: 100%; height: 150px" />
        </view>
      </swiper-item>
    </swiper>
    <uni-section title="常用界面展示DEMO" type="line">
    </uni-section>

    <uni-row style="margin-top: 5px;">
      <uni-col :span="6" v-for="(item, index) in FGridList" :key="index">
        <view @click="onJump(item)" class="gridItem">
          <img :src="item.img" alt="" style="width:50px; height:50px;border" />
          <view>{{ item.text }}</view>
        </view>
      </uni-col>
    </uni-row>

    <uni-section title="与后台交互" type="line">
    </uni-section>
    <uni-row style="margin-top: 5px">
      <uni-col :span="6" v-for="(item, index) in FJXCGridList" :key="index">
        <view @click="onJXCJump(item)" class="gridItem">
          <img :src="item.img" alt="" style="width:50px; height:50px;border" />
          <view>{{ item.text }}</view>
        </view>
      </uni-col>
    </uni-row>

  </view>
  <OnetabBar></OnetabBar>
</template>
 
<script lang="ts">
import type { IOneRouterConfig } from "@/baselib/unihelper/OneRouterHelper";
import { defineComponent } from "vue";

export default defineComponent({
  name: "home",


  data() {
    return {
      FMsg: '',
      FSwiperList: [''],

      FGridList: [{ img: '', text: '' }],
      FJXCGridList: [{ img: '', text: '' }]
    }
  },
  mounted() {
    this.FSwiperList = [];
    this.FSwiperList.push("./static/login.png");
    this.FSwiperList.push("./static/login.png");
    this.FSwiperList.push("./static/login.png");
    this.FGridList = [];
    this.FGridList.push({ img: "./static/img/public/list.png", text: "列表展示" });
    this.FGridList.push({ img: "./static/img/public/form.png", text: "表单展示" });
    this.FGridList.push({ img: "./static/img/public/fileUpDown.png", text: "上传下载", });
    this.FGridList.push({ img: "./static/img/public/scan.png", text: "扫码" });
    this.FGridList.push({ img: "./static/img/public/list.png", text: "列表分页" });
    this.FJXCGridList = [];
    this.FJXCGridList.push({ img: "./static/img/goods/goods.png", text: "商品管理", });
    this.FJXCGridList.push({ img: "./static/img/user/sender.png", text: "发货方", });
    this.FJXCGridList.push({ img: "./static/img/user/receiver.png", text: "收货方", });
    this.FJXCGridList.push({ img: "./static/img/bill/bill.png", text: "要货单", });
  },
  methods: {
    onJump: function (item: any) {
      switch (item.text) {
        case "列表展示":
          let lConfig = this.$OneRouterHelper.createRouterConfig();
          lConfig.path = "pages/demo/demoList";
          this.$OneRouterHelper.navigateTo(lConfig);
          //uni.navigateTo({ url: "/pages/demo/demoList" });
          break;
        case "列表分页":
          let lConfigF = this.$OneRouterHelper.createRouterConfig();
          lConfigF.path = "pages/demo/demoPageList";
          this.$OneRouterHelper.navigateTo(lConfigF);
          break;
        case "表单展示":
          let lConfigD = this.$OneRouterHelper.createRouterConfig();
          lConfigD.path = "pages/demo/demoForm";
          this.$OneRouterHelper.navigateTo(lConfigD);
          break;
        case "扫码":
          let lConfigB = this.$OneRouterHelper.createRouterConfig();
          lConfigB.path = "pages/demo/demoScan";
          this.$OneRouterHelper.navigateTo(lConfigB);
          break;
        case "上传下载":
          let lConfigC = this.$OneRouterHelper.createRouterConfig();
          lConfigC.path = "pages/demo/demoFile";
          this.$OneRouterHelper.navigateTo(lConfigC);
          break;
        default:
          this.$OneMsgHelper.showDialogMsg(
            "未处理的类型:" + JSON.stringify(item)
          );
          break;
      }
    },
    //点击进销存九格宫跳转界面
    onJXCJump: function (item: any) {
      let lConfig: IOneRouterConfig = {} as IOneRouterConfig;
      switch (item.text) {
        case "商品管理":
          lConfig = this.$OneRouterHelper.createRouterConfig();
          lConfig.path = "pages/demo/jxc/demoGoodsList";
          this.$OneRouterHelper.navigateTo(lConfig);
          break;
        case "发货方":
          lConfig = this.$OneRouterHelper.createRouterConfig();
          lConfig.path = "pages/demo/billsend/demoSendReciveList";
          lConfig.urlParams = { custType: "发货方" };
          this.$OneRouterHelper.navigateTo(lConfig);
          break;
        case "收货方":
          lConfig = this.$OneRouterHelper.createRouterConfig();
          lConfig.path = "pages/demo/billsend/demoSendReciveList";
          lConfig.urlParams = { custType: "收货方" };
          this.$OneRouterHelper.navigateTo(lConfig);
          break;
        case "要货单":
          lConfig = this.$OneRouterHelper.createRouterConfig();
          lConfig.path = "pages/demo/billsend/demoBillSendList";
          this.$OneRouterHelper.navigateTo(lConfig);
          break;
        default:
          this.$OneMsgHelper.showDialogMsg(
            "未处理的类型:" + JSON.stringify(item)
          );
          break;
      }
    }
  }
})
</script>

<style scoped>
.gridItem {
  height: 90px;
  margin: 1px 1px 1px 1px;

  padding-top: 2px;
  border-radius: 5px;
  text-align: center;
}

.jxcView {
  text-align: center;
  color: red;
  font-size: 18px;
}
</style>
