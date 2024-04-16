<template>
    <uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" title="要货单编辑" :fixed="true" status-bar />
    <view>
        <uni-list>
            <uni-list-item showArrow @click="onPickCustomerSend()" :clickable="true">
                <template v-slot:body>
                    <uni-easyinput v-model="FBillSend.FBillSenderName" placeholder="请选择发货方" disabled></uni-easyinput>
                </template>
            </uni-list-item>
            <uni-list-item showArrow @click="onPickCustomerRecive()" :clickable="true">
                <template v-slot:body>
                    <uni-easyinput v-model="FBillSend.FBillReceivName" placeholder="请选择收货方" disabled></uni-easyinput>
                </template>
            </uni-list-item>
            <uni-list-item>
                <template v-slot:body>
                    <uni-easyinput v-model="FBillSend.FBillRemark" placeholder="请输入备注"></uni-easyinput>
                </template>
            </uni-list-item>
        </uni-list>
    </view>
    <view style="margin-left: 15px;margin-top: 5px;">
        <uni-row>
            <uni-col :span="15">
                <uni-easyinput prefixIcon="search" v-model="FFilterGoodsInfo" placeholder="请输入内容进行商品搜索"></uni-easyinput>
            </uni-col>
            <uni-col :span="3">
                <uni-icons type="search" size="35" color="blue" @click="onSearchGoods()"></uni-icons>
            </uni-col>
            <uni-col :span="3">
                <uni-icons type="scan" size="35" color="blue" @click="onScanGoods()"></uni-icons>
            </uni-col>
            <uni-col :span="3">
                <uni-icons type="plus-filled" size="35" color="green" @click="onPickGoods()"></uni-icons>
            </uni-col>
        </uni-row>
    </view>
    <view style="margin-top:5px;">
        <uni-list :border="true">
            <uni-list-chat v-for="item in FBillDetail" :key="item.FGoodsID" :title="item.FGoodsName" :avatar-circle="true"
                :avatar="getImgurl()" :note="'单价：' + item.FGoodsPrice" clickable>
				<template v-slot:default>
				    <uni-icons v-show="!FBillSend.FIsCFM" type="closeempty"  size="20" color="red" @click="onDelDetail(item)"></uni-icons>
					<view v-show="FBillSend.FIsCFM"></view>	
					<view class="uni-flex uni-row" >
						<uni-icons type="minus-filled" size="30" color="green" @click="onAddQuantity(item,-1)"></uni-icons>
						<input class="uni-input" type="digit" style="width:50px;height:20px;" :value="item.FGoodsQuantity"/>
						<uni-icons type="plus-filled" size="30" color="green"  @click="onAddQuantity(item,1)"></uni-icons>
					</view>		
				</template>
            </uni-list-chat>
        </uni-list>
    </view>
	<view   style="position: fixed; bottom: 0; left: 0px;width:100%;">
		<uni-card margin="5px" >
		<button type="primary"  @click="onSaveBillSend()">
		        保存
		</button>
		</uni-card>
	</view>
    
</template>

