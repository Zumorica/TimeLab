/world
	fps = 30
	icon_size = 32
	view = "15x15"
	mob = /mob/living/human
	area = /area/underground

	/world/New()
		..()
		HUDS()																								// Creates HUDs.

	/world/proc/HUDS()
		CREATE_HUD(1,3,15,1, m_id="Main HUD")
		CREATE_STATUS("15,12", "Health", "HealthDisplay")
