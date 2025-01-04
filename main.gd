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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset() -> void:
	var grid: Grid = get_node("Grid")
	grid.reset(players)	


func _on_grid_move_done(side:Util.PlayerSide) -> void:
	var grid: Grid = get_node("Grid")
	var nextSide = Util.PlayerSide.White if (side == Util.PlayerSide.Black) else Util.PlayerSide.Black
	if (automatons.has(nextSide)):
		var player:AutomatedPlayer = automatons[nextSide]
		#player.updateGrid()
		var position = player.selectNextPosition(grid.size)
		grid.setElement(position.row, position.column, side)
	
