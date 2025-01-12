class_name AutomatedPlayer
extends Object

var Util = preload("util.gd")
var dummyPosition = Util.ReturnPosition.new(0,0, false)

var side: Util.PlayerSide

var gridData: Dictionary = {}

func _init(side: Util.PlayerSide) -> void:
	self.side = side

	
func updateGrid(gridSize:int, state: Array[Util.GridData]) -> void:
	gridData.clear()
	#print("Grid state")
	for i in range(0, state.size()):
		var item:Util.GridData = state[i]
		#print(item)
		gridData[item.position.getIndex(gridSize)] = item.puck
	
func selectNextPosition(validPositions:Dictionary, gridSize:int) -> Util.ReturnPosition:
	if (validPositions.size()):
		var validPositionIndex:int = randi() % validPositions.size()
		var positionIndex:int = validPositions.keys()[validPositionIndex]
		return Util.ReturnPosition.fromPosition(validPositions[positionIndex], true)
	else:
		return dummyPosition
		
