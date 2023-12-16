extends Resource
class_name Item

var genes = []
var identified = false
var is_starting_item = false
var is_hidden = false

func _init(dict, is_identified=false, starting_item=false):
	genes = dict.get("genes", [])
	identified = dict.get("identified", is_identified)
	self.is_starting_item = starting_item

func full_duplicate() -> Item:
	return Item.new({
			"genes": genes.duplicate(true)
		}, 
		identified, is_starting_item
	)

func equals(other: Item, idenfitied_relevant: bool=false) -> bool:
	if not other is Item:
		return false
	if idenfitied_relevant and other.identified != identified:
		return false
	return GeneHelpers.genes_match(self.genes, other.genes)
