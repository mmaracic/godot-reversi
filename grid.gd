class_name Grid
extends Node3D

var Util = preload("util.gd")
	
var players:Array[Util.Player]
var playerIndex:int

@export var size:int = 8
@export var gridElement: PackedScene

signal move_done

var elementDictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(0, size):
		for z in range(0, size):
			var element:GridElement = gridElement.instantiate()
			element.setPosition(Vector3(x, 0, z))
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
	var children = get_children()
	for i in range(0, children.size()):
		var child:GridElement = children[i]
		child._setPuck(Util.Puck.None)

func getGridState() -> Array[Util.GridData]:
	var state:Array[Util.GridData] = []
	var children = get_children()
	for i in range(0, children.size()):
		var child:GridElement = children[i]
		if (child.getPuck() != Util.Puck.None):
			var childPosition:Vector3 = child.getPosition()
			var data = Util.GridData.new()
			data.position = Util.Position.new()
			data.position.row = roundi(childPosition.z)
			data.position.column = roundi(childPosition.x)
			data.puck = child.getPuck()
			state.append(data)
	return state

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
	
func _setPuckToElementIfTurnAndEmpty(element: GridElement, side: Util.PlayerSide, type: Util.PlayerType) -> bool:
	if (!players.is_empty()):
		var puckType:Util.Puck = Util.Puck.White if (side == Util.PlayerSide.White) else Util.Puck.Black
		var player:Util.Player = players[playerIndex]
		var result: bool = element.setPuckIfEmpty(puckType) if (player.side == side and player.type == type) else false
		var nextSide = _nextPlayer()
		move_done.emit(nextSide, getGridState())
		return result
	else:
		return false
	

func _nextPlayer() -> Util.PlayerSide:
	playerIndex+=1
	if (playerIndex >= players.size()):
		playerIndex = 0
	return players[playerIndex].side
