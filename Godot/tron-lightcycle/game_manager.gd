extends Node
@export var end_screen: Control
@export var result_text: Label

var trail_positions = {}
var game_started = false

@onready var countdown_label = get_parent().get_node("CanvasLayer/CountdownLabel")
@onready var grid_is_live = $GridIsLive


func _ready():
	
	start_countdown()

func start_countdown():
	grid_is_live.play()
	countdown_label.text = "3"
	await get_tree().create_timer(1).timeout

	countdown_label.text = "2"
	await get_tree().create_timer(1).timeout

	countdown_label.text = "1"
	await get_tree().create_timer(1).timeout

	countdown_label.text = "GO!"
	await get_tree().create_timer(1).timeout

	countdown_label.visible = false

	game_started = true

func game_over():
	show_end_screen("YOU LOSE")
		
func win():
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
