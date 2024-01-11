extends Resource
class_name FloradexSpecies

var species: Species
var phenotype_data: _PhenotypeData
var genome_data: _GenomeData

func _init(species: Species, floradex_data: Dictionary):
	self.species = species
	self.phenotype_data = _PhenotypeData.new(floradex_data, species)
	self.genome_data = _GenomeData.new(species)

class _PhenotypeData:
	var phenotypes: Array[_PhenotypeEntry]

	func _init(data: Dictionary, species: Species):
		for phenotype in data:
			phenotypes.append(_PhenotypeEntry.new(data[phenotype], species))
			
	class _PhenotypeEntry:
		var display_gene: Dictionary
		var species: Species
		var genotypes: Array[_GenotypeEntry] = []
		
		func _init(phenotype: Dictionary, species: Species):
			display_gene = phenotype.get("display_genes")
			self.species = species
			for genotype in phenotype.get("genotypes"):
				genotypes.append(_GenotypeEntry.new(genotype, species))

		func get_progress() -> float:
			var progress_sum = 0
			for genotype in genotypes:
				progress_sum += genotype.get_progress()
			print(progress_sum, " ", genotypes.size(), " ", progress_sum/genotypes.size())
			return progress_sum/genotypes.size()
		
		class _GenotypeEntry:
			var raw_genotype: String
			var species: Species
			var identifications: int = 0
			var identified: bool = false
			
			func _init(genotype: String, species: Species):
				self.raw_genotype = genotype
				self.species = species

			func get_progress() -> float:
				return 100*identifications/species.id_difficulty.genotype
		
class _GenomeData:
	var genes: Array[_GeneEntry]
	var interactions: Array[_InteractionEntry]
	
	func _init(species: Species):
		for gene in species.genome.values():
			self.genes.append(_GeneEntry.new(gene, species))
		for interaction in species.interactions:
			interactions.append(_InteractionEntry.new(interaction, species))

	class _GeneEntry:
		var name: String
		var species: Species
		var alleles: Array[_AlleleEntry]
		var phenotypes: Array[_PhenotypeEntry]
		var identifications: int = 0
		
		func _init(gene: Gene, species: Species):
			self.name = gene.name
			self.species = species
			for allele in gene.alleles:
				alleles.append(_AlleleEntry.new(allele, species))
			for phenotype in gene.phenotypes:
				phenotypes.append(_PhenotypeEntry.new(phenotype, gene.phenotypes[phenotype], species))
	
		func get_progress() -> float:
			var progress_sum = 0
			for p in phenotypes:
				progress_sum += p.get_progress()
			for a in alleles:
				progress_sum += a.get_progress()
			return progress_sum/(phenotypes.size()+alleles.size())

		class _AlleleEntry:
			var name: String
			var species: Species
			var identifications: int = 0
			
			func _init(name: String, species: Species):
				self.name = name
				self.species = species
			
			func get_progress() -> float:
				return 100*identifications/species.id_difficulty.allele

		
		class _PhenotypeEntry:
			var name: String
			var interactions: Array[String]
			var identifications: int = 0
			var species: Species
		
			func _init(name: String, data: Dictionary, species: Species):
				self.name = name
				self.species = species
				interactions.assign(data.get("interactions", []))
		
			func get_progress() -> float:
				return 100*identifications/species.id_difficulty.phenotype

	class _InteractionEntry:
		var name: String
		var species: Species
		var requiremenets: Array[String]
		var identifications: int = 0
		
		func _init(interaction: Interaction, species: Species):
			#name = interaction.name
			self.species = species
			requiremenets = interaction.requirements
		
		func get_progress() -> float:
			# todo
			return 0
