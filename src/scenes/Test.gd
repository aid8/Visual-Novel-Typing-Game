extends Node2D
#==========TODO==========#
#Store Challenge menu stats
#Starting Chapter Anim
#Stats Menu fade
#Add to Global current stats after finishing chapter
#Recheck add_finished_scenes (after branching)

#==========Testing Stuffs==========#
onready var testbox = $TestBox
var debug_mode = true

func _on_TestBox_confirmed():
	Global.load_user_data()
	load_saved_progress()
	get_current_dialogue()
	ui.show()

func _on_TestBtn_pressed():
	get_tree().reload_current_scene()

func _on_ClearButton_pressed():
	#Delete data and Reload current scene
	Global.delete_user_data()
	get_tree().reload_current_scene()
	
func cancelled():
	get_current_dialogue()
	ui.show()

#==========Variables==========#
const white : Color = Color("#FFFFFF")
const red : Color = Color("#FF0000")
const green : Color = Color("#90EE90")
const yellow : Color = Color("#FFFF80")
const light_blue : Color = Color("#ADD8E6")
const light_gray : Color = Color("#D3D3D3")
const light_orange : Color = Color("#FFD580")

var current_scene : String = "Chapter 1" #"Test"
var current_scene_index: int = 0
var current_letter_index : int = 0
var current_location : String = ""
var wrong_letter_length : int = 0
var current_dialogue : String = ""
var current_dialogue_remark : String = ""
var dialogue_space : bool = false
var typing_target : String = "dialogue" #dialogue or choice
var choosing_selection : bool = false
var chosen_selection : Node2D = null
var	choice_selections : Array = []
var character_dict : Dictionary = {}
var typed_word_accuracy : Dictionary = {}
var current_word_index : int = 0
var mastered_word_indices : Dictionary = {} #{start : length}
var mastered_words : Dictionary = {} #{word : true}
var has_choice_timer : bool = false
var ignore_typing : bool = false
var current_wpm : float = 0
var total_time : float = 0
var tracing_wpm : bool = false
var skipped_characters_length : int = 0 #for accurate wpm computation, skipped characters should be taken note of
var skip_dialogue : bool = false
var total_wpm : Array = [0, 0] #[total_wpm, count]
var total_accuracy : Array = [0, 0] #[correct_count, wrong_count]
var chapter_play_time : float = 0

#Scene animation variables
var shake_strength : float = 0.0
var shake_decay : float = 0.0
var history_text_storage : String = ""
#var new_progress : bool = true#if false, this will load the saved progress instead of a new one

#==========Onready Variables==========#
onready var rand = RandomNumberGenerator.new()
onready var camera : Camera2D = $Camera
onready var ui : CanvasLayer = $UI
onready var characters : Node2D = $Characters
onready var backgrounds : AnimatedSprite = $Backgrounds
onready var character_name : RichTextLabel = $UI/CharacterName
onready var dialogue : RichTextLabel = $UI/Dialogue
onready var type_box :RichTextLabel = $UI/TypeBox
onready var type_box_background : Sprite = $UI/TypeBoxBackground
onready var choice_selection_position : Position2D = $UI/ChoiceSelectionPosition
onready var character_positions : Dictionary = {
	"LEFT" : $Characters/CharacterLeftPosition,
	"MIDDLE" : $Characters/CharacterMidPosition,
	"RIGHT" : $Characters/CharacterRightPosition,
}
onready var choice_timer : Timer = $ChoiceTimer
onready var timer_pop_up : AcceptDialog = $UI/TimerPopUp
onready var timer_node : Node2D = $UI/TimerNode
onready var timer_label : Label = $UI/TimerNode/TimerLabel
onready var wpm_label : Label = $UI/WPMLabel
onready var space_label : Label = $UI/SpaceLabel
onready var history_menu : Node2D = $UI/HistoryMenu
onready var history_text : RichTextLabel = $UI/HistoryMenu/HistoryText
onready var stats_menu : Node2D = $UI/StatsMenu
onready var name_menu : Node2D = $UI/NameMenu
onready var name_edit : LineEdit = $UI/NameMenu/NameEdit

#==========Preload Variables==========#
onready var choice_selection = preload("res://src/ui/ChoiceSelection.tscn")
onready var character = preload("res://src/objects/Character.tscn")

