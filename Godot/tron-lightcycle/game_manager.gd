extends Node
@export var end_screen: Control
@export var result_text: Label

var trail_positions = {}
var game_started = false

@onready var countdown_label = get_parent().get_node("CanvasLayer/CountdownLabel")
@onready var grid_is_live = $GridIsLive
@onready var game_music = $GameMusic


func _ready():
	
	start_countdown()

func start_countdown():
	grid_is_live.play()
	countdown_label.text = "3"
	await get_tree().create_timer(2).timeout

	countdown_label.text = "2"
	await get_tree().create_timer(2).timeout

	countdown_label.text = "1"
	await get_tree().create_timer(2).timeout

	countdown_label.text = "GO!"
	await get_tree().create_timer(0.5).timeout

	countdown_label.visible = false

	game_started = true
	game_music.play()

func game_over():
	if not game_started:
		return
	show_end_screen("YOU LOSE")

func win():
	if not game_started:
		return
	show_end_screen("YOU WIN")

func show_end_screen(text):
	game_started = false
	get_tree().paused = true

	result_text.text = text
	end_screen.visible = true
	
	
func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")
