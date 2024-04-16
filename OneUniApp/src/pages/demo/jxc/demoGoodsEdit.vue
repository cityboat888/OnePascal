<template>
  <uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" title="商品编辑" :fixed="true" status-bar />
  <view>
    <uni-card padding="10px 0px 0px 0px" margin="5px">
      <uni-forms ref="goodsForm" :modelValue="FGoods" :rules="FGoodsRules" :label-width="80">
        <uni-forms-item>
          <uni-tag text="上传" type="primary" style="margin-top: 5px; margin-left: 15px; float: right"
            @click="onImgUpload" />
          <image :src="getImgurl()" style="width: 80px; height: 80px; "></image>
        </uni-forms-item>
        <uni-forms-item label="商品名称" required name="FGoodsName">
          <uni-easyinput v-model="FGoods.FGoodsName" placeholder="请输入商品名称" clearable />
        </uni-forms-item>
        <uni-forms-item label="商品编号">
          <uni-easyinput v-model="FGoods.FGoodsCode" placeholder="不可编辑，商品唯一" clearable />
        </uni-forms-item>
        <uni-forms-item label="售价">
          <uni-easyinput v-model="FGoods.FGoodsPrice" type="number" placeholder="请输入商品价格" />
        </uni-forms-item>
        <uni-forms-item label="备注">
          <uni-easyinput v-model="FGoods.FGoodsRemark" placeholder="请输入商品备注" clearable />
        </uni-forms-item>
      </uni-forms>
    </uni-card>
    <view style="position: fixed; bottom: 0; left: 0px;width:100%;">
      <uni-card margin="5px">
        <button type="primary" @click="onSaveGoodsForm('goodsForm')">
          保存
        </button>
      </uni-card>
    </view>

  </view>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import type { TGoodsDemo } from "./GoodsApi";
import GoodsApi from "./GoodsApi";
export default defineComponent({
  data() {
    return {
      FGoods: {} as TGoodsDemo,
      FGoodsRules: {
        FGoodsCode: {
          rules: [
            {
              required: true,
              errorMessage: "商品代码不可为空",
            },
          ],
        },
        FGoodsName: {
          rules: [
            {
              required: true,
              errorMessage: "商品名称不可为空",
            },
          ],
        },
      }
    }
  },
  mounted() {
    let lGoodsID = this.$OneRouterHelper.getLocationParams('goodsID');
    if (lGoodsID) {
      this.FGoods.FGoodsID = lGoodsID;
      this.openData();
    }
  },
  methods: {
    onBack: function () {
      this.$OneRouterHelper.navigateBackOne();
    },
    getImgurl(): string {
      if (!this.FGoods.FGoodsImgUrl) {
        return "/static/img/goods/goods.png";
      }
      return GoodsApi.GetGoodsImgUrl(this.FGoods.FGoodsImgUrl);
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
    onSaveGoodsForm: async function (form: any) {
      let lIsCheck = await this.checkForm();
      if (!lIsCheck) {
        //验证规则失败退出用异步写法。好写代码
        return;
      }
      if (typeof this.FGoods.FGoodsPrice == "string") {
        this.FGoods.FGoodsPrice = Number(this.FGoods.FGoodsPrice);
      }
      let lResult = await GoodsApi.SaveGoods(this.FGoods);
      if (!lResult.ResultSuccess) {
        this.$OneMsgHelper.showDialogMsg(lResult.ResultMsg);
        return;
      }
      this.FGoods.FGoodsID = lResult.ResultData;
      this.$OneMsgHelper.showToast("保存商品信息成功!!!");
      //保存后,在次打开数据，取最新数据
      this.openData();
    },
    openData: async function () {
      if (!this.FGoods.FGoodsID) {
        //为空代表新建
        this.FGoods = {} as TGoodsDemo;
        return;
      }
      let lResult = await GoodsApi.GetGoods(this.FGoods.FGoodsID);
      if (!lResult.ResultSuccess) {
        this.$OneMsgHelper.showDialogMsg(lResult.ResultMsg);
        return;
      }
      this.FGoods = lResult.ResultData;
      this.$OneMsgHelper.showToast("获取商品数据成功");
    },
    //上传图片
    onImgUpload: async function () {
      //上传图片
      //打开文件夹获取要上传的文件，默认只选择一个文件
      let lChooseResult = await this.$OneUniApiHelper.ChooseImage();
      if (!lChooseResult.sucess) {
        this.$OneMsgHelper.showDialogMsg(lChooseResult.errMsg);
        return;
      }
      let lFormData: FormData = new FormData();
      if (this.FGoods.FGoodsImgUrl) {
        lFormData.append("oldImgUrl", this.FGoods.FGoodsImgUrl);
      }
      console.error(lChooseResult);
      lFormData.append("file", lChooseResult.filePaths[0]);
      //上传到服务端，文件信息记录在base_file,返回base_file信息
      let lPostReulst = await this.$OneUniApiHelper.UploadFile(lChooseResult.filePaths[0], lFormData, "/UniDemo/Goods/PostGoodsImg");
      if (!lPostReulst.ResultSuccess) {
        this.$OneMsgHelper.showDialogMsg(lPostReulst.ResultMsg);
        return;
      }
      this.FGoods.FGoodsImgUrl = lPostReulst.ResultData;
    }
  },
});

</script>