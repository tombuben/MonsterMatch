class_name CuttablePolygon extends Polygon2D

var trigger : Area2D
var colliderPolygon : CollisionPolygon2D

@export var beardRoots : CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# ensure we have a collider to check if cursor is above
	trigger = Area2D.new()
	add_child(trigger)
	colliderPolygon = CollisionPolygon2D.new()
	colliderPolygon.polygon = polygon
	
	trigger.add_child(colliderPolygon)
	

func cut(start_screen_point : Vector2, end_screen_point : Vector2):
	var polyline = PackedVector2Array()
	
	polyline.append(get_global_transform().affine_inverse() * start_screen_point)
	polyline.append(get_global_transform().affine_inverse() * end_screen_point)
	
	polyline = Geometry2D.offset_polyline(polyline, 2)[0]
	var cutpolygons = Geometry2D.clip_polygons(polygon, polyline)
	
	if len(cutpolygons) == 1:
		polygon = cutpolygons[0]
	elif len(cutpolygons) > 1:
		polygon = []
		trigger.queue_free()
		for index in cutpolygons.size():
			var newpoly = cutpolygons[index]
			
			# ugly but simple to write
			var intersections = Geometry2D.intersect_polygons(newpoly, beardRoots.polygon)
			
			var node = CuttablePolygon.new()
			node.polygon = newpoly
			node.texture = texture
			node.beardRoots = beardRoots
			
			if len(intersections) == 0:
				var rigid = RigidBody2D.new()
				add_child(rigid)
				rigid.add_child(node)
			else:
				add_child(node)


func calculate_center_of_mass_expensive():
	var triangulationIndices = Geometry2D.triangulate_polygon(polygon)
	var area = 0
	var center_of_mass = Vector2(0,0)
	for i in len(triangulationIndices) / 3:
		var a = polygon[triangulationIndices[i * 3 + 0]]
		var b = polygon[triangulationIndices[i * 3 + 1]]
		var c = polygon[triangulationIndices[i * 3 + 2]]
		
		var triangleCenter = (a + b + c) / 3
		
		var ab = b - a
		var ac = c - a
		var triangleArea = ab.cross(ac) * 0.5
		
		var totalArea = area + triangleArea
		var originalPart = area / totalArea
		var newPart = triangleArea / totalArea
		center_of_mass = originalPart * center_of_mass + newPart * triangleCenter
		
	return center_of_mass