#==========Functions==========#
func _ready() -> void:
	rand.randomize()
	#TESTING
	if not Global.check_first_time():
		ui.hide()
		testbox.connect("modal_closed", self, "cancelled")
		testbox.get_close_button().connect("pressed", self, "cancelled")
		testbox.get_cancel().connect("pressed", self, "cancelled")
		testbox.popup()
		return
	name_menu.show() #get name for the first time
	get_current_dialogue()
	history_text.set_scroll_follow(true)
	SceneTransition.connect("transition_finished", self, "on_scene_transition_finished")

func _process(delta : float) -> void:
	#In charge of choice timer
	if has_choice_timer:
		timer_label.text = String(choice_timer.time_left).pad_decimals(2)
	#In charge of tracing wpm
	if tracing_wpm:
		total_time += delta
	handle_scene_animation(delta)
	
	#RECHECK/TESTING
	if not stats_menu.visible:
		chapter_play_time += delta

func handle_scene_animation(delta : float) -> void:
	#shake anim
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0, shake_decay * delta)
		var rand_off = rand.randf_range(-shake_strength, shake_strength)
		camera.offset = Vector2(rand_off, rand_off)
		if floor(shake_strength) == 0:
			camera.offset = Vector2.ZERO
			shake_strength = 0

#Loads necessary characters, location and scene
func load_saved_progress():
	var data = Global.user_data["SavedProgress"]
	current_scene = data.scene
	current_scene_index = data.scene_index
	for c in data.characters:
		add_character(c.name, c.outfit, c.expression, c.position)
		if c.is_hidden:
			toggle_character(c.name, true)
	current_location = data.location
	change_background(current_location, data.location_tint)

#Creates a character array and puts all info about the characters present
#Then also saves scene info
func save_progress():
	var char_array : Array = []
	for c in character_dict.values():
		var char_info : Dictionary = {}
		char_info["name"] = c.character_name
		char_info["outfit"] = c.current_outfit
		char_info["expression"] = c.current_expression
		char_info["position"] = c.current_position
		char_info["is_hidden"] = c.is_hidden
		char_array.append(char_info)
	Global.add_user_data_story_progress(current_scene, current_scene_index, char_array, current_location, "#" + backgrounds.self_modulate.to_html(false))
	Global.save_user_data()
	print("Progress is saved!")

#Adds a character sprite on the screen
func add_character(name : String, outfit : String, expression : String, char_position: String):
	var c = character.instance()
	c.initialize(name, outfit, expression, char_position)
	c.position = character_positions[char_position].position
	characters.add_child(c)
	character_dict[name] = c
	
#Deletes all character
func remove_characters(has_fade : bool = true):
	for c in character_dict.values():
		c.remove_character(has_fade)
	character_dict = {}

#Shows/Hides the character depending on passed boolean (hidden)
func toggle_character(name : String, hidden : bool, instant : bool = false):
	character_dict[name].toggle_character(hidden, false, instant)

#Changes the outfit/expression of the character, if parameter is blank, it will be ignored
func modify_character(name : String, outfit : String = "", expression : String = "", char_position : String = ""):
	if outfit != "":
		character_dict[name].change_outfit(outfit)
	if expression != "":
		character_dict[name].change_expression(expression)
	if char_position != "":
		character_dict[name].position = character_positions[char_position].position

#in charge of changing backgrounds and tint
func change_background(location : String = "", location_tint : String = ""):
	if location != "":
		backgrounds.animation = Data.backgrounds[location].Animation
		backgrounds.frame = Data.backgrounds[location].Frame
	if location_tint != "":
		backgrounds.self_modulate = Color(location_tint)

#scene animations
func apply_scene_animation(values : Dictionary) -> void:
	if values.animation == "shake":
		shake_strength = values.shake_strength
		shake_decay = values.shake_decay

#Incharge of displaying selections
func show_selection(selections : Array) -> void:
	choosing_selection = true
	skip_dialogue = false
	for i in range (0, selections.size()):
		var cs = choice_selection.instance()
		cs.next_scene_name = selections[i][1]
		cs.next_scene_index = selections[i][2]
		cs.position = choice_selection_position.position
		cs.position.y += (50 * i)
		choice_selections.append(cs)
		ui.add_child(cs)
		cs.set_choice_text(selections[i][0])
		print(Global.user_data["FinishedScenes"])
		if Global.check_if_scene_is_finished(selections[i][1]):
			cs.set_background("done")

