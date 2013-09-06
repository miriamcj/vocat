class ScoreSerializer < ActiveModel::Serializer

  attributes

  def attributes
    hash = super
    hash['creator_type'] = object.submission.creator_type
    object.scores.each {| key, value | hash[key] = value}
    hash
  end



end
