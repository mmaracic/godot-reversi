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

static func mapPlayerToPuck(side: PlayerSide) -> Puck:
	return Puck.White if (side == PlayerSide.White) else Puck.Black

class PositionDelta:
	var deltaRow:int
	var deltaColumn:int

	func _to_string() -> String:
		return "Delta row: " + str(deltaRow) + " Delta column: " + str(deltaColumn)
		
	static func create(deltaRow:int, deltaColumn:int) -> PositionDelta:
		var delta = Util.PositionDelta.new()
		delta.deltaRow = deltaRow
		delta.deltaColumn = deltaColumn
		return delta
		
	static func generate8NeighbourPositions() -> Array[Util.PositionDelta]:	
		return [
			PositionDelta.create(1, 1),
			PositionDelta.create(1, -1),
			PositionDelta.create(0, 1),
			PositionDelta.create(0, -1),
			PositionDelta.create(1, 0),
			PositionDelta.create(-1, 1),
			PositionDelta.create(-1, 0),
			PositionDelta.create(-1, -1)
		]

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
		
	func equals(obj) -> bool:
		if (!is_instance_of(obj, Position)):
			return false
		else:
			return self.row == obj.row and self.column == obj.column
	
		
	func generate8NeighbourPositions() -> Array[Util.Position]:
		var deltas = PositionDelta.generate8NeighbourPositions()
		return [
			self.getNeighbourPosition(deltas[0]),
			self.getNeighbourPosition(deltas[1]),
			self.getNeighbourPosition(deltas[2]),
			self.getNeighbourPosition(deltas[3]),
			self.getNeighbourPosition(deltas[4]),
			self.getNeighbourPosition(deltas[5]),
			self.getNeighbourPosition(deltas[6]),
			self.getNeighbourPosition(deltas[7])
		]

	func getNeighbourPosition(delta:PositionDelta) -> Util.Position:
		var position = Util.Position.new()
		position.row = self.row + delta.deltaRow
		position.column = self.column + delta.deltaColumn
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
		
