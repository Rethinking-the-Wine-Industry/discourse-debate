import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import DButton from "discourse/components/d-button";
import { ajax } from "discourse/lib/ajax";

export default class SuggestionYesNoVote extends Component {
  @tracked loading = false;
  @tracked user_vote = null;

  constructor() {
    super(...arguments);
    this.user_vote = this.topic.current_user_vote;
  }

  get topic() {
    return this.args.topic;
  }

  get enabled() {
    return this.topic.is_suggestion;
  }

  get votes() {
    return (
      this.topic?.custom_fields?.suggestion_votes || {
        yes: 0,
        no: 0,
      }
    );
  }

  get canVote() {
    return !this.user_vote;
  }

  get yesLabel() {
    return `Yes (${this.votes.yes})`;
  }

  get noLabel() {
    return `No (${this.votes.no})`;
  }

  get userVoteLabel() {
    if (this.userVote === "yes" || this.userVote === 1) {
      return "Yes";
    }
    if (this.userVote === "no" || this.userVote === 0) {
      return "No";
    }
    return null;
  }

  get yesDisabled() {
    return !this.canVote;
  }

  get noDisabled() {
    return !this.canVote;
  }

  @action
  voteYes() {
    this.submitVote("yes");
  }

  @action
  voteNo() {
    this.submitVote("no");
  }

  async submitVote(value) {
    if (!this.topic) {
      return;
    }

    try {
      const result = await ajax(`/debates/suggestions/${this.topic.id}/vote`, {
        type: "POST",
        data: { vote: value },
      });

      this.topic.custom_fields ||= {};
      this.topic.custom_fields.suggestion_votes = {
        yes: result.counts.yes,
        no: result.counts.no,
      };
      this.topic.custom_fields.user_vote = result.vote;
    } catch (e) {
      // eslint-disable-next-line no-console
      console.error("Vote failed", e);
    }
  }

  <template>
    {{#if this.enabled}}
      <div class="debate-suggestion-vote">
        <div class="question">
          Do you think this issue should be open for debate?
        </div>

        <div class="buttons">
          <DButton
            @icon="thumbs-up"
            @label={{this.yesLabel}}
            @action={{this.voteYes}}
            @disabled={{this.yesDisabled}}
            class="btn-primary"
          />

          <DButton
            @icon="thumbs-down"
            @label={{this.noLabel}}
            @action={{this.voteNo}}
            @disabled={{this.noDisabled}}
            class="btn-danger"
          />
        </div>

        {{#if this.userVoteLabel}}
          <div class="user-vote">
            You voted:
            <strong>{{this.userVoteLabel}}</strong>
          </div>
        {{/if}}
      </div>
    {{/if}}
  </template>
}
