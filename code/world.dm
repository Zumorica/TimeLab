/world
	fps = 30
	icon_size = 32
	view = "16x16"
	mob = /mob/new_player
	area = /area/underground

	/world/New()
		..()
		HUDS()																								// Creates HUDs.

	/world/proc/HUDS()
		CREATE_BUTTON("6, SOUTH", "Keychain", "Keychain")
		CREATE_BUTTON("7, SOUTH", "Back", "Back")
		CREATE_BUTTON("8, SOUTH", "LeftHand", "HLeft")
		CREATE_BUTTON("8, SOUTH", "LeftHandActive", "AHLeft")
		CREATE_BUTTON("9, SOUTH", "RightHand", "HRight")
		CREATE_BUTTON("9, SOUTH", "RightHandActive", "AHRight")
		CREATE_BUTTON("10, SOUTH", "Pocket", "Pocket")
		CREATE_BUTTON("11, SOUTH", "Pocket1", "Pocket1")
		CREATE_STATUS("16,12", "Health", "HealthDisplay")
		CREATE_STATUS("16,12", "Health1", "HealthDisplay1")
		CREATE_STATUS("16,12", "Health2", "HealthDisplay2")
		CREATE_STATUS("16,12", "Health3", "HealthDisplay3")
		CREATE_BUTTON("15, SOUTH", "IntentButton", "Intent")
		CREATE_BUTTON("15, SOUTH", "IntentButton1", "Intent1")
		CREATE_BUTTON("15, SOUTH", "Drop", "DropButton")
		CREATE_BUTTON("15, SOUTH", "Throw", "ThrowButton")
