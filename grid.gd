extends Node3D

@export var gridSize:int = 8
@export var gridElement: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for x in range(-gridSize/2+1, gridSize/2):
		for z in range(-gridSize/2+1, gridSize/2):
			var gridElement = gridElement.instantiate()
			gridElement.setPosition(Vector3(x, 0, z))
			add_child(gridElement)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
