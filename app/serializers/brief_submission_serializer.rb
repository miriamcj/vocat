class BriefSubmissionSerializer < ActiveModel::Serializer
  attributes  :id, :thumb, :creator_id, :project_id, :instructor_score_percentage, :published, :has_video?,
              :scored_by_instructor?

end
