#ifndef ABSOLUTE_MINIMUM_MODE
#include "map_files\shared\CentCom.dmm" //this MUST be loaded no matter what for SSmapping's multi-z to work correctly
#else
#include "map_files\shared\CentCom_minimal.dmm"
#endif

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS // I cry
		#include "map_files/debug/roguetest.dmm"
		#include "map_files/daftmarsh/daftmarsh_outland.dmm"
		#include "map_files/daftmarsh/daftmarsh.dmm"
		#include "map_files/kalypso/projectkalypso.dmm"
		#include "map_files/rosewood/rosewood_forest.dmm"
		#include "map_files/rosewood/rosewood_marsh.dmm"
		#include "map_files/rosewood/rosewood_mountain.dmm"
		#include "map_files/rosewood/rosewood.dmm"
		#include "map_files/vanderlin/vanderlin_bog.dmm"
		#include "map_files/vanderlin/vanderlin_forest.dmm"
		#include "map_files/vanderlin/vanderlin_mountain.dmm"
		#include "map_files/vanderlin/vanderlin.dmm"
		#include "map_files/voyager/voyager.dmm"
		#include "map_files/whitepalacepass/WhitePalacePass.dmm"
	#endif
	#ifdef ALL_TEMPLATES
		#include "templates.dm"
	#endif
#endif
