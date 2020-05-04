extends Node2D


var time = -1
var fret = -1
var string = -1
var sustain =-1

var scrollSpeed = 0
const tailWidth = 0.15
var tailLength = 0
var frozen = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init(note):
	self.sustain = note.sustain
	self.time = note.time
	self.string = note.string
	self.fret = note.fret
	set_fret_sprite()
	translate(Vector2(160 + fmod(time, 2.0)/2.0 * 960 , 125 + floor(time / 2) * 250 + string * 20 ))

func init_from_chord(time, string, fret):
	self.sustain = 0
	self.time = time
	self.string = string
	self.fret = fret
	set_fret_sprite()
	translate(Vector2(160 + fmod(time, 2.0)/2.0 * 960 , 125 + floor(time / 2) * 250 + string * 20 ))

func set_fret_sprite():
	if fret <= 9:
		var sprite_path = "res://src/fretboard/" + str(fret) + ".png"
		var texture = load(sprite_path)
		$single_sprite/Sprite.set_texture(texture)
	else:
		var sprite_path_left = "res://src/fretboard/" + str(fret / 10) + ".png"
		var texture_left = load(sprite_path_left)
		$double_sprite/Sprite_left.set_texture(texture_left)
		
		var sprite_path_right = "res://src/fretboard/" + str(fret % 10) + ".png"
		var texture_right = load(sprite_path_right)
		$double_sprite/Sprite_right .set_texture(texture_right)
