
/*
	Group: Basic Macros and Defines
	Author(s): Naught
	Description:
		Basic macros and definitions for
		use anywhere in the framework.
*/

#define QUOTE(val) #val
#define DEFAULT_PARAM(idx,dft) if ((count _this) > idx) then {_this select idx} else {dft}

/*
	Group: Module Macros and Defines
	Author(s): Naught
	Description:
		These macros and definitions are used in
		the module configs. They shouldn't be used
		anywhere else, and may be overwritten in SQF.
*/

#define MODULE(mod) \
	class mod { \
		title		= QUOTE(-------- mod); \
		values[]	= {0}; \
		texts[]		= {"Settings --------"}; \
		default		= 0;
#define END_MODULE }
