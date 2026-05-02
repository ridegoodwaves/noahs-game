extends RefCounted
class_name ShopSystem


static func try_purchase(entry: Dictionary, profile: Node) -> bool:
	var price := int(entry.get("price", 0))
	var id := str(entry.get("id", ""))
	if id.is_empty():
		return false
	if profile.has_instruction(id):
		return false
	var flags := {}
	if not InstructionCatalog.can_purchase(entry, profile.wealth_tier, flags):
		return false
	if not profile.spend_studs(price):
		return false
	profile.own_instruction(id)
	return true
