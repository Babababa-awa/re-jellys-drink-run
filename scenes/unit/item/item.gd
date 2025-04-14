extends ItemUnit

func _init() -> void:
	super._init(&"item")

func set_item_type(item_type_: Core.ItemType) -> void:
	super.set_item_type(item_type_)
	
	var coords: Vector2i = Vector2i(0, 2)
	
	match item_type_:
		Core.ItemType.NONE:
			coords = Vector2i(0, 0)
		Core.ItemType.FOOD:
			coords = Vector2i(0, 1)
		Core.ItemType.HEALTH:
			coords = Vector2i(0, 4)
		Core.ItemType.HEALTH_FOOD:
			coords = Vector2i(0, 3)

	var item_tile_map_layer = get_node_or_null("%Box")
	if item_tile_map_layer is TileMapLayer:
		if item_tile_map_layer.tile_set:
			item_tile_map_layer.set_cell(Vector2i(0, 0), item_tile_map_layer.tile_set.get_source_id(0), coords)
		else:
			push_warning("Item TileMapLayer does not have a TileSet set. (" + alias + ")")
