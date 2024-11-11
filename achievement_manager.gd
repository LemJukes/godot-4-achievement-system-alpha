# achievement_manager.gd
extends Node

signal achievement_unlocked(achievement_name: String)
signal achievements_loaded
signal achievements_reset

# Dictionary to store achievement definitions
var achievements := {}

func _ready() -> void:
	load_achievements()

# Reset all achievements to locked state
func reset_achievements() -> void:
	for achievement_id in achievements:
		achievements[achievement_id].unlocked = false
	achievements_reset.emit()

# Check if score triggers any achievements
func check_achievements(score: int) -> void:
	for achievement_id in achievements:
		var achievement = achievements[achievement_id]
		if not achievement.unlocked and score >= achievement.requirement:
			unlock_achievement(achievement_id)

# Unlock an achievement
func unlock_achievement(achievement_id: String) -> void:
	if achievement_id in achievements:
		achievements[achievement_id].unlocked = true
		achievement_unlocked.emit(achievements[achievement_id].name)
		save_achievements()

# Save achievement states
func save_achievements() -> void:
	var save_data = SaveManager.load_game_data()
	
	# Create achievements section if it doesn't exist
	if not save_data.has("achievements"):
		save_data["achievements"] = {}
	
	# Update only the achievements data
	for achievement_id in achievements:
		save_data["achievements"][achievement_id] = achievements[achievement_id].unlocked
	
	SaveManager.save_game_data(save_data)

# Load achievement states
func load_achievements() -> void:
	if not FileAccess.file_exists(SaveManager.SAVE_FILE_PATH):
		achievements_loaded.emit()
		return
		
	var save_file = FileAccess.open(SaveManager.SAVE_FILE_PATH, FileAccess.READ)
	if save_file == null:
		achievements_loaded.emit()
		return
		
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result == OK:
		var save_data = json.get_data()
		if save_data.has("achievements"):
			for achievement_id in save_data.achievements:
				if achievement_id in achievements:
					achievements[achievement_id].unlocked = save_data.achievements[achievement_id]
	
	achievements_loaded.emit()

# Get all achievements for display
func get_all_achievements() -> Array:
	var achievement_list := []
	for achievement_id in achievements:
		achievement_list.append(achievements[achievement_id])
	return achievement_list
