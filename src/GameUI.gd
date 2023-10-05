extends CanvasLayer

signal reshuffle_pawns
signal approve_pawns

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Reshuffle_pressed():
	emit_signal("reshuffle_pawns")


func _on_Approve_pressed():
	emit_signal("approve_pawns")
