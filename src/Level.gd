extends Node

var SQUARE_SIZE = 80
var SQUARE_COUNT_X = 7
var SQUARE_COUNT_Y = 6
var BOARD_POS_X = 100
var BOARD_POS_Y = (600 - SQUARE_SIZE * SQUARE_COUNT_Y) / 2
var BORDER_COLOR = "c6d878"
var BORDER_WIDTH = 2
var SQUARE_COLOR_1 = "c6d878"
var SQUARE_COLOR_2 = "9fbb23"
var PAWN_ROWS = 2

var boardState = []
var shuffle_states = [Constants.Items.HiddenRock, Constants.Items.HiddenScissor, Constants.Items.HiddenPaper]
enum GameStates {
	PlaceFlag,
	PlaceTrap,
	ShufflePawns,
	PlayerTurn,
	EnemyTurn,
	PlayerWin,
	EnemyWin,
	Draw
}

var gameState = GameStates.PlaceFlag

# Called when the node enters the scene tree for the first time.
func _ready():
	var border = ColorRect.new()
	print(SQUARE_SIZE * SQUARE_COUNT_X + BORDER_WIDTH*2)
	border.rect_size = Vector2(float(SQUARE_SIZE * SQUARE_COUNT_X + BORDER_WIDTH*2), float(SQUARE_SIZE * SQUARE_COUNT_Y + BORDER_WIDTH*2))
	border.rect_position = Vector2(BOARD_POS_X - BORDER_WIDTH, BOARD_POS_Y - BORDER_WIDTH)

	border.color = BORDER_COLOR
	add_child(border)
	for x in SQUARE_COUNT_X:
		for y in SQUARE_COUNT_Y:
			var square = ColorRect.new()
			square.rect_position = Vector2(BOARD_POS_X + x * SQUARE_SIZE, BOARD_POS_Y + y * SQUARE_SIZE)
			square.rect_size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
			square.name = str("square", x, "-", y)
			#print(str("(", BOARD_POS_X + x * SQUARE_SIZE, ", ", BOARD_POS_Y + y * SQUARE_SIZE, " -> ", (x % 2 + y % 2) % 2 == 0, ")"))
			if (x % 2 + y % 2) % 2 == 0:
				square.color = SQUARE_COLOR_1
			else:
				square.color = SQUARE_COLOR_2
			
			add_child(square)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_run_game():
	pass

func set_random_item(pawn):
	var state = shuffle_states[randi() % shuffle_states.size()]
	pawn.set_item(state)

func _on_menu_start_singleplayer():
	var GameUI = get_node("GameUI")
	GameUI.show()
	GameUI.get_node("PlaceFlag").show()
	var PawnEnemy = load("res://src/PawnEnemy.tscn")
	var PawnMine = load("res://src/PawnMine.tscn")
	for x in SQUARE_COUNT_X:
		boardState.append([])
		for y in SQUARE_COUNT_Y:
			boardState[x].append(null)
	# Place enemy pawns
	for x in SQUARE_COUNT_X:
		for y in PAWN_ROWS:
			var pawn_enemy_node = PawnEnemy.instance()
			pawn_enemy_node.set_name(str("enemy", x, "-", y))
			pawn_enemy_node.position = Vector2(BOARD_POS_X + x * SQUARE_SIZE, BOARD_POS_Y + y * SQUARE_SIZE)
			pawn_enemy_node.type = Constants.Types.Enemy
			boardState[x][y] = pawn_enemy_node
			add_child(pawn_enemy_node)
	# Place my pawns
	for x in SQUARE_COUNT_X:
		for y in PAWN_ROWS:
			var pawn_mine_node = PawnMine.instance()
			pawn_mine_node.set_name(str("mine", x, "-", y))
			pawn_mine_node.position = Vector2(BOARD_POS_X + x * SQUARE_SIZE, BOARD_POS_Y + SQUARE_SIZE * SQUARE_COUNT_Y - (y + 1) * SQUARE_SIZE)
			pawn_mine_node.hide_all()
			pawn_mine_node.connect("pawn_clicked", self, "_on_pawn_clicked")
			boardState[x][SQUARE_COUNT_Y - (y + 1)] = pawn_mine_node
			add_child(pawn_mine_node)

func _on_pawn_clicked(pawn):
	if gameState == GameStates.PlaceFlag:
		pawn.set_item(Constants.Items.Flag)
		get_node("GameUI").get_node("PlaceFlag").hide()
		get_node("GameUI").get_node("PlaceTrap").show()
		gameState = GameStates.PlaceTrap
	elif gameState == GameStates.PlaceTrap:
		if pawn.item == Constants.Items.Empty:
			pawn.set_item(Constants.Items.Trap)
			get_node("GameUI").get_node("PlaceTrap").hide()
			get_node("GameUI").get_node("ShufflePawns").show()
			shuffle_pawns()
			gameState = GameStates.ShufflePawns
	elif gameState == GameStates.ShufflePawns:
		pass
	elif gameState == GameStates.PlayerTurn:
		pass
	elif gameState == GameStates.EnemyTurn:
		pass
	elif gameState == GameStates.PlayerWin:
		pass
	elif gameState == GameStates.EnemyWin:
		pass
	elif gameState == GameStates.Draw:
		pass
	else:
		pass

func shuffle_pawns():
	var number_of_pairs = SQUARE_COUNT_X * PAWN_ROWS - 2
	for x in SQUARE_COUNT_X:
		for y in SQUARE_COUNT_Y:
			var pawn = boardState[x][y]
			if pawn != null and pawn.item != Constants.Items.Trap and pawn.item != Constants.Items.Flag:
				set_random_item(pawn)

func _on_game_ui_reshuffle_pawns():
	if gameState == GameStates.ShufflePawns:
		shuffle_pawns()

func _on_game_ui_approve_pawns():
	if gameState == GameStates.ShufflePawns:
		get_node("GameUI").get_node("ShufflePawns").hide()
		gameState = GameStates.PlayerTurn
