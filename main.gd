extends Node3D

var AutomatedPlayer = preload("res://automated_player.gd")
var Util = preload("util.gd")

@export var grid: PackedScene

var players: Array[Util.Player] = []
var automatons:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var playerWhite:Util.Player = Util.Player.create(Util.PlayerSide.White, Util.PlayerType.Human)
	var playerBlack:Util.Player = Util.Player.create(Util.PlayerSide.Black, Util.PlayerType.Automated)
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
	var ui:UI = get_node("UI")
	ui.reset()


func _on_grid_move_done(nextSide:Util.PlayerSide, gridState:Array[Util.GridData], availableMoves:Dictionary) -> void:
	var grid: Grid = get_node("Grid")
	if (automatons.has(nextSide)):
		var player:AutomatedPlayer = automatons[nextSide]
		player.updateGrid(grid.size, gridState)
		if (!availableMoves.is_empty()):
			var position:Util.ReturnPosition = player.selectNextPosition(availableMoves, grid.size)
			if (position.valid and grid.moveOptionsDictionary.has(position.position.getIndex(grid.size))):
				grid.setElement(position.position.row, position.position.column, nextSide)
			else:
				print("Automated player has played an invalid position")
				grid.switchPlayer()
		else:
			print("There are no valid positions for the automated player to play")
			grid.switchPlayer()
	


func _on_ui_start_game() -> void:
	reset()
