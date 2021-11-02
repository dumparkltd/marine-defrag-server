class CreateActorsMeasures < ActiveRecord::Migration[6.1]
  def change
    create_table :actors_measures do |t|
      t.belongs_to :actor, foreign_key: true, index: true, null: false
      t.belongs_to :measure, foreign_key: true, index: true, null: false
      t.date :date_start
      t.date :date_end
      t.decimal :value

      t.timestamps
    end
  end
end
