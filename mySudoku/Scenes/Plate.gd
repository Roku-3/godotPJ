extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selectionIndex: Vector2
export var selectionMoveSpd = 1.0
export var dampSpd = 0.8 
var selectionAcc = Vector2.ZERO
var pressCounter:int = 0
var cellPos:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	$popUp.hide()
	selectionIndex = Vector2(0,0)
	var randXarray = get_random_array()
	var randYarray = get_random_array()
	var randReplacearray = get_random_array(1)
	randReplacearray.insert(0, 0)
	var listQuest = [-6,-5,-4,-2,-3,-9,-8, 7,-1,
					  2, 9,-3, 1,-7,-8,-6,-4, 5,
					 -7, 8, 1,-5, 6,-4,-2,-9, 3,
					  5,-3,-9,-8,-4, 1,-7,-6,-2,
					 -1,-4,-2, 6, 9, 7,-3,-5,-8,
					 -8,-7,-6,-3, 2,-5, 4,-1,-9,
					 -9,-2, 8,-4,-5,-6,-1,-3,-7,
					 -3, 6,-5,-7,-1, 2,-9, 8, 4,
					 -4, 1,-7, 9,-8,-3, 5,-2, 7]
	var remakedQuest = remakeQuest(listQuest, randXarray, randYarray, randReplacearray)
	set_quest(remakedQuest)
	
	
func get_random_array(offset = 0):
	randomize()
	var array012 = [0,1,2]
	var a = [0,3,6]
	var randArray = []
	a.shuffle()
	for i in a:
		randomize()
		array012.shuffle()
		for j in array012:
			randArray.append(i+j + offset)
	return randArray

func remakeQuest(rawQuest, randXarray, randYarray, randReplace):
	var rawRemakedQuest = []
	for xi in randXarray:
		for yi in randYarray:
			var pickedNum = rawQuest[xi+yi*9]
			# 入れ替える数字が負の場合、一度正にしてから戻す
			var sign_changed = false
			if pickedNum < 0:
				pickedNum = -pickedNum
				sign_changed = true
			var replacedNum = randReplace[pickedNum]
			if sign_changed:
				replacedNum = -replacedNum
			rawRemakedQuest.append(replacedNum)
	return rawRemakedQuest

	
func set_quest(quest):
	var ix = 0
	for num in quest:
		if num < 1 || num > 9:
			num = -10
		$numTileMap.set_cell(ix%9, ix/9, num+9)
		ix += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $popUp.is_visible_in_tree():
		$Target.hide()
		selectionAcc = Vector2.ZERO
	else:
		$Target.show()
		move_selection()
		
	var newCellPos =  Vector2(floor(selectionIndex.x)/60, floor(selectionIndex.y)/60)
	if cellPos != newCellPos and Input.is_action_pressed("ui_seek"):
		$highlightTileMap.clear()
		highlight_numbers()
	cellPos = newCellPos

	if $numTileMap.get_cellv(cellPos) < 10:
		press_space()

	if Input.is_action_just_pressed("ui_seek"):
		highlight_numbers()

	if Input.is_action_just_released("ui_seek"):
		$highlightTileMap.clear()

func move_selection() -> void:
	var selectionDirection = Vector2.ZERO
	$selectionTileMap.clear()
	if Input.is_action_pressed("ui_right"):
		selectionDirection.x += 1
	if Input.is_action_pressed("ui_left"):
		selectionDirection.x -= 1
	if Input.is_action_pressed("ui_down"):
		selectionDirection.y += 1
	if Input.is_action_pressed("ui_up"):
		selectionDirection.y -= 1

	selectionDirection = selectionDirection.normalized()
	selectionAcc += selectionDirection*selectionMoveSpd
	selectionAcc *= dampSpd

	selectionIndex += selectionAcc

	if selectionIndex.x < 0:
		selectionIndex.x = 60*9-0.1
	if selectionIndex.y < 0:
		selectionIndex.y = 60*9-0.1
	if selectionIndex.x >= 60*9:
		selectionIndex.x = 0
	if selectionIndex.y >= 60*9:
		selectionIndex.y = 0

	$Target.position = selectionIndex + $numTileMap.position
	$selectionTileMap.set_cell(floor(selectionIndex.x)/60, floor(selectionIndex.y)/60, 0)

func press_space() -> void:
	if Input.is_action_pressed("ui_accept"):
		pressCounter += 1

	if Input.is_action_just_pressed("ui_accept"):
		pressCounter = 0
		if $popUp.is_visible():
			$popUp.hide()
		else:
			$popUp.show()
			$popUp.set_position($Target.position)
		
	if pressCounter > 10:
		$popUp.mode_temp = true
	else:
		$popUp.mode_temp = false
		
	if Input.is_action_just_released("ui_accept"):
		if pressCounter > 10:
			$popUp.hide()

func input_apply(inputNum, isTemp) -> void:
	var tileStr = "smallTileContainer/smallNumTileMap"

	if not isTemp:	# 大きい数字の入力
		for i in range(9):	# 小さい数字を全て消す
			get_node(tileStr+String(i+1)).set_cellv(cellPos,-1)

		if inputNum == $numTileMap.get_cellv(cellPos):
			$numTileMap.set_cellv(cellPos, -1)	# 同じ数字を入力したら空欄にする
		else:
			$numTileMap.set_cellv(cellPos, inputNum)

	else:	# 仮の小さい数字の入力
		if inputNum == 10: #全てを入力
			var empty_exist = false
			for tilen in range(9):
				if get_node(tileStr+String(tilen+1)).get_cellv(cellPos) != 0:
					empty_exist = true
					break

			if empty_exist:
				for tilen in range(9):
					get_node(tileStr+String(tilen+1)).set_cellv(cellPos, 0)
				return
			else:
				for tilen in range(9):
					get_node(tileStr+String(tilen+1)).set_cellv(cellPos, -1)
				return



		var smallTile = get_node(tileStr+String(inputNum))
		$numTileMap.set_cellv(cellPos, -1)

		if smallTile.get_cellv(cellPos) == 0:
			smallTile.set_cellv(cellPos, 1)
		else:
			smallTile.set_cellv(cellPos, 0)

func highlight_numbers() -> void:
	var hoverNum = $numTileMap.get_cellv(cellPos)
	if hoverNum < 0:
		return
	if hoverNum > 9:
		hoverNum -= 9
	for xi in range(9):
		for yi in range(9):
			if $numTileMap.get_cell(xi,yi) in [hoverNum, hoverNum+9]:
				$highlightTileMap.set_cell(xi,yi,0)
