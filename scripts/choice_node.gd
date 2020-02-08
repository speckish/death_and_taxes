extends Node2D

onready var choice = get_node("choice")

func _ready():
	pass
	
func show_choice(text, value):
	choice.show_choice(text, value)
