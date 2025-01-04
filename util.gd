class_name Util
extends Object

enum PlayerSide{White, Black}
enum PlayerType{Human, Automated}

class Player:
	var side: PlayerSide
	var type: PlayerType

enum Puck {White, Black, None}

class Position:
	var row:int
	var column:int
	
	func getIndex(gridSize:int) -> int:
		return  row*gridSize+column

	func _to_string() -> String:
		return "Position Row: " + str(row) + " Column: " + str(column)

class GridData:
	var position:Position
	var puck:Puck
	
	func _to_string() -> String:
		return position._to_string() + " Puck: " + str(puck)
	
class ReturnPosition:
	var position:Position
	var valid:bool
	
	
	func _to_string() -> String:
		return position._to_string() + " Valid: " + str(valid)
