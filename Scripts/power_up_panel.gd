extends PanelContainer

var item = null

func initElement() :
	#$HbcIcon/ArcIcon/TrIcon.texture = item["icon"]
	$HbcIcon/McNameDesc/HbcNameDesc/name.text = item["displayname"]
	$HbcIcon/McNameDesc/HbcNameDesc/description.text = item["details"]
	$HbcIcon/McPriceBtn/VbcPriceBtn/HbcPriceBtn/price.text = str(item["priceInital"])
	#$ColorRect/Sprite2D.scale = Vector2($ColorRect/Sprite2D.texture.get_width(), $ColorRect/Sprite2D.texture.get_height())
