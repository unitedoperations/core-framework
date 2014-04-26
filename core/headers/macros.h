
/*
	Title: Core Macros
*/

/*
	Section: General Macros
*/

#define QUOTE(var) #var
#define DOUBLES(var1,var2) ##var1##_##var2
#define TRIPLES(var1,var2,var3) ##var1##_##var2##_##var3
#define DEFAULT_PARAM(idx,dft) if ((count _this) > idx) then {_this select idx} else {dft}

/*
	Section: Function Macros
*/

#define DEPRECATE(oldFnc,newFunc) \
	(oldFnc = {_this call newFunc}) // Encapsulate in code brackets to disable copying of function

/*
	Section: Logging Macros
*/

#define LOG_FORMAT(varLevel,varComponent,varText,varParams) \
	[varLevel, varComponent, varText, varParams, __FILE__, __LINE__] call core_fnc_log

#define LOG(varLevel,varComponent,varText) \
	LOG_FORMAT(varLevel,varComponent,varText,[])

#define LOG_INFO(varComponent,varText) \
	LOG("Info",varComponent,varText)

#define LOG_NOTICE(varComponent,varText) \
	LOG("Notice",varComponent,varText)

#define LOG_WARNING(varComponent,varText) \
	LOG("Warning",varComponent,varText)

#define LOG_ERROR(varComponent,varText) \
	LOG("Error",varComponent,varText)

#define LOG_CRITICAL(varComponent,varText) \
	LOG("Critical",varComponent,varText)

/*
	Section: Internal Macros
*/

#define ARRAY_1(var1) [var1]
#define ARRAY_2(var1,var2) [var1,var2]
#define ARRAY_3(var1,var2,var3) [var1,var2,var3]
#define ARRAY_4(var1,var2,var3,var4) [var1,var2,var3,var4]
#define ARRAY_5(var1,var2,var3,var4,var5) [var1,var2,var3,var4,var5]
#define ARRAY_6(var1,var2,var3,var4,var5,var6) [var1,var2,var3,var4,var5,var6]
#define ARRAY_7(var1,var2,var3,var4,var5,var6,var7) [var1,var2,var3,var4,var5,var6,var7]
#define ARRAY_8(var1,var2,var3,var4,var5,var6,var7,var8) [var1,var2,var3,var4,var5,var6,var7,var8]
#define ARRAY_9(var1,var2,var3,var4,var5,var6,var7,var8,var9) [var1,var2,var3,var4,var5,var6,var7,var8,var9]
