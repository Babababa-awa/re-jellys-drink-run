extends PlatformerArea

func _init() -> void:
	super._init(&"5_apt_2")
	
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
