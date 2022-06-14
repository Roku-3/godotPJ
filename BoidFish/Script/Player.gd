extends Area2D

export (float) var speed = 1.5
var velocity := Vector2.ZERO

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if Input.is_action_pressed("ui_accept"):
	self.position += velocity * speed
	if position.x < 20:
		position.x = 20
	if position.x > 1024:
		position.x = 1024
	if position.y < -100:
		position.y = -100
	if position.y > 550:
		position.y = 550 
	
	self.look_at(get_global_mouse_position())
	if self.velocity.x < 0:
		scale.y = -1
	else:
		scale.y = 1
		
	velocity = self.position.direction_to(get_global_mouse_position())
	#self.rotation = get_global_mouse_position().angle()
