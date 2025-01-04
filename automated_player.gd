class_name AutomatedPlayer
extends Object

var Util = preload("util.gd")

var gridData: Dictionary = {}

	
func updateGrid(updates: Array[Util.GridData]) -> void:
	for i in range(0, updates.size()):
		var update:Util.GridData = updates[i]
		gridData[update.position] = update.puck
	
func selectNextPosition(gridSize:int) -> Util.Position:
	var position = Util.Position.new()
	for row in range(0, gridSize):
		for column in range(0, gridSize):
			position.valid = true
			position.row = row
			position.column = column
			if (!gridData.has(position)):
				return position
	position.valid = false
	return position 
	
	
