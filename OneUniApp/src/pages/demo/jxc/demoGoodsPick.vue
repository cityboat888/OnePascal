<template>
    <uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" title="商品选择" :fixed="true" status-bar />
    <view>
        <uni-card margin="0px">
            <uni-easyinput v-model="FFilterGood" placeholder="请输入商品编码或名称" @confirm="onConfirmFilter"></uni-easyinput>
        </uni-card>
        <!-- 滚动区域 -->
        <scroll-view :scroll-y="true" @scrolltolower="onLoadpage" style="height: calc(100vh - 50px)">
            <uni-list :border="true">
                <uni-list-chat v-for="item in FGoodsList" :key="item.FGoodsID" :title="item.FGoodsName"
                    :avatar-circle="true" :avatar="getImgurl(item.FGoodsImgUrl)"
                    :note="'编号：' + item.FGoodsCode + '    售价：' + item.FGoodsPrice" clickable @click="onItemClick(item)">
                </uni-list-chat>
            </uni-list>
            <uni-load-more :status="FLoadMoreStatus"></uni-load-more>
        </scroll-view>
</view>
</template>
  
<script lang="ts">
import { defineComponent } from "vue";
import type { TGoodsDemo } from "./GoodsApi";
import GoodsApi from "./GoodsApi";
export default defineComponent({
    data() {
        return {
            FGoodsList: [{} as TGoodsDemo],
            FFilterGood: '',
            FLoadMoreStatus: "more",
            FPageIndex: 1,
            FPageSize: 10,
        }
    },
    mounted() {
        this.FGoodsList = [];
        this.openData();
    },
    methods: {
        onBack: function () {
            this.$OneRouterHelper.navigateBackOne();
        },
        onItemClick: function (item: TGoodsDemo) {
            //
            uni.$emit('onPickGoods', item);
            this.onBack();
        },
        onConfirmFilter: function () {
            //清分页信息
            this.FPageIndex = 1;
            this.openData();
        },
        openData: async function () {
            if (this.FPageIndex <= 0) {
                this.FPageIndex = 1;
            }
            let lResult = await GoodsApi.GetGoodsList(this.FPageIndex, this.FPageSize, this.FFilterGood);
            if (!lResult.ResultSuccess) {
                //失败减回1
                this.FPageIndex = this.FPageIndex - 1;
                this.$OneMsgHelper.showDialogMsg(lResult.ResultMsg);
                return;
            }
            //
            let lList = lResult.ResultData;
            if (lList.length < this.FPageSize) {
                //没有更多了，减回1 
                this.FPageIndex = this.FPageIndex - 1;
                this.FLoadMoreStatus = "noMore";
            } else {
                this.FLoadMoreStatus = "more";
            }
            if (lList.length >= 0) {
                this.FGoodsList.push(...lList);
            }
        },
        onLoadpage: function (even: any) {
            if (this.FLoadMoreStatus == "noMore") {
                return;
            }
            this.FPageIndex = this.FPageIndex + 1;
            this.openData();
        },
        getImgurl(qGoodsImgUrl: string): string {
            if (!qGoodsImgUrl) {
                return "/static/weixin/logo.png";
            }
            return qGoodsImgUrl;
        }
    },
})
</script>
<style scoped></style>