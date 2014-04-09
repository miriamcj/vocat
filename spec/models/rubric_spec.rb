require 'spec_helper'

describe 'Rubric' do

  it 'has a valid factory' do
    FactoryGirl.build(:rubric).should be_valid
  end

  it 'is invalid without a name' do
    FactoryGirl.build(:rubric, 'name' => nil).should_not be_valid
  end

  it 'allows a range to be added' do
    rubric = FactoryGirl.build(:rubric)
    rubric.add_range({'name' => 'Low', 'low' => 1, 'high' => 2})
  end

  it 'allows a field to be added' do
    rubric = FactoryGirl.build(:rubric)
	    rubric.add_field({'name' => 'Voice', 'description' => 'Breathing; Centering; Projection'})
  end

  it 'allows a cell to be added' do
    r = FactoryGirl.build(:rubric)
    field_key = r.add_field({'name' => 'Voice', 'description' => 'Breathing; Centering; Projection'})
    range_key = r.add_range({'name' => 'Low', 'low' => 1, 'high' => 2})
    cell_options = {'range' => range_key, 'field' => field_key, 'description' => 'Vocal projection is weak. Posture is crumpled or slouched: breath is unsupported. Volume is unamplified. One has to strain, or cannot hear speaker. Articulation is mushy and difficult to understand.'}
    r.add_cell(cell_options)
    cell = r.get_cell(field_key, range_key)
    cell.should include cell_options
  end

  it 'allows multiple cells to be added at once' do
    r = FactoryGirl.build(:rubric)
    voice_key = r.add_field({'name' => 'Voice', 'description' => 'Breathing; Centering; Projection'})
    body_key = r.add_field({'name' => 'Body', 'description' => 'Relaxation; Physical tension; Eye-contact; Non-verbal communication'})
    expression_key = r.add_field({'name' => 'Expression', 'description' => 'Concentration; Focus; Point of View; Pacing'})
    overall_key = r.add_field({'name' => 'Overall Effect', 'description' => 'Integration of above categories; connection with audience'})
    low_key = r.add_range({'name' => 'Low', 'low' => 0, 'high' => 2})
    medium_key = r.add_range({'name' => 'medium', 'low' => 3, 'high' => 4})
    high_key = r.add_range({'name' => 'high', 'low' => 5, 'high' => 6})
    cells = [
          {'range' => low_key, 'field' => voice_key, 'description' => 'Vocal projection is weak. Posture is crumpled or slouched: breath is unsupported. Volume is unamplified. One has to strain, or cannot hear speaker. Articulation is mushy and difficult to understand.'},
          {'range' => low_key, 'field' => body_key, 'description' => 'Body is rigidly tense, or nervous tension in constant movement, shuffling, or fidgeting. Speaker avoids eye contact and physically "hides" from audience. Gestures and non-verbal communication are excessive or restricted and unrelated to narrative.'},
          {'range' => medium_key, 'field' => expression_key, 'description' => 'Concentration is disrupted. Speaker is distracted at times and loses focus, causing momentary hesitation. There are digressions from purpose. There is occasionally loss of emotional/intellectual connection to the narrative. Speaker rushes, or is monotone.'},
          {'range' => medium_key, 'field' => overall_key, 'description' => 'Speaker engages audience with varied success. Interest in the presentation ebbs and flows. Ideas are relatively clear, but lack overall coherence. Communication is effective, but neither dynamic nor very memorable.'},
          {'range' => high_key, 'field' => expression_key, 'description' => 'Concentration is sustained throughout. The speaker is focused and clear about what he/she wants to say. There is a point of view and speaker appears to have an emotional/intellectual connection to their narrative.'},
          {'range' => high_key, 'field' => overall_key, 'description' => 'Speaker engages audience and is compelling to watch and listen to. Ideas are clear, concise, and communicated in a creative, memorable way.'},
    ]
    r.add_cells(cells)
    cells.each do |cell|
      rubric_cell = r.get_cell(cell['field'], cell['range'])
      rubric_cell.should include cell
    end
  end

end
