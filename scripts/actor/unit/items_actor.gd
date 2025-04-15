extends UnitActor
class_name ItemsActor

var is_in_item_area: bool = false
var item_area_items: Array[ItemValue] = []

var use_action_enabled: bool = true
var use_action_enabled_default: bool = true
var signal_can_use: bool = false
var signal_use_handled: bool = false

var drop_action_enabled: bool = true
var drop_action_enabled_default: bool = true
var signal_can_drop: bool = false
var signal_drop_handled: bool = false

var pick_up_action_enabled: bool = true
var pick_up_action_enabled_default: bool = true
var signal_can_pick_up: bool = false
var signal_pickup_handled: bool = false

var can_select: bool = true

var items: Array[ItemValue] = []
var slots: int
var item_types: Array[Core.ItemType] = []
var selected_slot: int = 0
var drop_offset: Vector2 = Vector2.ZERO
var unit_alignment: Core.Alignment = Core.Alignment.CENTER_CENTER
var item_alignment: Core.Alignment = Core.Alignment.CENTER_CENTER

var action_left: StringName = &"player_item_left"
var action_right: StringName = &"player_item_right"
var action_use: StringName = &"player_item_use"
var action_pick_up: StringName = &"player_item_pick_up"
var action_drop: StringName = &"player_item_drop"
var action_select: StringName = &"player_item_select_"

signal use_error(item_value_: ItemValue, error_: Core.Error) 
signal use_before(item_value_: ItemValue)
signal use_after(item_value_: ItemValue)

signal drop_error(item_value_: ItemValue, error_: Core.Error) 
signal drop_before(item_value_: ItemValue)
signal drop_after(item_value_: ItemValue)

signal pick_up_error(item_value_: ItemValue, error_: Core.Error) 
signal pick_up_before(item_value_: ItemValue)
signal pick_up_after(item_value_: ItemValue)

func _init(unit_: PlayerUnit, enabled_: bool = true) -> void:
	super._init(unit_, &"items", enabled_)
	
func ready() -> void:
	reset_slots()
	
	var item_area = unit.get_node_or_null("%Area2DItem")

	if item_area != null:
		item_area.connect(&"body_entered", _on_item_body_entered)
		item_area.connect(&"body_exited", _on_item_body_exited)

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or 
		reset_type_ == Core.ResetType.RESTART
	):
		is_in_item_area = false
		item_area_items.clear()
		selected_slot = 0
		items.clear()
		
		use_action_enabled = use_action_enabled_default
		drop_action_enabled = drop_action_enabled_default
		pick_up_action_enabled = pick_up_action_enabled_default
		
		reset_slots()

func reset_slots() -> void:
	items = []
	
	selected_slot = 0
	
	for i in slots:
		items.push_back(null)
	
func process(delta: float) -> void:
	super.process(delta)

	if not can_process():
		return
		
	if not can_unit_process():
		return
		
	if not can_unit_input():
		return
		
	if Core.game.is_win or Core.game.is_lose:
		return
	
	_action_move_selection_left()
	_action_move_selection_right()
			
	for i in slots:
		_action_select_item(i)

func physics_process(delta: float) -> void:
	super.physics_process(delta)
	
	if not can_physics_process():
		return
		
	if not can_unit_process():
		return
		
	if not can_unit_input():
		return

	_action_use_selected_item()
	_action_drop_selected_item()
	_action_pick_up_item()

func _on_item_body_entered(body: Node2D) -> void:
	if not body is ItemUnit:
		return

	item_area_items.push_back(body.get_item_value())
	is_in_item_area = true

func _on_item_body_exited(body: Node2D) -> void:
	if not body is ItemUnit:
		return
		
	var item_value_ = body.get_item_value()
	
	for i in item_area_items.size():
		if item_area_items[i].is_equal(item_value_):
			item_area_items.remove_at(i)
			break
	
	is_in_item_area = item_area_items.size() > 0
	
func _action_move_selection_left() -> void:
	if not can_select:
		return

	if not unit.actions.is_just_pressed(action_left, true):
		return
	
	if unit.actions.is_just_pressed(action_right, true):
		return
		
	move_selection_left()

