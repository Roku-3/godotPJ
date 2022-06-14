extends RigidBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var hopFreqT:int = 300
var remainT:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remainT = hopFreqT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	remainT -= 1
	if remainT <= 0:
		self.apply_central_impulse(Vector2(-20, -100))
		remainT = hopFreqT
