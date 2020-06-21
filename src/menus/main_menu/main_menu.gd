extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_btn_play_pressed():
	get_tree().change_scene("res://src/menus/song_list/song_list.tscn")


func _on_btn_scan_songs_pressed():
	var files = []
	var dir = Directory.new()
	dir.open("./songs/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif dir.current_is_dir() && file != "." && file != "..":
			files.append(file)
	
	dir.list_dir_end()
	
	$Label.text = "Songs scanned: " + str(files.size())
	
	$OptionButton.clear()
	
	for i in range(files.size()):
		$OptionButton.add_item(files[i])


func _on_btn_exit_pressed():
	get_tree().quit(0)
