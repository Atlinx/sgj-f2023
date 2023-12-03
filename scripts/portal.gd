extends Node2D

#var transfer : bool = false
#
#func _on_portal_1_body_entered(body):
#	print(body)
#	if transfer:
#		body.global_position = get_tree().get_first_node_in_group("portal2").global_position
#		transfer = false

#func _on_portal_2_body_entered(body):
#	print(body)
#	if transfer:
#		body.global_position = get_tree().get_first_node_in_group("portal1").global_position
#		transfer = false
#
#func _process(delta):
#	if Input.is_action_just_pressed("portal"):
#		transfer = true





func _on_body_entered(body):
	print(body)
