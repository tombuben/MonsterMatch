class_name CuttablePolygon extends Polygon2D

var trigger : Area2D
var colliderPolygon : CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# ensure we have a collider to check if cursor is above
	trigger = Area2D.new()
	add_child(trigger)
	colliderPolygon = CollisionPolygon2D.new()
	trigger.add_child(colliderPolygon)
	
	colliderPolygon.polygon = polygon

func cut(start_point : Vector2, end_point : Vector2):
	var polyline = PackedVector2Array()
	polyline.append(start_point)
	polyline.append(end_point)
	
	polyline = Geometry2D.offset_polyline(polyline, 2)[0]
	var cutpolygons = Geometry2D.clip_polygons(polygon, polyline)
	
	if len(cutpolygons) == 1:
		polygon = cutpolygons[0]
	elif len(cutpolygons) > 1:
		polygon = []
		trigger.queue_free()
		for index in cutpolygons.size():
			var newpoly = cutpolygons[index]
			var node = CuttablePolygon.new()
			node.polygon = newpoly
			node.texture = texture
			
			add_child(node)
