extends Sprite

onready var caption_text = get_node('caption_text')

func _ready():
	visible = false

func show_caption(text):
	visible = true
	caption_text.show_caption(text);
	
func hide():
	visible = false
	caption_text.visible = false