extends KinematicBody2D
#==========Variables==========#
var ACCELERATION = 100
var FRICTION = 200
var MAX_SPEED = 30 #10

export (Color) var blue : Color = Color("#ADD8E6")
export (Color) var green : Color = Color("#90EE90")
export (Color) var white : Color = Color("#FFFFFF")

var knockback : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
var enemy_vol : Vector2 = Vector2.ZERO
var enemy_old_pos
var target
var text : String = ""
var type : String = "Enemy"

#==========Onready Variables==========#
onready var text_label : RichTextLabel = $TextLabel

#==========Functions==========#
func _ready():
	enemy_old_pos = global_position
	text = WordList.get_prompt(Global.current_menu.get_enemy_starting_letters())
	set_next_character(-1)

func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta : float) -> void:
	target = Global.current_menu.base

	velocity = velocity.move_toward((target.global_position - global_position).normalized() * MAX_SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity)
	
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	#AI tower prediction
	enemy_vol = global_position - enemy_old_pos
	enemy_old_pos = global_position

func get_prompt() -> String:
	return text

func damage() -> void:
	self.queue_free()

func set_next_character(next_character_index: int) -> void:
	if next_character_index == -1:
		text_label.parse_bbcode(set_center_tags(text))
		return
		
	var green_text = get_bbcode_color_tag(green) + text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var blue_text = get_bbcode_color_tag(blue) + text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var white_text = ""
	if next_character_index != text.length():
		white_text = get_bbcode_color_tag(white) + text.substr(next_character_index + 1, text.length() - next_character_index + 1) + get_bbcode_end_color_tag()
	text_label.parse_bbcode(set_center_tags(green_text + blue_text + white_text))

func set_center_tags(string_to_center: String) -> String:
	return "[center]" + string_to_center + "[/center]"
	
func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"

func get_bbcode_end_color_tag() -> String:
	return "[/color]"
