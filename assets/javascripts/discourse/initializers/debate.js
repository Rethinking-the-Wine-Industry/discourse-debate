import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "debate",

  initialize() {
    withPluginApi("1.9.0", (api) => {
      api.registerSidebarPanel("debate-panel", {
        title: "Do you agree with this hypothesis?",
        icon: "balance-scale",
        component: "debate-panel",
      });
    });
  },
};
