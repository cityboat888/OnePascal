<template>
    <uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" title="客户编辑" :fixed="true" status-bar />
    <view style="padding: 15px; margin-bottom: 25px">
        <uni-forms ref="customerForm" :modelValue="FCustomer" :rules="FCustomerRules" :label-width="80">
            <!-- <uni-forms-item label="头像">
        <uni-tag text="上传" type="primary" style="margin-top: 5px; margin-left: 15px; float: right"
          @click="onImgUpload" />
        <image class="slot-image" :src="getImgurl" style="width: 30px; height: 30px; float: right"></image>
      </uni-forms-item> -->
            <uni-forms-item label="客户名称" required name="FGoodsName">
                <uni-easyinput v-model="FCustomer.FCustomerName" placeholder="请输入客户名称" clearable />
            </uni-forms-item>
            <uni-forms-item label="客户编号">
                <uni-easyinput v-model="FCustomer.FCustomerCode" placeholder="请输入客户编号" clearable />
            </uni-forms-item>
            <uni-forms-item label="客户类型">
                <uni-easyinput v-model="FCustomer.FCustomerType" disabled />
            </uni-forms-item>
            <uni-forms-item label="联系人">
                <uni-easyinput v-model="FCustomer.FCustomerLXR" placeholder="请输入客户联系人" clearable />
            </uni-forms-item>
            <uni-forms-item label="联系电话">
                <uni-easyinput v-model="FCustomer.FCustomerTel" placeholder="请输入客户联系电话" clearable />
            </uni-forms-item>
            <uni-forms-item label="客户备注">
                <uni-easyinput v-model="FCustomer.FCustomerRemark" placeholder="请输入客户备注" clearable />
            </uni-forms-item>
            <uni-forms-item label="创建时间">
                <uni-easyinput v-model="FCustomer.FCreateTime" disabled />
            </uni-forms-item>
        </uni-forms>
    </view>
	<view   style="position: fixed; bottom: 0; left: 0px;width:100%;">
		<uni-card margin="5px" >
		<button type="primary" @click="onSaveCustomerForm('customerForm')">
		    保存
		</button>
		</uni-card>
	</view>
   
</template>

<script lang="ts">
import DateHelper, { emDateFormat } from "@/baselib/apublic/DateHelper";
import { defineComponent } from "vue";
import type { TSendReceiv } from "./SendReciveApi";
import SendReciveApi from "./SendReciveApi";
export default defineComponent({
    data() {
        return {
            FCustomer: {} as TSendReceiv,
            FCustomerRules: {
                FCustomerName: {
                    rules: [
                        {
                            required: true,
                            errorMessage: "客户名称不可为空",
                        },
                    ],
                },
                FCustomerCode: {
                    rules: [
                        {
                            required: true,
                            errorMessage: "客户编号不可为空",
                        },
                    ],
                },
            },
            FCustType: ''
        }
    },
    mounted() {
        let lCustType = this.$OneRouterHelper.getLocationParams('custType');
        if (lCustType) {
            this.FCustType = lCustType;

        }
        let lCustomerID = this.$OneRouterHelper.getLocationParams('customerID');
        if (lCustomerID) {
            this.FCustomer.FCustomerID = lCustomerID;
        }
        this.openData();
    },
    methods: {
        onBack: function () {
            this.$OneRouterHelper.navigateBackOne();
        },
        getImgurl(qGoodsImgUrl: string): string {
            if (!qGoodsImgUrl) {
                return "/static/weixin/logo.png";
            }
            return qGoodsImgUrl;
        },
        checkForm: async function () {
            let lIsCheck = await new Promise<boolean>((resolve, reject) => {
                if (this.$refs.customerForm != undefined) {
                    let lTemp: any = this.$refs.customerForm;
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
        onSaveCustomerForm: async function (form: any) {
            let lIsCheck = await this.checkForm();
            if (!lIsCheck) {
                //验证规则失败退出用异步写法。好写代码
                return;
            }
            let lResult = await SendReciveApi.SaveSendReceiv(this.FCustomer);
            if (!lResult.ResultSuccess) {
                this.$OneMsgHelper.showDialogMsg(lResult.ResultMsg);
                return;
            }
            this.FCustomer.FCustomerID = lResult.ResultData;
            this.$OneMsgHelper.showToast("保存客户数据成功!!!");
            //保存后,在次打开数据，取最新数据
            this.openData();
        },
        openData: async function () {
            if (!this.FCustomer.FCustomerID) {
                //为空代表新建
                this.FCustomer = {} as TSendReceiv;
                this.FCustomer.FCreateTime = DateHelper.FormatDateNow(emDateFormat.YMDHMS);
                this.FCustomer.FCustomerType = this.FCustType;
                return;
            }
            let lResult = await SendReciveApi.GetSendReceiv(this.FCustomer.FCustomerID);
            if (!lResult.ResultSuccess) {
                this.$OneMsgHelper.showDialogMsg(lResult.ResultMsg);
                return;
            }
            this.FCustomer = lResult.ResultData;
            this.$OneMsgHelper.showToast("获取客户数据成功");
        }
    },
});

</script>