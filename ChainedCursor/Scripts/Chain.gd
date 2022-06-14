extends Node2D

const chainPieceNode = preload("res://Scenes/ChainPiece.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var chainLength:int = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(chainLength):
		var chainPiece = chainPieceNode.instance()
		chainPiece.name = "ChainPiece"+String(i+1)
		if i%2 == 0:
			chainPiece.position = Vector2.ZERO
		else:
			chainPiece.position = Vector2(0, 31)
			chainPiece.rotate(PI)
			
		self.add_child(chainPiece)
		if i<=0:
			get_node("ChainAnchor/C/J").node_b = get_node("ChainPiece1").get_path()
			print("chained!!!")
		else:
			get_node("ChainPiece"+String(i)+"/C/J").node_b = get_node("ChainPiece"+String(i+1)).get_path()
		
	if chainLength%2 == 0:
		$Car.position = Vector2.ZERO
	else:
		$Car.position = Vector2(0,31)
	get_node("ChainPiece"+String(chainLength)+"/C/J").node_b = $Car.get_path()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_HUD_did_goal():
	for i in range(chainLength):
		get_node("ChainPiece"+String(i+1)+"/C/J").set_node_b("")
	#$"ChainPiece10/C/J".set_node_b("")
	for i in range(chainLength):
		var eachPiece = get_node("ChainPiece"+String(i+1))
		var l_v = eachPiece.get_linear_velocity().normalized()
		var a_v = clamp(eachPiece.get_angular_velocity(),-1,1)
		eachPiece.apply_central_impulse(l_v*50)
		eachPiece.apply_torque_impulse(a_v*500)
