#ifndef ABSOLUTE_MINIMUM_MODE
#include "map_files\shared\CentCom.dmm" //this MUST be loaded no matter what for SSmapping's multi-z to work correctly
#else
#include "map_files\shared\CentCom_minimal.dmm"
#endif

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\debug\roguetest.dmm"
		#include "map_files\vanderlin\vanderlin.dmm"
		#include "map_files\rosewood\rosewood.dmm"
		#include "map_files\whiteplacepass\WhitePalacePass.dmm"
		#include "map_files\daftmarsh\daftmarsh.dmm"

		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
