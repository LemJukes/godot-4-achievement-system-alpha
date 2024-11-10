# itisgame.gd
extends Control

var score: int = 0
@onready var score_value = get_node("%ScoreValLabel")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to SaveManager signals
	SaveManager.save_completed.connect(_on_save_completed)
	SaveManager.load_completed.connect(_on_load_completed)
	SaveManager.save_error.connect(_on_save_error)
	SaveManager.load_error.connect(_on_load_error)
	
	load_game()  # Try to load existing save when game starts

func save_game() -> void:
	var save_dict = {
		"score": score
	}
	SaveManager.save_game_data(save_dict)

func load_game() -> void:
	var save_data = SaveManager.load_game_data()
	if !save_data.is_empty():
		score = save_data["score"]
		score_value.text = str(score)

# Signal handlers for SaveManager
func _on_save_completed() -> void:
	print("Game saved successfully")

func _on_load_completed() -> void:
	print("Game loaded successfully")

func _on_save_error(error_message: String) -> void:
	print("Save error: ", error_message)

func _on_load_error(error_message: String) -> void:
	print("Load error: ", error_message)

func _on_score_button_pressed() -> void:
	score += 1
	score_value.text = str(score)
	print("Score: ", score)
	save_game()  # Save when score changes

func _on_reset_button_pressed() -> void:
	SaveManager.delete_save()
	get_tree().reload_current_scene()
	pass # Replace with function body.
