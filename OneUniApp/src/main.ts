import { createSSRApp } from "vue";
import { createPinia } from 'pinia'
import App from "./App.vue";
import OneMsgHelper from "@/baselib/unihelper/OneMsgHelper";
import OneUniApiHelper from "@/baselib/unihelper/OneUniApiHelper";
import OneRouterHelper from "@/baselib/unihelper/OneRouterHelper"
import OnetabBar from "@/components/OnetabBar.vue"
//*********************注入this.$全局提醒**************************************
declare module '@vue/runtime-core' {
  interface ComponentCustomProperties {
    $OneMsgHelper: typeof OneMsgHelper;
    $OneUniApiHelper: typeof OneUniApiHelper;
    $OneRouterHelper: typeof OneRouterHelper;
  }
}
//

//*********创建应用App***********/
export function createApp() {
  const pinia = createPinia();
  const app = createSSRApp(App);
  app.use(pinia);
  app.component("OnetabBar", OnetabBar);
  app.config.globalProperties.$OneMsgHelper = OneMsgHelper;  //弹框辅助
  app.config.globalProperties.$OneUniApiHelper = OneUniApiHelper;  //路由辅助
  app.config.globalProperties.$OneRouterHelper = OneRouterHelper;  //路由辅助
  return {
    app,
  };
}
