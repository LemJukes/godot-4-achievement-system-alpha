# itisgame.gd
extends Control

var score: int = 0
@onready var score_value = get_node("%ScoreValLabel")

# Path for save file
const SAVE_FILE_PATH = "user://savegame.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()  # Try to load existing save when game starts

# Called every frame
func _process(_delta: float) -> void:
	save_game()  # Autosave every frame

func _on_score_button_pressed() -> void:
	score += 1
	score_value.text = str(score)
	print("Score: ", score)

# Save game data to file
func save_game() -> void:
	# Create a dictionary with game data
	var save_dict = {
		"score": score,
		"timestamp": Time.get_unix_time_from_system()
	}
	
	# Create save file
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if save_file == null:
		print("Error saving game: ", FileAccess.get_open_error())
		return
		
	# Convert dictionary to JSON string and save
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)
	
# Load game data from file
func load_game() -> void:
	# Check if save file exists
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		print("No save file found")
		return
		
	# Open save file
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if save_file == null:
		print("Error loading game: ", FileAccess.get_open_error())
		return
		
	# Parse JSON data
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		print("JSON Parse Error: ", json.get_error_message())
		return
		
	var save_dict = json.get_data()
	
	# Load game data
	score = save_dict["score"]
	score_value.text = str(score)
	print("Game loaded. Score: ", score)
