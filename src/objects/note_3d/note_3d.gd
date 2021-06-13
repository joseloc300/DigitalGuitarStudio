extends Spatial

const red_mat = preload("res://src/objects/note_3d/red_note_mat.tres")
const yellow_mat = preload("res://src/objects/note_3d/yellow_note_mat.tres")
const blue_mat = preload("res://src/objects/note_3d/blue_note_mat.tres")
const orange_mat = preload("res://src/objects/note_3d/orange_note_mat.tres")
const green_mat = preload("res://src/objects/note_3d/green_note_mat.tres")
const purple_mat = preload("res://src/objects/note_3d/purple_note_mat.tres")

const mats = [red_mat, yellow_mat, blue_mat, orange_mat, green_mat, purple_mat]
const animation_duration = 1

enum preview_states {NO_PREVIEW, BF_PREVIEW, PREVIEW}

var time = -1
var fret = -1
var string = -1
var sustain = -1
var time_offset = -1

var scrollSpeed = 0
const tailWidth = 0.15
var tailLength = 0
var frozen = false

var curr_preview_state = preview_states.NO_PREVIEW

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(note_info, time_offset, scroll_speed, playback_speed, start_position):
	self.scrollSpeed = scroll_speed
	self.sustain = note_info.sustain
	self.time = note_info.time * (1.0 / playback_speed)
	self.string = note_info.string
	self.fret = note_info.fret
	initTailLength()
	set_color(string)
	$moving_note.translate(start_position)
	var preview_position = start_position
	preview_position.z = 0
	$note_preview.translate(preview_position)


func _physics_process(delta):
	var movement = delta * Vector3(0.0, 0.0, scrollSpeed)
	if frozen:
		if $moving_note.translation.z != 0:
			$moving_note.translation.z = 0.0
		updateTail(movement)
	else:
		$moving_note.translate(movement)
	
	if curr_preview_state == preview_states.BF_PREVIEW:
		curr_preview_state = preview_states.PREVIEW
	elif curr_preview_state == preview_states.PREVIEW and not $note_preview.visible:
		$note_preview.visible = true


func set_time_offset(time_offset):
	self.time_offset = time_offset
	$PreviewTimer.wait_time = time_offset - animation_duration
	$FreezeTimer.wait_time = time_offset
	$DestroyTimer.wait_time = time_offset + sustain


func set_color(string):
	$moving_note/note.material = mats[string]
	$moving_note/tail.material = mats[string]
	$note_preview.material_override = mats[string]
#	$note_preview.material = mats[string]


func initTailLength():
	tailLength = sustain * scrollSpeed
	$moving_note/tail.depth = tailLength
	$moving_note/tail.translate(Vector3(0, 0 , -tailLength/2.0))


func updateTail(movement):
	$moving_note/tail.depth -= movement.z
	$moving_note/tail.translate(movement/2)


func _on_PreviewTimer_timeout():
	curr_preview_state = preview_states.BF_PREVIEW
	$AnimationPlayer.play("show_note_preview")


func _on_FreezeTimer_timeout():
	frozen = true
	$moving_note.translation.z = 0.0


func _on_DestroyTimer_timeout():
	queue_free()