func _action_move_selection_right() -> void:
	if not can_select:
		return

	if not unit.actions.is_just_pressed(action_right, true):
		return
	
	if unit.actions.is_just_pressed(action_left, true):
		return
		
	move_selection_right()

func _action_select_item(slot_: int) -> void:
	if not can_select:
		return
	
	if not unit.actions.is_just_pressed(action_select + str(slot_ + 1), true):
		return
		
	select_item(slot_)
	
func _action_use_selected_item() -> void:
	if not use_action_enabled:
		return
	
	if not unit.actions.is_just_pressed(action_use):
		return
	
	if not unit.actions.has(action_use):
		use_error.emit(get_selected_item(), Core.Error.UNIT_RESTRICTION)
		return
		
	use_selected_item()
	
func _action_drop_selected_item() -> void:
	if not drop_action_enabled:
		return
		
	if not unit.actions.is_just_pressed(action_drop):
		return
		
	if not unit.actions.has(action_drop):
		drop_error.emit(get_selected_item(), Core.Error.UNIT_RESTRICTION)
		return
		
	drop_selected_item()	
	
func _action_pick_up_item() -> void:
	if not pick_up_action_enabled:
		return
		
	if not unit.actions.is_just_pressed(action_pick_up):
		return
		
	if not unit.actions.has(action_pick_up):
		pick_up_error.emit(get_selected_item(), Core.Error.UNIT_RESTRICTION)
		return

	pick_up_item()

func move_selection_left() -> void:
	if selected_slot == 0:
		selected_slot = slots - 1
	else:
		selected_slot -= 1

func move_selection_right() -> void:
	if selected_slot == slots - 1:
		selected_slot = 0
	else:
		selected_slot += 1

func can_use_item(item_value_: ItemValue) -> bool:
	if item_value_ == null:
		return false
	
	return true

func can_use_selected_item() -> bool:
	return can_use_item(get_selected_item())
		
func can_drop_selected_item() -> bool:
	if is_in_item_area:
		return false
		
	if get_selected_item() == null:
		return false
		
	return true
	
func can_pick_up_item() -> bool:
	return _can_pick_up_level_item(get_pick_up_level_item())

func _can_pick_up_level_item(level_item_value_: LevelItemValue) -> bool:
	if level_item_value_ == null:
		return false

	return true
	
func use_item(item_value_: ItemValue) -> bool:
	if not can_use_item(item_value_):
		use_error.emit(item_value_, Core.Error.ACTOR_RESTRICTION)
		return false
		
	signal_can_use = true
	signal_use_handled = false
	
	use_before.emit(item_value_)
	
	if signal_can_use == false:
		use_error.emit(item_value_, Core.Error.GAME_RESTRICTION)
		return false
	
	if not signal_use_handled:
		if not _use_item(item_value_):
			use_error.emit(item_value_, Core.Error.UNHANDLED)
			return false

	use_after.emit(item_value_)
	return true
		
func use_selected_item() -> bool:
	var item_value_ = get_selected_item()
	
	if not can_use_selected_item():
		use_error.emit(item_value_, Core.Error.ACTOR_RESTRICTION)
		return false

	signal_can_use = true
	signal_use_handled = false
	
	use_before.emit(item_value_)
	
	if signal_can_use == false:
		use_error.emit(item_value_, Core.Error.GAME_RESTRICTION)
		return false
	
	if not signal_use_handled:
		if not _use_item(item_value_):
			use_error.emit(item_value_, Core.Error.UNHANDLED)
			return false
	
	remove_selected_item()

	use_after.emit(item_value_)
	return true

