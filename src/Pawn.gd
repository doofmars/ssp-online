extends KinematicBody2D
signal pawn_clicked

export (int) var speed = 800
onready var target = position
var velocity = Vector2()

var type = Constants.Types.Player
var item = Constants.Items.Empty
var item_status = Constants.ItemStatus.Hidden
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


func set_item(status, new_item):
	if type == Constants.Types.Player and item != Constants.Items.Empty:
		get_node("Body").get_node(item_to_str(item_status, item)).hide()
	if type == Constants.Types.Player:
		get_node("Body").get_node(item_to_str(status, new_item)).show()
	else: # Enemy
		if new_item == Constants.Items.Empty:
			# Empty the enemies item
			get_node("Body").get_node(item_to_str(item_status, item)).hide()
		elif status != Constants.ItemStatus.Hidden:
			# Show the enemies item if it is not hidden
			get_node("Body").get_node(item_to_str(status, new_item)).show()
	item = new_item
	item_status = status


func show_item():
	if item_status == Constants.ItemStatus.Hidden:
		get_node("Body").get_node(item_to_str(item_status, item)).hide()
		item_status == Constants.ItemStatus.Active
		get_node("Body").get_node(item_to_str(item_status, item)).show()


func item_to_str(status, item):
	return str(Constants.ItemStatus.keys()[status], Constants.Items.keys()[item])


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
				print(str("Clicked On Object ", name, " ", Constants.Types.keys()[type], " -> ", Constants.ItemStatus.keys()[item_status], Constants.Items.keys()[item]))
			emit_signal("pawn_clicked", self)

func _to_string():
	return str(name, " ", Constants.Types.keys()[type], " -> ", Constants.ItemStatus.keys()[item_status], Constants.Items.keys()[item])
