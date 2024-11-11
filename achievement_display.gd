# achievement_display.gd
extends Window

@onready var achievement_container = $MarginContainer/ScrollContainer/VBoxContainer

func _ready() -> void:
	# Connect to achievement signals
	AchievementManager.achievement_unlocked.connect(_on_achievement_unlocked)
	AchievementManager.achievements_loaded.connect(_update_achievement_display)
	AchievementManager.achievements_reset.connect(_update_achievement_display)
	
	# Initial display update
	_update_achievement_display()
	
	# Hide window initially
	hide()
	
func _update_achievement_display() -> void:
	# Clear existing children
	for child in achievement_container.get_children():
		child.queue_free()
	
	# Display all achievements
	for achievement in AchievementManager.get_all_achievements():
		var achievement_panel = PanelContainer.new()
		achievement_panel.add_theme_constant_override("padding", 8)
		
		var vbox = VBoxContainer.new()
		achievement_panel.add_child(vbox)
		
		var name_label = Label.new()
		name_label.text = achievement.name
		name_label.add_theme_font_size_override("font_size", 18)
		name_label.add_theme_constant_override("outline_size", 2)
		vbox.add_child(name_label)
		
		var desc_label = Label.new()
		desc_label.text = achievement.description
		desc_label.modulate = Color(0.8, 0.8, 0.8)
		vbox.add_child(desc_label)
		
		if achievement.unlocked:
			achievement_panel.modulate = Color(0.7, 1.0, 0.7)
			name_label.text += " ✓"
		else:
			achievement_panel.modulate = Color(0.7, 0.7, 0.7)
		
		achievement_container.add_child(achievement_panel)

func _on_achievement_unlocked(_achievement_name: String) -> void:
	_update_achievement_display()

func _on_close_requested() -> void:
	hide()
