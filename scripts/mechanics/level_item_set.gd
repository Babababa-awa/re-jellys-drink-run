class_name LevelItemSet

var items: Array[LevelItemValue]

func _init(data_: BaseDataLoader) -> void:
	for area_ in data_.get_data(Core.DataType.AREA):
		if not area_.has("items"):
			continue
			
		for area_item_ in area_.items:
			var item_ = data_.get_from_alias(Core.DataType.ITEM, area_item_.alias)
			
			var item_value_ = ItemValue.new(
				item_.alias,
				item_.type,
				item_.meta if item_.has("meta") else {}
			)
			
			if item_.has("scene"):
				item_value_.scene = SceneValue.new()
				
				if item_.scene.has("path"):
					item_value_.scene.is_path = true
					item_value_.scene.path = item_.scene.path
				
				if item_.scene.has("scale"):
					item_value_.scene.is_scale = true
					item_value_.scene.scale = item_.scene.scale
				
				if item_.scene.has("tile_set_coords"):
					item_value_.scene.is_tile_set_coords = true
					item_value_.scene.tile_set_coords = item_.scene.tile_set_coords
						
			var level_item_value_ = LevelItemValue.new(
				item_value_,
				area_.alias,
				area_item_.position, # Item position within the area
				area_item_.visible if area_item_.has("visible") else true,
				area_item_.meta if area_item_.has("meta") else {},
			)
				
			items.push_back(level_item_value_)

func populate_area_items(area_alias_: StringName = &"") -> void:
	if area_alias_ == &"":
		area_alias_ = Core.game.get_level_area_alias()
		
	for item in items:
		if item.area_alias == area_alias_:
			populate_item(item)

func depopulate_area_items(area_alias_: StringName = &"") -> void:
	if area_alias_ == &"":
		area_alias_ = Core.game.get_level_area_alias()
		
	for item in items:
		if item.area_alias == area_alias_:
			depopulate_item(item)

func populate_item(level_item_value_: LevelItemValue) -> void:
	assert(Core.level != null and Core.level.area != null, "Level area is null.")
	
	var item_value_ = level_item_value_.item
	
	var scene
			
	if item_value_.scene != null and item_value_.scene.is_path:
		scene = item_value_.scene.path
	else:
		scene = "res://scenes/unit/item/" + item_value_.alias + ".tscn"
	
	var node = await Core.nodes.get_node(scene)
	
	if node == null:
		return
	
	level_item_value_.node = node

	if node is ItemUnit:
		node.set_item_value(item_value_)
	elif item_value_.scene != null:
		if item_value_.scene.is_scale:
			node.scale = item_value_.scene.scale
	
	var offset = Vector2.ZERO
	if level_item_value_.meta.has("alignment"):
		offset = node.get_align_offset(level_item_value_.meta.alignment)
			
	node.global_position = Core.level.area.global_position + level_item_value_.position + offset
		
	node.visible = level_item_value_.visible

func depopulate_item(item_: LevelItemValue) -> void:
	if item_.node != null:
		Core.nodes.free_node(item_.node)
	
func get_item(alias_: StringName) -> LevelItemValue:
	for item_ in items:
		if item_.alias == alias_:
			return item_
			
	return null
	
func get_items() -> Array[LevelItemValue]:
	return items

func get_items_from_area(area_alias_: StringName) -> Array[LevelItemValue]:
	var area_items: Array[LevelItemValue] = []
	
	for item in items:
		if item.area_alias == area_alias_:
			area_items.push_back(item)
			
	return area_items
	
func get_items_from_meta(meta: Dictionary) -> Array[LevelItemValue]:
	var items_: Array[LevelItemValue] = []
	
	for item_ in items:
		if Core.dictionary_contains(item_.meta, meta):
			items_.push_back(item_)
	
	return items_

func get_items_from_type(type_: Core.ItemType) -> Array[LevelItemValue]:
	var items_: Array[LevelItemValue] = []
	
	for item_ in items:
		if item_.type == type_:
			items_.push_back(item_)
	
	return items_
	
func get_items_from_area_meta(area_alias_: StringName, meta: Dictionary) -> Array[LevelItemValue]:
	var items_: Array[LevelItemValue] = []
	
	for item_ in items:
		if (item_.area_alias == area_alias_ and 
			Core.dictionary_contains(item_.meta, meta)
		):
			items_.push_back(item_)
	
	return items_

func get_items_from_area_type(area_alias_: StringName, type_: Core.ItemType) -> Array[LevelItemValue]:
	var items_: Array[LevelItemValue] = []
	
	for item_ in items:
		if (item_.area_alias == area_alias_ and 
			item_.type == type_
		):
			items_.push_back(item_)
	
	return items_
	
func add_item(item_: LevelItemValue):
	items.push_back(item_)
	
	if (item_.area_alias != &"" and 
		item_.area_alias == Core.game.get_level_area_alias()
	):
		populate_item(item_)

func remove_item(item_: LevelItemValue) -> void:
	for index in items.size():
		if items[index] == item_:
			depopulate_item(items[index])
			items.remove_at(index)
			break

func remove_items() -> void:
	for item_ in items:
		depopulate_item(item_)
		
	items.clear()

func remove_items_from_area(area_alias_: StringName) -> void:
	for index in range(items.size() - 1, -1, -1):
		if items[index].area_alias == area_alias_:
			depopulate_item(items[index])
			items.remove_at(index)
