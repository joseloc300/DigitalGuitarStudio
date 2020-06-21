extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_btn_play_pressed():
	get_tree().change_scene("res://src/menus/song_list/song_list.tscn")


func _on_btn_exit_pressed():
	get_tree().quit(0)
