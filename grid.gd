extends Node3D

@export var gridSize:int = 8
@export var gridElement: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for x in range(0, gridSize):
		for z in range(0, gridSize):
			var element = gridElement.instantiate()
			element.setPosition(Vector3(x, 0, z))
			add_child(element)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
