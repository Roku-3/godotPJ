extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var rays = [$RayCast2D, $RayCast2D2]
onready var stomp_effect = $StompEffect
export var run_speed = 20.0
export var jump_str = 400.0
export var grav = 800.0
var velocity = Vector2.ZERO
var floorCount:int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reload_scene"):
		get_tree().reload_current_scene()

	if self.is_on_floor():
		floorCount += 1
	else:
		floorCount = 0

	get_input()
	velocity.x *= 0.9
	velocity.y += grav*delta
	velocity.y *= 0.99
	velocity = move_and_slide(velocity, Vector2.UP)

func get_input()->void:
	if self.is_on_floor():
		state_machine.travel("Idle")
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			state_machine.travel("run")

	if Input.is_action_pressed("ui_right"):
		velocity.x += run_speed
		$Sprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		velocity.x -= run_speed
		$Sprite.flip_h = true

	if Input.is_action_just_pressed("ui_up"):
		if (rays[0].is_colliding() or rays[1].is_colliding()) and floorCount < 10:
			move_and_collide(Vector2.DOWN*100)
			state_machine.travel("stomp")
			stomp_effect.set_emitting(true)
			velocity.y = -jump_str*2
			frameFreeze(0.1, 0.5)
			$se_stomp.play()
		elif self.is_on_floor():
			velocity.y = -jump_str 
			state_machine.travel("spin")


func frameFreeze(timeScale, duration) -> void:
	Engine.time_scale = timeScale
	yield(get_tree().create_timer(duration * timeScale), "timeout")
	Engine.time_scale = 1.0

		
