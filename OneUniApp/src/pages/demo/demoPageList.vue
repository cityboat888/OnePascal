<template>
  <uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" title="列表分页" :fixed="true" status-bar />
  <view>
    <scroll-view :scroll-y="true" style="height: calc(100vh - 50px)" @scrolltolower="onLoadpage">
      <uni-list :border="true">
        <uni-list-chat v-for="(item,itemIndex) in FBillList" :key="item.FBillID" :title="item.BillNo" :avatar-circle="true"
          :avatar="FWXLogo" :note="'金额：' + item.BillAmount" :time="item.BillDate" :badge-text="itemIndex+1">
        </uni-list-chat>
      </uni-list>
      <uni-load-more :status="FLoadMoreStatus"></uni-load-more>
    </scroll-view>
  </view>
</template>

<script lang="ts">
interface JXCBill {
  FBillID: string,
  BillNo: string,
  BillDate: string,
  CustomerName: string,
  BillAmount: number
}

import DateHelper from "@/baselib/apublic/DateHelper";
import { defineComponent } from "vue";
export default defineComponent({
  data() {
    return {
      FWXLogo: "/static/img/goods/goods.png",
      FCurrentPage: 0,
      FLoadMoreStatus: 'more',
      FBillList: [{} as JXCBill]
    }
  },
  mounted() {
    this.FBillList = [];
    this.openData();
  },
  methods: {
    openData: function () {
      this.FCurrentPage = this.FCurrentPage + 1;
      //假设每页20条
      let lLow: number = (this.FCurrentPage - 1) * 20 + 1;
      let lHight: number = this.FCurrentPage * 20;
      if (this.FCurrentPage > 5) {
        //假设最多五页
        this.FCurrentPage = 5;
        this.FLoadMoreStatus = "noMore";
        return;
      }
      let lList = [];
      for (var i = lLow; i <= lHight; i++) {
        let lTempBill: JXCBill = {
          FBillID: "i",
          BillNo: "商品" + i.toString(),
          BillDate: DateHelper.FormatDateNow(),
          CustomerName: "",
          BillAmount: i,
        };
        lList.push(lTempBill);
      }

      this.FBillList.push(...lList);
    },
    onBack: function () {
      this.$OneRouterHelper.navigateBackOne();
    },
    onLoadpage: function (even: any) {
      this.openData();
    }
  },
})
</script>
<style scoped>

</style>