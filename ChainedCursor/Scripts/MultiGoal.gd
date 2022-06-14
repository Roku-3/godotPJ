extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal mgoaled


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

onready var chain = get_owner().get_node("Chain")
var finished = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if finished:
		return
	var is_overlapped = true 

	for N in self.get_children():
		var piece_overlapped = false
		for piece in chain.get_children():
			if N.overlaps_body(piece):
				piece_overlapped = true
				break
		if piece_overlapped:
			N.get_node("MGoal").set_frame(1)
		else:
			N.get_node("MGoal").set_frame(0)
			is_overlapped = false
		
	if is_overlapped:
		emit_signal("mgoaled")
		finished = true
		
