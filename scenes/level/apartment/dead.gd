extends Node2D

func _ready():
	Global.player.is_dead = true
	Global.player.show_speech_bubble(
		[
			"I'm dead!",
		], 
		-1,
		-16
	)

func _process(_delta):
	Global.hud.visible = false
