extends Button

var files = []

func _on_BtnScanSongs_pressed():
	scan_folders()


func scan_folders():
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
	
	print(files)

