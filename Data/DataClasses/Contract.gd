extends Resource
class_name Contract

var name: String = ""
var item_requirements: Array[GoalItem] = []
var dex_requirements: Array = []
var item_rewards: Array[Item] = []
var event_rewards: Array = []
var unlocked: bool = false
var is_complete: bool = false

signal contract_changed
signal contract_complete

func _init(contract: Dictionary):
	self.name = contract["name"]
	
	for requirement in contract.get("requirements"):
		match requirement["kind"]:
			"item": item_requirements.append(GoalItem.new(requirement))
			_: print("unknown requirement type: ", requirement["kind"], " in contract ", self.name)
			
	for reward in contract.get("rewards"):
		match reward["kind"]:
			"item": item_rewards.append(Item.new(reward))
			"contract": event_rewards.append(unlock_contract.bind(reward["name"]))
			_:print("unknown reward type: ", reward["kind"], " in contract ", self.name)

func unlock_contract(name):
	Database.Contracts[name].unlocked = true
	Database.Contracts[name].contract_changed.emit()

func complete():
	is_complete = true

func execute_reward_events():
	for event: Callable in event_rewards:
		event.call()
