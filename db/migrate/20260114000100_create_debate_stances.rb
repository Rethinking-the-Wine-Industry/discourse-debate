# frozen_string_literal: true

class CreateDebateStances < ActiveRecord::Migration[7.0]
  def change
    create_table :debate_stances do |t|
      t.integer :user_id, null: false
      t.integer :topic_id, null: false
      t.string :stance, null: false
      t.boolean :anonymous, default: false

      t.timestamps
    end

    add_index :debate_stances, [:user_id, :topic_id], unique: true
    add_index :debate_stances, :topic_id
  end
end
