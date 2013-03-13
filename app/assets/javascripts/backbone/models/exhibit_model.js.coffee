class Vocat.Models.Exhibit extends Backbone.RelationalModel
	relations: [
		type: Backbone.HasOne,
		key: 'submission',
		relatedModel: 'Vocat.Models.Submission',
		collectionType: 'Vocat.Collections.Submission'
	]
