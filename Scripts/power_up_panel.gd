extends ColorRect

var item = null

func initElement() :
	#$ColorRect/Sprite2D.texture = item["icon"]
	$name.text = item["displayname"]
	$description.text = item["details"]
	$price.text = str(item["priceInital"])
	#$ColorRect/Sprite2D.scale = Vector2($ColorRect/Sprite2D.texture.get_width(), $ColorRect/Sprite2D.texture.get_height())