#Incharge of selection ttimer
func set_selection_timer(type : String, time : float = 0) -> void:
	if type == "start":
		choice_timer.start(time)
		timer_node.show()
		has_choice_timer = true
	elif type == "stop":
		choice_timer.stop()
		timer_node.hide()
		has_choice_timer = false

#Incharge of editing, updating TypeBox
#Also adds word mastery
func update_typebox(type : String, letter : String = '') -> void:
	if skip_dialogue or ignore_typing:
		return
	if type == "delete":
		var s = type_box.text
		if s.length() > 0:
			s.erase(s.length() - 1, 1)
			type_box.parse_bbcode("[right]" + s + "[/right]")
			current_word_index -= 1
			check_word_mastery("force_wrong")
	elif type == "add":
		if current_letter_index >= current_dialogue.length():
			return
		if letter == " " and wrong_letter_length == 0 and current_dialogue[current_letter_index] == " ":
			check_word_mastery("add")
			type_box.text = ""
			check_word_mastery("reset")
		else:
			type_box.text += letter
			type_box.parse_bbcode("[right]" + type_box.text + "[/right]")
			check_word_mastery("check")
			current_word_index += 1
	elif type == "reset":
		type_box.text = ""
		check_word_mastery("reset")

#checks if the letters typed are correct, once wrong or backspaced it will be incorrect
#has also the ability to check the accuracy and add it to user data if type is "add"
func check_word_mastery(type : String):
	if type == "check":
		if typed_word_accuracy.has(current_word_index) and not typed_word_accuracy[current_word_index]:
			return
		if type_box.text[current_word_index] != current_dialogue[current_letter_index]:
			typed_word_accuracy[current_word_index] = false
		else:
			typed_word_accuracy[current_word_index] = true
	elif type == "force_wrong":
		typed_word_accuracy[current_word_index] = false
	elif type == "force_correct":
		typed_word_accuracy[current_word_index] = true
	elif type == "add":
		if typed_word_accuracy.size() <= 0:
			return
		var word_accuracy : float = typed_word_accuracy.values().count(true) / float(typed_word_accuracy.size())
		#Add letter mastery
		for i in range(type_box.text.length()):
			Global.add_letter_mastery(type_box.text[i], typed_word_accuracy[i])
			if not Data.unnecessary_characters.has(type_box.text[i]):
				if typed_word_accuracy[i]:
					total_accuracy[0] += 1
				else:
					total_accuracy[1] += 1
		#Add word mastery
		Global.add_word_mastery(type_box.text, word_accuracy)
		
	elif type == "reset":
		current_word_index = 0
		typed_word_accuracy = {}