func _use_item(item_value_: ItemValue) -> bool:
	if item_value_.type == Core.ItemType.FOOD:
		if item_value_.meta.has("hunger"):
			_increase_unit_hunger(item_value_.meta.hunger)
		
		return true
	
	if item_value_.type == Core.ItemType.HEALTH_FOOD:
		if item_value_.meta.has("hunger"):
			_increase_unit_hunger(item_value_.meta.hunger)
			
		if item_value_.meta.has("health"):
			_increase_unit_health(item_value_.meta.health)
			
		return true
	
	if item_value_.type == Core.ItemType.ARMOR:
		if item_value_.meta.has("armor"):
			_increase_unit_armor(item_value_.meta.armor)
			
		return true
		
	if item_value_.type == Core.ItemType.ARMOR_HEALTH:
		if item_value_.meta.has("armor"):
			_increase_unit_armor(item_value_.meta.armor)
			
		if item_value_.meta.has("health"):
			_increase_unit_health(item_value_.meta.health)
			
		return true
		
	if item_value_.type == Core.ItemType.HEALTH or item_value_.type == Core.ItemType.REPAIR:
		if item_value_.meta.has("health"):
			_increase_unit_health(item_value_.meta.health)
			
		return true
			
	return false
	
func drop_selected_item() -> void:
	var item_value_ = get_selected_item()
	
	if not can_drop_selected_item():
		drop_error.emit(item_value_, Core.Error.ACTOR_RESTRICTION)
		return
		
	signal_can_drop = true
	signal_use_handled = false
	
	drop_before.emit(item_value_)
	
	if signal_can_drop == false:
		drop_error.emit(item_value_, Core.Error.GAME_RESTRICTION)
		return
	
	if not signal_use_handled:
		if not _drop_item(item_value_):
			drop_error.emit(item_value_, Core.Error.UNHANDLED)
			return
		
	remove_selected_item()

	drop_after.emit(item_value_)
	
func _drop_item(item_value_: ItemValue) -> bool:
	if not Core.level is AreaLevel:
		return false
	
	if Core.level.area == null:
		return false
		
	var unit_position_ = unit.get_align_global_position(unit_alignment)
		
	var level_item_value = LevelItemValue.new(
		item_value_,
		Core.level.area.alias,
		unit_position_ - Core.level.area.global_position + drop_offset,
		true,
		{"alignment": item_alignment}
	)
	
	Core.level.items.add_item(level_item_value)
	
	return true

func pick_up_item() -> void:
	var level_item_value_ = get_pick_up_level_item()
		
	if not _can_pick_up_level_item(level_item_value_):
		if level_item_value_ == null:
			pick_up_error.emit(null, Core.Error.ACTOR_RESTRICTION)
		else:
			pick_up_error.emit(level_item_value_.item, Core.Error.ACTOR_RESTRICTION)
		return
		
	signal_can_pick_up = true
	signal_use_handled = false
	
	pick_up_before.emit(level_item_value_.item)
	
	if signal_can_pick_up == false:
		pick_up_error.emit(level_item_value_.item, Core.Error.GAME_RESTRICTION)
		return

	if not signal_use_handled:
		if not _pick_up_item(level_item_value_):
			pick_up_error.emit(level_item_value_.item, Core.Error.UNHANDLED)
			return
	
	pick_up_after.emit(level_item_value_.item)
	
func get_pick_up_level_item() -> LevelItemValue:
	if not is_in_item_area:
		return null
	
	if not Core.level is AreaLevel:
		return null
	
	var area_alias_ = Core.game.get_level_area_alias()
	if area_alias_ == &"":
		return null
		
	var unit_position_: Vector2 = unit.get_align_global_position(unit_alignment)
	
	var closest_level_item_value_: LevelItemValue = null
	var closest_position_: Vector2
	
	for level_item_value_ in Core.level.items.get_items_from_area(area_alias_):
		if not level_item_value_.visible:
			continue
			
		if item_types.size() > 0 and not item_types.has(level_item_value_.item.type):
			continue
			
		if not level_item_value_.node is ItemUnit:
			continue
			
		if closest_level_item_value_ == null:
			closest_level_item_value_ = level_item_value_
			closest_position_ = level_item_value_.node.get_align_global_position(item_alignment)
			continue
	
		var current_position_: Vector2 = level_item_value_.node.get_align_global_position(item_alignment)
		var test_position_: Vector2 = Core.get_closest_vector2(unit_position_, closest_position_, current_position_)
		
		if test_position_ == current_position_:
			closest_level_item_value_ = level_item_value_
			closest_position_ = current_position_
	
	return closest_level_item_value_

