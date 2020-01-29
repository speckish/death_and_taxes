extends RichTextLabel

func _ready():
	visible = false

func show_caption(text):
	set_bbcode(text)
	visible = true
