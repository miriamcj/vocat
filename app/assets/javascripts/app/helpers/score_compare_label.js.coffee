define 'app/helpers/score_compare_label', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper "score_compare_label", (value, options) ->
    switch value
      when 'my-scores' then 'My Scores'
      when 'instructor-scores' then 'Instructor Scores'
      when 'peer-scores' then 'Peer Scores'
      when 'self-scores' then 'Self Evaluation Scores'
      when 'rubric-scores' then 'Rubic Scores'
      else value
