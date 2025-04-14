extends BaseLevel
class_name AreaLevel

var area: BaseArea
var items: LevelItemSet
var locks: LevelLockSet
var doors: LevelDoorSet

var data: AreaLevelDataLoader

func _init(alias_: StringName, level_type_: Core.LevelType) -> void:
	super._init(alias_, level_type_)
	
	auto_start_play_time = true
	auto_stop_play_time = true
	
	data = _init_data_loader()
	
func _init_data_loader() -> AreaLevelDataLoader:
	var data_: AreaLevelDataLoader = AreaLevelDataLoader.new(alias)
	data_.load()
	return data_
	
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
		
	if (reset_type_ == Core.ResetType.START or 
		reset_type_ == Core.ResetType.RESTART
	):
		reset_area()
		
		items = LevelItemSet.new(data)
		locks = LevelLockSet.new(data)
		doors = LevelDoorSet.new(data)
		
		var level = data.get_level_data()
		
		if level.has("player"):
			await Core.game.change_player(level.player.alias)
			
			await change_player_area(
				level.area.alias,
				level.player.position,
				level.player.mode,
			)

func reset_area() -> void:
	if area != null:
		if area is PlatformerArea:
			area.door_opened.disconnect(_on_door_opened)
			
		items.depopulate_area_items(area.alias)
		Core.nodes.free_node(area)
		
func change_player_area(
	area_alias_: String, 
	unit_position_: Vector2 = Vector2.ZERO,
	unit_mode_: Core.UnitMode = Core.UnitMode.NONE
) -> void:
	Core.game.start_load()
	
	reset_area()
	
	Core.player.position = unit_position_
	
	var area_ = data.get_area_from_alias(area_alias_)
	
	var scene: String
	
	if area_.has("scene"):
		scene = area_.scene
	else:
		scene = "res://scenes/level/" + alias + "/area/" + area_.alias + ".tscn"
	
	var node = await Core.nodes.get_node(scene)
	
	assert(node is BaseArea, "Area is invalid. (" + scene + ")")
	
	area = node
	
	area.alias = area_.alias
	area.position = Vector2.ZERO
	
	if area is PlatformerArea:
		area.door_opened.connect(_on_door_opened)
	
	items.populate_area_items(area_.alias)
	
	if area_.has("music") and area_.music != null:
		Core.audio.play_music(area_.music)
	else: 
		Core.audio.stop_music()
		
	if area_.has("ambience") and area_.ambience != null:
		Core.audio.play_ambience(area_.ambience)
	else: 
		Core.audio.stop_ambience()
	
	Core.game.is_outside = area_.has("outside") and area_.outside
	Core.game.is_lightning = area_.has("lightning") and area_.lightning
	
	Core.player.set_unit_mode(unit_mode_)
	
	Core.camera.set_target(Core.player)
	
	Core.game.end_load()

func change_player_area_zoom(
	area_name_: String, 
	unit_position_: Vector2 = Core.DEAD_ZONE,
	unit_mode_: Core.UnitMode = Core.UnitMode.NONE
) -> void:
	# TODO: add effect that pauses engine, zooms in 
	# player camera, then switches area
	change_player_area(area_name_, unit_position_, unit_mode_)

func add_mode(mode_: StringName, add_to_children: bool = false) -> void:
	super.add_mode(mode_)
	
	if add_to_children:
		if area != null:
			area.add_mode(mode_)
	
func remove_mode(mode_: StringName, remove_from_children: bool = false) -> void:
	super.remove_mode(mode_)
			
	if remove_from_children:
		if area != null:
			area.remove_mode(mode_)

func _on_door_opened(door_alias_: StringName, _door_type: Core.DoorType) -> void:
	if door_alias_ == &"":
		return

	var door: LevelDoorValue = doors.get_door(door_alias_)
	if door == null:
		return
		
	change_player_area(door.area_alias, door.unit_position, door.unit_mode)
