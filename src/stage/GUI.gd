extends Control

var sections


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var effect = AudioServer.get_bus_effect(0, 0)
	effect.pitch_scale = 1
	get_tree().change_scene("res://src/menus/arrangement_selection/arrangement_selection.tscn")


func set_sections(sections):
	self.sections = sections
	
	for section in sections:
		$OptionButton.add_item(section.name)

