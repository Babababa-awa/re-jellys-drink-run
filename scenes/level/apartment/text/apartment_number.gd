extends TileMap

@export_range(3, 5) var floor_number: int = 3
@export_range(1, 2) var apartment_number: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var x
	var y
	
	match floor_number:
		3:
			y = 6
		4:
			y = 7
		5:
			y = 8
	
	match apartment_number:
		1:
			x = 13
		2:
			x = 14
		
	self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(x, y))
