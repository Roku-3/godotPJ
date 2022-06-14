extends Node2D

const AccelStruct = preload("res://Script/AccelStructure.gd")
const Boid = preload("res://Scene/Fish.tscn")

export(int) var starting_boids = 20
export(int) var compute_groups = 4

export(Dictionary) var parameters = {
	"Cohesion":			20,
	"Separation":		30,
	"Alignment":		30,
	"TargetForce":		20,
	"ViewDistance":		80,
	"AvoidDistance":	15,
	"MinSpeed":			90,
	"MaxSpeed":			100,
	"MaxFlockSize":		25,
}

onready var screen_size: = get_viewport_rect().size
onready var scaled_points = range(starting_boids)

var accel_struct: AccelStruct
var boids = []


func _ready():
	init_boids()


func _process(delta):
	# rebuild the accel_struct for the entire scene
	build_struct()
	# update each boid with it's respective partition
	update_boids()
	
	# move the boids
	process_boids(delta)

func init_boids():
	#var initial_boid_values = $ControlsUI.get_current_values()
	var initial_boid_values = parameters
	
	# initialize the boids
	for _i in starting_boids:
		randomize()
		var boid = Boid.instance()
		var init_pos: = Vector2(rand_range(0, screen_size.x), rand_range(0, screen_size.y))
		boid.position = init_pos
		boid.add_to_group("boids")
		boid.set_values(initial_boid_values)
		boids.append(boid)
		$Boids.add_child(boid)


func build_struct():
	# set struct scale to a size that will (mostly) fit the view radius
	var struct_scale = floor(boids[0].view_distance / 2)
	accel_struct = AccelStruct.new(screen_size, struct_scale)
	for i in boids.size():
		var scaled_point = accel_struct.scale_point(boids[i].position)
		accel_struct.add_body(boids[i], scaled_point)
		scaled_points[i] = scaled_point


func update_boids():
	for i in boids.size():
		boids[i].flock = accel_struct.get_bodies(scaled_points[i])


func process_boids(delta):
	for group in compute_groups:
		process_group({"delta": delta, "group": group})


# I tried out compute groups and threads
# But both methods introduced stuttering
# I was sad.
func process_group(data):
	var start = boids.size() / compute_groups * data.group
	var end = start + boids.size() / compute_groups
	# if the number of bodies is not divisible by num_threads,
	# add the remainder to the last thread
	if data.group == compute_groups - 1:
		end += boids.size() % compute_groups
	for i in range(start, end):
		boids[i].process(data.delta)


# func reset_boids():
# 	# delete all curent boids
# 	for _i in boids.size():
# 		var boid = boids.pop_back()
# 		boid.queue_free()

# 	init_boids()


# func reset_simulation():
# 	# delete all curent boids
# 	for _i in boids.size():
# 		var boid = boids.pop_back()
# 		boid.queue_free()

# 	# factory reset controls
# 	$ControlsUI.reset()

# 	init_boids()


# func _unhandled_input(event: InputEvent):
# 	if event.is_action_released('toggle_controls'):
# 		$ControlsUI.visible = not $ControlsUI.visible
# 	elif event.is_action_released('exit'):
# 		get_tree().quit()
# 	elif event.is_action_released('toggle_grid'):
# 		$Grid.visible = not $Grid.visible
# 	elif event.is_action_released("reset_boids"):
# 		call_deferred("reset_boids")
# 	elif event.is_action_released("reset_simulation"):
# 		call_deferred("reset_simulation")
