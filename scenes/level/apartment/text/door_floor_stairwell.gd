extends TileMap

@export_range(3, 5) var floor_number: int = 3

func _ready():
	match floor_number:
		1:
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(15,8))
		2:
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(15,7))
		3:
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(15,6))
		4:
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(15,5))
		5:
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(15,4))
