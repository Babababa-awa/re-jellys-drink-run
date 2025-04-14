extends BaseDataLoader
class_name AreaLevelDataLoader

func load() -> void:
	super.load()

	_data[Core.DataType.AREA] = _load_data(Core.DataType.AREA, "res://data/" + level_alias + "/area")
	_data[Core.DataType.OBJECT] = _load_data(Core.DataType.OBJECT, "res://data/" + level_alias + "/object")
	_data[Core.DataType.ITEM] = _load_data(Core.DataType.ITEM, "res://data/" + level_alias + "/item")
	_data[Core.DataType.LEVEL] = _load_json_data(Core.DataType.LEVEL, "res://data/" + level_alias + "/level.json")
	
func get_area(area_alias_: StringName) -> Dictionary:
	return get_from_alias(Core.DataType.AREA, area_alias_)
	
func get_area_data() -> Array[Dictionary]:
	return get_data(Core.DataType.AREA)

func get_object(object_alias_: StringName) -> Dictionary:
	return get_from_alias(Core.DataType.OBJECT, object_alias_)
	
func get_object_data() -> Array[Dictionary]:
	return get_data(Core.DataType.OBJECT)

func get_item(item_alias_: StringName) -> Dictionary:
	return get_from_alias(Core.DataType.ITEM, item_alias_)

func get_item_data() -> Array[Dictionary]:
	return get_data(Core.DataType.ITEM)
	
func get_level_data() -> Dictionary:
	return _data[Core.DataType.LEVEL]

func get_area_from_alias(alias: StringName) -> Dictionary:
	return get_from_alias(Core.DataType.AREA, alias)
	
func get_object_from_alias(alias: StringName) -> Dictionary:
	return get_from_alias(Core.DataType.OBJECT, alias)

func get_item_from_alias(alias: StringName) -> Dictionary:
	return get_from_alias(Core.DataType.ITEM, alias)

func _format_data(data_type: Core.DataType, json_data: Dictionary) -> Dictionary:
	match data_type:
		Core.DataType.AREA:
			json_data = _format_area_data(json_data)
		Core.DataType.ITEM:
			json_data = _format_item_data(json_data)
		Core.DataType.LEVEL:
			json_data = _format_level_data(json_data)
		
	return json_data

func _format_level_data(json_data: Dictionary) -> Dictionary:
	assert(json_data.has("type"), "Level type missing. (" + json_data.alias + ")")
	assert(json_data.has("area"), "Level area missing. (" + json_data.alias + ")")
	assert(json_data.has("player"), "Level player missing. (" + json_data.alias + ")")
	
	match json_data.type:
		"platformer":
			json_data.type = Core.LevelType.PLATFORMER
			
	json_data.area = _format_level_area_data(json_data, json_data.area)
	
	json_data.player = _format_level_player_data(json_data, json_data.player)
	
	if json_data.has("locks"):
		for i in json_data.locks.size():
			json_data.locks[i] = _format_level_lock_data(json_data, json_data.locks[i])
	
	return json_data
	
func _format_level_area_data(level: Dictionary, area: Dictionary) -> Dictionary:
	assert(level.area.has("alias"), "Level area missing alias. (" + level.alias + ")")
	
	area.alias = StringName(area.alias)
	
	return area
	
func _format_level_player_data(level: Dictionary, player: Dictionary) -> Dictionary:
	assert(player.has("alias"), "Level player missing alias. (" + level.alias + ")")
	assert(player.has("position"), "Level player missing position. (" + level.alias + ")")
	assert(player.has("mode"), "Level player missing mode. (" + level.alias + ")")
	
	player.alias = StringName(player.alias)
	
	player.position = Vector2(player.position[0], player.position[1])
	
	match player.mode:
		"none":
			player.mode = Core.UnitMode.NONE
		"normal":
			player.mode = Core.UnitMode.NORMAL
		"climbing":
			player.mode = Core.UnitMode.CLIMBING
			
	return player

