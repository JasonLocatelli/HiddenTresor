extends Node2D

@onready var collision = $Area2D/CollisionShape2D

var velocity = 0
var force = 0
var height = 0
var target_height = 0
var index = 0
var motion_factor = 0.014

var collided_with = null
signal splash

func water_update(sprintConstant, dampening):
	height = position.y
	var x = height - target_height
	var loss = -dampening * velocity
	force = - sprintConstant * x + loss
	velocity += force
	position.y += velocity

func initialize(x_position, id):
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position
	index = id
	
func set_collision_width(value):
	var extents = collision.shape.size
	var new_extents = Vector2(value/2, extents.y)
	collision.shape.size = new_extents

func _on_area_2d_body_entered(body):
	if body == collided_with:
		return
	collided_with = body
	if (!(body is StaticBody2D)) :
		var speed = body.velocity.y * motion_factor
		emit_signal("splash", index, speed)
