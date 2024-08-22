extends PanelContainer

var item = null
var button

func initElement() :
	button = $HbcIcon/McPriceBtn/VbcPriceBtn/Button
	$HbcIcon/ArcIcon/TrIcon.texture = item["icon"]
	$HbcIcon/McNameDesc/HbcNameDesc/name.text = item["displayname"]
	$HbcIcon/McNameDesc/HbcNameDesc/description.text = item["details"]
	$HbcIcon/ArcIcon/TrIcon.scale = Vector2($HbcIcon/ArcIcon/TrIcon.texture.get_width(), $HbcIcon/ArcIcon/TrIcon.texture.get_height())
	updateButton()

func getPrice():
	return max(item["priceInital"], item["priceInital"] + (GameManager.getLevelFromItem(item) * item["priceAugmentationByLv"]))

func updateButton():
	if item["maxLevel"] > GameManager.getLevelFromItem(item):
		if getPrice() <= GameManager.coins :
			$HbcIcon/McPriceBtn/VbcPriceBtn/Button.disabled = false
			$HbcIcon/McPriceBtn/VbcPriceBtn/Button.text = "BUY"
			$HbcIcon/McPriceBtn/VbcPriceBtn/Button.focus_mode = FocusMode.FOCUS_ALL
		else :
			$HbcIcon/McPriceBtn/VbcPriceBtn/Button.disabled = true
			$HbcIcon/McPriceBtn/VbcPriceBtn/Button.text = "NOT ENOUGH MONEY"
			$HbcIcon/McPriceBtn/VbcPriceBtn/Button.focus_mode = FocusMode.FOCUS_NONE
		$HbcIcon/McPriceBtn/VbcPriceBtn/HbcPriceBtn/price.text = str(getPrice())
		
	else :
		$HbcIcon/McPriceBtn/VbcPriceBtn/Button.disabled = true
		$HbcIcon/McPriceBtn/VbcPriceBtn/Button.text = "OUT OF STOCK"
		$HbcIcon/McPriceBtn/VbcPriceBtn/Button.focus_mode = FocusMode.FOCUS_NONE
		$HbcIcon/McPriceBtn/VbcPriceBtn/HbcPriceBtn/price.text = "--"

func _on_button_pressed() -> void:
	AudioManager.playAudioSelect()
	GameManager.addLevelFromItem(item)
	GameManager.remove_coins(max(item["priceInital"], item["priceInital"] + ((GameManager.getLevelFromItem(item)-1) * item["priceAugmentationByLv"])))
	SaveAndLoad.saveDataFromSaveFile(GameManager.gameSlot)
