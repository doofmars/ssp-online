extends Node2D
signal move_spot_clicked

var mouse_over = false
var direction = Constants.Direction.Up
var pawn = null
var posX = -1
var posY = -1
var radius = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	# Draw a circle
	draw_circle(Vector2(0, 0), radius, Color(1, 1, 1))

func _on_control_gui_input(event):
	if event is InputEventMouseButton:
		if mouse_over and event.pressed:
			print(str("Clicked On MoveSpot ", name, " ", Constants.Direction.keys()[direction]))
			emit_signal("move_spot_clicked", self)


func _on_control_mouse_exited():
	mouse_over = false


func _on_control_mouse_entered():
	mouse_over = true
