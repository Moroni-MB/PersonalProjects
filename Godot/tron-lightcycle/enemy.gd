extends CharacterBody2D

var game_manager

var tile_size = 20
var move_delay = 0.08

var direction = Vector2.LEFT
var TrailScene = preload("res://trail.tscn")

var timer = 0.0
var decision_timer = 0.0
var decision_delay = 0.2  # tweak this

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


func _process(delta):
	if not game_manager.game_started:
		return
	
	timer += delta
	decision_timer += delta

	if timer >= move_delay:
		timer = 0
		move_enemy()


func move_enemy():
	
	# 🧠 Only rethink direction sometimes
	if decision_timer >= decision_delay:
		decision_timer = 0
		change_direction()
	
	var new_position = position + direction * tile_size
	var screen_size = get_viewport_rect().size

	# If we hit something → game over
	if new_position.x < 0 or new_position.x >= screen_size.x \
	or new_position.y < 0 or new_position.y >= screen_size.y:
		game_manager.game_over()
		return

	if game_manager.trail_positions.has(new_position):
		game_manager.game_over()
		return

	# Leave trail
	spawn_trail(position)

	# Move enemy
	position = new_position.snapped(Vector2(tile_size, tile_size))


func change_direction():
	var valid_directions = []
	var player = get_parent().get_node("Player")
	
	# 🔮 Predict where player will be
	var prediction_steps = 4  # tweak this
	var target_pos = player.position + player.direction * tile_size * prediction_steps

	# Step 1: Collect valid directions
	for dir in possible_directions:
		if dir == opposite_directions[direction]:
			continue

		var new_pos = position + dir * tile_size
		var screen_size = get_viewport_rect().size

		# Wall check
		if new_pos.x < 0 or new_pos.x >= screen_size.x \
		or new_pos.y < 0 or new_pos.y >= screen_size.y:
			continue

		# Trail check
		if game_manager.trail_positions.has(new_pos):
			continue

		valid_directions.append(dir)

	# Step 2: If trapped → game over
	if valid_directions.size() == 0:
		game_manager.win()
		return

	# Step 3: Score each direction
	var best_dir = valid_directions[0]
	var best_score = -INF

	for dir in valid_directions:
		var new_pos = position + dir * tile_size

		var score = 0

		var to_target = target_pos - position

		# 🧠 Move toward predicted position
		if sign(to_target.x) == dir.x:
			score += 150

		if sign(to_target.y) == dir.y:
			score += 150

		# 🎯 Strong bonus if we intercept path
		if abs(new_pos.x - target_pos.x) < tile_size:
			score += 120

		if abs(new_pos.y - target_pos.y) < tile_size:
			score += 120


		# 🚫 Avoid walls (still important)
		var screen_size = get_viewport_rect().size
		if new_pos.x <= tile_size or new_pos.x >= screen_size.x - tile_size:
			score -= 80
		if new_pos.y <= tile_size or new_pos.y >= screen_size.y - tile_size:
			score -= 80


		# 🧱 Avoid getting trapped
		var open_spaces = 0
		for check_dir in possible_directions:
			var check_pos = new_pos + check_dir * tile_size
			if not game_manager.trail_positions.has(check_pos):
				open_spaces += 1

		score += open_spaces * 20
		
		if score > best_score:
			best_score = score
			best_dir = dir

	direction = best_dir



func spawn_trail(pos):
	var trail = TrailScene.instantiate()
	trail.position = pos
	trail.modulate = Color(3.5, 0.8, 0)
	get_parent().add_child(trail)

	# Register trail position
	game_manager.trail_positions[pos] = true
