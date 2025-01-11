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
			elementDictionary[element.getPosition().getIndex(size)] = element


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
	
	
func _cloneAndFilterInvalidMoveOptionsDictionary(playerPuck:Util.Puck) -> Dictionary:
	var newDictionary:Dictionary = {}
	for key in moveOptionsDictionary.keys():
		var position:Util.Position = moveOptionsDictionary[key]
		var gridElement:GridElement = elementDictionary[position.getIndex(size)]
		var flippablePucks:int = _findFlippablePucks(gridElement, playerPuck)
		if (flippablePucks>0):
			newDictionary[key] = position.clone()
	return newDictionary

#This is how automated player sets puck	
func setElement(row: int, column: int, side: Util.PlayerSide) -> bool:
	var index = Util.Position.create(row, column).getIndex(size)
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
		var puckType:Util.Puck = Util.mapPlayerToPuck(side)
		var availableMoves:Dictionary = _cloneAndFilterInvalidMoveOptionsDictionary(puckType)
		if (!availableMoves.is_empty()):
			if (availableMoves.has(element.getPosition().getIndex(size))):
				var player:Util.Player = players[playerIndex]
				var playerCorrect:bool = player.side == side and player.type == type
				if (playerCorrect):
					var positionSet: bool = _setPuckToElementIfEmpty(element, puckType)
					print("Player ", side, " of type ", type, " setting position: ", element.getPosition(), " on thread ", OS.get_thread_caller_id(), " success: ", positionSet)
					if (positionSet):
						switchPlayer()
					return positionSet
				else:
					print("Player with side: ", side, " and type: ", type, " does not correspond to requested player: ", player)
					return false
			else:
				print("Player with side: ", side, " and type: ", type, " has played an invalid position ", element.getPosition())
				return false
		else:
			print("There are no valid moves for player with side: ", side, " and type: ", type, " to play")
			#switchPlayer()
			return false
	else:
		print("No players available")
		return false

#Common method to set puck for automated and manual players without the checks
func _setPuckToElementIfEmpty(element: GridElement, puckType:Util.Puck) -> bool:
	var result = element.setPuckIfEmpty(puckType)
	if (result):
			var flippedPucks:int = _flipPucks(element, puckType)
			#print("Flipped pucks: ", flippedPucks)
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

#Filp pucks that can be flipped in all directions
#Because starting element may be empty sthe assumed starting puck is provided
func _flipPucks(startGridElement:GridElement, startPuck:Util.Puck) -> int:
	var directions = Util.PositionDelta.generate8NeighbourPositions()
	var totalFlipped = 0
	for direction:Util.PositionDelta in directions:
		var flippedPucks:int=_flipPucksUntil(startGridElement, startPuck, direction)
		totalFlipped+=flippedPucks
	return totalFlipped

#Flip pucks that can be flipped in the desired direction
#Because starting element may be empty sthe assumed starting puck is provided	
func _flipPucksUntil(startGridElement:GridElement, startPuck:Util.Puck, delta:Util.PositionDelta) -> int:
	var distanceToUnflippablePuck:int = _findFlippablePucksUntil(startGridElement, startPuck, delta)
	if (distanceToUnflippablePuck > 0):
		var position = startGridElement.getPosition().getNeighbourPosition(delta)
		for i:int in range(1, distanceToUnflippablePuck):
			var gridElement:GridElement = elementDictionary[position.getIndex(size)]
			gridElement.flipPuck()
			position = position.getNeighbourPosition(delta)
		return distanceToUnflippablePuck-1
	else:
		return distanceToUnflippablePuck

#Find pucks that can be flipped in all directions
#Because starting element may be empty sthe assumed starting puck is provided
func _findFlippablePucks(startGridElement:GridElement, startPuck:Util.Puck) -> int:
	var directions = Util.PositionDelta.generate8NeighbourPositions()
	var totalFlippable = 0
	for direction:Util.PositionDelta in directions:
		var flippablePucks:int=_findFlippablePucksUntil(startGridElement, startPuck, direction)
		#print("From position ", startGridElement.getPosition(), " in direction ", direction, " number of flippable pucks is ", flippablePucks)
		#Flippable pucks includes end puck that belongs to current player
		totalFlippable+= flippablePucks-1 if (flippablePucks>0) else 0
	#print("From position ", startGridElement.getPosition(), " total flippable pucks is ", totalFlippable)
	return totalFlippable

#Find pucks that can be flipped in the desired direction, starting from current element that may be empty
#Because starting element may be empty sthe assumed starting puck is provided
#Count includes the position of last puck that shouldnt be flipped	
func _findFlippablePucksUntil(startGridElement:GridElement, startPuck:Util.Puck, delta:Util.PositionDelta) -> int:
	var nextPosition = startGridElement.getPosition().getNeighbourPosition(delta)
	var count:int = 1
	while(nextPosition.isValid(size)):
		var gridElement:GridElement = elementDictionary[nextPosition.getIndex(size)]
		var puck:Util.Puck = gridElement.getPuck()
		if (puck == Util.Puck.None):
			return 0
		elif (puck == startPuck):
			return 0 if (count <= 1) else count
		nextPosition = nextPosition.getNeighbourPosition(delta)
		count+=1
	return 0

func switchPlayer():
	var nextSide:Util.PlayerSide = _nextPlayer()
	var nextPuck:Util.Puck = Util.mapPlayerToPuck(nextSide)
	var availableMoves:Dictionary = _cloneAndFilterInvalidMoveOptionsDictionary(nextPuck)
	move_done.emit(nextSide, getGridState(), availableMoves)


func _nextPlayer() -> Util.PlayerSide:
	playerIndex=(playerIndex+1)%players.size()
	return players[playerIndex].side
