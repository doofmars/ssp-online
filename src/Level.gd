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
var shuffle_states = [Constants.Items.Rock, Constants.Items.Paper, Constants.Items.Scissor]
enum GameStates {
	PlaceFlag,
	PlaceTrap,
	ShufflePawns,
	PlayerTurn,
	EnemyTurn,
	Fight,
	SameWeapon,
	PlayerWin,
	EnemyWin,
	Draw
}

var PawnEnemy = load("res://src/PawnEnemy.tscn")
var PawnMine = load("res://src/PawnMine.tscn")
var MoveSpot = load("res://src/MoveSpot.tscn")

var gameState = GameStates.PlaceFlag

# Called when the node enters the scene tree for the first time.
func _ready():
	var border = ColorRect.new()
	border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	border.rect_size = Vector2(float(SQUARE_SIZE * SQUARE_COUNT_X + BORDER_WIDTH*2), float(SQUARE_SIZE * SQUARE_COUNT_Y + BORDER_WIDTH*2))
	border.rect_position = Vector2(BOARD_POS_X - BORDER_WIDTH, BOARD_POS_Y - BORDER_WIDTH)

	border.color = BORDER_COLOR
	add_child(border)
	for x in SQUARE_COUNT_X:
		for y in SQUARE_COUNT_Y:
			var square = ColorRect.new()
			square.mouse_filter = Control.MOUSE_FILTER_IGNORE
			square.rect_position = Vector2(BOARD_POS_X + x * SQUARE_SIZE, BOARD_POS_Y + y * SQUARE_SIZE)
			square.rect_size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
			square.name = str("square", x, "-", y)
			#print(str("(", BOARD_POS_X + x * SQUARE_SIZE, ", ", BOARD_POS_Y + y * SQUARE_SIZE, " -> ", (x % 2 + y % 2) % 2 == 0, ")"))
			if (x % 2 + y % 2) % 2 == 0:
				square.color = SQUARE_COLOR_1
			else:
				square.color = SQUARE_COLOR_2
			
			add_child(square)
	if OS.is_debug_build():
		skip_game()

func skip_game():
	get_node("Menu").hide()
	_on_menu_start_singleplayer()
	_on_pawn_clicked(boardState[2][5])
	_on_pawn_clicked(boardState[2][4])
	_on_game_ui_approve_pawns()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_run_game():
	pass

func set_random_item(pawn):
	var state = shuffle_states[randi() % shuffle_states.size()]
	pawn.set_item(Constants.ItemStatus.Hidden, state)

func _on_menu_start_singleplayer():
	var GameUI = get_node("GameUI")
	GameUI.show()
	GameUI.get_node("PlaceFlag").show()
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
			pawn_enemy_node.posX = x
			pawn_enemy_node.posY = y
			if x == 0 and y == 0:
				pawn_enemy_node.set_item(Constants.ItemStatus.Hidden, Constants.Items.Flag)
			if x == 0 and y == 1:
				pawn_enemy_node.set_item(Constants.ItemStatus.Hidden, Constants.Items.Trap)
			boardState[x][y] = pawn_enemy_node
			add_child(pawn_enemy_node)
	# Place my pawns
	for x in SQUARE_COUNT_X:
		for y in PAWN_ROWS:
			var pawn_mine_node = PawnMine.instance()
			pawn_mine_node.set_name(str("mine", x, "-", y))
			pawn_mine_node.position = Vector2(BOARD_POS_X + x * SQUARE_SIZE, BOARD_POS_Y + SQUARE_SIZE * SQUARE_COUNT_Y - (y + 1) * SQUARE_SIZE)
			pawn_mine_node.posX = x
			pawn_mine_node.posY = SQUARE_COUNT_Y - (y + 1)
			pawn_mine_node.hide_all()
			pawn_mine_node.connect("pawn_clicked", self, "_on_pawn_clicked")
			boardState[x][SQUARE_COUNT_Y - (y + 1)] = pawn_mine_node
			add_child(pawn_mine_node)

func _on_pawn_clicked(pawn):
	if gameState == GameStates.PlaceFlag:
		pawn.set_item(Constants.ItemStatus.Hidden, Constants.Items.Flag)
		get_node("GameUI").get_node("PlaceFlag").hide()
		get_node("GameUI").get_node("PlaceTrap").show()
		gameState = GameStates.PlaceTrap
	elif gameState == GameStates.PlaceTrap:
		if pawn.item == Constants.Items.Empty:
			pawn.set_item(Constants.ItemStatus.Hidden, Constants.Items.Trap)
			get_node("GameUI").get_node("PlaceTrap").hide()
			get_node("GameUI").get_node("ShufflePawns").show()
			shuffle_pawns()
			gameState = GameStates.ShufflePawns
	elif gameState == GameStates.ShufflePawns:
		pass
	elif gameState == GameStates.PlayerTurn:
		if can_pawn_move(pawn):
			clear_pawn_moves()
			show_pawn_moves(pawn)
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
			if pawn != null and \
				pawn.item != Constants.Items.Trap and \
				pawn.item != Constants.Items.Flag:
				set_random_item(pawn)

