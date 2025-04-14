extends BaseUI

func _init():
	super._init(&"difficulty")

func _on_button_easy_pressed() -> void:
	Core.game_difficulty = Core.GameDifficulty.EASY
	Core.game.start()

func _on_button_normal_pressed() -> void:
	Core.game_difficulty = Core.GameDifficulty.NORMAL
	Core.game.start()

func _on_button_hard_pressed() -> void:
	Core.game_difficulty = Core.GameDifficulty.HARD
	Core.game.start()
