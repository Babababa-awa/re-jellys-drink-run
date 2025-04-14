extends PlatformerArea

func _init() -> void:
	super._init(&"side_building")

func _on_area_2d_notice_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		if Core.help.issue_notice("side_building_fire_escape"):
			Core.speech.say(SpeechValue.new(
				body,
				"NOTICE:side_building_fire_escape",
				2.5,
				Core.SpeechStyle.THINK,
				Core.SpeechSize.LARGE,
			))
