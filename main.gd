extends Node3D

var AutomatedPlayer = preload("res://automated_player.gd")
var Util = preload("util.gd")

@export var grid: PackedScene

var players: Array[Util.Player] = []
var automatons:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var playerWhite:Util.Player = Util.Player.new()
	playerWhite.side = Util.PlayerSide.White
	playerWhite.type = Util.PlayerType.Human
	var playerBlack:Util.Player = Util.Player.new()
	playerBlack.side = Util.PlayerSide.Black
	playerBlack.type = Util.PlayerType.Automated
	players = [playerWhite, playerBlack]
	
	for player in players:
		if (player.type == Util.PlayerType.Automated):
			automatons[player.side] = AutomatedPlayer.new()
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset() -> void:
	var grid: Grid = get_node("Grid")
	grid.reset(players)	


func _on_grid_move_done(nextSide:Util.PlayerSide, gridState:Array[Util.GridData]) -> void:
	var grid: Grid = get_node("Grid")
	if (automatons.has(nextSide)):
		var player:AutomatedPlayer = automatons[nextSide]
		player.updateGrid(grid.size, gridState)
		var position:Util.ReturnPosition = player.selectNextPosition(grid.size)
		print("Automated player selected position: ", position)
		if (position.valid):
			grid.setElement(position.position.row, position.position.column, nextSide)
	


func _on_ui_start_game() -> void:
	reset()
