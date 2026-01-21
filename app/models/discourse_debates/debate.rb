module DiscourseDebates
  class Debate < ::ActiveRecord::Base
    self.table_name = "debates"

    belongs_to :topic

    enum :status, {
      suggestion: 0,
      open: 1,
      closed: 2
    }
  end
end
