extends Resource
class_name Species

var name: String = ""
var id_difficulty: IdDifficulty
var modules: Array = []
var genome: = {}
var interactions: Array[Interaction] = []
var identifications: Dictionary = {}
var floradex_data: FloradexSpecies
var enableGenotypeDex = true
var discovered: Dictionary = {}

class IdDifficulty:
	var genotype: int = 1
	var phenotype: int = 1
	var allele: int = 1
	
	func _init(data: Dictionary):
		genotype = data.get("genotype", genotype)
		phenotype = data.get("phenotype", phenotype)
		allele = data.get("allele", allele)

func _init(data: Dictionary):
	if not "name" in data:
		print("Error: couldn't find name of species in ", data)
	self.name = data.get("name")
	self.id_difficulty = IdDifficulty.new(data.get("id_difficulty", {}))
	for gene in data.get("genome", []):
		self.genome[gene["name"]] = Gene.new(gene)
	self.modules = data.get("modules", [])
	for interaction in data.get("interactions", []):
		self.interactions.append(Interaction.new(interaction))
	self.enableGenotypeDex = data.enableGenotypeDex
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
		print(instances_for_genes.size())
	
	var phenotype_counts = {}
	var phenotype_ids = {}
	var phenotype_hetero_counts = {}
	var phenotype_hetero_ids = {}
	var temp_floradex_data = {}
	for gene in instances_for_genes:
		var phenotype = GeneHelpers.get_phenotype(self, gene).get("modules", {})
		var hetero_count = GeneHelpers.get_heterozygous_count(gene)
		if not str(phenotype) in temp_floradex_data:
			phenotype_ids[str(phenotype)] = phenotype_ids.size()
			phenotype_counts[str(phenotype)] = 0
			temp_floradex_data[str(phenotype)] = {
				"display_genes": gene,
				"genotypes": []
			}
		else:
			phenotype_counts[str(phenotype)] += 1
		temp_floradex_data[str(phenotype)]["genotypes"].append(
			GeneHelpers.get_raw_genotype(self, gene)
		)
		var phen_het_id = str(phenotype)+str(hetero_count)
		if not phen_het_id in phenotype_hetero_counts:
			phenotype_hetero_counts[phen_het_id] = 0
		else:
			phenotype_hetero_counts[phen_het_id] += 1
		phenotype_hetero_ids[phen_het_id] = phenotype_hetero_counts[phen_het_id]
		var raw_genotype = GeneHelpers.get_raw_genotype(self, gene)
		identifications[raw_genotype] = {
			"phenotype_id": phenotype_ids[str(phenotype)],
			"phen_het_id": phenotype_hetero_ids[phen_het_id],
			"genotype_id": phenotype_counts[str(phenotype)]
		}
	floradex_data = FloradexSpecies.new(self, temp_floradex_data)
	print()
 
func identify(genes: Dictionary):
	var id = identifications[GeneHelpers.get_raw_genotype(self, genes)]
	var pheno_id = id["phenotype_id"]
	var geno_id = id["genotype_id"]
	
	# identify the genotype
	var dex_entry_genotype = floradex_data.phenotype_data.phenotypes[pheno_id].genotypes[geno_id]
	dex_entry_genotype.identifications += 1
	var identifications = dex_entry_genotype.identifications
	dex_entry_genotype.identified = true
	if identifications == id_difficulty.genotype:
		print("genotype sequenced! ", GeneHelpers.get_raw_genotype(self, genes))
	
	# identify the alleles & phenotype
	for dex_entry_gene in floradex_data.genome_data.genes:
		var phenotype = genes[dex_entry_gene.name]
		for dex_entry_phenotype in dex_entry_gene.phenotypes:
			if not GeneHelpers.alleles_match(phenotype, dex_entry_phenotype.name):
				continue
			dex_entry_phenotype.identifications += 1
			if dex_entry_phenotype.identifications == self.id_difficulty.phenotype:
				print("phenotype sequenced: ", dex_entry_phenotype.name)
			break
		for dex_entry_allele in dex_entry_gene.alleles:
			for allele in GeneHelpers.get_raw_genotype(self, genes):
				if allele != dex_entry_allele.name:
					continue
				dex_entry_allele.identifications += 1
				if dex_entry_allele.identifications == self.id_difficulty.allele:
					print("phenotype sequenced: ", dex_entry_allele.name)
				break
