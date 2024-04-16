<template>
    <uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" title="要货单" :fixed="true" status-bar right-icon="plus"
        @clickRight="onAddBill()" />
    <view style="overflow-y: hidden;">
        <uni-card style="margin:5px;padding:0px;">
            <uni-row>
                <uni-col :span="12">
                    <uni-datetime-picker type="date" :clear-icon="true" v-model="FFilterStartTime"
                        @change="onDateChangeStart" />
                </uni-col>
                <uni-col :span="12">
                    <uni-datetime-picker type="date" :clear-icon="true" v-model="FFilterEndTime"
                        @change="onDateChangeEnd" />
                </uni-col>
            </uni-row>
        </uni-card>
        <uni-card margin="5px">
            <uni-row>
                <uni-col :span="8">
                    <view :style="onGetStatusStyle('全部')" @click="onSetStatus('全部')">全部</view>
                </uni-col>
                <uni-col :span="8">
                    <view :style="onGetStatusStyle('已审核')" @click="onSetStatus('已审核')">已审核</view>
                </uni-col>
                <uni-col :span="8">
                    <view :style="onGetStatusStyle('未审核')" @click="onSetStatus('未审核')">未审核</view>
                </uni-col>
            </uni-row>
        </uni-card>
        <!-- 滚动区域 -->
        <scroll-view :scroll-y="true" @scrolltolower="onLoadpage" style="height: calc(100vh - 50px)">
            <uni-card v-for="item in FBillList" :key="item.FBillID" margin="5px"
                @click="onItemClick(item)">
				<uni-section :title="'单号:'+item.FBillNo" type="line" style="margin:-10px;">
				</uni-section>
                <view><span style="width:100px;color: blue;">制单时间:</span>{{ item.FBillDate }}</view>
                <view><span style="width:100px;color: blue;">发货方:</span> {{ item.FBillSenderName }}</view>
                <view><span style="width:100px;color: blue;">总额:</span>{{ item.FBillAmount }}</view>
            </uni-card>
            <uni-load-more :status="FLoadMoreStatus"></uni-load-more>
        </scroll-view>
</view>
</template>

<script lang="ts">
import DateHelper from "@/baselib/apublic/DateHelper";
import { defineComponent } from "vue";
import type { TBillSend } from "./SendReciveApi";
import SendReciveApi from "./SendReciveApi";
export default defineComponent({
    data() {
        return {
            FCFMStatus: "全部",
            FBillList: [{} as TBillSend],
            FFilterGood: '',
            FLoadMoreStatus: "more",
            FPageIndex: 1,
            FPageSize: 10,
            FFilterStartTime: DateHelper.FormatDateStart(),
            FFilterEndTime: DateHelper.FormatDateEnd()
        }
    },
    mounted() {
        this.FBillList = [];
        this.openData();
    },
    methods: {
        onBack: function () {
            this.$OneRouterHelper.navigateBackOne();
        },
        onItemClick: function (item: TBillSend) {
            //
            let lConfig = this.$OneRouterHelper.createRouterConfig();
            lConfig.urlParams = { billID: item.FBillID };
            lConfig.path = "pages/demo/billsend/demoBillSendEdit";
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
            let lResult = await SendReciveApi.GetBillSendList(this.FPageIndex, this.FPageSize, this.FFilterStartTime, this.FFilterEndTime, this.FCFMStatus);
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
                this.FBillList.push(...lList);
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
            return "/static/weixin/logo.png";
        },
        onAddBill: function () {
            let lConfig = this.$OneRouterHelper.createRouterConfig();
            lConfig.urlParams = { goodsID: "" };
            lConfig.path = "pages/demo/billsend/demoBillSendEdit";
            this.$OneRouterHelper.navigateTo(lConfig);
        },
        onDateChangeStart: function (qValue: any) {
            this.FPageIndex = 1;
            this.FFilterStartTime = qValue;
            if (this.FFilterEndTime) {
                if (this.FFilterEndTime.indexOf("23:59:59") <= 0) {
                    this.FFilterEndTime = this.FFilterEndTime + " 23:59:59"
                }
            }
            this.openData();
        },
        onDateChangeEnd: function (qValue: any) {
            this.FPageIndex = 1;
            this.FFilterEndTime = qValue;
            if (this.FFilterEndTime) {
                if (this.FFilterEndTime.indexOf("23:59:59") <= 0) {
                    this.FFilterEndTime = this.FFilterEndTime + " 23:59:59"
                }
            }
            this.openData();
        },
        onGetStatusStyle: function (qVaule: string) {
            if (this.FCFMStatus == qVaule) {
                return { textAlign: "center", fontSize: "16px", color: "blue" }
            } else {
                return { textAlign: "center", fontSize: "16px" }
            }
        },
        onSetStatus: function (qValue: string) {
            this.FBillList = [];
            this.FCFMStatus = qValue;
            this.openData();
        }
    }
},
)
</script>
<style scoped></style>