<template>
    <uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" title="客户档案" :fixed="true" status-bar
        @clickRight="onAddCustomer()" right-icon="plus" />
    <view>
        <uni-card margin="0px">
            <uni-easyinput v-model="FFilterCustInfo" placeholder="请输入客户名称或代码" @confirm="onConfirmFilter"></uni-easyinput>
        </uni-card>
        <!-- 滚动区域 -->
        <scroll-view :scroll-y="true" @scrolltolower="onLoadpage" style="height: calc(100vh - 50px)">
            <uni-list :border="true">
				<uni-card margin="5px" padding="0px" v-for="item in FCustomerList" :key="item.FCustomerID">
					<uni-list-chat :title="item.FCustomerName"
					    :avatar-circle="true" :avatar="getImgurl()"
					    :note="'编号：' + item.FCustomerCode + '    电话：' + item.FCustomerTel" clickable @click="onItemClick(item)">
					</uni-list-chat>
				</uni-card>             
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
            let lConfig = this.$OneRouterHelper.createRouterConfig();
            lConfig.urlParams = { customerID: item.FCustomerID, custType: item.FCustomerType };
            lConfig.path = "pages/demo/billsend/demoSendReciveEdit";
            this.$OneRouterHelper.navigateTo(lConfig);
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
            if (lList.length < this.FPageSize) {
                //没有更多了，减回1 
				if(lList.length==0){
				this.FPageIndex = this.FPageIndex - 1;
				}
				
                this.FLoadMoreStatus = "noMore";
            } else {
			
                this.FLoadMoreStatus = "more";
            }  
					 if (lList.length > 0) {
					     this.FCustomerList.push(...lList);
					 }
        },
        onLoadpage: function (even: any) {
            if (this.FLoadMoreStatus == "noMore") {
                return;
            }
            this.FPageIndex = this.FPageIndex + 1;
            this.openData();
        },
        getImgurl(): string {
            return "/static/img/user/user.png";
        },
        onAddCustomer: function () {
            let lConfig = this.$OneRouterHelper.createRouterConfig();
            lConfig.urlParams = { customerID: '', custType: this.FCustType };
            lConfig.path = "pages/demo/billsend/demoSendReciveEdit";
            this.$OneRouterHelper.navigateTo(lConfig);
        }
    },
})
</script>
<style scoped></style>