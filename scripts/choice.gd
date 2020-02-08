extends Sprite

onready var choice_text = get_node("choice_text")

func _ready():
	pass 
	
func show_choice(choice, value):
	choice_text.show_choice(choice, value)
