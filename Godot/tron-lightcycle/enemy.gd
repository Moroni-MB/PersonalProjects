extends CharacterBody2D

var game_manager

var tile_size = 20
var move_delay = 0.08
var decision_delay = 0.2

var direction = Vector2.LEFT
var TrailScene = preload("res://trail.tscn")

var timer = 0.0
var decision_timer = 0.0

var difficulty = 1  # 1 = Easy, 2 = Medium, 3 = Hard

@onready var turn = $Turn

# Enemy cannot reverse direction
var opposite_directions = {
	Vector2.LEFT: Vector2.RIGHT,
	Vector2.RIGHT: Vector2.LEFT,
	Vector2.UP: Vector2.DOWN,
	Vector2.DOWN: Vector2.UP
}

var possible_directions = [
	Vector2.RIGHT,
	Vector2.LEFT,
	Vector2.UP,
	Vector2.DOWN
]

func _ready():
	game_manager = get_parent().get_node("GameManager")
	
	# Apply selected difficulty
	difficulty = Global.difficulty

	# 🔥 Make higher difficulty faster
	#move_delay = move_delay / difficulty
	#decision_delay = decision_delay / difficulty

	randomize()

	# 🎯 Random spawn (like player)
	var screen_size = get_viewport_rect().size
	var grid_x = int(screen_size.x / tile_size)
	var grid_y = int(screen_size.y / tile_size)

	var rand_x = randi() % grid_x
	var rand_y = randi() % grid_y

	position = Vector2(rand_x * tile_size, rand_y * tile_size)


func _process(delta):
	if not game_manager.game_started:
		return
	
	timer += delta
	decision_timer += delta

	if timer >= move_delay:
		timer = 0
		move_enemy()

	if decision_timer >= decision_delay:
		decision_timer = 0
		change_direction()


func move_enemy():
	var new_position = position + direction * tile_size
	var screen_size = get_viewport_rect().size

	# Enemy collision with walls → player wins
	if new_position.x < 0 or new_position.x >= screen_size.x \
	or new_position.y < 0 or new_position.y >= screen_size.y:
		game_manager.win()
		return
		
	# Enemy collision with trail → player wins
	if game_manager.trail_positions.has(new_position):
		game_manager.win()
		return

	# Leave trail
	spawn_trail(position)

	# Move enemy
	position = new_position.snapped(Vector2(tile_size, tile_size))


func change_direction():
	var valid_directions = []
	var player = get_parent().get_node("Player")

	var player_pos = player.position
	var player_dir = player.direction

	var prediction_steps = 6
	var future_pos = player_pos + player_dir * tile_size * prediction_steps
	var player_next = player_pos + player_dir * tile_size

	var distance = position.distance_to(player_pos)

	# 🔥 LOCK MODE CONDITIONS
	var aligned_x = abs(position.x - player_pos.x) < tile_size
	var aligned_y = abs(position.y - player_pos.y) < tile_size

	var ahead_of_player = (player_dir.x != 0 and sign(position.x - player_pos.x) == sign(player_dir.x)) \
		or (player_dir.y != 0 and sign(position.y - player_pos.y) == sign(player_dir.y))

	var lock_mode = (aligned_x or aligned_y or ahead_of_player or distance < tile_size * 6)

	# Step 1: valid directions
	for dir in possible_directions:
		if dir == opposite_directions[direction]:
			continue

		var new_pos = position + dir * tile_size
		var screen_size = get_viewport_rect().size

		if new_pos.x < 0 or new_pos.x >= screen_size.x \
		or new_pos.y < 0 or new_pos.y >= screen_size.y:
			continue

		if game_manager.trail_positions.has(new_pos):
			continue

		valid_directions.append(dir)

	if valid_directions.size() == 0:
		game_manager.win()
		return

	# Step 2: scoring
	var attack_mode = distance < tile_size * 8
	
	var best_dir = valid_directions[0]
	var best_score = -INF

	for dir in valid_directions:
		var new_pos = position + dir * tile_size
		var score = 0
		
		var future_space = get_open_space_count(new_pos)

		if future_space == 0:
			score -= 2000  # instant death
		elif future_space == 1:
			score -= 800   # very risky

		# 🧠 1. SURVIVAL (always important)
		var my_space = 0
		for check_dir in possible_directions:
			var check_pos = new_pos + check_dir * tile_size
			if not game_manager.trail_positions.has(check_pos):
				my_space += 1

		score += my_space * 60  # strong but not overpowering

		# 🎯 2. CHASE PLAYER (balanced)
		var dist_to_player = new_pos.distance_to(player_pos)
		score -= dist_to_player * 1.5

		# 🔮 3. INTERCEPT FUTURE POSITION
		score -= new_pos.distance_to(future_pos) * 2

		# 🚧 4. BLOCK PLAYER PATH (important for traps)
		if player_dir.x != 0 and abs(new_pos.y - player_pos.y) < tile_size:
			score += 250
		if player_dir.y != 0 and abs(new_pos.x - player_pos.x) < tile_size:
			score += 250

		# 💀 5. DIRECT CUT-OFF (VERY IMPORTANT)
		if new_pos == player_next:
			score += 1000

		# 🔥 6. STAY AGGRESSIVE BUT NOT SUICIDAL
		if dist_to_player < position.distance_to(player_pos):
			score += 120
		else:
			score -= 60

		# 🧱 7. WALL AVOIDANCE
		var screen_size = get_viewport_rect().size
		if new_pos.x <= tile_size or new_pos.x >= screen_size.x - tile_size:
			score -= 120
		if new_pos.y <= tile_size or new_pos.y >= screen_size.y - tile_size:
			score -= 120

		# 🎲 8. SMALL RANDOMNESS
		score += randi() % 15

		if score > best_score:
			best_score = score
			best_dir = dir

	# 🎵 turn sound
	if best_dir != direction:
		turn.play()

	direction = best_dir


func spawn_trail(pos):
	var trail = TrailScene.instantiate()
	trail.position = pos
	trail.modulate = Color(3.5, 0.8, 0)
	get_parent().add_child(trail)

	# Register trail position
	game_manager.trail_positions[pos] = true


func get_open_space_count(pos):
	var count = 0
	
	for dir in possible_directions:
		var check_pos = pos + dir * tile_size
		
		if not game_manager.trail_positions.has(check_pos):
			count += 1
	
	return count
