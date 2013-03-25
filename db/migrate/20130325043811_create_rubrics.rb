class CreateRubrics < ActiveRecord::Migration
  def change
    create_table :rubrics do |t|
      t.string :name
      t.boolean :public
      t.hstore :structure

      t.timestamps
    end
  end
end
