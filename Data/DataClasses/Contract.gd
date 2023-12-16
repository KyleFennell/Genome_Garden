extends Resource
class_name Contract

var requirements: Array[GoalItem] = []
var rewards: Array[Item] = []

func _init(contract: Dictionary):
	requirements = contract.get("requirements").each(GoalItem.new)
	rewards = contract.get("rewards").each(Item.new)
	
