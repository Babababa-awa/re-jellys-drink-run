extends ParallaxBackground

func _ready() -> void:
	%Lightning.start()

func _process(_delta: float) -> void:
	if Core.player != null and not %Lightning.is_lightning:
		%Lightning.position.x = Core.player.position.x * 0.25
