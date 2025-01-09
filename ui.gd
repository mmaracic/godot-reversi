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
	
func _setPlayer(side:Util.PlayerSide) -> void:
	var player:Label = get_node("Player") 
	player.text = "Player: " + str(side)



func _on_grid_move_done(nextSide:Util.PlayerSide, gridState:Array[Util.GridData]) -> void:
	_setPlayer(nextSide)
	print("UI next side", str(nextSide))

func _on_start_button_down() -> void:
	start_game.emit()
