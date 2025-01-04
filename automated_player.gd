class_name AutomatedPlayer
extends Object

var Util = preload("util.gd")

var gridData: Dictionary = {}

	
func updateGrid(gridSize:int, state: Array[Util.GridData]) -> void:
	gridData.clear()
	#print("Grid state")
	for i in range(0, state.size()):
		var item:Util.GridData = state[i]
		#print(item)
		gridData[item.position.getIndex(gridSize)] = item.puck
	
func selectNextPosition(gridSize:int) -> Util.ReturnPosition:
	var element = Util.ReturnPosition.new()
	element.position = Util.Position.new()
	for row in range(0, gridSize):
		for column in range(0, gridSize):
			element.valid = true
			element.position.row = row
			element.position.column = column
			if (!gridData.has(element.position.getIndex(gridSize))):
				return element
	element.valid = false
	return element 
	
	
