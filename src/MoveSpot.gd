extends Node2D
signal move_spot_clicked

var direction = Constants.Direction.Up
var pawn = null
var posX = -1
var posY = -1
var radius = 10
var color = Color(1, 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	# Draw a circle
	draw_circle(Vector2(0, 0), radius, color)


func _on_Node2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			print(str("Clicked On MoveSpot ", name, " ", Constants.Direction.keys()[direction]))
			emit_signal("move_spot_clicked", self)
