extends Node2D
signal pawn_clicked

var type = Constants.Types.Player
var mouse_over = false
var item = Constants.Items.Empty

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


func set_item(state_enum):
	if type == Constants.Types.Player and item != Constants.Items.Empty:
		get_node("Body").get_node(Constants.Items.keys()[item]).hide()
	if type == Constants.Types.Player:
		get_node("Body").get_node(Constants.Items.keys()[state_enum]).show()
	item = state_enum


func _on_control_gui_input(event):
	if event is InputEventMouseButton:
		if mouse_over and event.pressed:
			print(str("Clicked On Object ", name, " ", Constants.Types.keys()[type], " -> ", Constants.Items.keys()[item]))
			emit_signal("pawn_clicked", self)


func _on_control_mouse_exited():
	mouse_over = false


func _on_control_mouse_entered():
	mouse_over = true
