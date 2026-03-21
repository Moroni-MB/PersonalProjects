extends Control

@onready var color_select = get_node("VBoxContainer/ColorSelectButton")

func _ready():
	color_select.add_item("Blue")
	color_select.add_item("Orange")
	color_select.add_item("Green")
	color_select.add_item("Purple")
	
func _on_play_button_pressed():
	var selected = color_select.get_selected_id()
	
	match selected:
		0:
			Global.player_color = Color(0, 2, 4)   # Blue
		1:
			Global.player_color = Color(4, 1.5, 0) # Orange
		2:
			Global.player_color = Color(0.0, 1.2, 0.3)   # Green
		3:
			Global.player_color = Color(2, 0, 4)   # Purple
	
	get_tree().change_scene_to_file("res://main.tscn")
	
