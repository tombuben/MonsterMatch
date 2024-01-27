extends Node

enum{
	MISSING = -1,
	CORRECT = 2,
	EXTRA = -2
}

func compare_validation_matrices(desired: Array[Vector2i], actual: Array[Vector2i]):
	var penalization : int = 0
	var sets_union: Dictionary
	
	for i in desired:
		sets_union[i] = MISSING
	for i in actual:
		if i in sets_union.keys():
			sets_union[i] = CORRECT
		else:
			sets_union[i] = EXTRA
	
	for value in sets_union.values():
		penalization += value
	
	return penalization