func _pick_up_item(level_item_value_: LevelItemValue) -> bool:
	if not Core.level is AreaLevel:
		return false
		
	if not has_empty():
		if use_action_enabled and use_item(level_item_value_.item):
			Core.level.items.remove_item(level_item_value_)
			return true
		
		var item_value_ = get_selected_item()
		
		replace_selected_item(level_item_value_.item)
		
		level_item_value_.item = item_value_
		
		if level_item_value_.node is ItemUnit:
			level_item_value_.node.set_item_value(item_value_)
			
		return true

	Core.level.items.remove_item(level_item_value_)
	add_item(level_item_value_.item)

	return true

func select_item(slot_: int) -> void:
	assert(slot_ >= 0 and slot_ < slots, "Slot is out of range.")
	
	selected_slot = slot_
	
func select_item_of_type(type_: Core.ItemType) -> bool:
	for i in items.size():
		if items[i].type == type_:
			selected_slot = i
			return true
		
	return false
	
func is_item_of_type_selected(type_: Core.ItemType) -> bool:
	if items[selected_slot].type == type_:
		return true
	
	return false

func get_item(slot_: int) -> ItemValue:
	assert(slot_ >= 0 and slot_ < slots, "Slot is out of range.")
	
	return items[slot_]
	
func get_selected_item() -> ItemValue:
	return items[selected_slot]
	
func get_selected_item_type() -> Core.ItemType:
	if items[selected_slot] == null:
		return Core.ItemType.NONE

	return items[selected_slot].type

func get_items_from_meta(meta: Dictionary) -> Array[ItemValue]:
	var items_: Array[ItemValue] = []
	
	for item_ in items:
		if item_ != null and Core.dictionary_contains(item_.meta, meta):
			items_.push_back(item_)
	
	return items_
	
func get_items_from_type(type_: Core.ItemType) -> Array[ItemValue]:
	var items_: Array[ItemValue] = []
	
	for item_ in items:
		if item_ != null and item_.type == type_:
			items_.push_back(item_)
	
	return items_

func add_item(item_: ItemValue) -> bool:
	if items[selected_slot] == null:
		items[selected_slot] = item_
		return true
		
	for i in items.size():
		if items[i] == null:
			items[i] = item_
			return true
			
	return false

func replace_item(slot_: int, item_: ItemValue) -> void:
	items[slot_] = item_
	
func replace_selected_item(item_: ItemValue) -> void:
	items[selected_slot] = item_
	
func remove_item(slot_: int) -> void:
	assert(slot_ >= 0 and slot_ < slots, "Slot is out of range.")
	
	items[slot_] = null
	
func remove_selected_item() -> void:
	items[selected_slot] = null

func is_empty() -> bool:
	for item in items:
		if item != null:
			return false
			
	return true

func is_slot_empty(slot_: int) -> bool:
	assert(slot_ >= 0 and slot_ < slots, "Slot is out of range.")
	
	return items[slot_] == null

func is_selected_slot_empty() -> bool:
	return is_slot_empty(selected_slot)
	
func has_empty() -> bool:
	for item in items:
		if item == null:
			return true
	
	return false

func get_actions() -> Array[StringName]:
	var actions_: Array[StringName] = [
		action_left,
		action_right,
		action_use,
		action_pick_up,
		action_drop,
	]
	
	for i in slots:
		actions_.push_back(action_select + str(i + 1))
		
	return actions_

func _increase_unit_health(amount: float) -> void:
	if amount == 0.0:
		return
	
	var health_actor = unit.get_actor_or_null(&"health")
	
	if health_actor == null:
		return
	
	health_actor.increase_health(amount)
	
func _increase_unit_armor(amount: float) -> void:
	if amount == 0.0:
		return
		
	var health_actor = unit.get_actor_or_null(&"health")
	
	if health_actor == null:
		return
	
	health_actor.increase_armor(amount)

func _increase_unit_hunger(amount: float) -> void:
	if amount == 0.0:
		return
		
	var hunger_actor = unit.get_actor_or_null(&"hunger")
	
	if hunger_actor == null:
		return
	
	hunger_actor.increase_hunger(amount)
