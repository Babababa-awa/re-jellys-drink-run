extends TileMap

@export_range(1, 5) var floor_number: int = 3
@export_enum("Up", "Down", "Floor") var direction: String = "Up"

func _ready():
	match direction:
		"Up":
			self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(15, 2))
		"Down":
			self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(15, 3))
		"Floor":
			self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(13, 9))
	
	match floor_number:
		1:
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(15, 8))
		2:
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(15, 7))
		3:
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(15, 6))
		4:
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(15, 5))
		5:
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(15, 4))
