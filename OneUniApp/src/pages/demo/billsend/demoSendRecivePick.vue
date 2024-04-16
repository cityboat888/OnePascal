<template>
    <uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" title="客户档案" :fixed="true" status-bar />
    <view>
        <uni-card margin="0px">
            <uni-easyinput v-model="FFilterCustInfo" placeholder="请输入客户名称或代码" @confirm="onConfirmFilter"></uni-easyinput>
        </uni-card>
        <!-- 滚动区域 -->
        <scroll-view :scroll-y="true" @scrolltolower="onLoadpage" style="height: calc(100vh - 50px)">
            <uni-list :border="true">
                <uni-list-chat v-for="item in FCustomerList" :key="item.FCustomerID" :title="item.FCustomerName"
                    :avatar-circle="true" :avatar="getImgurl()"
                    :note="'编号：' + item.FCustomerCode + '    电话：' + item.FCustomerTel" clickable @click="onItemClick(item)">
                </uni-list-chat>
            </uni-list>
            <uni-load-more :status="FLoadMoreStatus"></uni-load-more>
        </scroll-view>
</view>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import type { TSendReceiv } from "./SendReciveApi";
import SendReciveApi from "./SendReciveApi";
export default defineComponent({
    props: {

    },
    data() {
        return {
            FCustomerList: [{} as TSendReceiv],
            FFilterCustInfo: '',
            FLoadMoreStatus: "more",
            FPageIndex: 1,
            FPageSize: 10,
            FCustType: '发货方'
        }
    },
    mounted() {
        this.FCustomerList = [];
        let lCustType = this.$OneRouterHelper.getLocationParams('custType');

        if (lCustType) {
            this.FCustType = lCustType;
            this.openData();
        }
    },
    methods: {
        onBack: function () {
            this.$OneRouterHelper.navigateBackOne();
        },
        onItemClick: function (item: TSendReceiv) {
            //
            uni.$emit('onPickSendRecive', item);
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
            let lResult = await SendReciveApi.GetSendCustomerList(this.FPageIndex, this.FPageSize, this.FCustType, this.FFilterCustInfo);
            if (!lResult.ResultSuccess) {
                //失败减回1
                this.FPageIndex = this.FPageIndex - 1;
                this.$OneMsgHelper.showDialogMsg(lResult.ResultMsg);
                return;
            }
            //
            let lList = lResult.ResultData;
            if (lList.length == 0) {
                //没有更多了，减回1 
                this.FPageIndex = this.FPageIndex - 1;
                this.FLoadMoreStatus = "noMore";
            } else {
                this.FCustomerList.push(...lList);
            }
        },
        onLoadpage: function (even: any) {
            this.FPageIndex = this.FPageIndex + 1;
            this.openData();
        },
        getImgurl(): string {
            return "/static/weixin/logo.png";
        },
    },
})
</script>
<style scoped></style>