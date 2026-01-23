import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import { ajax } from "discourse/lib/ajax";

export default class SuggestionYesNoVote extends Component {
  @service currentUser;
  @service siteSettings;

  // ---------- DATA ----------

  get topic() {
    return this.args.outletArgs?.topic;
  }

  get isEnabled() {
    return !!this.siteSettings.discourse_debates_enabled;
  }

  get isSuggestionBox() {
    return (
      this.topic &&
      this.topic.category_id ===
        this.siteSettings.discourse_debates_suggestion_category_id
    );
  }

  get shouldRender() {
    return this.isEnabled && this.isSuggestionBox;
  }

  get votes() {
    return (
      this.topic?.custom_fields?.suggestion_votes || {
        yes: 0,
        no: 0,
      }
    );
  }

  get userVote() {
    return this.topic?.custom_fields?.user_vote;
  }

  get canVote() {
    return !!this.currentUser && !this.userVote;
  }

  // ---------- UI HELPERS ----------

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

  // ---------- ACTIONS ----------

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

  // ---------- TEMPLATE ----------

  <template>
    {{#if this.shouldRender}}
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
