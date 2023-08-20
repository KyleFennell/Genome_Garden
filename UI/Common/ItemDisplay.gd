extends Container

@onready var StartingItemTag = %StartingItemTag
@onready var MainTexture = %MainTexture
@onready var Identification = %Identification
@onready var InnerTexture = %InnerTexture
@onready var HiddenItem = %HiddenItem

var item = null

func _ready():
	MainTexture.texture = MainTexture.texture.duplicate()
	Identification.texture = Identification.texture.duplicate()
	InnerTexture.texture = InnerTexture.texture.duplicate()
	HiddenItem.get_child(0).texture = MainTexture.texture
	Events.allele_discovered.connect(update_item_display)
	
func update_item_display() -> void:
	# update the textures and tags based on self.item
	if self.item == null:
		hide()
		Identification.hide()
		StartingItemTag.hide()
		InnerTexture.hide()
	else:
		show()
		
		if GeneHelpers.is_hidden(item):
			HiddenItem.show()
			return
		HiddenItem.hide()
		
		var phenotypes = GeneHelpers.get_phenotype(item.genes)
		if item is GoalItem and item.properties:
			phenotypes = item.properties
		var colour = null
		if phenotypes.has("colour"):
			colour = phenotypes["colour"]["value"]
		MainTexture.texture.set_colour(colour if colour != null else 4)
			
		var inner_colour = null
		if phenotypes.has("colour_inner"):
			inner_colour = phenotypes["colour_inner"]["value"]
			if inner_colour != null:
				InnerTexture.show()
				InnerTexture.texture.set_colour(inner_colour if inner_colour != null else 4)
		
		if item.is_starting_item:
			StartingItemTag.show()
		
		if item.identified:
			var raw_genotype = GeneHelpers.get_raw_genotype(item.genes)
			var id = Database.Levels[Globals.current_level].identifications[raw_genotype]
			Identification.show()
			Identification.texture.set_colour(id)

func set_item(_item: Item) -> void:
	self.item = _item
	update_item_display()