#Gets and sets the current dialogue and and calls show_colored_dialogue()
func get_current_dialogue() -> void:
	var dialogue_data = Data.dialogues[current_scene][current_scene_index]
	var has_transition = false
	
	#If dialogue has transition, do that first then wait for it to emit a signal
	if dialogue_data.has("transition"):
		has_transition = true
		SceneTransition.add_transition(dialogue_data.transition)
		ignore_typing = true
		yield(SceneTransition, "transition_finished")
		ignore_typing = false
	
	#If dialouge has goto_chapter, do this and return
	if dialogue_data.has("goto_chapter"):
		var chap_data = dialogue_data.goto_chapter
		set_next_scene(chap_data[0], chap_data[1])
		return
		
	#Iterate through the dialogue and get all mastered words with index and length
	var word : String = ""
	var tmp : String = dialogue_data.dialogue + " "
	var starting_tmp : int = 0
	for i in range(0, tmp.length()):
		if tmp[i] != " ":
			word += tmp[i]
		else:
			#Check if word is mastered
			var formatted_word = Global.format_word(word)
			var mastery = Global.get_word_mastery(formatted_word)
			print(formatted_word, mastery)
			if mastery.size() > 0:
				if mastery.accuracy >= Data.WORD_MASTERY_ACCURACY_BOUND and mastery.count >= Data.WORD_MASTERY_COUNT_BOUND:
					mastered_word_indices[starting_tmp] = word.length()
					mastered_words[formatted_word] = true
					skipped_characters_length += word.length()
			word = ""
			starting_tmp = i
	
	#Remove character
	if dialogue_data.has("remove_character"):
		for c in dialogue_data.remove_character:
			c.remove_character(!has_transition)
	if dialogue_data.has("remove_all_characters"):
		remove_characters(!has_transition)
	
	#Check dialogue options
	if dialogue_data.has("skip_dialogue"):
		skip_dialogue = true
		toggle_space_label(true)
	else:
		skip_dialogue = false
	if dialogue_data.has("location"):
		current_location = dialogue_data.location
		change_background(current_location)
	if dialogue_data.has("location_tint"):
		change_background("", dialogue_data.location_tint)
	
	#Show current character
	if dialogue_data.has("forced_name"):
		character_name.text = dialogue_data.forced_name
	else:
		character_name.text = dialogue_data.character
	
	if not character_dict.has(dialogue_data.character) and Data.characters.has(dialogue_data.character):
		add_character(dialogue_data.character, dialogue_data.outfit, dialogue_data.expression, dialogue_data.position)
	else:
		if dialogue_data.has("outfit"):
			modify_character(dialogue_data.character, dialogue_data.outfit)
		if dialogue_data.has("expression"):
			modify_character(dialogue_data.character, "", dialogue_data.expression)
		if dialogue_data.has("position"):
			modify_character(dialogue_data.character, "", "", dialogue_data.position)
		if dialogue_data.has("show_character"):
			for c in dialogue_data.show_character:
				toggle_character(c, false, has_transition)
		if dialogue_data.has("show_all_characters"):
			for c in character_dict:
				toggle_character(c, false, has_transition)
		if dialogue_data.has("hide_character"):
			for c in dialogue_data.hide_character:
				toggle_character(c, true, has_transition)
		if dialogue_data.has("hide_all_characters"):
			for c in character_dict:
				toggle_character(c, true, has_transition)
	
	#show other chracters
	if dialogue_data.has("show_more_characters"):
		for c in dialogue_data.show_more_characters:
			if not character_dict.has(c.character) and Data.characters.has(c.character):
				add_character(c.character, c.outfit, c.expression, c.position)
			else:
				modify_character(c.character, c.outfit, c.expression, c.position)
				
	
	#add character animation
	if dialogue_data.has("character_animation"):
		for c in dialogue_data.character_animation:
			if character_dict.has(c.character):
				character_dict[c.character].play_animation(c.anim)
	
	#Check if words should be skipped
	var has_mastered_words = false
	while mastered_word_indices.has(current_letter_index):
		current_letter_index += mastered_word_indices[current_letter_index] + int(current_letter_index != 0)
		has_mastered_words = true
	if has_mastered_words:
		current_letter_index += 1
	
	#dialogue remark
	if dialogue_data.has("dialogue_remark"):
		current_dialogue_remark = dialogue_data.dialogue_remark
	else:
		current_dialogue_remark = ""
	
	#Show current dialogue
	current_dialogue = dialogue_data.dialogue
	show_colored_dialogue(dialogue)
	
	#Add scene animation
	if dialogue_data.has("scene_animation"):
		apply_scene_animation(dialogue_data.scene_animation)
	
#Gets the next dialouge and calls get_current_dialogue
func set_next_dialogue() -> void:
	current_scene_index += 1
	mastered_word_indices.clear()
	mastered_words.clear()
	if(current_scene_index >= Data.dialogues[current_scene].size() - 1):
		show_stats_menu()
		Global.add_finished_scenes(current_scene)
		return
	get_current_dialogue()
	update_typebox("reset")

#Shows current wpm, adds it to overall wpm, then resets info for new wpm
func register_wpm() -> void:
	if total_time > 0:
		current_wpm = (current_dialogue.length() - skipped_characters_length) * 60 / (5 * total_time)
		total_wpm[0] += current_wpm
		total_wpm[1] += 1
		Global.add_overall_wpm(current_wpm)
		wpm_label.text = "WPM : " + String(floor(current_wpm))
	else:
		wpm_label.text = "WPM : -"
	tracing_wpm = false
	total_time = 0
	skipped_characters_length = 0

func toggle_space_label(b : bool) -> void:
	if b:
		space_label.show()
	else:
		space_label.hide()

