extends Resource
class_name Species

var name: String = ""
var modules: Array = []
var genome: = {}
var interactions: Array[Interaction] = []
var identifications: Dictionary = {}
var discovered: Dictionary = {}

func _init(data: Dictionary):
	if not "name" in data:
		print("Error: couldn't find name of species in ", data)
	self.name = data.get("name")
	for gene in data.get("genome", []):
		self.genome[gene["name"]] = Gene.new(gene)
	_calculate_identifications()
	self.modules = data.get("modules", [])

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
		var phenotype = GeneHelpers.get_phenotype(self, gene)
		if not str(phenotype) in phenotype_counts:
			phenotype_counts[str(phenotype)] = 0
		else:
			phenotype_counts[str(phenotype)] += 1
		var raw_genotype = GeneHelpers.get_raw_genotype(gene)
		identifications[raw_genotype] = phenotype_counts[str(phenotype)]
