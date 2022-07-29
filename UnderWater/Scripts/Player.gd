extends KinematicBody2D

export(float, 1, 10) var speed
export(float, 0, 10) var grav
export(float, 0.8, 0.999) var dampX
export(float, 0.8, 0.999) var dampY
export(int) var stageWidth = 512 
export(PackedScene) var par_damage

var velocity = Vector2.ZERO
var look_right = true

onready var animState = $AnimationTree["parameters/playback"]
onready var animTree = $AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_reload"):
		get_tree().reload_current_scene()

	if self.position.x > stageWidth:
		self.position.x -= stageWidth
	if self.position.x < 0:
		self.position.x += stageWidth

	velocity.y += grav

	get_input()
	if Input.is_action_just_pressed("ui_up") :
		damaged()

	velocity.x *= dampX
	velocity.y *= dampY


	velocity = move_and_slide(velocity, Vector2.UP)

func get_input() -> void:
	var player_dir = Vector2.ZERO

	if self.is_on_floor():
		animState.travel("stand")
	else:
		animState.travel("move")


	if Input.is_action_pressed("ui_left"):
		player_dir.x -= 1
		animState.travel("move")
	if Input.is_action_pressed("ui_right"):
		player_dir.x += 1
		animState.travel("move")

	if player_dir.x > 0:
		look_right = true
	if player_dir.x < 0:
		look_right = false


	if Input.is_action_pressed("ui_up"):
		player_dir.y += 1
	if Input.is_action_pressed("ui_down"):
		player_dir.y -= 1

	
	
	animTree.set("parameters/stand/blend_position", player_dir)
	animTree.set("parameters/move/blend_position", player_dir)

	if player_dir.length() < 0.1:
		var vecRight = Vector2(1,0)
		if look_right == true:
			animTree.set("parameters/stand/blend_position", vecRight)
			animTree.set("parameters/move/blend_position", vecRight)
		else:
			animTree.set("parameters/stand/blend_position", -vecRight)
			animTree.set("parameters/move/blend_position", -vecRight)

	player_dir.y = -player_dir.y
	velocity += player_dir * speed

	if Input.is_action_just_pressed("ui_accept"):
		$Shot.set_direction(player_dir)
		$Shot.set_emitting(true)


func damaged()->void:
	var parDamage = par_damage.instance()
	parDamage.set_emitting(true)
	add_child(parDamage)
