extends Node

var values: Dictionary = {}

func _init(initial_values: Dictionary) -> void:
    values = initial_values

func set_value(key: String, value) -> void:
    if key in values:
        values[key][key] = value

func get_value(key: String):
    if key in values:
        return values[key][key]
    return null

func is_key_user_data(key: String) -> bool:
    if key in values and "userData" in values[key]:
        return values[key]["userData"]
    return false

func get_achvName() -> String:
    var name = get_value("achvName")
    return name if name != null else "Name Not Set"

func get_desc() -> String:
    var desc = get_value("desc")
    return desc if desc != null else "Desc Not Set"

func get_progress() -> int:
    var progress = get_value("progress")
    return progress if progress != null else 0

func get_total() -> int:
    var total = get_value("total")
    return total if total != null else 1

func has_custom_progress_bar_colors() -> bool:
    return "progress-bar-background-color" in values and "progress-bar-color" in values

func get_progress_bar_background_color() -> Color:
    return Color(get_value("progress-bar-background-color"))

func get_progress_bar_color() -> Color:
    return Color(get_value("progress-bar-color"))

func has_picture() -> bool:
    return "picture" in values

func get_picture_location() -> String:
    return get_value("picture")

func increment(amount: int) -> void:
    values["progress"]["progress"] = get_value("progress") + amount