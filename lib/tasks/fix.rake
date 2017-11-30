namespace :fix do

  def deletable?(submission)
    return false if submission.has_asset?
    return false if submission.evaluations.count > 0
    return false if submission.discussion_posts.count > 0
    return true
  end


  task :count_duplicates => :environment do |t, args|
    dupes = Submission.group(:project_id, :creator_id, :creator_type).count()
    problems = 0
    found = 0
    removed = 0
    dupes.each do |k, v|
      if v > 1
        found = found + 1
        pid = k[0]
        cid = k[1]
        ctype = k[2]
        submissions = Submission.where(project_id: pid, creator_id: cid, creator_type: ctype)
        sub_one = submissions.first
        sub_two = submissions.second
        sub_one_deletable = deletable?(sub_one)
        sub_two_deletable = deletable?(sub_two)

        msg = ""
        if !sub_one_deletable && !sub_two_deletable
          msg << "NEITHER SUBMISSION CAN BE DELETED. PROBLEM!"
          problems = problems + 1
        elsif sub_one_deletable && sub_two_deletable
          msg << "Both deletable. "
          removed = removed + 1
          sub_one.destroy
          msg << "destroy submission [#1: #{sub_one.id}]"
        else
          msg << "First is deletable. " if sub_one_deletable
          msg << "First is NOT deletable. " unless sub_one_deletable
          msg << "Second is deletable. " if sub_two_deletable
          msg << "Second is NOT deletable. " unless sub_two_deletable
          if sub_one_deletable
            removed = removed + 1
            sub_one.destroy
            msg << "destroy submission [#1: #{sub_one.id}]"
          end
          if sub_two_deletable
            removed = removed + 1
            sub_two.destroy
            msg << "destroy submission [#2: #{sub_two.id}]"
          end
        end
        puts msg
      end
    end
    puts "FOUND: #{found}"
    puts "REMOVED: #{removed}"
    puts "PROBLEMS: #{problems}"
  end


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