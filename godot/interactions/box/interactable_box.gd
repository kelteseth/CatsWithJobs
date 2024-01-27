extends RigidBody2D

@export var vfx_prefab: PackedScene
@export var flame_field_prefab: PackedScene

var current_health = 100
var max_health = 100

var spawned_flame_field: Node
var spawned_flame_vfx: Node
var burn_sources: int = 0

var current_gravity_force = Vector2.ZERO

func react_to_gravity(direction: Vector2, strength: float):
	current_gravity_force = direction * strength * mass

func react_to_fire(damage_per_second: float, field: Node):
	if field in self.get_children():
		return
		
	if damage_per_second > 0:
		$AudioStreamPlayerBurning.play()
		
		self.burn_sources += 1
		if self.burn_sources == 1:
			var instance
			instance = self.vfx_prefab.instantiate()
			self.add_child(instance)
			self.spawned_flame_vfx = instance
			
			instance = self.flame_field_prefab.instantiate()
			call_deferred("add_child", instance)
			self.spawned_flame_field = instance
	else:
		self.burn_sources -= 1
		if self.burn_sources == 0:
			$AudioStreamPlayerBurning.stop()
			self.spawned_flame_vfx.queue_free()
			self.spawned_flame_field.queue_free()


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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.burn_sources > 0:
		self.current_health -= 20 * delta
	
	if self.current_health < 0:
		self.queue_free()
	
	self.modulate = Color.WHITE * self.current_health * 0.01
	var red = clamp(self.modulate.r, 0.3, 1.0)
	var green = clamp(self.modulate.g, 0.3, 1.0)
	var blue = clamp(self.modulate.b, 0.3, 1.0)
	self.modulate = Color(red, green, blue)

func _integrate_forces(state):
	apply_central_force(current_gravity_force)


func _on_body_entered(body):
	$AudioStreamPlayerColliding.play()

