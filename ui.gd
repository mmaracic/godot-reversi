class_name UI
extends Control

var Util = preload("util.gd")

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset() -> void:
	_setPlayer(Util.PlayerSide.White)
	_setGameOver(false)
	_setCount(2,2)
	
func _setPlayer(side:Util.PlayerSide) -> void:
	var player:Label = get_node("Player") 
	player.text = "Player: " + str(side)

func _setGameOver(gameOver:bool) -> void:
	var gameStatus:Label = get_node("GameOver")
	gameStatus.visible = gameOver
	
func _setCount(white:int, black:int) -> void:
	var countLabel:Label = get_node("PuckCount")
	countLabel.text = "White: " + str(white) + " Black: " + str(black)
	
func _calculateCounts(gridState:Array[Util.GridData]) -> void:
	var white:int=0
	var black:int=0
	for state:Util.GridData in gridState:
		var puck:Util.Puck = state.puck
		match puck:
			Util.Puck.White:
				white+=1
			Util.Puck.Black:
				black+=1
	_setCount(white, black)

func _on_grid_move_done(nextSide:Util.PlayerSide, gridState:Array[Util.GridData], availableMoves:Dictionary) -> void:
	_setPlayer(nextSide)
	print("UI next side", str(nextSide))
	_calculateCounts(gridState)


func _on_start_button_down() -> void:
	start_game.emit()

func _on_grid_game_over() -> void:
	_setGameOver(true)
