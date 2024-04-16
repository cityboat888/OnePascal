<template>
  <uni-nav-bar left-icon="left" leftText="返回" @clickLeft="onBack()" title="表单展示" :fixed="true" status-bar />
  <view>
    <uni-card margin="5px">
	  <uni-section title="基础表单" type="line" style="margin-left:-10px;" />
      <uni-easyinput errorMessage v-model="FValue" focus placeholder="请输入内容"></uni-easyinput>
    </uni-card>
    <uni-card margin="5px">
	  <uni-section title="左右布局表单" type="line" style="margin-left:-10px;" />
      <view class="uni-flex uni-row" style="margin-top: 10px">
        <view style="width: 80px; margin-top: 5px">标准写法</view>
        <view style="-webkit-flex: 1; flex: 1">
          <uni-easyinput v-model="FValue" focus placeholder="请输入内容"></uni-easyinput>
        </view>
      </view>
      <view class="uni-flex uni-row" style="margin-top: 10px">
        <view style="width: 80px; margin-top: 5px">自定样式</view>
        <view style="-webkit-flex: 1; flex: 1">
          <uni-easyinput :styles="styles" v-model="FValue" focus placeholder="请输入内容"></uni-easyinput>
        </view>
      </view>
    </uni-card>
    <!--放在view引用样式在自已调下,样式overflow解决下拉错位 -->
    <uni-card margin="5px" style="overflow: unset">
	  <uni-section title="下拉选择" type="line" style="margin-left:-10px;" />
      <uni-data-select v-model="FCity" :localdata="range" label="应用选择"></uni-data-select>
    </uni-card>
    <!--单选,多选  -->
    <uni-card margin="5px">
      <uni-section title="单选" type="line" style="margin-left:-10px;" />
      <uni-data-checkbox v-model="FCity" :localdata="checkboxRange"></uni-data-checkbox>
    </uni-card>
    <uni-card margin="5px">
      <uni-section title="多选" type="line" style="margin-left:-10px;" />
      <uni-data-checkbox v-model="FCitys" :localdata="checkboxRange" multiple></uni-data-checkbox>
    </uni-card>
    <!-- 日期选择 -->
    <uni-card margin="5px">
	  <uni-section title="日期选择" type="line" style="margin-left:-10px;" />
      <uni-datetime-picker type="date" :clear-icon="false" v-model="FDate" />
    </uni-card>
    <uni-card margin="5px">
	  <uni-section title="日期时间" type="line" style="margin-left:-10px;" />
      <uni-datetime-picker type="datetime" v-model="FDate" />
    </uni-card>
    <!-- 评分 -->
    <uni-card margin="5px">
	  <uni-section title="评分" type="line" style="margin-left:-10px;" />
      <uni-rate v-model="FRate" />
    </uni-card>
    <!-- 滑块 -->
    <view class="uni-list">
      <view class="uni-list-cell uni-list-cell-pd">
        <view class="uni-list-cell-db">开启中</view>
        <switch :checked="FCheck" @change="onSwitchChange" />
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  data() {
    return {
      FCheck: true,
      FRate: 0,
      FDate: "",
      FCity: "北京",
      FCitys: [''],
      styles:{
        color: "#2979FF",
        disableColor: "#eee",
        borderColor: "#2979FF",
      },
      candidates:["北京", "南京", "东京", "武汉", "天津", "上海", "海口"],
      range: [
        { text: "北京", value: "北京", disable: false },
        { text: "南京", value: "南京", disable: false },
        { text: "东京", value: "东京", disable: false },
      ],
      checkboxRange: [{ text: "北京", value: "北京", disabled: false }],
      FValue: ""
    }
  },
  methods: {
    onBack: function () {
      this.$OneRouterHelper.navigateBackOne();
    },
    onSwitchChange: function (event: any) {
      this.FCheck = event.detail.value;
    }
  },
})
</script>
<style scoped>

</style>