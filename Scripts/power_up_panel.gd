extends PanelContainer

var item = null

func initElement() :
	#$HbcIcon/ArcIcon/TrIcon.texture = item["icon"]
	$HbcIcon/McNameDesc/HbcNameDesc/name.text = item["displayname"]
	$HbcIcon/McNameDesc/HbcNameDesc/description.text = item["details"]
	#$ColorRect/Sprite2D.scale = Vector2($ColorRect/Sprite2D.texture.get_width(), $ColorRect/Sprite2D.texture.get_height())
	updateButton()

func getPrice():
	return max(item["priceInital"], item["priceInital"] + (GameManager.getLevelFromItem(item) * item["priceAugmentationByLv"]))

func updateButton():
	if item["maxLevel"] > GameManager.getLevelFromItem(item):
		if getPrice() <= GameManager.coins :
			$HbcIcon/McPriceBtn/VbcPriceBtn/Button.disabled = false
			$HbcIcon/McPriceBtn/VbcPriceBtn/Button.text = "BUY"
		else :
			$HbcIcon/McPriceBtn/VbcPriceBtn/Button.disabled = true
			$HbcIcon/McPriceBtn/VbcPriceBtn/Button.text = "SORRY"
		$HbcIcon/McPriceBtn/VbcPriceBtn/HbcPriceBtn/price.text = str(getPrice())
		
	else :
		$HbcIcon/McPriceBtn/VbcPriceBtn/Button.disabled = true
		$HbcIcon/McPriceBtn/VbcPriceBtn/Button.text = "OUT OF STOCK"
		$HbcIcon/McPriceBtn/VbcPriceBtn/HbcPriceBtn/price.text = "--"

func _on_button_pressed() -> void:
	GameManager.addLevelFromItem(item)
	GameManager.remove_coins(item["priceInital"])
	SaveAndLoad.saveDataFromSaveFile(GameManager.gameSlot)
