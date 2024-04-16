<template>
  <view class="one-tabbar">
    <view class="uni-flex uni-row">
      <view v-for="(item, index) in FTabList" :key="index" style="-webkit-flex: 1; flex: 1; text-align: center"
        @click="onTabClick(item, index)">
        <img :src="item.img" alt="" style="width: 30px; height: 30px" />
        <view :style="getStyle(index)">{{ item.text }}</view>
      </view>
    </view>
  </view>
</template>
 
<script lang="ts">
import { defineComponent } from "vue";
export default defineComponent({
  data() {
    return {
      FTabList: [
        {
          text: "主页",
          img: "./static/img/home/home.png",
          path: "pages/home/index",
        },
        { 
          text: "报表",
          img: "./static/img/report/report.png",
          path: "pages/demo/demoList",
        },
        {
          text: "我的",
          img: "./static/img/user/user.png",
          path: "pages/login/index",
        },
      ],
      FIndexTab: 0,
    };
  },
  mounted() { },
  methods: {
    onTabClick(item: any, index: number) {
      this.FIndexTab = index;
      if (item.path) {
        this.$OneRouterHelper.navigateTo({ path: item.path } as any);
      }
    },
    getStyle(index: number): any {
      let lStyle: any = {};
      lStyle["margin-top"] = "-5px";
      if (this.FIndexTab == index) {
        lStyle.color = "#00aaff";
      }
      return lStyle;
    },
  },
});
</script>

<style scoped>
.one-tabbar {
  position: fixed;
  bottom: 0;
  left: 0px;
  height: 55px;
  width: 100%;
  background-color: rgb(248, 248, 248);
}
</style>