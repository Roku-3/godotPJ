extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mode_temp:bool
enum K {left, right, up, down}
var keyArr = [false, false, false, false]
signal numInput(inputnum, is_tmpInput)


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("numInput", get_parent(), "input_apply")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not self.is_visible_in_tree():
		return

	$ModalIndicator.hide()
	if mode_temp:
		$GridConfirm.hide()
		$GridTemp.show()
	else:
		$GridConfirm.show()
		$GridTemp.hide()

	if Input.is_action_just_pressed("ui_left"):
		keyArr[K.left] = true
	if Input.is_action_just_pressed("ui_right"):
		keyArr[K.right] = true
	if Input.is_action_just_pressed("ui_up"):
		keyArr[K.up] = true
	if Input.is_action_just_pressed("ui_down"):
		keyArr[K.down] = true

	# show input indicator
	var key_pos = Vector2.ZERO
	if true in keyArr:
		key_pos.x += -1 if keyArr[K.left] else 0
		key_pos.x += 1 if keyArr[K.right] else 0
		key_pos.y += -1 if keyArr[K.up] else 0
		key_pos.y += 1 if keyArr[K.down] else 0
		$ModalIndicator.set_position(key_pos*40)
		$ModalIndicator.show()


	# key input
	if mode_temp and Input.is_action_just_pressed("ui_seek"):
		emit_signal("numInput", 10, mode_temp)
		return

	if not true in [Input.is_action_pressed("ui_left"),
					Input.is_action_pressed("ui_right"),
					Input.is_action_pressed("ui_up"),
					Input.is_action_pressed("ui_down")] and \
		   true in [Input.is_action_just_released("ui_left"),
					Input.is_action_just_released("ui_right"),
					Input.is_action_just_released("ui_up"),
					Input.is_action_just_released("ui_down")]: 
		
		var inputSum = 5
		if keyArr[K.left]:
			inputSum -= 1
		if keyArr[K.right]:
			inputSum += 1
		if keyArr[K.up]:
			inputSum -= 3
		if keyArr[K.down]:
			inputSum += 3

		emit_signal("numInput", inputSum, mode_temp)
		for n in keyArr.size():
			keyArr[n] = false	
		if not mode_temp:
			self.hide()
