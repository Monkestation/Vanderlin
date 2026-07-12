/// File path used for the "enable tracy next round" functionality
/// The server port is appended to the end of the filename to avoid conflicts if multiple servers share the same data folder.
#define TRACY_ENABLE_PATH "data/enable_tracy.[world.port]"
/// The DLL path for byond-tracy.
#define TRACY_DLL_PATH (world.system_type == MS_WINDOWS ? "prof.dll" : "./libprof.so")
