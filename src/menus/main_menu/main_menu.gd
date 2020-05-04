extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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


func _on_OptionButton2_item_selected(id):
	print(id)


func _on_OptionButton_item_selected(id):
	var selected_folder = $OptionButton.text
	print(selected_folder)
	
	$OptionButton2.visible = true
	
	var arrangements = []
	
	var dir = Directory.new()
	dir.open("./songs/" + selected_folder + "/songs/arr/")
	
	dir.list_dir_begin(true)
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif !file.ends_with("_showlights.xml"):
			arrangements.append(file)
	
	dir.list_dir_end()
	
	$Label2.text = "Arrangements scanned: " + str(arrangements.size())
	
	$OptionButton2.clear()
	
	for i in range(arrangements.size()):
		$OptionButton2.add_item(arrangements[i])


func _on_Button_pressed():
	var file = File.new()
	if file.file_exists("./dsp_fx/event_queue.txt"):
		print("found file")
		while file.open("./dsp_fx/event_queue.txt", File.WRITE) != 0:
			continue
		file.store_line("add overdrive")
		OS.set_clipboard("add overdrive")


func _on_Button2_pressed():
	var file = File.new()
	if file.file_exists("./dsp_fx/event_queue.txt"):
		print("found file")
		while file.open("./dsp_fx/event_queue.txt", File.WRITE) != 0:
			continue
		file.store_line("remove overdrive")
		OS.set_clipboard("remove overdrive")
