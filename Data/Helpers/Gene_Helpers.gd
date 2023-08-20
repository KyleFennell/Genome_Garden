extends Node
class_name GeneHelpers

static func get_phenotype(genes):
	var matching_phenotypes = {}
#	print("genes: ", genes)
	# get phenotypes for genes
	for gene_id in genes:
		var sections = gene_id.split(":")
		var gene = sections[0]
		var phenotypes = Database.Genes[gene].phenotypes
		for phenotype in phenotypes:
			var matches_phenotype = true
			for i in genes[gene].length():
				if phenotype[i] == "*":
					continue
				elif phenotype[i] != genes[gene][i]:
					matches_phenotype = false
					break;
			if matches_phenotype:
				var tags = Database.Genes[gene].tags if Database.Genes[gene].tags != [] else ["no_tag"]
				for tag in tags:
					if not matching_phenotypes.has(tag):
						matching_phenotypes[tag] = {"interactions": {}}
					for property in phenotypes[phenotype]:
#						print(property, " ", phenotypes[phenotype])
						if property == "interactions":
							for interaction in phenotypes[phenotype][property]:
								for value in phenotypes[phenotype][property][interaction]:
									if matching_phenotypes[tag][property].has(interaction):
										matching_phenotypes[tag][property][interaction] += value["value"]
									else:
										matching_phenotypes[tag][property][interaction] = value["value"]
						else:
							matching_phenotypes[tag][property] = phenotypes[phenotype][property]
#	print("complete phenotype matches: ", matching_phenotypes)

	# Handel interactions
	var interactions = {}
	for tag in matching_phenotypes:
		for interaction_name in matching_phenotypes[tag]["interactions"]:
			var interaction_res = Database.Interactions[interaction_name]
			interactions[interaction_name] = interaction_res.get_properties(matching_phenotypes[tag]["interactions"][interaction_name])
#	print("interactions: ", interactions)
	
	# Handel supressions
	var supressing = true
	var supressed_tags = []
	while supressing:
		supressing = false
		for tag in matching_phenotypes:
			if matching_phenotypes[tag].has("supresses"):
				for supressed_tag in matching_phenotypes[tag]["supresses"]:
					if not matching_phenotypes.has(supressed_tag) or supressed_tag in supressed_tags:
						continue
					supressed_tags.append(supressed_tag)
#	print("spressions: ", supressed_tags)

	# Colapse tags
	var phenotype_properties = {}
	for tag in matching_phenotypes:
		if tag in supressed_tags:
			continue
		for property in matching_phenotypes[tag]:
			if ("@"+property) in supressed_tags:
				continue
			phenotype_properties[property] = matching_phenotypes[tag][property]
	for interaction in interactions:
		if ("$"+interaction) in supressed_tags:
			continue
		for property in interactions[interaction]:
			if ("@"+property) in supressed_tags:
				continue
			phenotype_properties[property] = interactions[interaction][property]
#	print("phenotype properties: ", phenotype_properties, "\n")
	phenotype_properties.erase("interactions")
	return phenotype_properties

static func generate_child(p1: Item, p2: Item)-> Item:
	#generates a random child from two parents mutations included
	var child = _generate_combo_child(p1, p2)
	return _generate_genetic_child(p1, p2) if child == null else child
	
static func _generate_genetic_child(p1: Item, p2: Item) -> Item:
	var child = {"genes": {}}
	for gene in p1.genes:
		var new_gene = p1.genes[gene][randi()%2] + p2.genes[gene][randi()%2]
		child["genes"][gene] = sort_gene(new_gene, Database.Genes[gene].alleles)
	return Item.new(child)

static func _generate_combo_child(p1: Item, p2: Item) -> Item:
	# attempts to generate a mutated child.
	# returns null if no mutation is generated
	var possible_combos = []
	var hidden_combinations = Database.Levels[Globals.current_level].hidden_combinations
	# get all the valid combos and their chances
	for combo in hidden_combinations:
		if combo.check_match(p1, p2):
			possible_combos.append(combo)
	# pick a random mutation from the list respecting their probabilities
	var remaining_chance = randf()
	for combo in possible_combos:
		remaining_chance -= combo.chance
		if remaining_chance <= 0:
			return _create_combo_child(combo)
	return null

static func _create_combo_child(combo: HiddenCombination) -> Item:
	if not combo.discovered:
		_discover_alleles_from_genes(combo.child.genes)
		Events.show_modal.emit({
			"heading": "Mutation Found",
			"message": "",
			"item": combo.child
		})
		Events.allele_discovered.emit()
	combo.discovered = true
	return combo.child.full_duplicate()

static func _discover_alleles_from_genes(genes: Dictionary) -> void:
	# iterates through all genes and if any of the alleles are hidden
	# it erases them from the hidden dictionary
	var hidden_alleles = Database.Levels[Globals.current_level].hidden_alleles
	for gene in genes:
		if hidden_alleles.has(gene):
			for allele in genes[gene]:
				hidden_alleles[gene].erase(allele)

