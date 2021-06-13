extends Nodes

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func checkFolders():
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

func checkConfigs
