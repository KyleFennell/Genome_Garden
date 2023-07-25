extends PanelContainer

@onready var Input1 = %Input1
@onready var Input2 = %Input2
@onready var Output = %Output

func set_hidden_combination(combo: HiddenCombination):
	Input1.set_item(combo.parent1)
	Input2.set_item(combo.parent2)
	Output.set_item(combo.child)
