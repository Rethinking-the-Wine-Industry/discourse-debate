class DebateStat < ActiveRecord::Base
  def self.for_topic(topic_id)
    stat = find_or_create_by(topic_id: topic_id)
    {
      favor: stat.favor,
      neutral: stat.neutral,
      against: stat.against
    }
  end

  def self.refresh!(topic_id)
    topic_users = TopicUser.where(topic_id: topic_id)
    favor = topic_users.where("custom_fields ->> 'debate_stance' = 'favor'").count
    neutral = topic_users.where("custom_fields ->> 'debate_stance' = 'neutral'").count
    against = topic_users.where("custom_fields ->> 'debate_stance' = 'against'").count
    stat = find_or_create_by(topic_id: topic_id)
    stat.update!(favor: favor, neutral: neutral, against: against)
  end
end
