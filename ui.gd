extends Control

var Util = preload("util.gd")

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_grid_move_done(nextSide:Util.PlayerSide, gridState:Array[Util.GridData]) -> void:
	var player:Label = get_node("Player") 
	player.text = "Player: " + str(nextSide)


func _on_start_button_down() -> void:
	start_game.emit()
