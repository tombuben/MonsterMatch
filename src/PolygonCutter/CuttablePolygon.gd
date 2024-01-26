extends Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready():
	cut(Vector2(10,300), Vector2(700,300))
	pass # Replace with function body.

func cut(start_point : Vector2, end_point : Vector2):
	var polyline = PackedVector2Array()
	polyline.append(start_point)
	polyline.append(end_point)
	
	polyline = Geometry2D.offset_polyline(polyline, 2)[0]
	var cutpolygons = Geometry2D.clip_polygons(polygon, polyline)
	
	print(len(cutpolygons))
	if len(cutpolygons) == 1:
		polygon = cutpolygons[0]
	elif len(cutpolygons) > 1:
		polygon = []
		for index in cutpolygons.size():
			var newpoly = cutpolygons[index]
			var node = Polygon2D.new()
			node.set_name("piece %d" % index)
			add_child(node)
			
			node.polygon = newpoly
			node.texture = texture
