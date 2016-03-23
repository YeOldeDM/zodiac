
extends RichTextLabel

func _ready():
	set_scroll_follow(true)

func say(text):
	newline()
	append_bbcode(text)


