FactoryGirl.define do
  factory :rubric do
    name 'A test rubric'
    low 0
    high 10
    association :owner, factory: :evaluator, strategy: :build
    fields [
               {
                   'name' => 'body',
                   'desc' => 'desc',
                   'id'   => 'b'
               },
               {
                   'name' => 'voice',
                   'desc' => 'desc',
                   'id'   => 'v'
               },
               {
                   'name' => 'rhetoric',
                   'desc' => 'desc',
                   'id'   => 'r'
               },
           ]
    cells []
    ranges [
              {
                  'low' => 0,
                  'high' => 5,
                  'name' => 'low'
              },
              {
                  'low' => 6,
                  'high' => 10,
                  'name' => 'high'
              }
           ]
  end
end
