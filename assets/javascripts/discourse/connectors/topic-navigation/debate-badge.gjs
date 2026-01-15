import Component from "@glimmer/component";

export default class DebateBadge extends Component {
  get stance() {
    return this.args.topic?.custom_fields?.debate_stance;
  }

  get label() {
    return {
      favor: "For",
      neutral: "Neutral",
      against: "Against",
    }[this.stance];
  }

  <template>
    {{#if this.label}}
      <span class="debate-badge debate-badge--{{this.stance}}">
        {{this.label}}
      </span>
    {{/if}}
  </template>
}
