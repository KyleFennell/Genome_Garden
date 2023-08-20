extends Node
class_name ConditionParser

class Token:
	var token
	func _init(token):
		self.token = token

class NumberToken extends Token:
	pass
class VariableToken extends Token:
	pass
class StringToken extends Token:
	pass
class OperatorToken extends Token:
	pass
class OpenExpressionToken extends Token:
	pass
class CloseExpressionToken extends Token:
	pass
	
class ExpressionNode:
	pass

class ValueNode extends ExpressionNode:
	var value: Variant
	var type: String
	
	func _init(value: Variant, type: String):
		self.value = value
		self.type = type
	
	func get_value() -> Variant:
		return value

class VariableNode extends ValueNode: 
	var variable_name: String
	var context: Dictionary
	
	func _init(variable_name: String, context: Dictionary):
		self.variable_name = variable_name
		self.context = context
	
	func get_value():
		return context[variable]

class OperationNode extends ExpressionNode:
	var left: ValueNode
	var right: ValueNode
	var operation: Callable
	
	func coerce_types():
		if left.type == right.type:
			return [left, right]
		
	
	func _init(operation: Callable, left: ValueNode, right: ValueNode):
		self.operation = operation
		self.left = left
		self.right = right
	
	func evaluate():
		return operation(left.get_value(), right.get_value())

static func evaluate_condition(condition: str, context: Dictionary) -> bool:
	var tokens = _tokenize()

static func _tokenize(condition: String) -> Array[String]:
	var tokens = []
	var current_token = ""
	
	while condition.length() > 0:
		var char = condition[0]
		if char == " ":
			tokens.append(current_token)
			current_token = ""
			condition = condition.substr(1)
		elif char == "(":
			tokens.append(OpenExpressionToken.new(char))
			condition = condition.substr(1)
		elif char == "(":
			tokens.append(CloseExpressionToken.new(char))
			condition = condition.substr(1)
		elif char in "+-*/%":
			tokens.append(OperationToken.new(char))
			condition = condition.substr(1)
		elif char.match('[\\w]+'):
			while(char.match('[\\w]+')):
				char = condition[0]
				token += char
				condition = condition.substr(1)
			tokens.append(VariableToken.new(token))
			token = ""
		elif char.match('[\\d.]+'):
			while(char.match('[\\d.]+')):
				char = condition[0]
				token += char
				condition = condition.substr(1)
			tokens.append(NumberToken(token))
			token = ""
		elif char in "=><!":
			token += char
			if condition[1] == "=":
				token += "=" 
				tokens.append(OperatorToken.new(token))
				condition = condition.substr(1)
			condition = condition.substr(1)
			token = ""
		else:
			print("unknown token: ", token, " ", char)
			token = ""
			condition = condition.substr(1)
	
	return tokens

static func _evaluate_tokenized_statement(statement: Array[str], context: Dictionary) -> bool:
	for token in statement:
		
