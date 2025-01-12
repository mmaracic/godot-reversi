class_name Util
extends Object

enum PlayerSide{White, Black}
enum PlayerType{Human, Automated}

class Player:
	var side: PlayerSide
	var type: PlayerType
	
	func _init(side: PlayerSide, type: PlayerType) -> void:
		self.side = side
		self.type = type

	func _to_string() -> String:
		return "Player side: " + str(side) + " type: " + str(type)

enum Puck {White, Black, None}

static func mapPlayerToPuck(side: PlayerSide) -> Puck:
	return Puck.White if (side == PlayerSide.White) else Puck.Black

class PositionDelta:
	var deltaRow:int
	var deltaColumn:int

	func _to_string() -> String:
		return "Delta row: " + str(deltaRow) + " Delta column: " + str(deltaColumn)
		
	func _init(deltaRow:int, deltaColumn:int) -> void:
		self.deltaRow = deltaRow
		self.deltaColumn = deltaColumn
		
	static func generate8NeighbourPositions() -> Array[Util.PositionDelta]:	
		return [
			PositionDelta.new(1, 1),
			PositionDelta.new(1, -1),
			PositionDelta.new(0, 1),
			PositionDelta.new(0, -1),
			PositionDelta.new(1, 0),
			PositionDelta.new(-1, 1),
			PositionDelta.new(-1, 0),
			PositionDelta.new(-1, -1)
		]

class Position:
	var row:int
	var column:int
	
	func _init(row:int, column:int) -> void:
		self.row = row
		self.column = column
		
	func _to_string() -> String:
		return "Position Row: " + str(row) + " Column: " + str(column)
		
	func getIndex(gridSize:int) -> int:
		return  row*gridSize+column

	func isValid(gridSize:int) -> bool:
		if (row >=0 and row<gridSize && column >=0 and column<gridSize):
			return true
		else:
			return false

	func clone() -> Position:
		return Position.new(self.row, self.column)
	
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
		return Util.Position.new(self.row + delta.deltaRow, self.column + delta.deltaColumn)


class GridData:
	var position:Position
	var puck:Puck
	
	func _init(position:Position,  puck:Puck) -> void:
		self.position = position
		self.puck = puck
	
	func _to_string() -> String:
		return position._to_string() + " Puck: " + str(puck)
	
class ReturnPosition:
	var position:Position
	var valid:bool
	
	func _init(row:int, column:int, valid:bool) -> void:
		self.position = Position.new(row, column)
		self.valid = valid

	func _to_string() -> String:
		return position._to_string() + " Valid: " + str(valid)
		
	static func fromPosition(position:Position, valid:bool) -> ReturnPosition:
		return ReturnPosition.new(position.row, position.column, valid)		
