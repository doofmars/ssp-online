extends Node

var SQUARE_SIZE = 80
var SQUARE_COUNT_X = 7
var SQUARE_COUNT_Y = 6
var BOARD_POS_X = 100
var BOARD_POS_Y = (ProjectSettings.get_setting("display/window/size/viewport_height") - SQUARE_SIZE * SQUARE_COUNT_Y) / 2
var BORDER_COLOR = "c6d878"
var BORDER_WIDTH = 2
var SQUARE_COLOR_1 = "c6d878"
var SQUARE_COLOR_2 = "9fbb23"
var PAWN_ROWS = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	var border = ColorRect.new()
	border.size = Vector2(SQUARE_SIZE * SQUARE_COUNT_X + BORDER_WIDTH*2, SQUARE_SIZE * SQUARE_COUNT_Y + BORDER_WIDTH*2)
	border.position = Vector2(BOARD_POS_X - BORDER_WIDTH, BOARD_POS_Y - BORDER_WIDTH)
	print(ProjectSettings.get_setting("display/window/size/viewport_height"))
	border.color = BORDER_COLOR
	add_child(border)
	for x in SQUARE_COUNT_X:
		for y in SQUARE_COUNT_Y:
			var square = ColorRect.new()
			square.position = Vector2(BOARD_POS_X + x * SQUARE_SIZE, BOARD_POS_Y + y * SQUARE_SIZE)
			square.size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
			square.name = str("square", x, "-", y)
			#print(str("(", BOARD_POS_X + x * SQUARE_SIZE, ", ", BOARD_POS_Y + y * SQUARE_SIZE, " -> ", (x % 2 + y % 2) % 2 == 0, ")"))
			if (x % 2 + y % 2) % 2 == 0:
				square.color = SQUARE_COLOR_1
			else:
				square.color = SQUARE_COLOR_2
			
			add_child(square)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_run_game():
	pass


func _on_menu_start_singleplayer():
	# Place enemy pawns
	for x in SQUARE_COUNT_X:
		for y in PAWN_ROWS:
			var PawnEnemy = load("res://PawnEnemy.tscn")
			var pawn_enemy_node = PawnEnemy.instantiate()
			pawn_enemy_node.set_name(str("enemy", x, "-", y))
			pawn_enemy_node.position = Vector2(BOARD_POS_X + x * SQUARE_SIZE, BOARD_POS_Y + y * SQUARE_SIZE)
			add_child(pawn_enemy_node)
	# Place my pawns
	for x in SQUARE_COUNT_X:
		for y in PAWN_ROWS:
			var PawnMine = load("res://PawnMine.tscn")
			var pawn_mine_node = PawnMine.instantiate()
			pawn_mine_node.set_name(str("mine", x, "-", y))
			pawn_mine_node.position = Vector2(BOARD_POS_X + x * SQUARE_SIZE, BOARD_POS_Y + SQUARE_SIZE * SQUARE_COUNT_Y - (y + 1) * SQUARE_SIZE)
			add_child(pawn_mine_node)
