extends Node3D

enum Puck {White, Black, None}

var targeted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setPuck(Puck.White)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func setPosition(position: Vector3) -> void:
	var marker = get_node("ElementMarker")
	marker.position = position
	
func setPuck(type: Puck) -> void:
	var whitePuck = get_node("ElementMarker/WhitePuck")
	var blackPuck = get_node("ElementMarker/BlackPuck")
	match type:
		Puck.White:
			whitePuck.visible = true
			blackPuck.visible = false
		Puck.Black:
			whitePuck.visible = false
			blackPuck.visible = true
		Puck.None:
			whitePuck.visible = false
			blackPuck.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and targeted:
		var elementMarker: Marker3D = get_node("ElementMarker")
		print("Clicked position: ", elementMarker.position)

func _on_square_area_mouse_entered() -> void:
	targeted = true


func _on_square_area_mouse_exited() -> void:
	targeted = false
