extends ResourceBehaviour
class_name FireBallAbility

var ballNode : Node2D = null

func Trigger():
	if (ballNode != null):
		ballNode.position.x += 1
	pass
