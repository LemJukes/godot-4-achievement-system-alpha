# save_manager.gd
extends Node

signal save_completed
signal load_completed
signal save_error(error_message: String)
signal load_error(error_message: String)

const SAVE_FILE_PATH = "user://savegame.json"

# Save game data to file
func save_game_data(game_data: Dictionary) -> void:
	# Add timestamp to save data
	game_data["timestamp"] = Time.get_unix_time_from_system()
	
	# Create save file
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if save_file == null:
		var error = FileAccess.get_open_error()
		save_error.emit("Error saving game: " + str(error))
		return
		
	# Convert dictionary to JSON string and save
	var json_string = JSON.stringify(game_data)
	save_file.store_line(json_string)
	save_completed.emit()
	
# Load game data from file
func load_game_data() -> Dictionary:
	var empty_data = {}
	
	# Check if save file exists
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		load_error.emit("No save file found")
		return empty_data
		
	# Open save file
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if save_file == null:
		var error = FileAccess.get_open_error()
		load_error.emit("Error loading game: " + str(error))
		return empty_data
		
	# Parse JSON data
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		load_error.emit("JSON Parse Error: " + json.get_error_message())
		return empty_data
		
	var save_dict = json.get_data()
	load_completed.emit()
	return save_dict

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		DirAccess.remove_absolute(SAVE_FILE_PATH)
		print("Save Deleted")
