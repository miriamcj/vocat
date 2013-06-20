class BriefSubmissionSerializer < ActiveModel::Serializer
  attributes  :id, :thumb, :creator_id, :project_id, :instructor_score_percentage, :published, :has_uploaded_attachment,
              :scored_by_instructor?

  def has_uploaded_attachment
    object.uploaded_attachment?()
  end

  def thumb
		object.thumb()
  end

  def url
    object.url()
  end

end
