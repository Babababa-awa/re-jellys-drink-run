extends Node2D

const RAIN_WIDTH = 4096 # Rain tile size is 64 x 64px
const RAIN_HEIGHT = 4096

var is_outside: bool = false

func _ready() -> void:	
	_reset_rain()
	
func _reset_rain() -> void:
	var index = 0
	var start = Vector2(-RAIN_WIDTH / 2.0, -RAIN_HEIGHT / 2.0)
	
	for x in 2:
		for y in 3:
			index += 1
			var rain = get_node_or_null("%Rain" + str(index))
			rain.position = Vector2(start.x + x * RAIN_WIDTH, start.y + y * RAIN_HEIGHT)
			
func _process(_delta: float) -> void:
	if Core.game.is_outside != is_outside:
		is_outside = Core.game.is_outside
		
		if is_outside:
			z_index = 29
		else:
			z_index = 4
			
