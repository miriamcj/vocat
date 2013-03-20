class SubmissionSerializer < ActiveModel::Serializer
  attributes :id, :name, :summary, :url, :thumb

  def url
    object.url()
  end

end
