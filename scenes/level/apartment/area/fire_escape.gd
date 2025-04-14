extends PlatformerArea

func _init() -> void:
	super._init(&"fire_escape")

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	%SakanaCoverWindow.visible = true

func _on_area_2d_sakana_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		%SakanaCoverWindow.visible = false

func _on_area_2d_song_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		Core.audio.play_music(&"pink_drinker")

func _on_area_2d_talk_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		if not Core.states.has("TALK:fire_escape") or not Core.states["TALK:fire_escape"]:
			Core.states["TALK:fire_escape"] = true
			Core.speech.say(SpeechValue.new(body, "TALK:fire_escape", 2.5))
