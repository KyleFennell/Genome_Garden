extends Resource
class_name Level

var name: String = ""
var genome: Dictionary = {}
var starting_inventory: Array[Item] = []
var goal: Array[GoalItem] = []
var identifications: Dictionary = {}
var hidden_combinations: Array[HiddenCombination] = []
var hidden_alleles: Dictionary = {}

func _init(data: Dictionary):
	name = data["name"]
	for gene in data["genome"]:
		genome[gene] = Database.Genes[gene]
	for item in data["starting_inventory"]:
		starting_inventory.append(Item.new(item, false, true))
	for goal_item in data["goal"]:
		goal.append(GoalItem.new(goal_item))
	for combo in data.get("hidden_combinations", []):
		hidden_combinations.append(
			HiddenCombination.new({
				"parent1": Item.new(combo["parent1"]),
				"parent2": Item.new(combo["parent2"]),
				"child": Item.new(combo["child"]),
				"chance": combo["chance"]
			})
		)
	hidden_alleles = data.get("hidden_alleles", {})
	_calculate_identifications()

func _calculate_identifications() -> void:
	var instances_for_genes = [{}]
	for gene in genome:
		var new_instances_for_genes = []
		for i in instances_for_genes.size():
			for combination in genome[gene].combinations:
				var instance = instances_for_genes[i].duplicate(true)
				instance[gene] = combination
				new_instances_for_genes.append(instance)
		instances_for_genes = new_instances_for_genes
	
	var phenotype_counts = {}
	for gene in instances_for_genes:
		var phenotype = GeneHelpers.get_phenotype(gene)
		if not str(phenotype) in phenotype_counts:
			phenotype_counts[str(phenotype)] = 0
		else:
			phenotype_counts[str(phenotype)] += 1
		var raw_genotype = GeneHelpers.get_raw_genotype(gene)
		identifications[raw_genotype] = phenotype_counts[str(phenotype)]
#	print("IDENTIFICATIONS: ", name, " ", identifications)
