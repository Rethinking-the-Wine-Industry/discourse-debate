class DebateInfoSerializer < ApplicationSerializer
  attributes :favor, :neutral, :against

  def favor
    DebateStat.for_topic(object.id)[:favor]
  end

  def neutral
    DebateStat.for_topic(object.id)[:neutral]
  end

  def against
    DebateStat.for_topic(object.id)[:against]
  end
end
