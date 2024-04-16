<template>
	<uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" title="卡片列表" :fixed="true" status-bar />
	<view>
		<!-- 滚动区域 -->
		<scroll-view :scroll-y="true" style="height: calc(100vh - 50px)">
			<uni-list :border="true">
				<uni-card margin="5px" padding="0px" v-for="(item,itemIndex) in FBillList" :key="item.FBillID">
					<uni-list-chat :title="item.BillNo" :avatar-circle="true" :avatar="FWXLogo"
						:note="'金额：' + item.BillAmount" :time="item.BillDate" :badge-text="itemIndex+1"
						style="margin-left:-12px;">
					</uni-list-chat>
				</uni-card>
			</uni-list>
		</scroll-view>
	</view>
</template>
<script lang="ts">
	import DateHelper from "@/baselib/apublic/DateHelper";
	import {
		defineComponent
	} from "vue";
	interface JXCBill {
		FBillID: string,
			BillNo: string,
			BillDate: string,
			CustomerName: string,
			BillAmount: number
	}
	export default defineComponent({
		data() {
			return {
				FWXLogo: "/static/img/goods/goods.png",
				FBillList: [{}as JXCBill]
			};
		},
		mounted() {
			this.FBillList = [];
			let lList = [];
			for (var i = 0; i < 100; i++) {
				let lTempBill: JXCBill = {
					FBillID: "i",
					BillNo: "商品" + i.toString(),
					BillDate: DateHelper.FormatDateNow(),
					CustomerName: "",
					BillAmount: i,
				};
				lList.push(lTempBill);
			}
			this.FBillList = lList;
		},
		methods: {
			onBack: function() {
				this.$OneRouterHelper.navigateBackOne();
			}
		},
	});
</script>
<style scoped>

</style>
