extends Resource
class_name Gene

var name: String
var alleles: Array[String]
var default: String
var phenotypes: Dictionary
var tags: Array[String]
var combinations: Array[String]

func _init(gene: Dictionary):
	name = gene.get("name")
	alleles.assign(gene.get("alleles"))
	default = gene.get("default", alleles[0]+alleles[0])
	phenotypes = gene.get("phenotypes")
	tags.assign(gene.get("tags", []))
	_generate_combinations()

func _generate_combinations():
	for i in alleles.size():
		for j in range(i, alleles.size()):
			var combination = alleles[i]+alleles[j]
			combination = GeneHelpers.sort_gene(combination, alleles)
			if not combination in combinations:
				combinations.append(combination)
