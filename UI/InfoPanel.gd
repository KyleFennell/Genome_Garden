extends MarginContainer

enum {SPECIES_INFO, GENE_INFO, PHENOTYPE_GRID, GENOTYPE_GRID}
	

@onready var BackButton = %BackButton
@onready var CloseButton = %CloseButton
@onready var SpeciesList = %SpeciesList
@onready var InfoTabs = %InfoTabs
@onready var GenesListContainer = %GenesListContainer
@onready var GenesList = %GenesList
@onready var InteractionsList = %InteractionsList
@onready var GeneInfoContainer = %GeneInfoContainer
@onready var GeneInfoBackButton = %GeneInfoBackButton
@onready var GeneLabel = %GeneLabel
@onready var AllelesList = %AllelesList
@onready var PhenotypesList = %PhenotypesList
@onready var DexPanel = %Dex
@onready var PhenotypesGrid = %PhenotypesGrid
@onready var GenotypesGrid = %GenotypesGrid

const ProgressLabel = preload("res://UI/ProgressLabel.tscn")
const ProgressItem = preload("res://UI/ProgressItem.tscn")
const ProgressIcon = preload("res://UI/ProgressIcon.tscn")
const Identifications = preload("res://Resources/Identification.tres")

var state: int = SPECIES_INFO

func _ready():
	BackButton.connect("button_up", on_back_button)
	CloseButton.connect("button_up", self.hide)
	populate_species_list(Database.Speciess)

func populate_species_list(speciess: Dictionary):
	for species in Database.Speciess.values():
		var species_button = Button.new()
		species_button.text = species.name
		species_button.add_theme_font_size_override("", 8)
		species_button.button_down.connect(load_species_to_info_tab.bind(species))
		SpeciesList.add_child(species_button)

func load_species_to_info_tab(species: Species):
	clear_species_info()
	populate_genes_list(species.floradex_data.genome_data.genes)
	populate_interactions_list(species.floradex_data.genome_data.interactions)
	populate_phenotypes_pannel(species.floradex_data.phenotype_data, species)
	show_species_info()

func clear_species_info():
	for child in GenesList.get_children():
		child.queue_free()
	for child in InteractionsList.get_children():
		child.queue_free()

func populate_genes_list(genome: Array[FloradexSpecies._GenomeData._GeneEntry]):
	for gene in genome:
		create_gene_progressbar(gene)

func create_gene_progressbar(gene: FloradexSpecies._GenomeData._GeneEntry):
	var pbar = ProgressLabel.instantiate()
	GenesList.add_child(pbar)
	pbar.set_label(gene.name)
	pbar.set_progress(gene.get_progress())
	pbar.connect("clicked", populate_gene_info.bind(gene))

func populate_gene_info(gene: FloradexSpecies._GenomeData._GeneEntry):
	clear_gene_info()
	populate_alleles_list(gene.alleles)
	populate_phenotypes_list(gene.phenotypes)
	show_gene_info()

func clear_gene_info():
	for child in AllelesList.get_children():
		child.queue_free()
	for child in PhenotypesList.get_children():
		child.queue_free()

func populate_alleles_list(alleles: Array[FloradexSpecies._GenomeData._GeneEntry._AlleleEntry]):
	for allele in alleles:
		var pbar = ProgressLabel.instantiate()
		AllelesList.add_child(pbar)
		pbar.set_label(allele.name)
		pbar.set_progress(allele.get_progress())

func populate_phenotypes_list(phenotypes: Array[FloradexSpecies._GenomeData._GeneEntry._PhenotypeEntry]):
	for phenotype in phenotypes:
		var pbar = ProgressLabel.instantiate()
		PhenotypesList.add_child(pbar)
		pbar.set_label(phenotype.name)
		pbar.set_progress(phenotype.get_progress())
	
func populate_interactions_list(interactions: Array[FloradexSpecies._GenomeData._InteractionEntry]):
	for interaction in interactions:
		var pbar = ProgressLabel.instantiate()
		InteractionsList.add_child(pbar)
		pbar.set_label(interaction.name)
		pbar.set_progress(interaction.get_progress())

func populate_phenotypes_pannel(phenotype_data: FloradexSpecies._PhenotypeData, species: Species):
	for child in PhenotypesGrid.get_children():
		child.queue_free()
		
	var total_identified_phenotypes = 0
	for phenotype in phenotype_data.phenotypes:
		var prog_item = ProgressItem.instantiate()
		PhenotypesGrid.add_child(prog_item)
		prog_item.set_progress(phenotype.get_progress())
		prog_item.set_item(Item.new({ 
			"genes": phenotype.display_gene,
			"species": species.name
		}))
		prog_item.connect("clicked", populate_dex_genotypes.bind(phenotype.genotypes, species))
	show_phenotypes_grid()

func populate_dex_genotypes(genotypes: Array[FloradexSpecies._PhenotypeData._PhenotypeEntry._GenotypeEntry], species: Species):
	for child in GenotypesGrid.get_children():
		child.queue_free()
	for genotype in genotypes:
		var tex = ProgressIcon.instantiate()
		GenotypesGrid.add_child(tex)
		if not genotype.identified:
			tex.set_icon(load("res://Resources/Coloured_Shapes/black_star.png"))
		else:
			tex.set_icon(Identifications.duplicate())
			var id = species.identifications[genotype.raw_genotype]["phen_het_id"]
			var purity = GeneHelpers.get_heterozygous_count_raw(genotype.raw_genotype)
			var sub_tex = id+(min(purity,5)*3*16)
			tex.get_icon().texture.set_colour(sub_tex)
			tex.set_progress(genotype.get_progress())
	show_genotypes_grid()

func on_back_button():
	match state:
		GENE_INFO:
			show_species_info()
			state = SPECIES_INFO
		GENOTYPE_GRID:
			show_phenotypes_grid()
		_:
			self.hide()
			
func show_species_info():
	GeneInfoContainer.hide()
	GenesListContainer.show()
	state = SPECIES_INFO

func show_gene_info():
	GenesListContainer.hide()
	GeneInfoContainer.show()
	state = GENE_INFO
	BackButton.show()

func show_phenotypes_grid():
	GenotypesGrid.hide()
	PhenotypesGrid.show()
	state = PHENOTYPE_GRID
	
func show_genotypes_grid():
	PhenotypesGrid.hide()
	GenotypesGrid.show()
	state = GENOTYPE_GRID
	BackButton.show()
