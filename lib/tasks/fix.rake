namespace :fix do
  desc "Fix duplicate submissions"
  task :duplicate_submissions, [:course_id] => :environment do |t, args|
    course = Course.find(args[:course_id])
    course.projects.each do |project|
      course.creators.each do |creator|
        count = course.submissions.where(project: project, creator: creator).count
        if count > 1
          submissions = course.submissions.where(project: project, creator: creator)
          submissions.each do |submission|
            unless submission.has_asset? || submission.evaluations.count > 0 || submission.discussion_posts.count > 0
              puts "[#{project.id}, #{creator.id}] - Count #{count} - Destroying submission #{submission.id}"
              submission.destroy
            end
          end
        end
      end
    end
  end
end