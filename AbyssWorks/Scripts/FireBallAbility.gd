extends Ability
class_name FireBallAbility

var ballNode : Node2D

func Trigger():
	if (ballNode):
		ballNode.position.x += 1
	pass
