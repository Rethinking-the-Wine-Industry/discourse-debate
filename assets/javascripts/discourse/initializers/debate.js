import { withPluginApi } from 'discourse/lib/plugin-api';

export default {
  name: 'debate',
  initialize() {
    withPluginApi('1.9.0', api => {
      api.decorateWidget('post-meta-data:after', helper => {
        const post = helper.getModel();
        const stance = post.topic_user_custom_fields?.debate_stance;
        if (!stance) return;
        const label = { favor: 'A Favor', neutral: 'Neutro', against: 'Contra' }[stance];
        return helper.h('span.debate-badge', label);
      });

      api.registerSidebarPanel('debate-panel', {
        title: 'Posições do Debate',
        icon: 'balance-scale',
        component: 'debate-panel'
      });
    });
  }
};
