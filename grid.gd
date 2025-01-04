class_name Grid
extends Node3D

var Util = preload("util.gd")
	
var currentPlayers:Array[Util.Player]
var currentPlayer:int

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
		currentPlayers = players
		currentPlayer = 0
	var children = get_children()
	for i in range(0, children.size()):
		var child:GridElement = children[i]
		child.setPuck(Util.Puck.None)

func _calculateIndex(row: int, column: int) -> int:
	return row*size+column
	
#This is how automated player sets puck	
func setElement(row: int, column: int, side: Util.PlayerSide) -> bool:
	var index = _calculateIndex(row, column)
	var element: GridElement = elementDictionary.get(index)
	var result: bool = _setPuckToElementIfTurnAndEmpty(element, side, Util.PlayerType.Automated)
	move_done.emit(side)
	return result

#This is how human player sets puck
func setCurrentPuckToElement(element: GridElement) -> bool:
	if (!currentPlayers.is_empty()):
		var playerSide = currentPlayers[currentPlayer].side
		var result:bool = _setPuckToElementIfTurnAndEmpty(element, playerSide, Util.PlayerType.Human)
		move_done.emit(playerSide)
		return result
	else:
		return false
	
func _setPuckToElementIfTurnAndEmpty(element: GridElement, side: Util.PlayerSide, type: Util.PlayerType) -> bool:
	if (!currentPlayers.is_empty()):
		var puckType:Util.Puck = Util.Puck.White if (side == Util.PlayerSide.White) else Util.Puck.Black
		var player:Util.Player = currentPlayers[currentPlayer]
		var result: bool = element.setPuckIfEmpty(puckType) if (player.side == side and player.type == type) else false
		_nextPlayer()
		return result
	else:
		return false
	

func _nextPlayer() -> void:
	currentPlayer+=1
	if (currentPlayer >= currentPlayers.size()):
		currentPlayer = 0
