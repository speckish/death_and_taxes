extends Sprite

onready var dialogue_text = get_node('dialogue_text')

func _ready():
	visible = false

func advance():
	dialogue_text.advance()

func show_dialogue(text):
	visible = true
	dialogue_text.visible = true
	dialogue_text.show_dialogue(text);
	
func hide():
	visible = false
	dialogue_text.visible = false
