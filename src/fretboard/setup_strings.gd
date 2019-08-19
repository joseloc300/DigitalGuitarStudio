extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$string_1.set_color_red()
	$string_2.set_color_yellow()
	$string_3.set_color_blue()
	$string_4.set_color_orange()
	$string_5.set_color_green()
	$string_6.set_color_purple()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
