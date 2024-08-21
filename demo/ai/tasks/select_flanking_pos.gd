#*
#* select_flanking_pos.gd
#* =============================================================================
#* Copyright 2021-2024 Serhii Snitsaruk
#*
#* Use of this source code is governed by an MIT-style
#* license that can be found in the LICENSE file or at
#* https://opensource.org/licenses/MIT.
#* =============================================================================
#*
@tool
extends BTAction
## Selects a position on the target's side and stores it on the
## blackboard, returning [code]SUCCESS[/code]. [br]
## Returns [code]FAILURE[/code] if the target is not valid.

enum AgentSide {
	CLOSEST,
	FARTHEST,
	BACK,
	FRONT,
}

## Blackboard variable that holds current target (should be a Node2D instance).
@export var target_var: StringName = &"target"

## Which agent's side should we flank?
@export var flank_side: AgentSide = AgentSide.CLOSEST

## Minimum range relative to the target.
@export var range_min: int = 300

## Maximum range relative to the target.
@export var range_max: int = 400

## Blackboard variable that will be used to store selected position.
@export var directionVar: StringName = &"dir"

# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	var target := blackboard.get_var(target_var) as Node2D
	if not is_instance_valid(target):
		return FAILURE

	var directionToTarget = agent.global_position.direction_to(target.position).angle()
	#if not agent.is_good_position(flank_pos):
		# Choose the opposite side if the preferred side is not good (i.e., inside a collision shape).
#		flank_pos = target.global_position - offset
	blackboard.set_var(directionVar,directionToTarget+deg_to_rad(90))
	return SUCCESS
