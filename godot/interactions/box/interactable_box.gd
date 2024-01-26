extends RigidBody2D

@export var flame: PackedScene

var current_health = 1
var max_health = 1

var current_gravity_force = Vector2.ZERO

func react_to_gravity(direction: Vector2, strength: float):
	current_gravity_force = direction * strength * mass

func react_to_fire(damage_per_second: float):
	var instance = self.flame.instantiate()
	self.add_child(instance)

func react_to_force():
	pass

func react_to_cold():
	pass

func react_to_wetness():
	pass

func react_to_electriity():
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(Vector2(100, 0))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _integrate_forces(state):
	apply_central_force(current_gravity_force)
