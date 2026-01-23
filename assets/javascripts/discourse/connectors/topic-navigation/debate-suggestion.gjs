import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { eq } from "truth-helpers";
import dIcon from "discourse/helpers/d-icon";
import { ajax } from "discourse/lib/ajax";

export default class DebateSuggestion extends Component {
  @tracked isSubmitting = false;
  @tracked counts = null;
  @tracked userVote = null;

  constructor() {
    super(...arguments);

    const suggestion = this.suggestion;
    if (suggestion) {
      this.counts = { ...suggestion.counts };
      this.userVote = suggestion.user_vote;
    }
  }

  get topic() {
    return this.args.outletArgs.topic;
  }

  get suggestion() {
    return this.topic?.debate_suggestion;
  }

  get disableButtons() {
    return this.isSubmitting;
  }

  @action
  async vote(value) {
    if (this.disableButtons) {
      return;
    }

    this.isSubmitting = true;

    try {
      const result = await ajax(`/debates/suggestions/${this.topic.id}/vote`, {
        type: "POST",
        data: { vote: value },
      });

      this.counts = result.counts;
      this.userVote = result.vote;
    } catch (e) {
      // eslint-disable-next-line no-console
      console.error("Vote failed", e);
    } finally {
      this.isSubmitting = false;
    }
  }

  <template>
    {{#if this.suggestion}}
      <div class="debate-suggestion-panel">
        <p class="question">
          Do you think this issue should be open for debate?
        </p>

        <div class="votes">
          <button
            class="vote yes {{if (eq this.userVote 'yes') 'active'}}"
            disabled={{this.disableButtons}}
            {{on "click" (fn this.vote "yes")}}
          >
            {{#if this.isSubmitting}}
              {{dIcon "spinner" class="fa-spin"}}
            {{else}}
              {{dIcon "thumbs-up"}}
            {{/if}}
            Yes ({{this.counts.yes}})
          </button>

          <button
            class="vote no inverted {{if (eq this.userVote 'no') 'active'}}"
            disabled={{this.disableButtons}}
            {{on "click" (fn this.vote "no")}}
          >
            {{#if this.isSubmitting}}
              {{dIcon "spinner" class="fa-spin"}}
            {{else}}
              {{dIcon "thumbs-up"}}
            {{/if}}
            No ({{this.counts.no}})
          </button>
        </div>

        {{#if this.userVote}}
          <p class="user-vote">
            You voted:
            <strong>{{this.userVote}}</strong>
          </p>
        {{/if}}
      </div>
    {{/if}}
  </template>
}
