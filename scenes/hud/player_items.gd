extends BaseNode2D

@onready var hud_items: Array[BaseNode2D] = [
	%HudItem1,
	%HudItem2,
	%HudItem3,
	%HudItem4,
]
@onready var hud_labels: Array[Label] = [
	%HudLabel1,
	%HudLabel2,
	%HudLabel3,
	%HudLabel4,
]

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	_update()

func _update() -> void:
	if Core.player == null:
		visible = false
		return

	var items_actor = Core.player.get_actor_or_null(&"items")
	if items_actor == null or not items_actor is ItemsActor:
		visible = false
		return
		
	var slots = min(hud_items.size(), items_actor.slots)
	
	%HudLabelName.visible = false
	
	for i in hud_items.size():
		if i >= slots:
			hud_items[i].visible = false
			hud_labels[i].visible = false
			continue
			
		var item_ = items_actor.get_item(i)
		
		if item_ != null:
			if i == items_actor.selected_slot:
				%HudLabelName.visible = true
				%HudLabelName.text = "ITEM:" + item_.alias
			
			hud_items[i].item_alias = item_.alias
		else:
			hud_items[i].item_alias = &""
		
		if i == items_actor.selected_slot:
			hud_items[i].selected = true
		else:
			hud_items[i].selected = false
			
		hud_items[i].visible = true
		hud_labels[i].visible = true
	
