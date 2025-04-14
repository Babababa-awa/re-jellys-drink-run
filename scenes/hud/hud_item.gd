extends BaseNode2D

var item_alias: StringName = &""
var selected: bool = false

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	_update()
	
func _update() -> void:
	var item_type_: Core.ItemType = Core.ItemType.NONE
	
	if item_alias == &"":
		%Item.visible = false
	elif Core.level is PlatformerLevel:
		var item = Core.level.data.get_item(item_alias)
		%Item.set_cell(Vector2i(0, 0), %Item.tile_set.get_source_id(0), item.scene.tile_set_coords)
		%Item.visible = true

		item_type_ = item.type
	else:
		%Item.visible = false

	var x_coord_: int
	var y_coord_: int
	
	if selected:
		x_coord_ = 1
	else:
		x_coord_ = 0
	
	match item_type_:
		Core.ItemType.NONE:
			y_coord_ = 0
		Core.ItemType.FOOD:
			y_coord_ = 1
		Core.ItemType.HEALTH:
			y_coord_ = 4
		Core.ItemType.HEALTH_FOOD:
			y_coord_ = 3
		_:
			y_coord_ = 2

	%ItemUnder.set_cell(Vector2i(0, 0), %ItemUnder.tile_set.get_source_id(0), Vector2i(x_coord_, y_coord_))
	%ItemOver.set_cell(Vector2i(0, 0), %ItemOver.tile_set.get_source_id(0), Vector2i(x_coord_ + 2, y_coord_))
