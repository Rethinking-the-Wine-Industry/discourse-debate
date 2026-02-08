import Component from "@glimmer/component";

export default class DebateStanceBadge extends Component {
  get post() {
    return this.args.outletArgs.post;
  }

  get stance() {
    return this.post.current_user_stance;
  }

  get label() {
    return {
      for: "For",
      neutral: "Neutral",
      against: "Against",
    }[this.stance];
  }

  <template>
    {{#if this.label}}
      <span class="user-badge debate-stance-badge {{this.stance}}">
        {{this.label}}
      </span>
    {{/if}}
  </template>
}