func _format_level_lock_data(_level: Dictionary, lock: Dictionary) -> Dictionary:
	lock.alias = StringName(lock.alias)
	
	if lock.has("type"):
		match lock.type:
			"none":
				lock.type = Core.LockType.NONE
			"key":
				lock.type = Core.LockType.KEY
			"passcode":
				lock.type = Core.LockType.PASSCODE
			"terminal":
				lock.type = Core.LockType.TERMINAL
			"obstruction":
				lock.type = Core.LockType.OBSTRUCTION
	else:
		lock.type = Core.LockType.KEY
		
	if lock.has("mode"):
		match lock.mode:
			"lock_only":
				lock.mode = Core.LockMode.LOCK_ONLY
			"unlock_only":
				lock.mode = Core.LockMode.UNLOCK_ONLY
			"manual":
				lock.mode = Core.LockMode.MANUAL
			"auto":
				lock.mode = Core.LockMode.AUTO
			_:
				assert(false, "Invalid lock mode. (" + lock.mode + ")")
	else:
		lock.mode = Core.LockMode.MANUAL
		
	if not lock.has("unlocked"):
		lock.unlocked = false
	
	if not lock.has("bypassable"):
		lock.bypassable = false
		
	if lock.has("meta") and lock.meta.has("keys"):
		lock.meta.keys = lock.meta.keys.map(func(value): return StringName(value))
		
	return lock

func _format_area_data(json_data: Dictionary) -> Dictionary:
	json_data.alias = StringName(json_data.alias)
	
	if json_data.has("doors"):
		for i in json_data.doors.size():
			json_data.doors[i] = _format_area_door_data(json_data, json_data.doors[i])
				
	
	if json_data.has("items"):
		for i in json_data.items.size():
			json_data.items[i] = _format_area_item_data(json_data, json_data.items[i])
			
	
	return json_data
	
func _format_area_door_data(area: Dictionary, door: Dictionary) -> Dictionary:
	assert(door.has("alias"), "Area door missing alias. (" + area.alias + ")")
	
	door.alias = StringName(door.alias)
	
	if door.has("area"):
		assert(door.area.has("alias"), "Area door area missing alias. (" + area.alias + ", " + door.alias + ")")
		assert(door.area.has("position"), "Area door area missing position. (" + area.alias + ", " + door.alias + ")")
	
		door.area.alias = StringName(door.area.alias)
		door.area.position = Vector2(door.area.position[0], door.area.position[1])	
		
	return door
	
func _format_area_item_data(area: Dictionary, item: Dictionary) -> Dictionary:
	assert(item.has("alias"), "Item area missing alias. (" + area.alias + ")")
	assert(item.has("position"), "Item area missing position. (" + area.alias + ", " + item.alias + ")")
	
	item.alias = StringName(item.alias)
	item.position = Vector2(item.position[0], item.position[1])
	
	return item

func _format_item_data(json_data: Dictionary) -> Dictionary:
	assert(json_data.has("type"), "Item missing type. (" + json_data.alias + ")")
	
	json_data.alias = StringName(json_data.alias)
	
	match json_data.type:
		"accessory":
			json_data.type = Core.ItemType.ACCESSORY
		"armor":
			json_data.type = Core.ItemType.ARMOR
		"armor_health":
			json_data.type = Core.ItemType.ARMOR_HEALTH
		"food":
			json_data.type = Core.ItemType.FOOD
		"health":
			json_data.type = Core.ItemType.HEALTH
		"food_health":
			json_data.type = Core.ItemType.HEALTH_FOOD
		"key":
			json_data.type = Core.ItemType.KEY
		"knife":
			json_data.type = Core.ItemType.KNIFE
		"lock_pick":
			json_data.type = Core.ItemType.LOCK_PICK
		"repair":
			json_data.type = Core.ItemType.REPAIR
		"shield":
			json_data.type = Core.ItemType.SHIELD
		"tool":
			json_data.type = Core.ItemType.TOOL
	
	if json_data.has('scene'):
		json_data.scene = _format_scene_data(json_data.scene)
		
	return json_data

func _format_scene_data(json_data: Dictionary) -> Dictionary:
	if json_data.has("path"):
		json_data.path = StringName(json_data.path)
		
	if json_data.has("tile_set_coords"):
		json_data.tile_set_coords = Vector2i(
			json_data.tile_set_coords[0],
			json_data.tile_set_coords[1]
		)
	
	if json_data.has("scale"):
		json_data.scale = Vector2(json_data.scale[0], json_data.scale[1])	
		
	return json_data
