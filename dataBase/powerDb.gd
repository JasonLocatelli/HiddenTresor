extends Node

const ICON_PATH = "res://Sprites/Upgrade/"

const UPGRADE = {
	"POWER": {
		"icon": preload(ICON_PATH+"Joint2.png"),
		"id":"POWER",
		"displayname": "MORE POWER",
		"details": "ADD 2 POWER",
		"maxLevel" : 1,
		"priceInital" : 1,
		"priceAugmentationByLv" : 1, 
		"prerequisite": [],
	},
	"OXYGENE": {
		"icon": preload(ICON_PATH+"Joint2.png"),
		"id":"OXYGENE",
		"displayname": "MORE OXYGENE",
		"details": "ADD 10 seconds",
		"maxLevel" : 30,
		"priceInital" : 1,
		"priceAugmentationByLv" : 5, 
		"prerequisite": [],
	},
	"SPEED": {
		"icon": preload(ICON_PATH+"Joint2.png"),
		"id":"SPEED",
		"displayname": "MORE SPEED",
		"details": "ADD SPEED",
		"maxLevel" : 20,
		"priceInital" : 10,
		"priceAugmentationByLv" : 30, 
		"prerequisite": [],
	},
	"DASH": {
		"icon": preload(ICON_PATH+"Joint2.png"),
		"id":"DASH",
		"displayname": "DASH",
		"details": "NOW YOU CAN DASH",
		"maxLevel" : 1,
		"priceInital" : 10,
		"priceAugmentationByLv" : 30, 
		"prerequisite": [],
	}
}
