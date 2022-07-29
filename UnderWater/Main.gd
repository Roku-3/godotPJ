extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var playerPos: Vector2 = $Player.get_position();
	$"CanvasLayer/ColorRect".material.set_shader_param("posY", playerPos.y);
	$"CanvasLayer/ColorRect".material.set_shader_param("posX", playerPos.x);

	$"CanvasLayer/ColorRect".set_position(Vector2(fmod(-playerPos.x,512)-256,-88));
	$"CanvasLayer/ColorRect2".set_position(Vector2(fmod(-playerPos.x,512)+256,-88));
