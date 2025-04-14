extends BaseNode2D

@export var length: int = 1
@export var tile_offset: int = 0

const TILE_COUNT = 3

func _ready() -> void:
	super._ready()

	_update_length2()

func _update_length2() -> void:
	var offset = tile_offset % TILE_COUNT

	for x in length:
		%Glass.set_cell(
			Vector2i(x, -1), 
			%Glass.tile_set.get_source_id(0), 
			Vector2i(offset, 0)
		)
		
		offset += 1
		if offset >= TILE_COUNT:
			offset = 0
			
	%CollisionShape2D.position = Vector2(length * Core.TILE_SIZE / 2, -3.5)
	%CollisionShape2D.shape.size = Vector2(length * Core.TILE_SIZE, 7)

	$Area2DSpeech/CollisionShape2D.position = Vector2(((96 + (length * Core.TILE_SIZE)) / 2) - 48, -3.5)
	$Area2DSpeech/CollisionShape2D.shape.size = Vector2(96 + length * Core.TILE_SIZE, 7)

func _on_area_2d_speech_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		if Core.help.issue_notice("glass"):
			Core.speech.say(SpeechValue.new(
				body,
				"NOTICE:glass",
				2.5,
				Core.SpeechStyle.THINK,
				Core.SpeechSize.LARGE,
			))
