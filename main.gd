extends Node3D

var AutomatedPlayer = preload("res://automated_player.gd")
var Util = preload("util.gd")

@export var grid: PackedScene

var players: Array[Util.Player] = []
var automatons:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var playerWhite:Util.Player = Util.Player.new(Util.PlayerSide.White, Util.PlayerType.Human)
	var playerBlack:Util.Player = Util.Player.new(Util.PlayerSide.Black, Util.PlayerType.Automated)
	players = [playerWhite, playerBlack]
	
	for player in players:
		if (player.type == Util.PlayerType.Automated):
			automatons[player.side] = AutomatedPlayer.new(player.side)
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset() -> void:
	print("New game")
	var grid: Grid = get_node("Grid")
	grid.reset(players)	
	var ui:UI = get_node("UI")
	ui.reset()


func _on_grid_move_done(nextSide:Util.PlayerSide, gridState:Array[Util.GridData]) -> void:
	var ui:UI = get_node("UI")
	ui.processMove(nextSide, gridState)
	
	var grid: Grid = get_node("Grid")
	if (automatons.has(nextSide) and !grid.isGameOver()):
		var player:AutomatedPlayer = automatons[nextSide]
		grid.processAutomatedPlayer(player, gridState)


func _on_ui_start_game() -> void:
	reset()
