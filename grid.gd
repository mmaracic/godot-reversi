class_name Grid
extends Node3D

var Util = preload("util.gd")

var players:Array[Util.Player]
var playerIndex:int

@export var size:int = 8
@export var gridElement: PackedScene

signal move_done

var elementDictionary:Dictionary = {}
var moveOptionsDictionary:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(0, size):
		for z in range(0, size):
			var element:GridElement = gridElement.instantiate()
			element.set3DPosition(Vector3(x, 0, z))
			element.clicked.connect(setCurrentPuckToElement.bind(element))
			add_child(element)
			elementDictionary[_calculateIndex(z,x)] = element


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset(players:Array[Util.Player]) -> void:
	if (!players.is_empty()):
		self.players = players
		playerIndex = 0
	var children = elementDictionary.values()
	for i in range(0, children.size()):
		var child:GridElement = children[i]
		child._setPuck(Util.Puck.None)
	_setPuckToElementIfEmpty(elementDictionary[Util.Position.create(3,3).getIndex(size)], Util.Puck.White)
	_setPuckToElementIfEmpty(elementDictionary[Util.Position.create(4,4).getIndex(size)], Util.Puck.White)
	_setPuckToElementIfEmpty(elementDictionary[Util.Position.create(4,3).getIndex(size)], Util.Puck.Black)
	_setPuckToElementIfEmpty(elementDictionary[Util.Position.create(3,4).getIndex(size)], Util.Puck.Black)

func getGridState() -> Array[Util.GridData]:
	var state:Array[Util.GridData] = []
	var children = elementDictionary.values()
	for i in range(0, children.size()):
		var child:GridElement = children[i]
		if (child.getPuck() != Util.Puck.None):
			var data = Util.GridData.new()
			data.position = child.getPosition()
			data.puck = child.getPuck()
			state.append(data)
	return state
	
	
func cloneMoveOptionsDictionary() -> Dictionary:
	var newDictionary:Dictionary = {}
	for key in moveOptionsDictionary.keys():
		var position:Util.Position = moveOptionsDictionary[key]
		newDictionary[key] = position.clone()
	return newDictionary

func _calculateIndex(row: int, column: int) -> int:
	return row*size+column
	
#This is how automated player sets puck	
func setElement(row: int, column: int, side: Util.PlayerSide) -> bool:
	var index = _calculateIndex(row, column)
	var element: GridElement = elementDictionary.get(index)
	var result: bool = _setPuckToElementIfTurnAndEmpty(element, side, Util.PlayerType.Automated)
	return result

#This is how human player sets puck
func setCurrentPuckToElement(element: GridElement) -> bool:
	if (!players.is_empty()):
		var playerSide = players[playerIndex].side
		var result:bool = _setPuckToElementIfTurnAndEmpty(element, playerSide, Util.PlayerType.Human)
		return result
	else:
		return false

#Common method to set puck for automated and manual players
func _setPuckToElementIfTurnAndEmpty(element: GridElement, side: Util.PlayerSide, type: Util.PlayerType) -> bool:
	if (!players.is_empty()):
		var puckType:Util.Puck = Util.Puck.White if (side == Util.PlayerSide.White) else Util.Puck.Black
		var player:Util.Player = players[playerIndex]
		var playerCorrect:bool = player.side == side and player.type == type
		if (playerCorrect):
			var positionSet: bool = _setPuckToElementIfEmpty(element, puckType)
			print("Player ", side, " of type ", type, " setting position: ", element.getPosition(), " on thread ", OS.get_thread_caller_id(), " success: ", positionSet)
			#print("Open positions: ", moveOptionsDictionary)
			if (positionSet):
				switchPlayer()
			return positionSet
		else:
			print("Player with side: ", side, " and type: ", type, " does not correspond to requested player: ", player)
			return false
	else:
		return false

#Common method to set puck for automated and manual players without the checks
func _setPuckToElementIfEmpty(element: GridElement, puckType:Util.Puck) -> bool:
	var result = element.setPuckIfEmpty(puckType)
	if (result):
			_unregistePositionAsMoveOption(element)
			_registerValidNeighboursAsMoveOptions(element)
	return result

#Check 8-neighbourhood and register empty neighbours as options for next move 
func _registerValidNeighboursAsMoveOptions(element: GridElement) -> void:
	var neighbours:Array[Util.Position] = element.getPosition().generate8NeighbourPositions()
	for neighbour:Util.Position in neighbours:
		_registerPositionAsMoveOption(neighbour)
	
func _registerPositionAsMoveOption(position: Util.Position) -> void:
	if (position.isValid(size)):
		var index:int = position.getIndex(size)
		var element: GridElement = elementDictionary[index]
		if (element.isEmpty()):
			moveOptionsDictionary[index] = position

func _unregistePositionAsMoveOption(element: GridElement) -> void:
	var position: Util.Position = element.getPosition()
	if (position.isValid(size)):
		var index:int = position.getIndex(size)
		moveOptionsDictionary.erase(index)

func switchPlayer():
	var nextSide = _nextPlayer()
	move_done.emit(nextSide, getGridState())


func _nextPlayer() -> Util.PlayerSide:
	playerIndex=(playerIndex+1)%players.size()
	return players[playerIndex].side
