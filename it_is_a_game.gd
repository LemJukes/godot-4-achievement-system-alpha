# itisgame.gd
extends Control

var score: int = 0
@onready var score_value = get_node("%ScoreValLabel")
@onready var achievement_window = preload("res://achievement_display.tscn").instantiate()
var notification_scene = preload("res://achievement_notification.tscn")
var active_notifications = []  # Track active notification windows

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to SaveManager signals
	SaveManager.save_completed.connect(_on_save_completed)
	SaveManager.load_completed.connect(_on_load_completed)
	SaveManager.save_error.connect(_on_save_error)
	SaveManager.load_error.connect(_on_load_error)
	# Add achievement windows
	add_child(achievement_window)
	add_child(achievement_window)
	AchievementManager.achievement_unlocked.connect(_on_achievement_unlocked)

	# Connect achievements button
	get_node("AspectRatioContainer/VBoxContainer/HBoxContainer4/AchievementsButton").pressed.connect(_on_achievements_button_pressed)
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
		AchievementManager.check_achievements(score)

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
	AchievementManager.check_achievements(score)


func _on_reset_button_pressed() -> void:
	SaveManager.delete_save()
	AchievementManager.reset_achievements()
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_achievements_button_pressed() -> void:
	if achievement_window.visible:
		achievement_window.hide()
	else:
		achievement_window.show()

func cleanup_notifications() -> void:
	# Remove any null (closed) notifications from our array
	active_notifications = active_notifications.filter(func(notif): return is_instance_valid(notif))

func _on_achievement_unlocked(achievement_name: String) -> void:
	cleanup_notifications()
	
	# Find the achievement details
	for achievement in AchievementManager.get_all_achievements():
		if achievement.name == achievement_name:
			# Create new notification instance
			var achvNotification = notification_scene.instantiate()
			add_child(achvNotification)
			active_notifications.append(achvNotification)
			
			# Set up the new notification with appropriate vertical offset
			achvNotification.setup_notification(
				achievement_name, 
				achievement.description, 
				active_notifications.size() - 1
			)
			
			# Connect to its close_requested signal to remove it from our array
			achvNotification.close_requested.connect(
				func(): active_notifications.erase(achvNotification),
				CONNECT_ONE_SHOT
			)
			break
