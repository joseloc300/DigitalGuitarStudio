extends Node


var vocals = []
var vocals_count = -1

var error_parsing = false
var node_type

var parser = XMLParser.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func readArrangement():
	var code = parser.open(Global.selected_arrangement_path)
	print("error code: " + str(code))
	parser.read()
	node_type = parser.get_node_type()
	_parse_vocals()


func _parse_vocals():
	while node_type != 1 || parser.get_node_name() != "vocals":
		parser.read()
		node_type = parser.get_node_type()
	
	vocals_count = int(parser.get_named_attribute_value("count"))
	
	while node_type != 2 || parser.get_node_name() != "vocals":
		if !(node_type == 1 && parser.get_node_name() == "vocal"):
			parser.read()
			node_type = parser.get_node_type()
		
		if node_type == 1 && parser.get_node_name() == "vocal":
			var vocal = {}
			vocal.time = float(parser.get_named_attribute_value("time"))
			vocal.note = int(parser.get_named_attribute_value("note"))
			vocal.length = float(parser.get_named_attribute_value("length"))
			vocal.lyric = parser.get_named_attribute_value("lyric")
			vocal.eol = vocal.lyric.ends_with("+")
			vocal.word_continues = vocal.lyric.ends_with("-")
			if vocal.eol or vocal.word_continues:
				vocal.lyric = vocal.lyrics.substr(0, vocal.lyrics.size() - 1)
			vocals.append(vocal)
	
	if vocals.size() != vocals_count:
		print("ERROR: vocals.size() and vocals_count do not match")
