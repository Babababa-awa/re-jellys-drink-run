class_name LevelItemValue

var item: ItemValue
var area_alias: StringName
var position: Vector2
var visible: bool
var meta: Dictionary

var node: Node = null

func _init(
	item_: ItemValue,
	area_alias_: StringName,
	position_: Vector2,
	visible_: bool = true,
	meta_: Dictionary = {}
) -> void:	
	item = item_
	area_alias = area_alias_
	position = position_
	visible = visible_
	meta = meta_
