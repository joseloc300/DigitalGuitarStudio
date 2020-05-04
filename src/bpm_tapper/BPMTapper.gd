extends Control


var first = true
var delay = 0
var total_time = 0
var beats = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !first:
		delay += delta
	if Input.is_action_just_pressed("bpm_tap"):
		if first:
			first = false
		else:
			total_time += delay
			delay = 0
			beats += 1
			var bpm = calc_bpm()
			$Label.text = str(bpm)

func calc_bpm():
	var bpm = beats * 60 / total_time
	return bpm
