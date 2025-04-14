extends ParallaxBackground

const LIGHTNING_DELAY = 20
const HIDE_DELAY = 0.5

var next_lightning: float = 0.0
var lightning: bool = false
var _lightning1: bool = false
var hide_delay: float = 0.0


func _process(delta):
	if Global.game.is_lightning != lightning:
		lightning = Global.game.is_lightning
		%SpriteLightning1.visible = false
		%SpriteLightning2.visible = false
		next_lightning = LIGHTNING_DELAY + randf_range(-5.0, 5.0)
		
	if lightning:
		if hide_delay > 0:
			hide_delay -= delta
			if hide_delay <= 0:
				%SpriteLightning1.visible = false
				%SpriteLightning2.visible = false
				
		next_lightning -= delta
		if next_lightning <= 0.0:
			show_lightning()		
			next_lightning = LIGHTNING_DELAY + randf_range(-5.0, 5.0)

func show_lightning():
	Global.audio.play_sfx("thunder", 3)
	_lightning1 = !_lightning1
	hide_delay = HIDE_DELAY
	if _lightning1:
		%SpriteLightning1.visible = true
	else:
		%SpriteLightning2.visible = true
	
