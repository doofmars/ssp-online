extends Node2D
signal pawn_clicked

var MouseOver = false
var Item = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func hide_all():
	var body = get_node("Body")
	for node in body.get_children():
		node.hide()


func show_item(state):
	get_node("Body").get_node(state).show()
	Item = state


func _on_control_gui_input(event):
	if event is InputEventMouseButton:
		if MouseOver and event.pressed:
			print(str("Clicked On Object ", name))
			emit_signal("pawn_clicked", self)


func _on_control_mouse_exited():
	MouseOver = false


func _on_control_mouse_entered():
	MouseOver = true
