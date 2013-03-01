module ExhibitsHelper
  def find_exhibit(exhibits, creator, project)
    index = "#{project.id}#{creator.id}".to_i
    exhibit = exhibits.find{|exhibit| exhibit.index == index}
  end
end
