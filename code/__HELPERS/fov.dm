/proc/get_fov_angle(shadow_angle = FOV_90_DEGREES)
	switch(shadow_angle)
		if(FOV_90_DEGREES, FOV_180_DEGREES, FOV_270_DEGREES)
			return 0
		if(FOV_180MINUS45_DEGREES)
			return -45
		if(FOV_180PLUS45_DEGREES)
			return 45
