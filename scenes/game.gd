extends BaseGame
class_name Game

var rain: bool = true
var is_lightning: bool = true
var is_outside: bool = true

func start_select() -> void:
	hide_uis(Global.UIType.MENU)
	current_level.start_select()

func _process(delta):
	super._process(delta)
	
	if is_lose and get_level_area_alias() != &"lose":
		Core.level.change_player_area(&"lose", Vector2(64, -32))
		Core.player.velocity = Vector2.ZERO
		hide_ui(&"hud")
		if Core.camera is TargetCamera2D:
			Core.camera.target_offset = Vector2.ZERO
	elif is_win:
		Core.level.change_player_area(&"win", Vector2(64, -32))
		Core.player.velocity = Vector2.ZERO
		hide_ui(&"hud")
		if Core.camera is TargetCamera2D:
			Core.camera.target_offset = Vector2.ZERO

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
