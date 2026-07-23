class_name MobileIAPFlowBoilerplate
extends Node

## Expert boilerplate for In-App Purchases (IAP).
## Abstracts GooglePlayBilling and AppleInAppStore functionality.

var _payment: Object = null

func _ready() -> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		_payment = Engine.get_singleton("GodotGooglePlayBilling")
		_payment.startConnection()
	elif Engine.has_singleton("InAppStore"):
		_payment = Engine.get_singleton("InAppStore")

func purchase_product(product_id: String) -> void:
	if not _payment:
		push_error("MobileIAP: No payment singleton found.")
		return
	
	# Platform specific purchase logic...
	if _payment.has_method("purchase"):
		_payment.purchase({"product_id": product_id})

## Expert: Always perform server-side receipt validation for production games.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/platform/android/android_in_app_purchases.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html
# - https://docs.godotengine.org/en/stable/tutorials/platform/ios/index.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md — product catalogs + receipt validation ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — store billing plugin / capability wiring
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md
# =============================================================================
