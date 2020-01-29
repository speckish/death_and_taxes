extends Node2D

const choice = preload("res://scenes/choice.tscn")

func _ready():
	visible = false
	
func show_menu(choices):
	visible = true
	var length = choices.size()
	var spacing = 100
	var y = get_viewport_rect().size.y/2 - ((choices.size() - 1) * spacing / 2)
	for i in choices.size():
		var c = choice.instance()
		add_child(c)
		c.show_choice(choices[i]['choice'], i)
		c.set_position(Vector2(get_viewport_rect().size.x/2, y))
		y += spacing
	
func hide():
	visible = false
