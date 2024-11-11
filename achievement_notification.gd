# achievement_notification.gd
extends Window

@onready var description_label = $MarginContainer/Label

var vertical_offset = 0

func _ready() -> void:
	close_requested.connect(_on_close_requested)
	hide()

func setup_notification(achievement_name: String, description: String, offset: int) -> void:
	title = "Achievement Unlocked: " + achievement_name
	description_label.text = description
	
	# Position window in top-right with vertical offset
	var screen_size = DisplayServer.window_get_size()
	position = Vector2i(screen_size.x - 350, 50 + (offset * 120))
	
	show()

func _on_close_requested() -> void:
	hide()
