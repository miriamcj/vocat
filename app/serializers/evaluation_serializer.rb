class EvaluationSerializer < ActiveModel::Serializer
  attributes  :id, :evaluator_id, :scores, :total_percentage

end
