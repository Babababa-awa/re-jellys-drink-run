extends BaseUI

func _init():
	super._init(&"win")
	
func _ready() -> void:
	_update_button_visibility()

func show_ui():
	super.show_ui()
	
	Core.audio.play_sfx(&"ui/win")
	_update_button_visibility()
	
	if Core.level != null:
		%LabelTimeValue.text = Core.format_time(Core.level.get_play_time())
	else:
		%LabelTimeValue.text = Core.format_time(0)

		
func _update_button_visibility() -> void:
	if Core.game_difficulty == Core.GameDifficulty.EASY:
		%ButtonPlayAgainNormal.visible = true
		%ButtonPlayAgainHard.visible = false
	elif Core.game_difficulty == Core.GameDifficulty.NORMAL:
		%ButtonPlayAgainNormal.visible = false
		%ButtonPlayAgainHard.visible = true
	else:
		%ButtonPlayAgainNormal.visible = false
		%ButtonPlayAgainHard.visible = false

func _on_button_play_again_pressed() -> void:
	Core.game.restart()

func _on_button_play_again_normal_pressed() -> void:
	Core.game_difficulty = Global.GameDifficulty.NORMAL
	Core.game.restart()

func _on_button_play_again_hard_pressed() -> void:
	Core.game_difficulty = Global.GameDifficulty.HARD
	Core.game.restart()
