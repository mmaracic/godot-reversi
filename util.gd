class_name Util
extends Object

enum PlayerSide{White, Black}
enum PlayerType{Human, Automated}

class Player:
	var side: PlayerSide
	var type: PlayerType
	
	func _to_string() -> String:
		return "Player side: " + str(side) + " type: " + str(type)
	
	static func create(side: PlayerSide, type: PlayerType) -> Player:
		var player:Player = Player.new()
		player.side = side
		player.type = type
		return player

enum Puck {White, Black, None}

class Position:
	var row:int
	var column:int
	
	func getIndex(gridSize:int) -> int:
		return  row*gridSize+column

	func isValid(gridSize:int) -> bool:
		if (row >=0 and row<gridSize && column >=0 and column<gridSize):
			return true
		else:
			return false

	func clone() -> Position:
		return Position.create(self.row, self.column)
	
	func _to_string() -> String:
		return "Position Row: " + str(row) + " Column: " + str(column)
		
	func generate8NeighbourPositions() -> Array[Util.Position]:
		return [
			self.getNeighbourPosition(1, 1),
			self.getNeighbourPosition(1, -1),
			self.getNeighbourPosition(0, 1),
			self.getNeighbourPosition(0, -1),
			self.getNeighbourPosition(1, 0),
			self.getNeighbourPosition(-1, 1),
			self.getNeighbourPosition(-1, 0),
			self.getNeighbourPosition(-1, -1)
		]

	func getNeighbourPosition(rowChange:int, columnChange: int) -> Util.Position:
		var position = Util.Position.new()
		position.row = self.row + rowChange
		position.column = self.column + columnChange
		return position
		
	static func create(row:int, column:int) -> Position:
		var position = Util.Position.new()
		position.row = row
		position.column = column
		return position
		


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
		
	static func create(row:int, column:int, valid:bool) -> ReturnPosition:
		var returnPosition = ReturnPosition.new()
		returnPosition.position = Position.create(row, column)
		returnPosition.valid = valid
		return returnPosition

	static func fromPosition(position:Position, valid:bool) -> ReturnPosition:
		var returnPosition = ReturnPosition.new()
		returnPosition.position = position
		returnPosition.valid = valid
		return returnPosition
		
