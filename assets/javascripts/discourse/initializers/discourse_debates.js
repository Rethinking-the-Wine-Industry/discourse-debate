// import { alias } from "@ember/object/computed";
import { tracked } from "@glimmer/tracking";
import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "topic-custom-field-intializer",
  initialize(container) {
    const siteSettings = container.lookup("service:site-settings");
    const fieldName = siteSettings.topic_custom_field_name;

    withPluginApi((api) => {
      api.serializeOnCreate(fieldName);
      api.serializeToDraft(fieldName);
      api.serializeToTopic(fieldName, `topic.${fieldName}`);

      api.modifyClass("component:topic-list-item", (Superclass) => {
        return class extends Superclass {
          // Definimos a propriedade como rastreável
          @tracked customFieldValue = this.topic?.[fieldName];

          // Getters nativos em Glimmer rastreiam automaticamente
          // se dependerem de uma propriedade @tracked ou de args
          get showCustomField() {
            return !!this.customFieldValue;
          }
        };
      });
    });
  },
};
