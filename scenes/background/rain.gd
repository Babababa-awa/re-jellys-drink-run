extends ParallaxBackground

func _process(_delta):
	%ParallaxRain.visible = Global.game.rain
	if Global.game.is_outside:
		layer = 100
	else:
		layer = -100	
