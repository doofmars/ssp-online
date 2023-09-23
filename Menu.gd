extends CanvasLayer
signal start_singleplayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		start_single_player()
	if Input.is_action_pressed("action_quit"):
		get_tree().quit()


func _on_single_player_pressed():
	start_single_player()


func start_single_player():
	hide()
	emit_signal('start_singleplayer')

func _on_quit_pressed():
	get_tree().quit()


