extends Node2D

var script = {}
var script_file = File.new()
var script_state = []
var state = ''
var finished = false

onready var dialogue = get_node("dialogue")
onready var caption = get_node("caption")
onready var menu = get_node("menu")

func _ready():
	script_file.open("res://assets/script.json", script_file.READ)
	script = parse_json(script_file.get_as_text())
	set_process_input(true)
	dialogue.hide()
	caption.hide()
	menu.hide()
	_jump('start');

func _input(event):
	if event is InputEventMouse && event.is_pressed() and state != 'menu':
		if finished:
			_advance_script()
		else:
			dialogue.advance()

func _advance_script():
	finished = false
	var line = _get_line()
	if typeof(line) == TYPE_DICTIONARY and line.has('text'):
		_show_dialogue(line)
	elif typeof(line) == TYPE_ARRAY and line[0].has('choice'):
		_show_menu(line)
	elif typeof(line) == TYPE_DICTIONARY and line.has('action'):
		if line['action'] == 'jump':
			_jump(line['label'])

func _show_dialogue(line):
	if state == 'menu':
		menu.hide()
	state = 'dialogue'
	dialogue.show_dialogue(line['text'])
	if line['caption'] == '':
		caption.hide()
	else:
		caption.show_caption(line['caption'])

func _show_menu(line):
	if state == 'dialogue':
		caption.hide()
		dialogue.hide()
	state = 'menu'
	menu.show_menu(line)

func _jump(label):
	script_state = [{'label': label,
					 'state': 0}]
	_advance_script()	

func _get_block():
	pass

func _get_line():
	var label = null
	var i = null
	for j in range(script_state.size()-1, -1, -1):
		if script_state[j].has('label'):
			label = script_state[j]['label']
			i = j
			break
	var line = script[label][script_state[i]['state']]
	for k in range(i+1, script_state.size()):
		if script_state[k].has('action') and script_state[k]['action'] == 'choice':
			line = line[script_state[k]['choice']]['result']
			if script_state[k].has('state'):
				if script_state[k]['state'] >= line.size():
					script_state.pop_back()
					script_state[-1]['state'] += 1
					return _get_line()
				else:
					line = line[script_state[k]['state']]
	print(line)
	if typeof(line) == TYPE_DICTIONARY and line.has('caption'):
		script_state[-1]['state'] += 1
		return line
	elif typeof(line) == TYPE_DICTIONARY and line.has('action'):
		if line['action'] == 'jump':
			return line
	elif typeof(line) == TYPE_ARRAY and line.size() == 0:
		print("WHAT")
		script_state.pop_back()
		script_state[-1]['state'] += 1
		return _get_line()
	elif typeof(line) == TYPE_ARRAY and line[0].has('choice'):
		script_state.push_back({'action': 'choice'})
		return line
	elif typeof(line) == TYPE_ARRAY:
		script_state[-1]['state'] = 0
		return _get_line()

func _on_dialogue_text_dialogue_line_finished():
	finished = true
	
func _on_choice_selected(choice):
	script_state[-1]['choice'] = choice
	_advance_script()
