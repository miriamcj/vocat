Apipie.configure do |config|
  config.app_name                = "Vocat API"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apipie"
  config.app_info                =<<-EOS
    Vocat is a teaching and learning platform that facilitates qualitative and quantitative assessment of a range of
    media. Built as a collaboration between the Center for Teaching and Learning at Baruch College, City University of
    New York and Cast Iron Coding of Portland, Oregon, the tool is in active development.
  EOS
  config.validate                = :explicitly
  config.copyright               = "Copyright #{Time.now.year} Baruch College, City University of New York"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.use_cache = Rails.env.production?
end
