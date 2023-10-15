extends KinematicBody2D
signal pawn_clicked

export (int) var speed = 800
onready var target = position
var velocity = Vector2()

var type = Constants.Types.Player
var item = Constants.Items.Empty
var posX = -1
var posY = -1

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
	else:
		if !("Hidden" in Constants.Items.keys()[state_enum]):
			get_node("Body").get_node(Constants.Items.keys()[state_enum]).show()
	item = state_enum


func _physics_process(delta):
	if position.distance_to(target) > 10:
		velocity = position.direction_to(target) * speed
	else:
		# Move slower if close
		velocity = position.direction_to(target) * speed / 5
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)


func _on_Pawn_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if OS.is_debug_build():
				print(str("Clicked On Object ", name, " ", Constants.Types.keys()[type], " -> ", Constants.Items.keys()[item]))
			emit_signal("pawn_clicked", self)
