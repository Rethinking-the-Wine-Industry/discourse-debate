import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class DebateStancePicker extends Component {
  @tracked loading = false;
  @tracked stance = null;

  constructor() {
    super(...arguments);
    this.stance = this.topic.current_user_stance;
  }

  get topic() {
    return this.args.topic;
  }

  get enabled() {
    return this.topic.is_debate;
  }

  get isFor() {
    return this.stance === "for" ? "active" : "";
  }

  get isNeutral() {
    return this.stance === "neutral" ? "active" : "";
  }

  get isAgainst() {
    return this.stance === "against" ? "active" : "";
  }

  @action
  async select(value) {
    if (this.loading || this.stance === value) {
      return;
    }
    this.loading = true;
    try {
      await ajax(`/debates/stances/${this.topic.id}`, {
        type: "POST",
        data: { stance: value },
      });
      this.stance = value;
    } catch (e) {
      popupAjaxError(e);
    } finally {
      this.loading = false;
    }
  }

  <template>
    {{#if this.enabled}}
      <div class="debate-stance-picker">
        <p class="question">Do you agree with this hypothesis?</p>
        {{!-- <p class="question">enabled? {{this.enabled}}</p> --}}
        <p class="question">Current Stance: {{this.stance}}</p>
        <div class="segmented-control">
          <button
            class="btn btn-default stance for {{this.isFor}}"
            disabled={{this.loading}}
            {{on "click" (fn this.select "for")}}
          >
            For
          </button>

          <button
            class="btn btn-default stance neutral {{this.isNeutral}}"
            disabled={{this.loading}}
            {{on "click" (fn this.select "neutral")}}
          >
            Neutral
          </button>

          <button
            class="btn btn-default stance against {{this.isAgainst}}"
            disabled={{this.loading}}
            {{on "click" (fn this.select "against")}}
          >
            Against
          </button>
        </div>
      </div>
    {{/if}}
  </template>
}