func can_pawn_move(pawn) -> bool:
	if pawn.item == Constants.Items.Trap or \
		pawn.item == Constants.Items.Flag:
		return false
	else:
		return true

func clear_pawn_moves():
	for node in get_children():
		if "move_spot" in node.name:
			node.queue_free()

func show_pawn_moves(pawn):
	show_pawn_move(pawn.posX + 1, pawn.posY, pawn)
	show_pawn_move(pawn.posX - 1, pawn.posY, pawn)
	show_pawn_move(pawn.posX, pawn.posY + 1, pawn)
	show_pawn_move(pawn.posX, pawn.posY - 1, pawn)

func show_pawn_move(x, y, pawn) -> void:
	if x < 0 or x >= SQUARE_COUNT_X or y < 0 or y >= SQUARE_COUNT_Y:
		return
	if boardState[x][y] == null or boardState[x][y].type != pawn.type:
		var move_spot = MoveSpot.instance()
		move_spot.position = Vector2(BOARD_POS_X + x * SQUARE_SIZE + SQUARE_SIZE/2, BOARD_POS_Y + y * SQUARE_SIZE + SQUARE_SIZE/2)
		move_spot.connect("move_spot_clicked", self, "_on_move_clicked")
		move_spot.name = str("move_spot", x, "-", y)
		move_spot.posX = x
		move_spot.posY = y
		move_spot.pawn = pawn
		add_child(move_spot)

func _on_move_clicked(move_spot) -> void:
	if gameState == GameStates.PlayerTurn:
		if boardState[move_spot.posX][move_spot.posY] == null:
			boardState[move_spot.pawn.posX][move_spot.pawn.posY] = null
			boardState[move_spot.posX][move_spot.posY] = move_spot.pawn
			move_spot.pawn.posX = move_spot.posX
			move_spot.pawn.posY = move_spot.posY
			move_spot.pawn.target = Vector2(BOARD_POS_X + move_spot.posX * SQUARE_SIZE, BOARD_POS_Y + move_spot.posY * SQUARE_SIZE)
			clear_pawn_moves()
		else:
			if boardState[move_spot.posX][move_spot.posY].type == move_spot.pawn.type:
				return
			print("Fight")
			gameState = GameStates.Fight
			var attacker = move_spot.pawn
			var defender = boardState[move_spot.posX][move_spot.posY]
			clear_pawn_moves()
			initiate_fight(attacker, defender)


# Fight logic
func initiate_fight(attacker, defender):
	var attacker_wins = true
	attacker.target = Vector2(BOARD_POS_X + (SQUARE_COUNT_X + 1) * SQUARE_SIZE, BOARD_POS_Y + (SQUARE_COUNT_Y / 2 - 0.5) * SQUARE_SIZE)
	defender.target = Vector2(BOARD_POS_X + (SQUARE_COUNT_X + 2) * SQUARE_SIZE, BOARD_POS_Y + (SQUARE_COUNT_Y / 2 - 0.5) * SQUARE_SIZE)
	attacker.show_item()
	defender.show_item()
	yield(get_tree().create_timer(2.0), "timeout")
	if attacker_wins(attacker, defender):
		boardState[defender.posX][defender.posY] = attacker
		boardState[attacker.posX][attacker.posY] = null
		attacker.posX = defender.posX
		attacker.posY = defender.posY
		attacker.target = Vector2(BOARD_POS_X + defender.posX * SQUARE_SIZE, BOARD_POS_Y + defender.posY * SQUARE_SIZE)
		yield(get_tree().create_timer(0.5), "timeout")
		defender.queue_free()
		gameState = GameStates.PlayerTurn
	else:
		boardState[attacker.posX][attacker.posY] = null
		defender.target = Vector2(BOARD_POS_X + defender.posX * SQUARE_SIZE, BOARD_POS_Y + defender.posY * SQUARE_SIZE)
		attacker.queue_free()
		gameState = GameStates.PlayerTurn

func attacker_wins(attacker, defender) -> bool:
	if defender.item == Constants.Items.Flag:
		attacker.set_item(Constants.ItemStatus.Active, Constants.Items.Flag)
		return true
	if defender.item == Constants.Items.Trap:
		return false
	if attacker.item == Constants.Items.Rock:
		if defender.item == Constants.Items.Scissor:
			return true
		elif defender.item == Constants.Items.Paper:
			return false
		else:
			return draw(attacker, defender)
	elif attacker.item == Constants.Items.Scissor:
		if defender.item == Constants.Items.Paper:
			return true
		elif defender.item == Constants.Items.Rock:
			return false
		else:
			return draw(attacker, defender)
	elif attacker.item == Constants.Items.Paper:
		if defender.item == Constants.Items.Rock:
			return true
		elif defender.item == Constants.Items.Scissor:
			return false
		else:
			return true
	else:
		return false

func draw(attacker, defender):
	return true

func _on_game_ui_reshuffle_pawns():
	if gameState == GameStates.ShufflePawns:
		shuffle_pawns()

func _on_game_ui_approve_pawns():
	if gameState == GameStates.ShufflePawns:
		get_node("GameUI").get_node("ShufflePawns").hide()
		gameState = GameStates.PlayerTurn
