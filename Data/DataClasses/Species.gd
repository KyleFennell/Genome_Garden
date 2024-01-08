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
	self.modules = data.get("modules", [])
	for interaction in data.get("interactions", []):
		self.interactions.append(Interaction.new(interaction))
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
	var phenotype_id = 0
	var phenotype_ids = {}
	for gene in instances_for_genes:
		var phenotype = GeneHelpers.get_phenotype(self, gene).get("modules", {})
		var hetero_count = GeneHelpers.get_heterozygous_count(gene)
		if not str(phenotype)+str(hetero_count) in phenotype_counts:
			phenotype_ids[str(phenotype)+str(hetero_count)] = phenotype_id
			phenotype_id += 1
			phenotype_counts[str(phenotype)+str(hetero_count)] = 0
		else:
			phenotype_counts[str(phenotype)+str(hetero_count)] += 1
		var raw_genotype = GeneHelpers.get_raw_genotype(self, gene)
		identifications[raw_genotype] = {
			"phenotype_id": phenotype_ids[str(phenotype)+str(hetero_count)],
			"genotype_id": phenotype_counts[str(phenotype)+str(hetero_count)]
		}
	print(identifications.keys().filter(func(k): return identifications[k]['phenotype_id'] == 10))
	print(identifications.keys().filter(func(k): return identifications[k]['phenotype_id'] == 11))
	print(identifications.keys().filter(func(k): return identifications[k]['phenotype_id'] == 12))
	print()
