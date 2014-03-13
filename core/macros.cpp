
/*
	Group: Basic Macros and Defines
	Author(s): Naught
	Description:
		Basic macros and definitions for
		use anywhere in the framework.
*/

#define QUOTE(val) #val
#define DOUBLES(var1,var2) ##var1##_##var2
#define TRIPLES(var1,var2,var3) ##var1##_##var2##_##var3
#define DEFAULT_PARAM(idx,dft) if ((count _this) > idx) then {_this select idx} else {dft}