#adds history text
func add_history_text(type : String, name : String, dialogue : String) -> void:
	var text : String = ""
	if type == "dialogue":
		text = "[color=#" + light_blue.to_html(false) + "]" + name + ":  [/color]" + dialogue + "\n"
	else:
		text = "[color=#" + yellow.to_html(false) + "]" + dialogue + "[/color]\n"
	history_text_storage += text
	history_text.parse_bbcode(history_text_storage)

#Sets neccesary variables to be ready for the next scene
func set_next_scene(scene_name : String, scene_index : int = 0) -> void:
	current_scene = scene_name
	current_scene_index = scene_index
	current_letter_index = 0
	wrong_letter_length = 0
	total_wpm = [0, 0]
	total_accuracy = [0, 0]
	total_time = 0
	typing_target = "dialogue"
	mastered_word_indices.clear()
	typed_word_accuracy.clear()
	mastered_words.clear()
	current_word_index = 0
	#Remove choice selections
	for selection in choice_selections:
		selection.queue_free()
	choice_selections = []
	ignore_typing = false
	has_choice_timer = false
	chosen_selection = null
	choosing_selection = false
	remove_characters(false)
	character_dict.clear()
	update_typebox("reset")
	get_current_dialogue()

#Shows the dialogue on the display with color and alignment
func show_colored_dialogue(textbox : RichTextLabel, alignment : String = "") -> void:
	#Replace current_dialogue [name]
	current_dialogue = current_dialogue.replacen("[name]", Global.user_data["Name"])
	current_dialogue_remark = current_dialogue_remark.replacen("[name]", Global.user_data["Name"])
	
	if skip_dialogue:
		var remark = ""
		if current_dialogue_remark != "":
			remark = " [color=#" + light_blue.to_html(false) + "]" + current_dialogue_remark + "[/color]"
		textbox.parse_bbcode("[color=#" + light_orange.to_html(false) + "]" + current_dialogue + "[/color]" + remark)
		return
		
	var green_text = format_color_paragraph(mastered_words, current_dialogue.substr(0, current_letter_index), green)
	var red_text = ""
	if wrong_letter_length > 0:
		red_text = format_color_paragraph(mastered_words, current_dialogue.substr(current_letter_index, wrong_letter_length), red)
	var white_text = format_color_paragraph(mastered_words, current_dialogue.substr(current_letter_index + wrong_letter_length, current_dialogue.length()), white)
	
	var alignment_start_tag = ""
	var alignment_close_tag = ""
	if alignment != "":
		alignment_start_tag = "[" + alignment + "]"
		alignment_close_tag = "[/" + alignment + "]"
	
	var remark = ""
	if current_dialogue_remark != "":
		remark = " [color=#" + light_blue.to_html(false) + "]" + current_dialogue_remark + "[/color]"
	
	textbox.parse_bbcode(alignment_start_tag + "\"" + green_text + red_text + white_text + "\"" + alignment_close_tag + remark)

#Gets the words that should be ignored and adds a yellow color and striketrough
func format_color_paragraph(words : Dictionary, paragraph : String, color : Color) -> String:
	var color_start_tag = "[color=#" + color.to_html(false) + "]"
	var color_end_tag = "[/color]"
	var color_strikethrough = yellow
	paragraph = color_start_tag + paragraph
	
	if typing_target == "choice":
		return paragraph + color_end_tag
	
	for word in words:
		var index = paragraph.findn(word, 0)
		while index > -1 and index < paragraph.length():
			if index + word.length() < paragraph.length():
				if not Data.unnecessary_characters.has(paragraph[index + word.length()]):
					index += 1
					continue
			if index - 1 > 0:
				if not Data.unnecessary_characters.has(paragraph[index-1]):
					index += 1
					continue
			
			var orig_word = paragraph.substr(index, word.length())
			paragraph.erase(index, word.length())
			if color == green:
				color_strikethrough = green
			paragraph = paragraph.insert(index, color_end_tag + add_strikethrough_and_color(orig_word, color_strikethrough) + color_start_tag)
			index = paragraph.findn(word, index + word.length() + 2 + color_end_tag.length() + color_start_tag.length())
		#paragraph = paragraph.replacen(word, add_strikethrough(word))
	paragraph += "[/color]"
	return paragraph

func add_strikethrough_and_color(word : String, color : Color) -> String:
	return "[color=#" + color.to_html(false) + "][s]" + word + "[/s][/color]"

