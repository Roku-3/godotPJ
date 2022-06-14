extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var judgeTime:int = 0
var touchingGoal:bool = false
signal did_goal
export (String)var nextScenePath


# Called when the node enters the scene tree for the first time.
func _ready():
	$NestStageBtn.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if touchingGoal:
		judgeTime += 1
		
	if judgeTime > 100:
		goalEffect()
		judgeTime = 0

func goalEffect():
	print("Goal!!!")
	emit_signal("did_goal")
	$NestStageBtn.show()
	$WinEff.set_emitting(true)

func _on_Goal_body_entered(body):
	if body.name.match("Car"):
		touchingGoal = true


func _on_Goal_body_exited(body):
	if body.name.match("Car"):
		judgeTime = 0
		touchingGoal = false


func _on_RestartBtn_pressed():
	get_tree().reload_current_scene()


func _on_NestStageBtn_pressed():
	get_tree().change_scene(nextScenePath)


func _on_MultiGoal_mgoaled():
	goalEffect()
