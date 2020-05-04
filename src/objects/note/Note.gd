extends Spatial

const red_material = preload("res://src/objects/note/red_note_mat.tres")
const yellow_material = preload("res://src/objects/note/yellow_note_mat.tres")
const blue_material = preload("res://src/objects/note/blue_note_mat.tres")
const orange_material = preload("res://src/objects/note/orange_note_mat.tres")
const green_material = preload("res://src/objects/note/green_note_mat.tres")
const purple_material = preload("res://src/objects/note/purple_note_mat.tres")

const RED = 0
const YELLOW = 1
const BLUE = 2
const ORANGE = 3
const GREEN = 4
const PURPLE = 5

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

func init(note, scroll_speed, playback_speed):
	self.scrollSpeed = scroll_speed
	self.sustain = note.sustain
	self.time = note.time * (1.0 / playback_speed)
	self.string = note.string
	self.fret = note.fret
	initTailLength()
	
	if string == RED:
		set_color_red()
	elif string == YELLOW:
		set_color_yellow()
	elif string == BLUE:
		set_color_blue()
	elif string == ORANGE:
		set_color_orange()
	elif string == GREEN:
		set_color_green()
	elif string == PURPLE:
		set_color_purple()

func init_from_chord(time, string, fret, scroll_speed, playback_speed):
	self.scrollSpeed = scroll_speed
	self.sustain = 0
	self.time = time * (1.0 / playback_speed)
	self.string = string
	self.fret = fret
	initTailLength()
	
	if string == RED:
		set_color_red()
	elif string == YELLOW:
		set_color_yellow()
	elif string == BLUE:
		set_color_blue()
	elif string == ORANGE:
		set_color_orange()
	elif string == GREEN:
		set_color_green()
	elif string == PURPLE:
		set_color_purple()

func _process(delta):
	var movement = delta * Vector3(0.0, 0.0, scrollSpeed)
	$".".translate(movement)
	if translation.z >= 0:
#		$CSGBox.visible = false
		if !frozen && tailLength != 0:
			$CSGBox.translation.z = 0
			$CSGBox.set_ignore_transform_notification(true)
		updateTail(movement)
	if translation.z - tailLength >= 0:
		queue_free()

func set_color_red():
	$CSGBox.material = red_material
	$CSGTail.material = red_material

func set_color_yellow():
	$CSGBox.material = yellow_material
	$CSGTail.material = yellow_material

func set_color_blue():
	$CSGBox.material = blue_material
	$CSGTail.material = blue_material

func set_color_orange():
	$CSGBox.material = orange_material
	$CSGTail.material = orange_material

func set_color_green():
	$CSGBox.material = green_material
	$CSGTail.material = green_material

func set_color_purple():
	$CSGBox.material = purple_material
	$CSGTail.material = purple_material

func initTailLength():
	tailLength = sustain * scrollSpeed
	$CSGTail.depth = tailLength
	$CSGTail.translate(Vector3(0, 0 , -tailLength/2.0))

func updateTail(movement):
	$CSGTail.depth -= movement.z
	$CSGTail.translate(-movement/2)
