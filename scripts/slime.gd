extends CharacterBody2D

@export var ai : Node
@export var debug_speed : float = 64


func _ready():
	ai.speed = debug_speed


