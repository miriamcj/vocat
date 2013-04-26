# Set the random seed so we get a predictable outcome
srand 1234

# Create sample sections
def random_section
  rand(36**5).to_s(36).upcase
end

def random_name
  "#{Faker::Name.first_name} #{Faker::Name.last_name}"
end

# Create the organizations
baruch  = Organization.create(:name => "Baruch College")
other   = Organization.create(:name => Faker::Company.name)

# Create developer user accounts
for name in %w(alex gabe lucas peter scott zach)
  u = User.create(:email => "#{name}@castironcoding.com", :password => "testtest123", :name => name)
  u.role = "admin"
  u.organization = baruch
  u.save
end

# Create the courses
courses = Array.new
courses << baruch.courses.create(:name => "Data Structures", :department => "CS", :number => "163", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Programming Systems", :department => "CS", :number => "201", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Systems Programming", :department => "CS", :number => "202", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Discrete Structures I", :department => "CS", :number => "250", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Discrete Structures II", :department => "CS", :number => "251", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "AI: Combinatorial Search", :department => "CS", :number => "443", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Shakespeare", :department => "ENG", :number => "201", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Survey of English Literature I", :department => "ENG", :number => "204", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Survey of English Literature II", :department => "ENG", :number => "205", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Introduction to Literature", :department => "ENG", :number => "100", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Introduction to World Literature", :department => "ENG", :number => "108", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Native American Women Writers", :department => "ENG", :number => "367U", :section => random_section, :description => Faker::Lorem.paragraph)
courses << baruch.courses.create(:name => "Practical Grammar", :department => "ENG", :number => "425", :section => random_section, :description => Faker::Lorem.paragraph)

# Create sample users
evaluators = Array.new
assistants = Array.new
creators = Array.new

6.times do |i|
  u = User.new(:email => "evaluator#{i}@test.com", :password => "testtest123", :name => random_name)
  u.organization = baruch
  u.role = "evaluator"
  u.save
  evaluators << u
end

15.times do |i|
  u = User.new(:email => "assistant#{i}@test.com", :password => "testtest123", :name => random_name)
  u.organization = baruch
  u.role = "creator"
  u.save
  assistants << u
end

150.times do |i|
  u = User.new(:email => "creator#{i}@test.com", :password => "testtest123", :name => random_name)
  u.role = "creator"
  u.organization = baruch
  u.save
  creators << u
end

# Create a rubric
rubric = Rubric.new('name' => "Theater Rubric")
rubric.public = true

voice_key = rubric.add_field({
  :name => 'Voice',
  :description => 'Breathing; Centering; Projection'
})

body_key = rubric.add_field({
  :name => 'Body',
  :description => 'Relaxation; Physical tension; Eye-contact; Non-verbal communication'
})

expression_key = rubric.add_field({
  :name => 'Expression',
  :description => 'Concentration; Focus; Point of View; Pacing'
})

overall_key = rubric.add_field({
  :name => 'Overall Effect',
  :description => 'Integration of above categories; connection with audience'
})

rubric.add_range({
  :name => 'low',
  :low => 1,
  :high => 2,
  :descriptions => {
      voice_key => 'Vocal projection is weak. Posture is crumpled or slouched: breath is unsupported. Volume is unamplified. One has to strain, or cannot hear speaker. Articulation is mushy and difficult to understand.',
      body_key => 'Body is rigidly tense, or nervous tension in constant movement, shuffling, or fidgeting. Speaker avoids eye contact and physically "hides" from audience. Gestures and non-verbal communication are excessive or restricted and unrelated to narrative.',
      expression_key => 'Concentration is weak. Speaker cannot sustain concentration and is easily distracted: speaker giggles, or breaks away from what he/she is saying. There is no clear focus to the presentation and little emotional/intellectual connection to the narrative. Speaker rambles, or pauses awkwardly',
      overall_key => 'Tension impedes speaker from engaging audience. There is impatience and/or little interest in watching or listening to presentation. Ideas are incoherent, or nonexistent. Vocal and physical aspects of the presentation interfere with effective communication.'
  }
})

