extends Spatial

const red_mat = preload("res://src/objects/note_3d/red_note_mat.tres")
const yellow_mat = preload("res://src/objects/note_3d/yellow_note_mat.tres")
const blue_mat = preload("res://src/objects/note_3d/blue_note_mat.tres")
const orange_mat = preload("res://src/objects/note_3d/orange_note_mat.tres")
const green_mat = preload("res://src/objects/note_3d/green_note_mat.tres")
const purple_mat = preload("res://src/objects/note_3d/purple_note_mat.tres")

const mats = [red_mat, yellow_mat, blue_mat, orange_mat, green_mat, purple_mat]
const inverted_index_correction = 5

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
	
	set_color(string)

func init_from_chord(time, string, fret, scroll_speed, playback_speed):
	self.scrollSpeed = scroll_speed
	self.sustain = 0
	self.time = time * (1.0 / playback_speed)
	self.string = string
	self.fret = fret
	initTailLength()
	
	set_color(string)

func _process(delta):
	var movement = delta * Vector3(0.0, 0.0, scrollSpeed)
	$".".translate(movement)
	if translation.z >= 0:
#		$CSGBox.visible = false
		if !frozen && tailLength != 0:
			$note.translation.z = 0
			$note.set_ignore_transform_notification(true)
		updateTail(movement)
	if translation.z - tailLength >= 0:
		queue_free()

func set_color(string):
	$note.material = mats[string]
	$tail.material = mats[string]

func initTailLength():
	tailLength = sustain * scrollSpeed
	$tail.depth = tailLength
	$tail.translate(Vector3(0, 0 , -tailLength/2.0))

func updateTail(movement):
	$tail.depth -= movement.z
	$tail.translate(-movement/2)
