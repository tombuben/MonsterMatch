extends Node2D


enum {IDLE, CUTTING}
var brush_state = IDLE

@export var cut_size : float = 15

@onready var last_position : Vector2 = global_position
@onready var particles : GPUParticles2D = %GPUParticles2D
@onready var razor_sfx : AudioStreamPlayer2D = %RazorSFX

@onready var beard_particle_texture := preload("res://assets/Barnabus/beard_particle.png")
@onready var godot_particle_texture := preload("res://icon.svg")

func _ready():
	var monster := Globals.CurrentMonster
	
	match monster:
		Globals.MonsterTypeEnum.PIRATE:
			particles.texture = beard_particle_texture
		Globals.MonsterTypeEnum.SLIME:
			particles.texture = godot_particle_texture

func world_cut():
	
	var space_state = get_world_2d().direct_space_state
	
	var parameters = PhysicsShapeQueryParameters2D.new()
	var shape = SegmentShape2D.new()
	shape.a = last_position
	shape.b = global_position
	parameters.shape = shape
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false

	var result = space_state.intersect_shape(parameters)
	for colliderData in result:
		var collider = colliderData["collider"]
		var parent = collider.get_parent()
		if parent.has_method("cut"):
			parent.cut(last_position, global_position, cut_size)
			particles.emitting = true
			

func _process(_delta):
	match brush_state:
		IDLE:
			if Input.is_action_just_pressed("UseToolRight"):
				brush_state = CUTTING
				razor_sfx.play()
		CUTTING:
			particles.emitting = false
			world_cut()
			
	
	if Input.is_action_just_released("UseToolRight"):
		brush_state = IDLE
		particles.emitting = false
		razor_sfx.stop()
		
	last_position = global_position

