extends RigidBody2D

@export var vfx_prefab: PackedScene
@export var flame_field_prefab: PackedScene

var current_health = 1
var max_health = 1

var spawned_flame_field: Node
var spawned_flame_vfx: Node

var current_gravity_force = Vector2.ZERO

func react_to_gravity(direction: Vector2, strength: float):
	current_gravity_force = direction * strength * mass

func react_to_fire(damage_per_second: float):
	if damage_per_second > 0:
		if self.spawned_flame_field == null:
			var instance
			instance = self.vfx_prefab.instantiate()
			self.add_child(instance)
			self.spawned_flame_vfx = instance
			
			instance = self.flame_field_prefab.instantiate()
			call_deferred("add_child", instance)
			self.spawned_flame_field = instance
	else:
		call_deferred("queue_free", self.spawned_flame_vfx)
		call_deferred("queue_free", self.spawned_flame_field)


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


func _on_body_entered(body):
	print("TOOD tell hit body to take damage")

