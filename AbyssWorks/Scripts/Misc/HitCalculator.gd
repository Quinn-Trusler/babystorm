extends RefCounted
class_name HitCalculator

class Hit2D:
	var hit_point: Vector2 = Vector2.ZERO
	var hit_normal: Vector2 = Vector2.ZERO
	
	func _init(_hit_point: Vector2, _hit_normal: Vector2) -> void:
		hit_point = _hit_point
		hit_normal = _hit_normal

func get_collision_shape_node(parent: Node) -> CollisionShape2D:
	for child in parent.get_children():
		if child is CollisionShape2D:
			return child
	return null

func calculateHit2D(hitter: Node2D, collided: Node2D) -> Hit2D:
	if hitter == null or collided == null:
		return null
	
	var collidedColShape: CollisionShape2D = get_collision_shape_node(collided)
	
	if collidedColShape == null:
		return null
	
	var hitPoint = get_closest_point_on_capsule(collidedColShape, hitter.global_position)
	var hitNormal = (collided.global_position - hitter.global_position).normalized()
	
	var hit: Array[Vector2] = [hitPoint, hitNormal]
	
	return Hit2D.new(hitPoint, hitNormal)

func get_closest_point_on_capsule(capsule_node: CollisionShape2D, target_pos: Vector2) -> Vector2:
	var shape = capsule_node.shape as CapsuleShape2D
	if not shape: return target_pos
	
	# 1. Calculate the spine (the line connecting the two inner circle centers)
	var half_spine_dist = (shape.height / 2.0) - shape.radius
	
	# 2. Get global positions for the spine endpoints
	var g_top = capsule_node.to_global(Vector2(0, -half_spine_dist))
	var g_bottom = capsule_node.to_global(Vector2(0, half_spine_dist))
	
	# 3. Find the closest point on that spine segment to our target
	var point_on_spine = Geometry2D.get_closest_point_to_segment(target_pos, g_top, g_bottom)
	
	# 4. SAFETY: If the target is exactly on the spine, it's definitely inside
	if target_pos.is_equal_approx(point_on_spine):
		return target_pos
	
	# 5. Check if the point is inside using squared distance (perf optimization)
	var dist_sq = target_pos.distance_squared_to(point_on_spine)
	if dist_sq <= shape.radius * shape.radius:
		return target_pos 
	
	# 6. Otherwise, return the closest point on the perimeter
	var direction_to_edge = (target_pos - point_on_spine).normalized()
	return point_on_spine + (direction_to_edge * shape.radius)
