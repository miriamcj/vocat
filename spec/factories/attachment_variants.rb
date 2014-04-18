# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment_variant, :class => 'Attachment::Variant' do
    attachment_id 1
    location "/something"
    format ''
    state :unprocessed
    processor_name ''
    processor_data ''
    processor_error ''
  end
end
