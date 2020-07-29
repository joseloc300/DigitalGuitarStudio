extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_values()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _setup_values():
	$VBoxContainer/VBoxContainer2/slider_master_vol.value = Global.master_volume
	$VBoxContainer/VBoxContainer2/slider_music_vol.value = Global.music_volume


func _on_btn_back_pressed():
	get_tree().change_scene("res://src/menus/main_menu/main_menu.tscn")



func _on_slider_master_vol_value_changed(value):
	Global.master_volume = value


func _on_slider_music_vol_value_changed(value):
	Global.music_volume = value
