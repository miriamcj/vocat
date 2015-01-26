class AddCanvasToAnnotations < ActiveRecord::Migration
  def change
    add_column :annotations, :canvas, :text
  end
end
