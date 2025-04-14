extends BaseUI

func _init():
	super._init(&"pause")
	
func show_ui():
	super.show_ui()
	
	if Core.level != null:
		%LabelTimeValue.text = Core.format_time(Core.level.get_play_time())
	else:
		%LabelTimeValue.text = Core.format_time(0)


func _on_button_continue_pressed() -> void:
	hide_ui()
	Core.game.toggle_pause()