class _ChildChancePair:
	# small private data class for readability
	var child: Item
	var chance: float
	func _init(_child: Item, _chance: float):
		self.child = _child
		self.chance = _chance

static func generate_children_with_percentages(p1: Item, p2: Item) -> Array[_ChildChancePair]:
	# generates all possible children for the 
	var combo_children = _get_combo_children(p1, p2)
	var remaining_chance = combo_children.reduce(func(accum, c: _ChildChancePair): return accum - c.chance, 1.0)
	var potential_genes = _generate_potential_genes(p1, p2)
	var children = _generate_children_from_genes(potential_genes)
	var children_items: Array[_ChildChancePair]
	children_items.assign(_convert_children(children).map(
		func(child): 
			child.chance *= remaining_chance
			return child
	))
	children_items.append_array(combo_children)
	return children_items

static func _get_combo_children(p1, p2) ->Array[_ChildChancePair]:
	var combo_children: Array[_ChildChancePair] = []
	for combo in Database.Levels[Globals.current_level].hidden_combinations:
		if combo.check_match(p1, p2):
			var child = combo.child.full_duplicate()
			combo_children.append(_ChildChancePair.new(child, combo.chance))
	return combo_children

static func _generate_potential_genes(p1: Item, p2:Item) -> Dictionary:
	# generate a list of all combinations for each gene 
	# e.g. parents: Xx Xx -> [XX, Xx, xx]
	var potential_genes = {}
	for gene in p1.genes:
		potential_genes[gene] = {}
		for i in [[0, 0], [0, 1], [1, 0], [1, 1]]:
			var new_gene_value = p1.genes[gene][i[0]] + p2.genes[gene][i[1]]
			new_gene_value = sort_gene(new_gene_value, Database.Genes[gene].alleles)
			if potential_genes[gene].has(new_gene_value):
				potential_genes[gene][new_gene_value] += 0.25
			else:
				potential_genes[gene][new_gene_value] = 0.25
	return potential_genes

static func _generate_children_from_genes(potential_genes: Dictionary) -> Array[Dictionary]:
	var children = [{"child": { "genes": {}}, "chance": 1}]
	for gene in potential_genes:
		var next_children: Array[Dictionary] = []
		for child in children:
			for value in potential_genes[gene]:
				var temp = child.duplicate(true)
				temp["child"]["genes"][gene] = value
				temp["chance"] *= potential_genes[gene][value]
				next_children.append(temp)
		children = next_children
	return children

static func _convert_children(children: Array[Dictionary]) -> Array[_ChildChancePair]:
	# convert children from dict to Items
	var children_items: Array[_ChildChancePair] = []
	for child in children:
		children_items.append(
			_ChildChancePair.new(
				Item.new(child["child"]), 
				child["chance"]
			)
		)
	return children_items

static func generate_phenotype_percents(children: Array[_ChildChancePair]) -> Dictionary:
	# aggregates all phenotypes from the list of genotypical children
	# and produces their percentages. It skips hidden children as their phenotype
	# isn't known to the player
	var phenotypes = {}
	for child in children:
		if is_hidden(child["child"]):
			continue
		var properties = get_phenotype(child["child"].genes)
		var phenotype = ""
		for property in properties:
			phenotype += str(properties[property])
		if not phenotype in phenotypes:
			phenotypes[phenotype] = {
				"item": child["child"],
				"chance": child["chance"]
			}
		else:
			phenotypes[phenotype]["chance"] += child["chance"]
	return phenotypes

static func is_hidden(child: Item) -> bool:
	# if any allele in the child is hidden return true
	var hidden_alleles = Database.Levels[Globals.current_level].hidden_alleles
	for gene in child.genes:
		if hidden_alleles.has(gene):
			for allele in child.genes[gene]:
				if allele in hidden_alleles[gene]:
					return true
	return false

static func sort_gene(gene: String, dominance: Array[String]) -> String:
	# sorts the gene based on the dominance hierarchy array
	var arr = []
	for i in gene.length():
		arr.append(gene[i])
	arr.sort_custom(_get_sorter_by_array(dominance))
	return "".join(arr)

static func _get_sorter_by_array(arr: Array) -> Callable:
	# returns a comparison function that sorts based on position in an array
	var f = func (a, b):
		return arr.find(a) < arr.find(b)
	return f

static func genes_match(g1: Dictionary, g2: Dictionary) -> bool:
	# checks equivelance accounting for wildcards
	for gene in g1:
		if not g2.has(gene):
			return false
		for i in g1[gene].length():
			if g1[gene][i] == "*":
				continue
			if g2[gene][i] == "*":
				continue
			if g1[gene][i] != g2[gene][i]:
				return false
	return true

static func get_raw_genotype(genes) -> String:
	# concatenates all alleles together creating a unique string for the genotype
	var raw_genotype = ""
	for gene in genes:
		raw_genotype += genes[gene]
	return raw_genotype
