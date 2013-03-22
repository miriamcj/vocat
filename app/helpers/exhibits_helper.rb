module ExhibitsHelper
  def find_exhibit(exhibits, creator, project)
    exhibits.find do |exhibit|
      exhibit.creator.id == creator.id && exhibit.project.id == project.id
    end
  end
end
