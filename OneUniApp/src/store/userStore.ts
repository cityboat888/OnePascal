import { defineStore } from 'pinia'
import TTokenInfo from './userToken'
export const UserStore = defineStore({
  id: 'User',
  state: () => ({
    appID: "",
    apiBaseUrl: "",
    userToken: new TTokenInfo()
  }),

  actions: {
  },
})