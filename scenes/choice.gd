extends Button

signal selected
onready var choice_text = get_node("choice_text")
var value = null

func _ready():
	visible = false
	self.connect("selected", get_parent().get_parent().get_parent(), "_on_choice_selected")
	emit_signal("selected")
	

func show_choice(text, val):
	# set_text(text)
	choice_text.set_text(text)
	value = val
	visible = true

func _on_choice_pressed():
	emit_signal('selected', value)
