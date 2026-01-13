class CreateDebateStats < ActiveRecord::Migration[7.0]
  def change
    create_table :debate_stats do |t|
      t.integer :topic_id, null: false
      t.integer :favor, default: 0
      t.integer :neutral, default: 0
      t.integer :against, default: 0
      t.timestamps null: false
    end
    add_index :debate_stats, :topic_id, unique: true
  end
end
