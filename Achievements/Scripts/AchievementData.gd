extends Node

const DEFAULT_ACHIEVEMENT_DATA_FILE = "res://Achievements/Data/Default_Achievement_File.json";
const ACTUAL_ACHIEVEMENT_DIRECTORY = "user://Achievement System/";
const ACTUAL_ACHIEVEMENT_DATA_FILE = ACTUAL_ACHIEVEMENT_DIRECTORY + "Actual_Achievement_File.json";
const ACHIEVEMENT_SCRIPT = "res://Achievements/Scripts/Achievement.gd";

var achievements: Dictionary = {};

func _init() -> void:
	achievements = get_default_achievements();
	load_actual_achievements();
	save();

func get_default_achievements() -> Dictionary:
	var file := FileAccess.open(DEFAULT_ACHIEVEMENT_DATA_FILE, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text()).result
	
	for key in data:
		var achievement = load(ACHIEVEMENT_SCRIPT).instantiate()
		achievement.set_data(data[key])
		data[key] = achievement
	
	return data

func load_actual_achievements():
	var file := FileAccess.open(ACTUAL_ACHIEVEMENT_DATA_FILE, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text()).result
	
	if data:
		for achievement_name in data:
			if achievements[achievement_name] != null:
				for property in data[achievement_name]:
					if achievements[achievement_name].is_key_user_data(property):
						achievements[achievement_name].set_value(property, data[achievement_name][property]);

func save() -> void:
	var dict_save: Dictionary = {};
	
	for entry in achievements:
		dict_save[entry] = {};
		for property in achievements[entry].values:
			if achievements[entry].is_key_user_data(property):
				dict_save[entry][property] = achievements[entry].get_value(property);

	var dir := DirAccess.open("user://")
	dir.make_dir_recursive(ACTUAL_ACHIEVEMENT_DIRECTORY)
	if dir and dir.make_dir_recursive(ACTUAL_ACHIEVEMENT_DIRECTORY) != OK:
		push_error("Failed to create achievement directory")
	var file := FileAccess.open(ACTUAL_ACHIEVEMENT_DATA_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify(dict_save))
	file.close()

func get_achievements() -> Dictionary:
	return achievements;
