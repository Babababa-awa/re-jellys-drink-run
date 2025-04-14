extends PlatformerArea

func _init() -> void:
	super._init(&"3_apt_2_jelly")


func _on_area_2d_talk_body_entered(body: Node2D) -> void:
	if Core.level.level_mode == Core.LevelMode.MENU:
		return
		
	if body.is_in_group(&"player"):
		if not Core.states.has("TALK:jelly") or not Core.states["TALK:jelly"]:
			Core.states["TALK:jelly"] = true
			Core.speech.say(SpeechValue.new(body, "TALK:jelly_1", 2.5), true)
			Core.speech.say(SpeechValue.new(body, "TALK:jelly_2", 2.5), true)


func _on_fridge_fridge_opened() -> void:
	var items = Core.level.items.get_items_from_area_meta(
		alias,
		{"object": "fridge"}
	)
	
	if items.size() > 0 and items[0].node != null:
		items[0].visible = true
		items[0].node.visible = true


func _on_fridge_fridge_closed() -> void:
	var items = Core.level.items.get_items_from_area_meta(
		alias,
		{"object": "fridge"}
	)
	
	if items.size() > 0 and items[0].node != null:
		items[0].visible = false
		items[0].node.visible = false
