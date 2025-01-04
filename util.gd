class_name Util
extends Object

enum PlayerSide{White, Black}
enum PlayerType{Human, Automated}

class Player:
	var side: PlayerSide
	var type: PlayerType

enum Puck {White, Black, None}

class Position:
	var row:int
	var column:int

class GridData:
	var position:Position
	var puck:Puck
	
class ReturnPosition extends Position:
	var valid:bool
	
