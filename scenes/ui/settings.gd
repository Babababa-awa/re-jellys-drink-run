extends BaseUI

func _init():
	super._init(&"settings")

func show_ui() -> void:
	super.show_ui()
	%HSliderMusic.value = Core.audio.get_volume(Core.AudioType.MUSIC)
	%HSliderSFX.value = Core.audio.get_volume(Core.AudioType.SFX)
	%HSliderAmbience.value = Core.audio.get_volume(Core.AudioType.AMBIENCE)
	
func _on_h_slider_music_value_changed(value: float) -> void:
	Core.audio.set_volume(Core.AudioType.MUSIC, value)

func _on_h_slider_sfx_value_changed(value: float) -> void:
	Core.audio.set_volume(Core.AudioType.SFX, value)

func _on_h_slider_ambience_value_changed(value: float) -> void:
	Core.audio.set_volume(Core.AudioType.AMBIENCE, value)