rubric.add_range({
  :name => 'medium',
  :low => 3,
  :high => 4,
  :descriptions => {
      voice_key => 'Vocal projection fades in and out. Posture is off-balance: breathing is not always supported. Speaker\'s breathing is constricted by holding breath or too shallow. Volume loses amplification, particularly at end of sentences. Articulation is garbled or slurry, but distinct enough to be understood.',
      body_key => 'Speaker is initially self-conscious and tense, but grows more relaxed as he/she continues. There is occasional eye-contact. There is some nervous movement fidgeting, but it decreases as presentation continues. Gestures and non-verbal communication do not always reinforce narrative.',
      expression_key => 'Concentration is disrupted. Speaker is distracted at times and loses focus, causing momentary hesitation. There are digressions from purpose. There is occasionally loss of emotional/intellectual connection to the narrative. Speaker rushes, or is monotone.',
      overall_key => 'Speaker engages audience with varied success. Interest in the presentation ebbs and flows. Ideas are relatively clear, but lack overall coherence. Communication is effective, but neither dynamic nor very memorable.'
  }
})

rubric.add_range({
  :name => 'high',
  :low => 5,
  :high => 6,
  :descriptions => {
      voice_key => 'Vocal projection is strong. Posture supports breath: feet are grounded and body centered, allowing deep breathing to power voice. Volume is sufficiently amplified and sustained at consistent level. Articulation is clear. Speaker is easily heard and understood.',
      body_key => 'Speaker is physically calm and appears relaxed. Speaker makes direct eye-contact. Physical presence projects animation and energy. Gestures and non-verbal communication enhance narrative.',
      expression_key => 'Concentration is sustained throughout. The speaker is focused and clear about what he/she wants to say. There is a point of view and speaker appears to have an emotional/intellectual connection to their narrative.',
      overall_key => 'Speaker engages audience and is compelling to watch and listen to. Ideas are clear, concise, and communicated in a creative, memorable way.'
  }
})

rubric.save


# Create an project type
presentation = ProjectType.new(:name => "Presentation")

# Each course gets 1 evaluator, 2 assistants, 15 to 30 creators, and 2 to 10 projects
#
# SQL for finding number of courses per creator:
# select user_id, email, count(*) from courses_creators inner join users on users.id=courses_creators.user_id group by user_id;
#
courses.each do |course|

  evaluators.shuffle!
  assistants.shuffle!
  creators.shuffle!

  course.evaluators << evaluators[0]
  course.assistants << assistants[0..2]
  course.creators << creators[0..rand(10..15)]

  course.save

  rand(1..4).times do
    project = course.projects.create(:name => Faker::Company.bs.split(' ').map(&:capitalize).join(' '), :description => Faker::Lorem.paragraph)
    project.project_type = presentation
    project.rubric = rubric
    project.save

    course_creators = course.creators
    course_creators.shuffle!

    course_creators.length.times do |i|
      # Most creators submit a project
      if rand > 0.3
        submission = project.submissions.create(:name => Faker::Lorem.words(rand(2..5)).map(&:capitalize).join(' '), :summary => Faker::Lorem.paragraph )
        insert = "INSERT INTO attachments (media_file_name, media_content_type, media_file_size, media_updated_at, transcoding_status, created_at, updated_at, fileable_id, fileable_type) "
        if rand > 0.5
          values = "VALUES ('sample_mpeg5.mp4', 'video/mp4', '245779', '2013-02-20 23:43:11', '1', '2013-02-20 23:43:11', '2013-02-20 23:43:11', '#{submission.id}', 'Submission')"
        else
          values = "VALUES ('MVI_5450.AVI', 'video/avi', '1425522', '2013-02-20 23:42:21', '1', '2013-02-20 23:42:21', '2013-02-20 23:42:21', '#{submission.id}', 'Submission')"
        end
        ActiveRecord::Base.connection.execute "#{insert}#{values}"
        submission.creator = course_creators[i]
        submission.save!

        if rand > 0.5
          evaluation  = submission.evaluations.create()
          evaluation.rubric = rubric
          evaluation.evaluator = evaluators[0]
          evaluation.published = true
          rubric.field_keys.each { |key| evaluation.scores[key] = rand(rubric.low_score...rubric.high_score)}
          evaluation.save()
        end

      end
    end
  end

end

# Create an evaluator that is both a creator for a course and an evaluator for a course
evaluator = User.new(:email => "assistant_evaluator@test.com", :password => "testtest123", :name => random_name)
evaluator.organization = baruch
evaluator.role = "evaluator"
evaluator.save
course = courses.sample
course.creators << evaluator

course2 = courses.sample
loop do
  break unless course == course2
  course2 = courses.sample
end

course2.evaluators << evaluator
