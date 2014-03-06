class AddPositionToProjects < ActiveRecord::Migration
  def up
    add_column :projects, :listing_order, :integer
#    Project.update_all :listing_order => RankedModel::MIN_RANK_VALUE
    Course.all.each do |course|
      course.projects.order(:name).each_with_index do |project, index|
        project.listing_order_position = index
        project.save
      end
    end
  end

  def down
    remove_column :projects, :listing_order
  end
end
