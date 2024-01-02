extends PanelContainer

@onready var ProgressArrow = preload("res://UI/Common/ProgressArrow.tscn")
@onready var GoalSlot = preload("res://UI/Goals/GoalSlot.tscn")
@onready var ItemSlot = preload("res://UI/Common/ItemSlot.tscn")

var RequirementElements = []
var RewardElements = []
var contract: Contract

func set_contract(contract: Contract):
	self.contract = contract
	contract.contract_changed.connect(update_display)
	_add_item_requirement_children(contract.item_requirements)
	add_element(ProgressArrow.instantiate())
	_add_item_reward_children(contract.item_rewards)

func update_display():
	if self.contract.unlocked:
		self.show()
	else:
		self.hide()

func _add_item_requirement_children(item_requirements):
	for requirement in item_requirements:
		var req_slot = GoalSlot.instantiate()
		RequirementElements.append(req_slot)
		add_element(req_slot)
		req_slot.set_goal(requirement)
		req_slot.goal_complete.connect(_requirement_fulfilled)

func _add_item_reward_children(item_rewards):
	for reward in item_rewards:
		var req_slot = ItemSlot.instantiate()
		RewardElements.append(req_slot)
		add_element(req_slot)
		req_slot.set_item(reward)
		req_slot.dragable = false
		req_slot.dropable = false

func add_element(node: Node):
	get_child(0).add_child(node)

func _requirement_fulfilled():
	if RequirementElements.all(func(slot): return slot.complete):
		contract_complete()

func contract_complete():
	self.contract.complete()
	RewardElements.map(func(slot): slot.dragable = true)
	self.contract.execute_reward_events()
