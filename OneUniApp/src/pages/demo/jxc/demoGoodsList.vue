<template>
	<uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" title="商品管理" :fixed="true" status-bar
		right-icon="plus" @clickRight="onAddGoods()" />
	<view>
		<uni-card margin="0px">
			<uni-easyinput v-model="FFilterGood" placeholder="请输入商品编码或名称" @confirm="onConfirmFilter"></uni-easyinput>
		</uni-card>
		<!-- 滚动区域 -->
		<scroll-view :scroll-y="true" @scrolltolower="onLoadpage" style="height: calc(100vh - 50px)">
			<uni-list :border="true">
				<uni-card margin="5px" padding="0px" v-for="item in FGoodsList" :key="item.FGoodsID">
					<uni-list-chat :title="item.FGoodsName" :avatar-circle="true" :avatar="getImgurl(item.FGoodsImgUrl)"
						:note="'编号：' + item.FGoodsCode" :badge-text="'售价：' + item.FGoodsPrice" clickable
						@click="onItemClick(item)">
						<!-- 		<template v-slot:default>
							 <view>12313</view>
						</template> -->
					</uni-list-chat>
				</uni-card>
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
			let lConfig = this.$OneRouterHelper.createRouterConfig();
			lConfig.urlParams = {
				goodsID: item.FGoodsID
			};
			lConfig.path = "pages/demo/jxc/demoGoodsEdit";
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
			let lResult = await GoodsApi.GetGoodsList(this.FPageIndex, this.FPageSize, this.FFilterGood);
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
				this.FGoodsList.push(...lList);
			}
		},
		onLoadpage: function (even: any) {
			this.FPageIndex = this.FPageIndex + 1;
			this.openData();
		},
		getImgurl(qGoodsImgUrl: string): string {
			if (!qGoodsImgUrl) {
				return "/static/img/goods/goods.png";
			}
			return qGoodsImgUrl;
		},
		onAddGoods: function () {
			let lConfig = this.$OneRouterHelper.createRouterConfig();
			lConfig.urlParams = {
				goodsID: ""
			};
			lConfig.path = "pages/demo/jxc/demoGoodsEdit";
			this.$OneRouterHelper.navigateTo(lConfig);
		}
	},
})
</script>
<style scoped></style>
