extends Node2D
var Dive = preload("res://Scene/Dive.tscn")
var started = false
var time = 60

var dive

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and not started:
		$CanvasLayer/Result.hide()
		$CanvasLayer/Label.show()
		$CanvasLayer/Timeleft.show()
		dive = Dive.instance()
		add_child(dive)
		started = true
		$StartMSG.hide()
		$BGM.play()
		$Timer.start()
		_global.score = 0
		time = 60
	$CanvasLayer/Label.text = "Score:%4d" % _global.score
	
	
	if time <= 0 and started:
		$CanvasLayer/Result.text = "SCORE: %4d" % _global.score
		$CanvasLayer/Result.show()
		$CanvasLayer/Label.hide()
		$CanvasLayer/Timeleft.hide()
		$StartMSG.show()
		$Timer.stop()
		time = 60
		dive.queue_free()
		started = false
		$BGM.stop()
	
	


func _on_Timer_timeout():
	time -= 1
	$CanvasLayer/Timeleft.text = str(time)
