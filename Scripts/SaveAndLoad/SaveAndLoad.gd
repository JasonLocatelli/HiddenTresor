extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "save%s.json"
const SECURITY_KEY = "3BBF34FY7BF38VC39"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	verifySaveDirectory(SAVE_DIR)

func verifySaveDirectory(pPath : String):
	DirAccess.make_dir_absolute(pPath)

func saveData(pPath : String):
	var file = FileAccess.open_encrypted_with_pass(pPath, FileAccess.WRITE, SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return
	var data = {
		"playerData": {
			"coins": GameManager.coins,
			"speedLevel": GameManager.speedLevel,
			"oxygeneLevel": GameManager.oxygeneLevel
		}
	} 
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close

func loadDataFromSaveFile(pFileNumber : int):
	loadData(SAVE_DIR + (SAVE_FILE_NAME % str(pFileNumber)))
	
func saveDataFromSaveFile(pFileNumber : int):
	saveData(SAVE_DIR + (SAVE_FILE_NAME % str(pFileNumber)))

func deleteDataFromSaveFile(pFileNumber : int):
	deleteFile(SAVE_DIR + (SAVE_FILE_NAME % str(pFileNumber)))

func fileExist(pFileNumber : int):
	return FileAccess.file_exists(SAVE_DIR + (SAVE_FILE_NAME % str(pFileNumber)))

func loadData(pPath : String):
	if FileAccess.file_exists(pPath):
		var file = FileAccess.open_encrypted_with_pass(pPath, FileAccess.READ, SECURITY_KEY)
		if file == null:
			print(FileAccess.get_open_error())
		var content = file.get_as_text()
		file.close()
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json_string" % [pPath, content])
		extractData(data)
	else :
		printerr("Cannot open non-existent file at %s" % [pPath])

func extractData(data):
	GameManager.coins = data.playerData.coins
	GameManager.speedLevel = data.playerData.speedLevel
	GameManager.oxygeneLevel = data.playerData.oxygeneLevel
	
func deleteFile(pPath : String):
	if FileAccess.file_exists(pPath):
		DirAccess.remove_absolute(pPath)
