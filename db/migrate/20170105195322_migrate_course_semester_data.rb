class MigrateCourseSemesterData < ActiveRecord::Migration[5.0]
  def up
    Course.where('organization_id IS NOT NULL AND semester_id IS NOT NULL AND year IS NOT NULL').each do |course|
      semester = course.semester
      organization = course.organization
      new_semester = Semester.find_or_create_by(name: "#{semester.name} #{course.year}", organization_id: organization.id) do |attr|
        attr.position = organization.semesters.count + 1
        case semester.name
          when 'Fall'
            attr.start_date = Date.new(course.year, 8, 24)
            attr.end_date = Date.new(course.year, 12, 20)
          when 'Spring'
            attr.start_date = Date.new(course.year, 12, 16)
            attr.end_date = Date.new(course.year + 1, 5, 26)
          when 'Summer'
            attr.start_date = Date.new(course.year, 5, 30)
            attr.end_date = Date.new(course.year, 8, 3)
          when 'Winter'
            attr.start_date = Date.new(course.year, 1, 1)
            attr.end_date = Date.new(course.year, 1, 25)
        end
      end
      course.semester = new_semester
      course.save
    end

    Semester.where(start_date: nil).delete_all
  end
end
