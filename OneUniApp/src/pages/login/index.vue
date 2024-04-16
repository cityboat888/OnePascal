<template>
	<view class="app-container">
		<view>
			<img :src="FImg" alt="" style="width: 100%; height: 150px" />
		</view>
		<view class="formClass">
			<uni-easyinput v-model="FUserLogin.loginCode" placeholder="请输入账号" :focus="true" clearable>
			</uni-easyinput>
			<view style="height: 10px"></view>
			<uni-easyinput type="password" v-model="FUserLogin.loginPass" placeholder="请输入密码">
			</uni-easyinput>
			<view style="height: 10px"></view>
			<!-- <uni-easyinput v-model="FUserLogin.platUserCode" placeholder="请输入租户代码" clearable>
        </uni-easyinput>
        <view style="height: 20px"></view> -->
			<button type="primary" :plain="true" @click="onDoLogin">登陆</button>
			<view style="margin-top:5px;height:35px;">
				<!-- 多个按钮可以这么并排写 -->
				<!-- <button type="primary" size="mini" style="margin-right:5px;">清除</button> -->
				<button type="primary" size="mini" style="float:right;" @click="onShowSet()">设置</button>
			</view>
			<view v-show="FShowSet">
				<uni-easyinput v-model="FHostSet.hostIP" placeholder="IP地址" clearable>
				</uni-easyinput>
				<view style="height: 10px"></view>
				<uni-easyinput v-model="FHostSet.ztCode" placeholder="账套代码" clearable>
				</uni-easyinput>
				<view style="margin-top:5px;height:35px;">
					<button type="default" size="mini" style="float:right;" @click="FShowSet = false">关闭</button>
					<button type="primary" size="mini" style="float:right;margin-right:15px;"
						@click="onSaveHostSet()">保存</button>
				</view>
			</view>
		</view>
	</view>
</template>

<script lang="ts">
	import {
		defineComponent
	} from "vue";
	import md5 from "js-md5";
	import {
		UserStore
	} from "@/store/userStore";
	import LoginApi, {
		type TLoginInfo
	} from "./loginApi";
	import TTokenInfo from "@/store/userToken";
	export default defineComponent({
		name: "login",
		data() {
			return {
				FImg: "./static/login.png",
				FWXLogo: "./static/weixin/logo.png",
				FShowSet: false,
				FUserLogin: {
					loginCode: "flm",
					loginPass: "123456"
				},
				//"http://127.0.0.1:9090"
				FHostSet: {
					hostIP: "http://115.159.70.108:9090",
					ztCode: ""
				}
			};
		},
		mounted() {
			this.onLoadTokenSet();
			this.onLoadHostSet();
		},
		methods: {
			onLoadTokenSet: function() {
				//加载保存在本地信息
				let lTokenInfo = TTokenInfo.loadLocalStorage();
				if (lTokenInfo) {
					if (lTokenInfo.loginCode) {
						this.FUserLogin.loginCode = lTokenInfo.loginCode;
					}
					if (lTokenInfo.loginPass) {
						this.FUserLogin.loginPass = lTokenInfo.loginPass;
					}
				}
				//
				let lUserStore = UserStore();
				//测试账号密码
				if (!lUserStore.userToken.loginCode) {
					lUserStore.userToken.loginCode = 'flm';
				}
				if (!lUserStore.userToken.loginPass) {
					lUserStore.userToken.loginPass = '123456';
				}
				if (!lUserStore.apiBaseUrl){
					lUserStore.apiBaseUrl = this.FHostSet.hostIP;
				}		
			},
			onDoLogin: async function() {
				if (!this.FUserLogin.loginCode) {
					this.$OneMsgHelper.showDialogMsg("账号不可为空");
					return;
				}
				if (!this.FUserLogin.loginPass) {
					this.$OneMsgHelper.showDialogMsg("密码不可为空");
					return;
				}
				let lUserPass = md5(this.FUserLogin.loginPass);
				let lLoginInfo: TLoginInfo = {
					loginCode: this.FUserLogin.loginCode,
					loginPass: lUserPass,
					loginZTCode: this.FHostSet.ztCode,
					tokenID: "",
					privateKey: "",
					userName: ""
				};
				let lActionResult = await LoginApi.Login(lLoginInfo);
				if (!lActionResult.ResultSuccess) {
					this.$OneMsgHelper.showDialogMsg(lActionResult.ResultMsg);
					return;
				}
				lLoginInfo = lActionResult.ResultData;
				//成功设置保存Token信息
				let lUserStore = UserStore();
				lUserStore.userToken = new TTokenInfo();
				lUserStore.userToken.isLogin = true;
				lUserStore.userToken.loginCode = this.FUserLogin.loginCode;
				lUserStore.userToken.loginTime = Date.now();
				lUserStore.userToken.lastTime = Date.now();
				lUserStore.userToken.tokenID = lLoginInfo.tokenID;
				lUserStore.userToken.privateKey = lLoginInfo.privateKey;
				lUserStore.userToken.userName = lLoginInfo.userName;
				//保存到缓存里面
				TTokenInfo.saveLocalStorage(lUserStore.userToken);
				//跳转到主页
				this.$OneRouterHelper.navigateToHome();
			},
			onShowSet: function() {
				this.FShowSet = !this.FShowSet;
			},
			onLoadHostSet: function() {
				let lHostSetStr = uni.getStorageSync('OneUniAppSet');
				//不为空加载配置
				if (!lHostSetStr) {
					return;
				}
				let lHostSet = JSON.parse(lHostSetStr);
				if (!lHostSet) {
					return;
				}
				if (lHostSet.hostIP) {
					this.FHostSet.hostIP = lHostSet.hostIP;
				}
				if (lHostSet.ztCode) {
					this.FHostSet.ztCode = lHostSet.ztCode;
				}
				let lUserStore = UserStore();
				lUserStore.apiBaseUrl = this.FHostSet.hostIP;
				//保存配置
				uni.setStorage({
					key: 'OneUniAppSet',
					data: JSON.stringify(this.FHostSet)
				});
			},
			onSaveHostSet: function() {
				uni.setStorageSync('OneUniAppSet', JSON.stringify(this.FHostSet));
				let lUserStore = UserStore();
				lUserStore.apiBaseUrl = this.FHostSet.hostIP;
				this.$OneMsgHelper.showToast('保存配置成功')
			}
		},
	})
</script>

<style>
	.formClass {
		margin-top: 20px;
		margin-left: 15px;
		margin-right: 15px;
		padding-bottom: 15px;
		background-color: white;
		border-radius: 10px;
	}
</style>
