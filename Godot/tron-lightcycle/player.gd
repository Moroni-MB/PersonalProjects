extends CharacterBody2D

var tile_size = 20
var move_delay = 0.08
var direction = Vector2.RIGHT
var TrailScene = preload("res://trail.tscn")
var timer = 0.0
var game_manager

@onready var turn = $Turn


func _ready():
	modulate = Global.player_color.darkened(0.65)

	game_manager = get_parent().get_node("GameManager")

	randomize()

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

	if timer >= move_delay:
		timer = 0
		move_player()

	handle_input()


func handle_input():
	var new_direction = direction  # remember the original

	if Input.is_action_pressed("ui_right") and direction != Vector2.LEFT:
		new_direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left") and direction != Vector2.RIGHT:
		new_direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_up") and direction != Vector2.DOWN:
		new_direction = Vector2.UP
	elif Input.is_action_pressed("ui_down") and direction != Vector2.UP:
		new_direction = Vector2.DOWN

	# Only play sound if direction actually changed
	if new_direction != direction:
		direction = new_direction
		turn.play()


func move_player():
	var new_position = position + direction * tile_size
	var screen_size = get_viewport_rect().size

	# Check arena walls
	if new_position.x < 0 or new_position.x > screen_size.x:
		game_over()
		return
		
	if new_position.y < 0 or new_position.y > screen_size.y:
		game_over()
		return

	# Check trail collision
	if game_manager.trail_positions.has(new_position):
		game_over()
		return

	# Leave trail
	spawn_trail(position)

	position = new_position


func spawn_trail(pos):
	var trail = TrailScene.instantiate()
	trail.position = pos
	trail.modulate = Global.player_color
	get_parent().add_child(trail)
	game_manager.trail_positions[pos] = true


func game_over():
	game_manager.game_over()