func _unhandled_input(event : InputEvent) -> void:
	if ignore_typing:
		return
	
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var typed_event = event as InputEventKey
		var key_typed = PoolByteArray([typed_event.unicode]).get_string_from_utf8()
		
		#start tracing wpm (RECHECK)
		if typed_event.unicode != 0:
			tracing_wpm = true
			
		if stats_menu.visible:
			if typed_event.scancode == 32:
				get_current_dialogue()
				update_typebox("reset")
				stats_menu.hide()
			return
			
		#Focus on finding the choice selection if choosing selection is true
		if choosing_selection:
			var has_chosen_selection = false
			for selection in choice_selections:
				var selection_text = selection.choice_label_text
				if selection_text.substr(0, 1) == key_typed:
					chosen_selection = selection
					chosen_selection.set_background("active")
					current_dialogue = selection_text
					choosing_selection = false
					has_chosen_selection = true
			if not has_chosen_selection:
				return
		
		var character_to_type = current_dialogue.substr(current_letter_index, 1)
		
		if typed_event.scancode == 32:
			dialogue_space = true
		else:
			dialogue_space = false
		
		#Update Typebox
		if Input.is_action_pressed("ui_backspace"):
			update_typebox("delete")
			if wrong_letter_length <= 0:
				if not current_letter_index <= 0 and not current_dialogue[current_letter_index-1] == " ":
					current_letter_index -= 1
					if typing_target == "dialogue":
						show_colored_dialogue(dialogue)
					elif typing_target == "choice":
						show_colored_dialogue(chosen_selection.choice_text, "center")
			else:
				wrong_letter_length -= 1
		else:
			if typed_event.unicode != 0:
				if current_letter_index > current_dialogue.length():
					current_letter_index = current_dialogue.length()
					key_typed = character_to_type
					wrong_letter_length = 0
				else:
					update_typebox("add", key_typed)
			
		#TESTING
		if (skip_dialogue and typed_event.scancode == 32) or (debug_mode and typed_event.scancode == 16777233):
			current_letter_index = current_dialogue.length()
			key_typed = character_to_type
			wrong_letter_length = 0
			total_time = 0
			typed_event.scancode = 32
		
		#RECHECK THIS (SPACE AFTER DIALOGUE), TESTING?
		if current_letter_index == current_dialogue.length()-1 and (key_typed == character_to_type and wrong_letter_length <= 0):
			#key_typed = character_to_type
			#wrong_letter_length = 0
			register_wpm()
			toggle_space_label(true)
			if has_choice_timer:
				set_selection_timer("stop")
		elif current_letter_index >= current_dialogue.length():
			key_typed = character_to_type
			wrong_letter_length = 0
			toggle_space_label(false)
		
		#Update Dialogue
		if key_typed == character_to_type and wrong_letter_length <= 0:
			wrong_letter_length = 0
			
			#If mastered word is encountered, skip
			while mastered_word_indices.has(current_letter_index) and typing_target != "choice":
				current_letter_index += mastered_word_indices[current_letter_index] + 1
				if current_letter_index > current_dialogue.length():
					current_letter_index = current_dialogue.length()
				
			if not mastered_word_indices.has(current_letter_index) or typing_target == "choice":
				current_letter_index += 1
			
			if current_letter_index >= current_dialogue.length() and typed_event.scancode == 32:
				#Call show_colored_dialouge again to color the last letter
				if typing_target == "dialogue":
					show_colored_dialogue(dialogue)
					
				#Call word mastery to include last word and register WPM
				check_word_mastery("add")
				#register_wpm()
				update_typebox("reset")
				
				#wpm box reset
				wpm_label.text = "WPM : -"
				
				#If the dialogue has choices, switch typing target to choice
				current_letter_index = 0
				if Data.dialogues[current_scene][current_scene_index].has("show_selection") and typing_target == "dialogue":
					show_selection(Data.dialogues[current_scene][current_scene_index].show_selection)
					if Data.dialogues[current_scene][current_scene_index].has("show_selection_timer"):
						set_selection_timer("start", Data.dialogues[current_scene][current_scene_index].show_selection_timer)
					add_history_text(typing_target, character_name.text, current_dialogue)
					typing_target = "choice"
					update_typebox("reset")
				elif typing_target == "choice":
					if has_choice_timer:
						set_selection_timer("stop")
					add_history_text(typing_target, character_name.text, current_dialogue)
					Global.add_finished_scenes(current_scene)
					
					#If same scene, do not reset, change index only and run ncessessary functions
					if chosen_selection.next_scene_name == current_scene:
						current_scene_index = chosen_selection.next_scene_index
						update_typebox("reset")
						typing_target = "dialogue"
						get_current_dialogue()
						#Remove choice selections
						for selection in choice_selections:
							selection.queue_free()
						choice_selections = []
						ignore_typing = false
						has_choice_timer = false
						chosen_selection = null
						choosing_selection = false
						
					else:
						set_next_scene(chosen_selection.next_scene_name, chosen_selection.next_scene_index)
						
				elif typing_target == "dialogue":
					add_history_text(typing_target, character_name.text, current_dialogue)
					set_next_dialogue()
		else:
			#Space should also be included as wrong letter
			if typed_event.unicode != 0 or typed_event.scancode == 32:
				wrong_letter_length += 1
		
		if typing_target == "dialogue":
			show_colored_dialogue(dialogue)
		elif typing_target == "choice":
			if chosen_selection != null:
				current_dialogue_remark = ""
				show_colored_dialogue(chosen_selection.choice_text, "center")

