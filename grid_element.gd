class_name GridElement
extends Node3D

var Util = preload("util.gd")

signal clicked

var targeted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setPuck(Util.Puck.None)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set3DPosition(newPosition: Vector3) -> void:
	var marker:Marker3D = get_node("ElementMarker")
	marker.position = newPosition
	
func get3DPosition() -> Vector3:
	var marker:Marker3D = get_node("ElementMarker")
	return Vector3(marker.position)


func getPosition() -> Util.Position:
	var vectorPosition:Vector3 = get3DPosition()
	return Util.Position.create(roundi(vectorPosition.z), roundi(vectorPosition.x))
	
	
func _setPuck(type: Util.Puck) -> void:
	var whitePuck:Node3D = get_node("ElementMarker/WhitePuck")
	var blackPuck:Node3D = get_node("ElementMarker/BlackPuck")
	match type:
		Util.Puck.White:
			whitePuck.visible = true
			blackPuck.visible = false
		Util.Puck.Black:
			whitePuck.visible = false
			blackPuck.visible = true
		Util.Puck.None:
			whitePuck.visible = false
			blackPuck.visible = false

func getPuck() -> Util.Puck:
	var whitePuck:Node3D = get_node("ElementMarker/WhitePuck")
	var blackPuck:Node3D = get_node("ElementMarker/BlackPuck")
	if (whitePuck.visible):
		return Util.Puck.White
	elif (blackPuck.visible):
		return Util.Puck.Black
	else:
		return Util.Puck.None

func flipPuck() -> bool:
	var type: Util.Puck = self.getPuck()
	match type:
		Util.Puck.White:
			self._setPuck(Util.Puck.Black)
			return true
		Util.Puck.Black:
			self._setPuck(Util.Puck.White)
			return true
	return false

func setPuckIfEmpty(puck: Util.Puck) -> bool:
	if (isEmpty()):
		_setPuck(puck)
		return true
	else:
		return false
		
func isEmpty() -> bool:
	return getPuck() == Util.Puck.None 
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and targeted:
		clicked.emit()

func _on_square_area_mouse_entered() -> void:
	targeted = true


func _on_square_area_mouse_exited() -> void:
	targeted = false