<script lang="ts">
import { defineComponent } from "vue";
import GoodsApi, { type TGoodsDemo } from "../jxc/GoodsApi";
import type { TBillDetail, TBillSend, TBillSendInfo, TSendReceiv } from "./SendReciveApi";
import SendReciveApi from "./SendReciveApi";
export default defineComponent({
    data() {
        return {
            FBillID: "",
            FBillSendInfo: {} as TBillSendInfo,
            FBillSend: {} as TBillSend,
            FBillDetail: [] as TBillDetail[],
            FFilterGoodsInfo: ''
        }
    },
    mounted() {
        let lBillID = this.$OneRouterHelper.getLocationParams('billID');
        if (lBillID) {
            this.FBillID = lBillID;
        }
        this.openData();
    },
    methods: {

        onBack: function () {
            this.$OneRouterHelper.navigateBackOne();
        },
        getImgurl(): string {
            return "/static/img/goods/goods.png";
        },
        checkForm: async function () {
            let lIsCheck = await new Promise<boolean>((resolve, reject) => {
                if (this.$refs.goodsForm != undefined) {
                    let lTemp: any = this.$refs.goodsForm;
                    lTemp.validate().then((res: any) => {
                        resolve(true);
                    })
                        .catch((res: any) => {
                            resolve(false);
                        });
                }

            });
            return lIsCheck;
        },
        //打开要货单数据
        openData: async function () {

            if (!this.FBillID) {
                this.FBillSendInfo.BillSend = {} as TBillSend;
                this.FBillSendInfo.BillDetails = [];
                this.FBillSendInfo.Dels = [];
                this.FBillSend = this.FBillSendInfo.BillSend;
                this.FBillDetail = this.FBillSendInfo.BillDetails;
                return;
            }
            let lResult = await SendReciveApi.GetBillSendInfo(this.FBillID);
            if (!lResult.ResultSuccess) {
                this.$OneMsgHelper.showDialogMsg(lResult.ResultMsg);
                return;
            }
            this.FBillSendInfo.BillSend = lResult.ResultData.BillSend;
            this.FBillSendInfo.BillDetails = lResult.ResultData.BillDetails;
            this.FBillSendInfo.Dels = [];
            this.FBillSend = this.FBillSendInfo.BillSend;
            this.FBillDetail = this.FBillSendInfo.BillDetails;
        },
        //挑选发货方
        onPickCustomerSend: function () {
            let lConfig = this.$OneRouterHelper.createRouterConfig();
            lConfig.urlParams = { custType: "发货方" }
            lConfig.path = "pages/demo/billsend/demoSendRecivePick";
            this.$OneRouterHelper.navigateTo(lConfig);
        },
        //挑选收货方
        onPickCustomerRecive: function () {
            let lConfig = this.$OneRouterHelper.createRouterConfig();
            lConfig.urlParams = { custType: "收货方" }
            lConfig.path = "pages/demo/billsend/demoSendRecivePick";
            this.$OneRouterHelper.navigateTo(lConfig);
        },
        onPickGoods: function () {
            let lConfig = this.$OneRouterHelper.createRouterConfig();
            lConfig.path = "pages/demo/jxc/demoGoodsPick";
            this.$OneRouterHelper.navigateTo(lConfig);
        },
        onSearchGoods: async function () {
            if (this.FFilterGoodsInfo.trim() != "") {
                let lResult = await GoodsApi.GetGoodsList(1, 10, this.FFilterGoodsInfo.trim());
                if (!lResult.ResultSuccess) {
                    this.$OneMsgHelper.showDialogMsg(lResult.ResultMsg);
                    return;
                }
                if (lResult.ResultData.length >= 1) {
                    let lGoods = lResult.ResultData[0];
                    let lBillDetail: TBillDetail = {} as TBillDetail;
                    lBillDetail.FGoodsID = lGoods.FGoodsID;
                    lBillDetail.FGoodsName = lGoods.FGoodsName;
                    lBillDetail.FGoodsCode = lGoods.FGoodsCode;
                    lBillDetail.FGoodsPrice = lGoods.FGoodsPrice;
                    lBillDetail.FGoodsQuantity = 1;
                    this.FBillSendInfo.BillDetails.push(lBillDetail);
                    this.FBillSendInfo.BillDetails.forEach((item, iIndex) => {
                        item.FOrderNumber = iIndex + 1;
                    })
                }
            }
        },
        onScanGoods: async function () {
            let lScanResult = await this.$OneUniApiHelper.ScanBarCode();
            if (!lScanResult.success) {
                this.$OneMsgHelper.showDialogMsg(lScanResult.errMsg);
                return;
            }
            this.FFilterGoodsInfo = lScanResult.result;
            this.onSearchGoods();
        },
        onSaveBillSend: async function () {
            let lResult = await SendReciveApi.SaveBillSendInfo(this.FBillSendInfo);
            if (!lResult.ResultSuccess) {
                this.$OneMsgHelper.showDialogMsg(lResult.ResultMsg);
                return;
            }
            this.FBillID = lResult.ResultData;
            this.$OneMsgHelper.showToast('保存数据成功');
            this.openData();
        },
		onDelDetail(QItem:TBillDetail){
		  let lIndex =	this.FBillDetail.findIndex((item)=>{return item.FDetailID==QItem.FDetailID;});
		  if (lIndex>=0){
			  this.FBillDetail.splice(lIndex,1);
		  }
		  if(QItem.FDetailID) {
			  this.FBillSendInfo.Dels.push(QItem.FDetailID)
		  }
		  
		},
		onAddQuantity(QItem:TBillDetail,QNumber:number){		
			QItem.FGoodsQuantity =  QItem.FGoodsQuantity+QNumber;
			if (QItem.FGoodsQuantity<=0){
				QItem.FGoodsQuantity = 0;
			}
		}
    },

    onLoad: function () {
        let lBillSendInfo: TBillSendInfo = this.FBillSendInfo;
        uni.$on('onPickSendRecive', function (qCusomter: TSendReceiv) {
            //监听选择
            if (qCusomter.FCustomerType == '发货方') {
                lBillSendInfo.BillSend.FBillSenderID = qCusomter.FCustomerID;
                lBillSendInfo.BillSend.FBillSenderCode = qCusomter.FCustomerCode;
                lBillSendInfo.BillSend.FBillSenderName = qCusomter.FCustomerName;
                lBillSendInfo.BillSend.FBillSenderLXR = qCusomter.FCustomerLXR;
                lBillSendInfo.BillSend.FBillSenderTel = qCusomter.FCustomerTel;
            }
            else if (qCusomter.FCustomerType == '收货方') {
                lBillSendInfo.BillSend.FBillReceivID = qCusomter.FCustomerID;
                lBillSendInfo.BillSend.FBillReceivCode = qCusomter.FCustomerCode;
                lBillSendInfo.BillSend.FBillReceivName = qCusomter.FCustomerName;
                lBillSendInfo.BillSend.FBillReceivLXR = qCusomter.FCustomerLXR;
                lBillSendInfo.BillSend.FBillReceivTel = qCusomter.FCustomerTel;
            }

        });

        uni.$on('onPickGoods', function (qGoods: TGoodsDemo) {
            //监听选择
            let lBillDetail: TBillDetail = {} as TBillDetail;
            lBillDetail.FGoodsID = qGoods.FGoodsID;
            lBillDetail.FGoodsName = qGoods.FGoodsName;
            lBillDetail.FGoodsCode = qGoods.FGoodsCode;
            lBillDetail.FGoodsPrice = qGoods.FGoodsPrice;
            lBillDetail.FGoodsQuantity = 1;
            lBillSendInfo.BillDetails.push(lBillDetail);
            lBillSendInfo.BillDetails.forEach((item, iIndex) => {
                item.FOrderNumber = iIndex + 1;
            })
        })
    },
    onUnload: function () {
        //卸载监听
        uni.$off('onPickSendRecive')
    }
});

</script>