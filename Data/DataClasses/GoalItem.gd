extends Item
class_name GoalItem

const DEFAULT_TARGET_QUANITTY = 5
var properties = {}
var target_quantity

func _init(dict: Dictionary):
	super._init(dict)
	properties = dict.get("properties", {})
	target_quantity = dict.get("quantity", DEFAULT_TARGET_QUANITTY)

func equals(other) -> bool:
	if not other is Item:
		return false
	if self.genes:
		return GeneHelpers.genes_match(other.genes, self.genes)
	if self.properties:
		return GeneHelpers.get_phenotype(other.genes) == self.properties
	return false
