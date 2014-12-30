class CreateMemberships < ActiveRecord::Migration
  def up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :course_id
      t.string :role
      t.timestamps
    end

    sql = 'SELECT * FROM courses_evaluators'
    evaluators = ActiveRecord::Base.connection.execute(sql)
    evaluators.each do |evaluator|
      Membership.create({user_id: evaluator['user_id'], course_id: evaluator['course_id'], role: :evaluator})
    end

    sql = 'SELECT * FROM courses_assistants'
    evaluators = ActiveRecord::Base.connection.execute(sql)
    evaluators.each do |evaluator|
      Membership.create({user_id: evaluator['user_id'], course_id: evaluator['course_id'], role: :assistant})
    end

    sql = 'SELECT * FROM courses_creators'
    evaluators = ActiveRecord::Base.connection.execute(sql)
    evaluators.each do |evaluator|
      Membership.create({user_id: evaluator['user_id'], course_id: evaluator['course_id'], role: :creator})
    end

    rename_table :courses_evaluators, :courses_evaluators_to_be_deleted
    rename_table :courses_assistants, :courses_assistants_to_be_deleted
    rename_table :courses_creators, :courses_creators_to_be_deleted

  end

  def down
    drop_table :memberships
    rename_table :courses_evaluators_to_be_deleted, :courses_evaluators
    rename_table :courses_assistants_to_be_deleted, :courses_assistants
    rename_table :courses_creators_to_be_deleted, :courses_creators

  end

end
