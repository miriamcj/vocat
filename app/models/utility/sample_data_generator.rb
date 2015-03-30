module Utility

  class SampleDataGenerator

    def empty
      unless Rails.env.production?
        Annotation.delete_all
        Asset.delete_all
        Attachment::Variant.delete_all
        Attachment.delete_all
        CourseRequest.delete_all
        Course.delete_all
        Submission.delete_all
        DiscussionPost.delete_all
        Evaluation.delete_all
        Group.delete_all
        Membership.delete_all
        Organization.delete_all
        Project.delete_all
        Rubric.delete_all
        Submission.delete_all
        User.delete_all
      else
        raise 'Unable to remove data in production environment'
      end
    end

    def fill

      puts 'Emptying database'
      empty

      # Set the random seed so we get a predictable outcome
      srand 1234

      # Create the organizations
      puts 'Create Organization: Baruch College'
      baruch  = Organization.find_or_create_by(:name => "Baruch College")
      org_name = Faker::Company.name
      puts "Create Organization: #{org_name}"
      other   = Organization.create(:name => org_name)

      # Create developer user accounts
      first_names = %w(Peter Zach Clark Casey Gabe Naomi Lucas Joshie Baruch)
      last_names = %w(Soots Davis Burns Williams Blair Rubin Thurston Simmons Admin)
      admin = nil
      first_names.each_with_index do |first_name, index|
        email = "#{first_name}@castironcoding.com"
        puts "Creating user: #{email}"
        u = User.create(:email => email, :org_identity => rand(11111111..99999999), :password => "testtest123", :first_name => first_name, :last_name => last_names[index])
        u.role = "administrator"
        u.organization = baruch
        u.save
        admin = u
      end

      time = Time.new
      year = time.year

      # Create the courses

      fall = Semester.where({position: 1}).first
      puts "Found Fall Semester: ID #{fall.id}"
      winter = Semester.where({position: 2}).first
      puts "Found Winter Semester: ID #{winter.id}"
      spring = Semester.where({position: 3}).first
      puts "Found Spring  Semester: ID #{spring.id}"
      summer = Semester.where({position: 4}).first
      puts "Found Summer Semester: ID #{summer.id}"

      courses = Array.new
      puts "Create Course: CIS3810"
      courses << baruch.courses.create(:semester => winter, :year => year, :name => "Computer Information Systems", :department => "CIS", :number => "3810", :section => random_section, :description => Faker::Lorem.paragraph)
      puts "Create Course: ENG2100"
      courses << baruch.courses.create(:semester => spring, :year => year, :name => "Composition I", :department => "ENG", :number => "2100", :section => random_section, :description => Faker::Lorem.paragraph)
      puts "Create Course: ENG2150"
      courses << baruch.courses.create(:semester => fall, :year => year, :name => "Composition II: Intro to Literature", :department => "ENG", :number => "2150", :section => random_section, :description => Faker::Lorem.paragraph)
      puts "Create Course: ENG2850"
      courses << baruch.courses.create(:semester => summer, :year => year, :name => "Great Works of Literature", :department => "ENG", :number => "2850", :section => random_section, :description => Faker::Lorem.paragraph)

      # Create sample users
      evaluators = Array.new
      assistants = Array.new
      creators = Array.new

      2.times do |i|
        email = "evaluator#{i + 1}@test.com"
        puts "Create User: #{email}"
        u = User.new(:email => email, :org_identity => rand(11111111..99999999), :password => "testtest123", :first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name)
        u.organization = baruch
        u.role = "evaluator"
        u.save
        evaluators << u
      end

      2.times do |i|
        email = "assistant#{i + 1}@test.com"
        puts "Create User: #{email}"
        u = User.new(:email => email, :org_identity => rand(11111111..99999999), :password => "testtest123", :first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name)
        u.organization = baruch
        u.role = "creator"
        u.save
        assistants << u
      end

      50.times do |i|
        email = "creator#{i + 1}@test.com"
        puts "Create User: #{email}"
        u = User.new(:email => email, :org_identity => rand(11111111..99999999), :password => "testtest123", :first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name)
        u.role = "creator"
        u.organization = baruch
        u.save
        creators << u
      end

      # Create a rubric
      the_rubric = Rubric.new('name' => "Theater Rubric")
      the_rubric.low = 0
      the_rubric.high = 6
      the_rubric.public = true
      voice_key = the_rubric.add_field({'name' => 'Voice', 'description' => 'Breathing; Centering; Projection'})
      body_key = the_rubric.add_field({'name' => 'Body', 'description' => 'Relaxation; Physical tension; Eye-contact; Non-verbal communication'})
      expression_key = the_rubric.add_field({'name' => 'Expression', 'description' => 'Concentration; Focus; Point of View; Pacing'})
      overall_key = the_rubric.add_field({'name' => 'Overall Effect', 'description' => 'Integration of above categories; connection with audience'})
      low_key = the_rubric.add_range({'name' => 'Low', 'low' => 0, 'high' => 2})
      medium_key = the_rubric.add_range({'name' => 'Medium', 'low' => 3, 'high' => 4})
      high_key = the_rubric.add_range({'name' => 'High', 'low' => 5, 'high' => 6})
      the_rubric.owner = admin
      the_rubric.add_cells([
                               {'range' => low_key, 'field' => voice_key, 'description' => 'Vocal projection is weak. Posture is crumpled or slouched: breath is unsupported. Volume is unamplified. One has to strain, or cannot hear speakerubric. Articulation is mushy and difficult to understand.'},
                               {'range' => low_key, 'field' => body_key, 'description' => 'Body is rigidly tense, or nervous tension in constant movement, shuffling, or fidgeting. Speaker avoids eye contact and physically "hides" from audience. Gestures and non-verbal communication are excessive or restricted and unrelated to narrative.'},
                               {'range' => low_key, 'field' => expression_key, 'description' => 'Concentration is weak. Speaker cannot sustain concentration and is easily distracted: speaker giggles, or breaks away from what he/she is saying. There is no clear focus to the presentation and little emotional/intellectual connection to the narrative. Speaker rambles, or pauses awkwardly'},
                               {'range' => low_key, 'field' => overall_key, 'description' => 'Tension impedes speaker from engaging audience. There is impatience and/or little interest in watching or listening to presentation. Ideas are incoherent, or nonexistent. Vocal and physical aspects of the presentation interfere with effective communication.'},
                               {'range' => medium_key, 'field' => voice_key, 'description' => 'Vocal projection fades in and out. Posture is off-balance: breathing is not always supported. Speaker\'s breathing is constricted by holding breath or too shallow. Volume loses amplification, particularly at end of sentences. Articulation is garbled or slurry, but distinct enough to be understood.'},
                               {'range' => medium_key, 'field' => body_key, 'description' => 'Speaker is initially self-conscious and tense, but grows more relaxed as he/she continues. There is occasional eye-contact. There is some nervous movement fidgeting, but it decreases as presentation continues. Gestures and non-verbal communication do not always reinforce narrative.'},
                               {'range' => medium_key, 'field' => expression_key, 'description' => 'Concentration is disrupted. Speaker is distracted at times and loses focus, causing momentary hesitation. There are digressions from purpose. There is occasionally loss of emotional/intellectual connection to the narrative. Speaker rushes, or is monotone.'},
                               {'range' => medium_key, 'field' => overall_key, 'description' => 'Speaker engages audience with varied success. Interest in the presentation ebbs and flows. Ideas are relatively clear, but lack overall coherence. Communication is effective, but neither dynamic nor very memorable.'},
                               {'range' => high_key, 'field' => voice_key, 'description' => 'Vocal projection is strong. Posture supports breath: feet are grounded and body centered, allowing deep breathing to power voice. Volume is sufficiently amplified and sustained at consistent level. Articulation is clearubric. Speaker is easily heard and understood.'},
                               {'range' => high_key, 'field' => body_key, 'description' => 'Speaker is physically calm and appears relaxed. Speaker makes direct eye-contact. Physical presence projects animation and energy. Gestures and non-verbal communication enhance narrative.'},
                               {'range' => high_key, 'field' => expression_key, 'description' => 'Concentration is sustained throughout. The speaker is focused and clear about what he/she wants to say. There is a point of view and speaker appears to have an emotional/intellectual connection to their narrative.'},
                               {'range' => high_key, 'field' => overall_key, 'description' => 'Speaker engages audience and is compelling to watch and listen to. Ideas are clear, concise, and communicated in a creative, memorable way.'},
                           ])
      puts "Create Rubric: #{the_rubric.name}"
      the_rubric.save

      comm_rubric =  Rubric.new('name' => "COMM1010 Rubric")
      comm_rubric.public = true
      comm_rubric.low = 0
      comm_rubric.high = 6
      comm_rubric.owner = admin
      attention_key = comm_rubric.add_field({'name' => 'Attention', 'description' => 'Attention Step'})
      introduction_key = comm_rubric.add_field({'name' => 'Relation to Audience', 'description' => 'Relation to Audience'})
      thesis_key = comm_rubric.add_field({'name' => 'Specific purpose/thesis', 'description' => 'Specific purpose/thesis'})
      preview_key = comm_rubric.add_field({'name' => 'Preview', 'description' => 'Preview'})
      logical_key = comm_rubric.add_field({'name' => 'Logical Organization Pattern', 'description' => 'Logical Organization Pattern'})
      supporting_key = comm_rubric.add_field({'name' => 'Supporting Material', 'description' => 'Supporting Material'})
      citations_key = comm_rubric.add_field({'name' => 'Citations', 'description' => 'Citations'})
      transitions_key = comm_rubric.add_field({'name' => 'Transitions', 'description' => 'Transitions'})
      review_key = comm_rubric.add_field({'name' => 'Review', 'description' => 'Review'})
      intro_tieback_key = comm_rubric.add_field({'name' => 'Introduction Tieback', 'description' => 'Introduction Tieback'})
      rate_key = comm_rubric.add_field({'name' => 'Rate', 'description' => 'Rate'})
      level_key = comm_rubric.add_field({'name' => 'Level', 'description' => 'Level'})
      eye_key = comm_rubric.add_field({'name' => 'Eye Contact', 'description' => 'Eye Contact'})
      movement_key = comm_rubric.add_field({'name' => 'Movement', 'description' => 'Movement'})
      visual_key = comm_rubric.add_field({'name' => 'Visual Aids / Attire', 'description' => 'Visual Aids / Attire'})
      comm_low_key = comm_rubric.add_range({'name' => 'Poor/Failure', 'low' => 0, 'high' => 2})
      comm_medium_key = comm_rubric.add_range({'name' => 'Good/Average', 'low' => 3, 'high' => 4})
      comm_high_key = comm_rubric.add_range({'name' => 'Excellent', 'low' => 5, 'high' => 6})

      comm_rubric.add_cells([
                                {'range' => comm_low_key, 'field' => attention_key, 'description' => 'Doesn\'t gain attention, speaker picked weak/inappropriate devices, theme is unclear, creates limited or negative goodwill and credibility, major delivery issues'},
                                {'range' => comm_medium_key, 'field' => attention_key, 'description' => 'Gains some attention, speaker could have picked stronger devices, theme is present but unclear, creates some goodwill and credibility, minor delivery issues'},
                                {'range' => comm_high_key, 'field' => attention_key, 'description' => 'Strongly gains audiences attention with appropriate devices, establishes clear theme that is related to the topic, fosters a sense of goodwill and credibility, virtually free of delivery issues'},

                                {'range' => comm_low_key, 'field' => introduction_key, 'description' => 'Provides little or no rationale for why the speech has value to a "specific" or "general" audience'},
                                {'range' => comm_medium_key, 'field' => introduction_key, 'description' => 'Hints at why the speech is important, addresses the reason why a "general" audience should listen'},
                                {'range' => comm_high_key, 'field' => introduction_key, 'description' => 'Provided a terse, but strong rationale for why the speech is important and why his/her "specific" audience should listen'},

                                {'range' => comm_low_key, 'field' => thesis_key, 'description' => 'No clear thesis is provided, the audience at the start of the speech has little or no idea of the overall purpose and can\'t repeat or identify a thesis statement.'},
                                {'range' => comm_medium_key, 'field' => thesis_key, 'description' => 'Thesis provided but wording is ambiguous, hard to follow the overall goal of the speech, the audience can identify thesis but not with ease'},
                                {'range' => comm_high_key, 'field' => thesis_key, 'description' => 'Clearly provided a thesis statement for the speech, established a goal (persuade/inform)... Boldly stated in a fashion the audience can identify and easily repeat'},

                                {'range' => comm_low_key, 'field' => preview_key, 'description' => 'Lacking numeration, no clear taglines, audience has little or no idea what the main supporting points of the thesis, even with great effort listeners are confused about what the speaker is going to say and the order she/he is going to deal with issues'},
                                {'range' => comm_medium_key, 'field' => preview_key, 'description' => 'Main points are numerated, wording might be inconsistent/vague, taglines for points might be compound sentences, lacking elevation with no repetition or alliteration, points are identifiable but not repeatable and require some thought to extract'},
                                {'range' => comm_high_key, 'field' => preview_key, 'description' => 'Main points are numerated, are strong concise statements, not stated as questions, speaker probably used alliteration or repetition, the points previewed are identifiable and repeatable and provide a clear sequence of events to unfold in the speech'},

                                {'range' => comm_low_key, 'field' => logical_key, 'description' => 'Pattern is inappropriate for the specific topic or no pattern can be identified, speech lacks any logical flow of information or argument.'},
                                {'range' => comm_medium_key, 'field' => logical_key, 'description' => 'Pattern is adequate but other patterns would be a stronger fit of the given topic, points could be put in a different order to provide a more logical flow of information/argument'},
                                {'range' => comm_high_key, 'field' => logical_key, 'description' => 'Organization pattern is appropriate to specific purpose, points are arranged in a way that creates a logical progression of information/argument'},

                                {'range' => comm_low_key, 'field' => supporting_key, 'description' => 'Little or no primary or secondary support, most support is from weak web pages (low quality), personal and mass media examples are absent or poorly developed, material is out of date, support doesn\'t seem to fit the main/subpoint it is linked with'},
                                {'range' => comm_medium_key, 'field' => supporting_key, 'description' => 'Some primary and secondary support, source quality varies, uses some low quality sources, better data could be extracted from sources, personal and mass media example could be developed more, some support is out of date, most support links clearly to main/subpoint it supports'},
                                {'range' => comm_high_key, 'field' => supporting_key, 'description' => 'Uses primary and secondary support from high quality sources, great variety of sources, extracts quality data from sources, personal and mass media examples are richly described, support is current, support links clearly to main point/subpoint it supports'},

                                {'range' => comm_low_key, 'field' => citations_key, 'description' => 'Verbal footnotes are rarely or never given for supporting material, clearly stating source, clearly stating date of publication, clearly providing author where appropriate'},
                                {'range' => comm_medium_key, 'field' => citations_key, 'description' => 'Verbal footnotes are given for most supporting material, clearly stating source, clearly stating date of publication, clearly providing author where appropriate  but not consistently'},
                                {'range' => comm_high_key, 'field' => citations_key, 'description' => 'Verbal footnotes are given for all supporting material, clearly stating source, clearly stating date of publication, clearly providing author where appropriate'},

                                {'range' => comm_low_key, 'field' => transitions_key, 'description' => 'Movement from point to point is unclear, taglines are not restated for mainpoints or don\'t match preview order, movement from point to point can be occasionally clear but abrupt'},
                                {'range' => comm_medium_key, 'field' => transitions_key, 'description' => 'Speaker moves clearly from point to point, s/he restates most taglines for main points , changes are not consistently fluid and fail to include the use of quotations or anecdotes to serve as mini attention getters'},
                                {'range' => comm_high_key, 'field' => transitions_key, 'description' => 'Speaker moves clearly from point to point, s/he precisely restates taglines for main points, changes are fluid and often include the use of quotations or anecdotes to serve as mini attention getters'},

                                {'range' => comm_low_key, 'field' => review_key, 'description' => 'Fails to restate specific purpose and main points, offers no sense of summary'},
                                {'range' => comm_medium_key, 'field' => review_key, 'description' => 'Reviews specific purpose and main points, language doesn\'t mirror the speaker\'s statement and preview at the start of the speech'},
                                {'range' => comm_high_key, 'field' => review_key, 'description' => 'Clearly restates specific purpose and main points, language mirrors the speaker\'s statement and preview at the start of the speech'},

                                {'range' => comm_low_key, 'field' => intro_tieback_key, 'description' => 'Speech ends abruptly, no theme is referenced, little or no link to how the speech starts, listener feels like more should be said'},
                                {'range' => comm_medium_key, 'field' => intro_tieback_key, 'description' => 'Provides a sense of closure and completeness, could do a better job linking back to theme and attention getter'},
                                {'range' => comm_high_key, 'field' => intro_tieback_key, 'description' => 'Speaker refers back to attention getter and theme, provide a sense of closure and completeness'},

                                {'range' => comm_low_key, 'field' => rate_key, 'description' => 'Pace inappropriate to mood of language and content, seems like s/he is rushing or has pauses where s/he is going too slow, significant nonfluencies or fillers'},
                                {'range' => comm_medium_key, 'field' => rate_key, 'description' => 'Most pace changes appropriate to mood of language and content, occasionally seems like s/he is rushing or has pauses where s/he is going too slow, limited nonfluencies or fillers'},
                                {'range' => comm_high_key, 'field' => rate_key, 'description' => 'Pace changes appropriately to mirror mood of language and content, never seems like s/he is rushing or has pauses where s/he is going too slow, limited nonfluencies or fillers'},

                                {'range' => comm_low_key, 'field' => level_key, 'description' => 'Often seems like s/he is too loud or too quite, volume level fails to mirror the mood of language and speech content'},
                                {'range' => comm_medium_key, 'field' => level_key, 'description' => 'Most volume changes appropriately to mood of language and content, occasionally seems like s/he is too loud or is too quiet'},
                                {'range' => comm_high_key, 'field' => level_key, 'description' => 'Volume changes appropriately to mirror mood of language and content, never seems like s/he is loud or is too quiet, voice able to reach all parts of the room'},

                                {'range' => comm_low_key, 'field' => eye_key, 'description' => 'Rarely looks at audience and buried in notes or looking away from the eyes of the audience'},
                                {'range' => comm_medium_key, 'field' => eye_key, 'description' => 'Parts of the audience are neglected, spends too much time looking at notes or specific part of the audience'},
                                {'range' => comm_high_key, 'field' => eye_key, 'description' => 'Eyes work the whole room, rarely locked on notes or a specific part of the audience'},

                                {'range' => comm_low_key, 'field' => movement_key, 'description' => 'Limited or no expressive and symbolism movements to add to speech quality, uses flip gesture and has limited body control, hands in pockets or engaged in adaptive behaviors, posture and balance are distracters'},
                                {'range' => comm_medium_key, 'field' => movement_key, 'description' => 'Uses a few expressive and symbolic movements to add to speech quality but could do much more, uses flip gesture and has limited body control, posture and balance are inconsistent'},
                                {'range' => comm_high_key, 'field' => movement_key, 'description' => 'Uses expressive and symbolic movements to add to speech quality, understands the need to not always gesture and has full body control, maintains a good posture'},

                                {'range' => comm_low_key, 'field' => visual_key, 'description' => 'Visual aids are missing or do little to support the speech, Visual aids are handled poorly, Attire is a major detractor from the speech and harms overall perception'},
                                {'range' => comm_medium_key, 'field' => visual_key, 'description' => 'Visual aids have some guideline issues, could add more to the content of the speech, print of the Visual aids is off, Minor handling issues, Attire could be more fitting to the goals and content of the speech'},
                                {'range' => comm_high_key, 'field' => visual_key, 'description' => 'Visual aids clear and follow guidelines, Visual aids are handled well, attire is appropriate and fits the goals and content of the speech'},
                            ])
      comm_rubric.save
      puts "Create Rubric: #{comm_rubric.name}"

      rubrics = [the_rubric, comm_rubric]

      # Each course gets 1 evaluator, 2 assistants, 15 to 30 creators, and 2 to 10 projects
      #
      # SQL for finding number of courses per creator:
      # select user_id, email, count(*) from courses_creators inner join users on users.id=courses_creators.user_id group by user_id;
      #
      courses.each_with_index do |course, course_index|

        # Scramble the users
        puts "Shuffling Evaluators"
        evaluators.to_a.shuffle!
        puts "Shuffling Assistants"
        assistants.to_a.shuffle!
        puts "Shuffling Creators"
        creators.to_a.shuffle!

        # Add users to the course
        evaluators.sample(rand(1..3)).each do |user|
          puts "Enroll User: #{user.email} in #{course.department}#{course.number}"
          course.enroll user, :evaluator
        end
        assistants.sample(rand(0..2)).each do |user|
          puts "Enroll User: #{user.email} in #{course.department}#{course.number}"
          course.enroll user, :assistant
        end
        creators.sample(rand(10..25)).each do |user|
          puts "Enroll User: #{user.email} in #{course.department}#{course.number}"
          course.enroll user, :creator
        end
        course.save

        # Create some groups
        group_count = rand(1..5)
        group_count.times do |x|
          name = "Group ##{x + 1}"
          puts "Create Group: #{name}"
          group = course.groups.create(:name => name)
          per_group = (course.creators.count / group_count).floor
          creators_to_add =  course.creators.sample(per_group)
          puts "Enrolling Creators in Group: #{creators_to_add.length} creators enrolled"
          group.creators << creators_to_add
          group.save
        end

        # Create projects in various states of completeness
        rand(3..6).times do

          rubric = rubrics.sample()
          project = Project.create({
                                       :course => course,
                                       :name => Faker::Company.bs.split(' ').map(&:capitalize).join(' '),
                                       :description => Faker::Lorem.paragraph,
                                       :rubric => rubric,
                                       :type => 'UserProject',
                                       :settings => {
                                           'enable_peer_review' => random_boolean,
                                           'enable_self_evaluation' => random_boolean,
                                           'enable_creator_attach' => random_boolean,
                                           'enable_public_discussion' => random_boolean
                                       }
                                   })
          puts "Create Project: #{project.name} in #{course.department}#{course.number}"
          project.save

          course_creators = course.creators
          course_creators.to_a.shuffle!

          course_creators.length.times do |i|
            # Most creators submit a project
            if rand > 0.3
              submission = project.submissions.create(:name => Faker::Lorem.words(rand(2..5)).map(&:capitalize).join(' '), :creator => course_creators[i] )
              puts "Create Submission: #{course_creators[i].email} for #{project.name}"
              submission.save!
            end
          end
        end

      end

      # Create an evaluator that is both a creator for a course and an evaluator for a course
      evaluator = User.new(:email => "assistant_evaluator@test.com", :password => "testtest123", :first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name)
      evaluator.organization = baruch
      evaluator.role = "evaluator"
      evaluator.save
      course = courses.sample
      course.enroll(evaluator, :creator)

      course2 = courses.sample
      loop do
        break unless course == course2
        course2 = courses.sample
      end

      course2.enroll(evaluator, :evaluator)

    end


    # Create sample sections
    def random_section
      rand(36**5).to_s(36).upcase
    end

    def random_boolean
      [true, false].sample
    end

    def random_score
      r = RandomGaussian.new(4.2, 1.0)
      num = r.rand().round()
      if num <= 1 then num = 1 end
      if num >= 6 then num = 6 end
      num
    end

  end

end
