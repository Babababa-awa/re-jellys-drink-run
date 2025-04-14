extends PlatformerArea

var is_in_fire_escape_area: bool = false

func _init() -> void:
	super._init(&"roof")

func _process(delta_: float) -> void:
	super._process(delta_)

	if (is_in_fire_escape_area and
		Core.player != null and
		Core.player.interact.is_interacting
	):
		Core.audio.play_sfx(&"metal_step", 4)
		Core.level.change_player_area(&"fire_escape", Vector2(1088, 96), Core.UnitMode.CLIMBING)

func _on_area_2d_fire_escape_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		is_in_fire_escape_area = true

func _on_area_2d_fire_escape_body_exited(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		is_in_fire_escape_area = false

func _on_area_2d_ledge_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		if not Core.states.has("TALK:roof_ledge") or not Core.states["TALK:roof_ledge"]:
			Core.states["TALK:roof_ledge"] = true
			Core.speech.say(SpeechValue.new(body, "TALK:roof_ledge", 2.5))

func _on_area_2d_3_below_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		#TODO: Lock character and pan camera to center zoom on fire escape
		if not Core.states.has("TALK:roof_below") or not Core.states["TALK:roof_below"]:
			Core.states["TALK:roof_below"] = true
			Core.speech.say(SpeechValue.new(body, "TALK:roof_below", 3))

func _on_area_2d_awoo_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		#TODO:Awoo SFX
		#Core.audio.play_sfx(&"awoo", 4)

		Core.speech.say(SpeechValue.new(
			body,
			"TALK:roof_awoo",
			3,
			Core.SpeechStyle.TALK,
			Core.SpeechSize.SMALL,
		))
