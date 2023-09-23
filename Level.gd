extends Node

var BOARD_POS_X = 100
var BOARD_POS_Y = 144
var SQUARE_SIZE = 60
var SQUARE_COUNT_X = 7
var SQUARE_COUNT_Y = 6
var SQUARE_COLOR_1 = "c6d878"
var SQUARE_COLOR_2 = "9fbb23"

# Called when the node enters the scene tree for the first time.
func _ready():

	for x in SQUARE_COUNT_X:
		for y in SQUARE_COUNT_Y:
			var square = Sprite2D.new()
			square.texture = load("res://assets/white.png")
			square.transform = Transform2D(0.0, Vector2(SQUARE_SIZE, SQUARE_SIZE), 0, Vector2(BOARD_POS_X + x * SQUARE_SIZE + SQUARE_SIZE/2, BOARD_POS_Y + y * SQUARE_SIZE + SQUARE_SIZE/2))
			print(str("(", BOARD_POS_X + x * SQUARE_SIZE, ", ", BOARD_POS_Y + y * SQUARE_SIZE, " -> ", (x % 2 + y % 2) % 2 == 0, ")"))
			if (x % 2 + y % 2) % 2 == 0:
				square.set_modulate(SQUARE_COLOR_1)
			else:
				square.set_modulate(SQUARE_COLOR_2)
			
			add_child(square)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
