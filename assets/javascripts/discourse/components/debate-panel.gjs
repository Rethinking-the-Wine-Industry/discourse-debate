import Component from "@glimmer/component";

export default class DebatePanelComponent extends Component {
  get hello() {
    return "Debate component is alive";
  }

  <template>
    <div class="debate-panel-options">
      {{this.hello}}
    </div>
  </template>
}
