class Vocat.Models.Submission extends Backbone.RelationalModel
	relations: [
		type: Backbone.HasOne,
		key: 'exhibit',
		relatedModel: 'Vocat.Models.Exhibit',
		collectionType: 'Vocat.Collections.Exhibit',
	]
