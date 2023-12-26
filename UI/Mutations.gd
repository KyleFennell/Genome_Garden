extends VBoxContainer

@onready var SecretRow = preload("res://UI/Breeding_Row/Secret_Row.tscn")

func load_hidden_combinations(hidden_combinations):
	for combo in hidden_combinations:
		var row = SecretRow.instantiate()
		add_child(row)
		row.set_hidden_combination(combo)

func reset():
	for child in get_children():
		child.queue_free()
