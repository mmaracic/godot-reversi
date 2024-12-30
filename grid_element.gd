extends Node3D

var targeted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func setPosition(position: Vector3) -> void:
	var marker = get_node("ElementMarker")
	marker.position = position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and targeted:
		var elementMarker: Marker3D = get_node("ElementMarker")
		print("Clicked position: ", elementMarker.position)

func _on_square_area_mouse_entered() -> void:
	targeted = true


func _on_square_area_mouse_exited() -> void:
	targeted = false
