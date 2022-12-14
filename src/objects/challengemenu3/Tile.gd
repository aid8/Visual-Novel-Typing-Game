extends Node2D

#==========Variables==========#
export (Color) var blue : Color = Color("#ADD8E6")
export (Color) var green : Color = Color("#90EE90")
export (Color) var white : Color = Color("#FFFFFF")

export (Color) var tile_red : Color = Color("#FF0000")
export (Color) var tile_blue : Color = Color("#ADD8E6")
export (Color) var tile_green : Color =  Color("#90EE90")
export (Color) var tile_gray : Color
export (Color) var tile_start_highlight : Color
export (Color) var tile_end_highlight : Color

var text : String = ""

#==========Onready Variables==========#
onready var color_rect = $ColorRect
onready var tile_text = $TileText
onready var highlight = $Highlight
onready var refresh_time_timer = $RefreshTileTimer

#==========Functions==========#
func _ready():
	randomize()
	refresh_tile()

func delayed_refresh_tile(time : int):
	text = ""
	set_next_character(-1)
	color_rect.color = tile_gray
	refresh_time_timer.wait_time = time
	refresh_time_timer.start()

func refresh_tile():
	text = WordList.get_prompt(Global.current_menu.get_tiles_starting_letters())
	set_next_character(-1)
	set_random_color()

func toggle_highlight(b : bool, type : String = "none") -> void:
	if type != "none":
		if type == "start":
			highlight.color = tile_start_highlight
		elif type == "end":
			highlight.color = tile_end_highlight
	if b:
		highlight.show()
	else:
		highlight.hide()

func cancel_tile():
	set_next_character(-1)
	toggle_highlight(false)

func get_current_color():
	return color_rect.color

func get_prompt():
	return text

func set_random_color():
	var colors = [tile_blue, tile_green, tile_red]
	var rand = randi() % 3
	color_rect.color = colors[rand]

func set_next_character(next_character_index: int) -> void:
	if next_character_index == -1:
		tile_text.parse_bbcode(set_center_tags(text))
		return
		
	var green_text = get_bbcode_color_tag(green) + text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var blue_text = get_bbcode_color_tag(blue) + text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var white_text = ""
	if next_character_index != text.length():
		white_text = get_bbcode_color_tag(white) + text.substr(next_character_index + 1, text.length() - next_character_index + 1) + get_bbcode_end_color_tag()
	tile_text.parse_bbcode(set_center_tags(green_text + blue_text + white_text))

func set_center_tags(string_to_center: String) -> String:
	return "[center]" + string_to_center + "[/center]"
	
func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"

func get_bbcode_end_color_tag() -> String:
	return "[/color]"

func _on_Timer_timeout():
	refresh_tile()
