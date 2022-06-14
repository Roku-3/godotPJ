extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed:int = 200
export var rotateSpd:float= 0.05
var direction:float
var faceCnt:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		direction += rotateSpd
	if Input.is_action_pressed("ui_left"):
		direction -= rotateSpd
	direction = fmod(direction,TAU)
	self.rotation = direction
	
	# change face expression if pulled by chain
	if faceCnt > 80:
		var preFrame = $Chara0.get_frame()
		if self.get_linear_velocity().length() < 60:
			$Chara0.set_frame(1)
		else:
			$Chara0.set_frame(0)
		if preFrame != $Chara0.get_frame():
			faceCnt = 0
	faceCnt += 1

	apply_central_impulse(Vector2(cos(direction), sin(direction))*speed)
