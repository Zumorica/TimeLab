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
		CREATE_HUD(1,2,13,1, m_id="Main HUD")
		CREATE_STATUS("15,12", "Health", "HealthDisplay")
		CREATE_STATUS("15,12", "Health1", "HealthDisplay1")
		CREATE_STATUS("15,12", "Health2", "HealthDisplay2")
		CREATE_STATUS("15,12", "Health3", "HealthDisplay3")
		CREATE_BUTTON("15, 1", "IntentButton", "Intent")
		CREATE_BUTTON("15, 1", "IntentButton1", "Intent1")
