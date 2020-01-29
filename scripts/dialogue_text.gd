extends RichTextLabel

var dialogue = ["Test 1klsdjfklsadjfljsdkl;fjskal;djfkl;ajsdfklsajdklfjasdklfjkalsdjfklsdjfklasdjf",
				"test 2",
				"TEST 3"]

var script = {'start': [{'caption': '', 'text': 'Dog shows up.'},
						{'caption': 'Dog', 'text': 'Hello, ${player_name}'},
						{'caption': 'Dog', 'text': 'Welcome to renser, this is an example game.'},
						[{'choice': 'Yes!', 'result': [{'caption': '', 'text': 'Yes!'}]},
						{'choice': 'Of course!', 'result': [{'caption': '', 'text': 'Of course!'}]},
						{'choice': 'Absolutely!', 'result': [{'caption': '', 'text': 'Absolutely!'}]}]]}
var label = 'start'
var script_state = [0]
var page = 0

func _ready():
	set_process_input(true)
	_jump('start');

func _input(event):
	if event is InputEventMouse && event.is_pressed():
		if get_visible_characters() > get_total_character_count():
			_ready_line()
	else:
		set_visible_characters(get_total_character_count())

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1)
	
func _ready_line():
	var line = _get_line()
	print(line)
	if typeof(line) == TYPE_DICTIONARY and line.has('text'):
		set_bbcode(line['text'])
		set_visible_characters(0)
	elif typeof(line) == TYPE_ARRAY and line[0].has('choice'):
		pass
	
func _jump(new_label):
	label = new_label
	script_state = [0]
	_ready_line()	
	
func _get_line():
	var line = script[label]
	for i in script_state:
		line = line[i]
	if typeof(line) == TYPE_DICTIONARY:
		script_state[-1] += 1
		return line
	elif typeof(line) == TYPE_ARRAY and line.size() == 0:
		script_state.pop_back()
		script_state[-1] += 1
		return _get_line()
	elif typeof(line) == TYPE_ARRAY and line[0].has('choice'):
		return line
	elif typeof(line) == TYPE_ARRAY:
		script_state.push_back(0)
		return _get_line()
	