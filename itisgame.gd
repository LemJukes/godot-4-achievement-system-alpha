extends Control

var score: int = 0
@onready var score_value = get_node("%ScoreValLabel")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_value.text = str(score)

func _on_score_button_pressed() -> void:
	score += 1
	score_value.text = str(score)
