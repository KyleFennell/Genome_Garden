extends VBoxContainer

@onready var ContractRow = preload("res://UI/Breeding_Row/Contract_Row.tscn")
var rowElements: Dictionary = {}

func load_contracts(contracts: Array[Contract]):
	for contract in contracts:
		var row = ContractRow.instantiate()
		add_child(row)
		rowElements[contract.name] = row
		row.set_contract(contract)
		if not contract.unlocked:
			hide_contract(contract.name)

func show_contract(name):
	rowElements[name].show()

func hide_contract(name):
	rowElements[name].hide()

