extends RefCounted
class_name StudWallet

var studs: int = 0


func add(amount: int) -> void:
	studs += maxi(0, amount)


func can_spend(amount: int) -> bool:
	return studs >= amount


func spend(amount: int) -> bool:
	if not can_spend(amount):
		return false
	studs -= amount
	return true
