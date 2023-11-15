extends Node
class_name Team

enum TeamType {
	PLAYER,
	ENEMY
}

@export var team: TeamType = TeamType.PLAYER