func show_stats_menu():
	var title_label = stats_menu.get_node("TitleLabel")
	var cur_stats_label = stats_menu.get_node("CurrentStatsLabel")
	var overall_stats_label = stats_menu.get_node("OverallStatsLabel")
	var time_spent_label = stats_menu.get_node("TimeSpentLabel")
	var letter_diff_label = stats_menu.get_node("LetterDifficultyLabel")
	
	var cur_wpm = 0
	var cur_accuracy = 0
	if total_wpm[1] > 0:
		cur_wpm = total_wpm[0] / float(total_wpm[1])
	if total_accuracy[0] + total_accuracy[1] > 0:
		cur_accuracy = total_accuracy[0] / float(total_accuracy[0] + total_accuracy[1])
	var overall_stats = Global.get_user_stats()
	
	title_label.text = current_scene + " - DONE"
	cur_stats_label.text = "Current WPM: " + String(cur_wpm) + "\nCurrent Accuracy: " + String(cur_accuracy * 100)
	overall_stats_label.text = "Overall WPM: " + String(overall_stats["WPM"]) + "\nOverall Accuracy: " + String(overall_stats["Accuracy"] * 100)
	time_spent_label.text = "Time Spent: " + String(chapter_play_time / 60) + " minutes"
	letter_diff_label.text = "Keys that should be practiced: "
	
	#Reset time spent/RECHECK/TESTING
	chapter_play_time = 0
	
	var diff_letters = overall_stats["Difficult_Letters"]
	print(diff_letters,"?")
	if diff_letters.size() <= 0:
		letter_diff_label.text += "None"
	else:
		for i in range(0, diff_letters.size() - 1):
			letter_diff_label.text += String(diff_letters[i])
			if i < diff_letters.size() - 2:
				letter_diff_label.text += ", "
	print(Global.user_data)
	stats_menu.show()

#==========Connected Functions==========#
func _on_SaveButton_pressed():
	save_progress()

func _on_LoadButton_pressed():
	#Just restart scene for now
	#TESTING
	get_tree().reload_current_scene()

func _on_ChoiceTimer_timeout():
	timer_pop_up.show()
	ignore_typing = true
	set_selection_timer("stop")
	
func _on_TimerPopUp_confirmed():
	ignore_typing = false
	choosing_selection = false
	typing_target = "dialogue"
	current_letter_index = 0
	wrong_letter_length = 0
	mastered_word_indices.clear()
	typed_word_accuracy.clear()
	mastered_words.clear()
	current_word_index = 0
	for selection in choice_selections:
		selection.queue_free()
	choice_selections = []
	chosen_selection = null
	update_typebox("reset")
	get_current_dialogue()

func on_scene_transition_finished():
	pass

func _on_HistoryButton_pressed():
	history_menu.show()

func _on_HideHistoryButton_pressed():
	history_menu.hide()

func _on_NameChangeButton_pressed():
	Global.change_name(name_edit.text)
	name_menu.hide()

#Testing
func _on_TestButton2_pressed():
	Global.switch_scene("MainMenu")
