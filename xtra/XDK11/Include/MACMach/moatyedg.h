/*
ADOBE SYSTEMS INCORPORATED
Copyright 1994 - 2008 Adobe Macromedia Software LLC
All Rights Reserved

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
*/

#ifndef _H_moatyedg
#define _H_moatyedg

/*
    File: moatyedg.h (mac)
    Abstract:
    Fundamental types for the MOA Services library.
*/

/*---------------------------------------------------------------------------
/ 1. Include other headers we depend on.
/--------------------------------------------*/
/*-------------------------------------------------------------------------*/

#include <CodeFragments.h>
#include <Files.h>
#include <TextUtils.h>

#include <string.h>
#include <libkern/OSAtomic.h>
#if (defined(__APPLE__) && defined(__MACH__)) // for set_new_handler
#ifdef __cplusplus
#include <new>
#endif
#endif

/*---------------------------------------------------------------------------
/ 2. Define constants and macros.
/--------------------------------------------*/

/*-------------------------------------------------------------------------*/
/*
    every platform must define a MOAPLATFORM_xxx code.
*/

#if (!defined(__APPLE_CC__)) || defined(WINDOWS) || defined(_WINDOWS) || !(defined(__APPLE__) && defined(__MACH__))
    #error "This is a Macintosh XCode file."
#endif

/*-------------------------------------------------------------------------*/
/*
    This is a unique string to decribe the MOAPLATFORM_ code.
    It should be exactly 5 characters, not including the
    null terminator.
*/

#if (defined(__BIG_ENDIAN__))
	#define MOAPLATFORM_MACXPPC
	#define MOA_PLATFORM_NAME   "MacMP"
#endif

#if (defined(__LITTLE_ENDIAN__))
	#define MOAPLATFORM_MACINTEL
	#define MOA_PLATFORM_NAME   "MacMI"
#endif

/*-------------------------------------------------------------------------*/
/*
    if your compiler easily chokes on complex macros, define this.
    we remove some two-stage macros that reduce the flexibility
    but allow for compilation on older compilers.
*/
#undef COMPILER_LIMITED_MACRO_SPACE

/*-------------------------------------------------------------------------*/
/*
    if C++ bindings are allowed in this compiler configuration,
    define this; otherwise, undefine it.
*/
#undef MOA_CPLUS_BINDINGS_ALLOWED
#if defined(__cplusplus)
    #define MOA_CPLUS_BINDINGS_ALLOWED  1
#endif

/*-------------------------------------------------------------------------*/
/*
    If the current compiler configuration allows for auto-initialization
    of static variables to addresses (e.g., void* foo = &bar; ),
    define this; otherwise, undefine it. undefining it has the
    effect of always forcing "safer" vtables (rather than "smaller" vtables).
*/
#define MOA_STATIC_ADDR_ALLOWED

/*-------------------------------------------------------------------------*/
/*
    if the standard COM definitions have already been done
    by system includes, define _MOA_COM_PROVIDED_
*/

#undef _MOA_COM_PROVIDED_
#if defined(__COMPOBJ__) || defined(_OBJBASE_H_)
	#define _MOA_COM_PROVIDED_
#endif


/*-------------------------------------------------------------------------*/
/*
    This should define a type as being read-only constant data,
    and attempt to place all such data into a common segment
    for linkage redirection. usage is

        MOA_READONLY(MoaLong) gFoo = 1;

    declares gFoo to be a read-only MoaLong. Note that this
    is only allowed for statically initialized stuff.
*/
#define MOA_READONLY(macro_TYPE) const macro_TYPE

/*-------------------------------------------------------------------------*/
/*
    This macro is used to enforce that all methods and routines declared
    using STDMETHOD or STDAPI follow proper calling conventions.
    It doesn't change the declaration of the method, routine, or class,
    but should try to ensure the compiler is in the correct "mode",
    generating a compiler error if not.

    it's really just a trick used on 68k Macs to make sure you #pragma your
    stuff correctly: we prototype a function with pointers_in_D0
    in effect, then re-prototype it in all the places you need
    the pragma. if you forget, you'll get a compile error
    about "pointers_in_D0_reminder redeclared". unfortunately,
    we can't fix this for you automatically (since you can't include
    #pragma's inside macros) but we can type check and make sure you
    don't make a mistake.
*/
#define _MOA_PTRCHECK

/*-------------------------------------------------------------------------*/
/*
    If the wacky "pointers_in_D0" macro is required, define
    MOA_pointers_in_D0; otherwise, don't define it.
*/
#undef MOA_pointers_in_D0

/*-------------------------------------------------------------------------*/
/*
    If the compiler understands the "#pragma export" pragma,
    define MOA_EXPORT_LIST, otherwise undefine it.
*/
#define MOA_EXPORT_LIST

/*-------------------------------------------------------------------------*/
/*
    Magic Cookie structure needed below.
*/
typedef struct _MoaXtraMagicCookie * MoaXtraMagicCookie;

/*-------------------------------------------------------------------------*/
/*
    The following X_ macros are used to set up any global context
    pointers necessary when entering and exiting method or API call.
    Usage is as follows:

    X_ENTER -- used immediately after opening brace of a method
        or function.
    X_EXIT -- used immediately before the closing brace of a method
        or function.
    X_RETURN and X_RETURN_VOID -- used to return a value from
        within an X_ENTER/X_EXIT block. return CANNOT be used
        within this block.
*/
#define X_ENTER                     { _MOA_PTRCHECK
#define X_ENTER_(macro_COOKIE)		{ _MOA_PTRCHECK
#define X_ENTER_A4(macro_A4)		{ _MOA_PTRCHECK
#define X_ENTER_DLLENTRYPOINT		{ _MOA_PTRCHECK
#define X_ABORT						{ }
#define X_EXIT                      }
#define X_RETURN(retType, retVal)	do { return(retVal); } while (0)
#define X_RETURN_VOID				do { return; } while (0)
#define X_STD_RETURN(retVal)        X_RETURN(MoaError, retVal)

/*-------------------------------------------------------------------------*/
/*
    macro for declaring a function an external C function.
    says nothing about calling convention.
*/
#ifndef EXTERN_C
    #ifdef __cplusplus
        #define EXTERN_C    extern "C"
    #else
        #define EXTERN_C    extern
    #endif
#endif

/*-------------------------------------------------------------------------*/

#ifndef _MOA_COM_PROVIDED_
	/*
	    The calling convention for a COM method (typically cdecl)
	*/
	#define STDMETHODCALLTYPE                   /* cdecl */

	/*-------------------------------------------------------------------------*/
	/*
	    The calling convention for an API routine (typically pascal)
	*/
	#define STDAPICALLTYPE                      pascal

	/*-------------------------------------------------------------------------*/
	/* same as STDAPIIMP_ and STDAPIIMP, but an external prototype. */
	#define STDAPI_(macro_TYPE)                 _MOA_PTRCHECK EXTERN_C STDAPICALLTYPE macro_TYPE
	#define STDAPI                              STDAPI_(MoaError)

	/*-------------------------------------------------------------------------*/
	/* declare a function of STDMETHOD convention returning a given type. */
	#define STDMETHODIMP_(returnType)           _MOA_PTRCHECK returnType STDMETHODCALLTYPE

	/*-------------------------------------------------------------------------*/
	/* declare a function of STDMETHOD convention returning MoaError. */
	#define STDMETHODIMP                        STDMETHODIMP_(MoaError)

#endif	/* _MOA_COM_PROVIDED_ */

/*-------------------------------------------------------------------------*/
/* declare a function of STDAPI convention returning a given type. */
#define STDAPIIMP_(macro_TYPE)              _MOA_PTRCHECK STDAPICALLTYPE macro_TYPE

/*-------------------------------------------------------------------------*/
/* declare a function of STDAPI convention returning MoaError. */
#define STDAPIIMP                           STDAPIIMP_(MoaError)

/*-------------------------------------------------------------------------*/
/* same as STDMETHODIMP_ and STDMETHODIMP, but an external prototype. */
#define EXTERN_STDMETHODIMP_(returnType)    _MOA_PTRCHECK EXTERN_C returnType STDMETHODCALLTYPE
#define EXTERN_STDMETHODIMP                 EXTERN_STDMETHODIMP_(MoaError)

/*-------------------------------------------------------------------------*/
/*
    macro to declare a procptr of STDMETHODCALLTYPE convention.
*/
#define MOA_STD_METHOD_PROCPTR(macro_RETURNTYPE, macro_PROCNAME) \
    STDMETHODCALLTYPE macro_RETURNTYPE ( * macro_PROCNAME)

/*-------------------------------------------------------------------------*/
/*
    macro to declare a procptr of STDAPICALLTYPE convention.
*/
#define MOA_STD_API_PROCPTR(macro_RETURNTYPE, macro_PROCNAME) \
    STDAPICALLTYPE macro_RETURNTYPE ( * macro_PROCNAME)

/*-------------------------------------------------------------------------*/
/*
    BEGIN_INTERFACE is used to define the initial padding (if any) in
    an interface's vtable. This should match the standard padding for
    COM objects on that platform. Windows uses no padding; Mac uses
    a single 4-byte pad. Other systems may or may not have standards
    defined.

    You should also define _MOA_VTABLE_EXTRA_ENTRIES to be the number of
    entries padded, and _MOA_VTABLE_FILL_EXTRA_ENTRIES to be enough
    declarations of NULL to fill the extra entries (e.g., if there
    are two extra entries, define it to be " NULL, NULL, "
*/
#ifndef BEGIN_INTERFACE
#if defined(MOA_CPLUS_BINDINGS_ALLOWED) && !defined(CINTERFACE)
    #if !defined(NO_NULL_VTABLE_ENTRY)
        #define BEGIN_INTERFACE
    #else
        #define BEGIN_INTERFACE
    #endif
#else
	#ifndef _MOA_COM_PROVIDED_
	#define BEGIN_INTERFACE
    #endif
#endif
#endif // BEGIN_INTERFACE

#define _MOA_VTABLE_EXTRA_ENTRIES           0
#define _MOA_VTABLE_FILL_EXTRA_ENTRIES      /* nothing */

/*-------------------------------------------------------------------------*/
/*
    this macro is used to declare the parent interface of
    IMoaUnknown. On most systems, IMoaUnknown won't have
    one; some systems (Mac notably) require IMoaUnknown
    to inherit from a built-in compiler class to form
    C++ vtables correctly.
*/
#if defined(applec)
    /*
        With MPW and MWERKS you must descend from SingleObject
        to enforce traditional vtable building; otherwise
        the vtable may include offsets for multiple inheritance
        (even if the object doesn't multiply inherit). Since
        every other interface must inherit from this one, this
        will do the trick...
    */
    #define DECLARE_INTERFACE_IMOAUNKNOWN \
        DECLARE_INTERFACE_(IMoaUnknown, SingleObject)
#else
    #define DECLARE_INTERFACE_IMOAUNKNOWN \
        DECLARE_INTERFACE(IMoaUnknown)
#endif

/*-------------------------------------------------------------------------*/
/*
    This macro calls a routine to flush the instruction cache (if necessary).
    This is used primarily by debugging code after clearing freed memory
    to bogus values.
*/
#define _MOA_FLUSH_CACHE

/*-------------------------------------------------------------------------*/
/*
    This should output a debug message to a debugging console,
    and stop execution (if possible). The string is a C string
    that can be trashed by the routine!
*/
#define _MOA_DEBUGSTR_(cstr) do { Str255 pstr; c2pstrcpy(pstr, cstr); DebugStr(pstr); } while (0)

/*-------------------------------------------------------------------------*/
/*
    This should be equivalent to the stdio sequence:

    va_list args;

    va_start(args, (msg));
    vsprintf((buf), (msg), args);
    va_end(args);

    if your platform doesn't support va_args, you should use:

    strcpy((buf), (msg));

*/
#define _MOA_VSPRINTF_(buf, msg) \
    do { \
        va_list __args__; \
        va_start(__args__, (msg)); \
        vsprintf((buf), (msg), __args__); \
        va_end(__args__); \
    } while (0)

/*-------------------------------------------------------------------------*/
/*
    This macro needs to call the C++ new_handler in order to handle
    a failure from operator new. although theoretically a standard
    technique, some compilers do things differently (e.g., MSVC).
    This macro needs to call the current new_handler. if there
    is no new_handler, it should return() a value of 0.
*/

#define _MOA_DO_NEW_HANDLER \
    do { \
        void (*pehf)() = std::set_new_handler(0); \
        std::set_new_handler(pehf); \
        if (pehf) pehf(); else return(0); \
    } while (0)

/*-------------------------------------------------------------------------*/
/*
    The maximum possible length of a pathname for this platform's
    file system.
*/
#define MOA_MAX_PATHNAME        1024

/*-------------------------------------------------------------------------*/
/*
    The maximum possible length of a filename for this platform's
    file system.
*/
#define MOA_MAX_FILENAME        1024

/*-------------------------------------------------------------------------*/
/* macro to use for any pointer which has to be at least a 32 bit pointer */
#ifndef FAR
    #define FAR
#endif

/*-------------------------------------------------------------------------*/
/* Macro to use for any pointer where there may be math done on the pointer
/  causing it to access 64k or more beyond the pointer.  On most platforms
/  there is no such distinction. */
#define HUGEP

/*-------------------------------------------------------------------------*/
/*
    series of macros for operating on the "wide" data types.
    You may implement these as you like (inline assembly, conditional
    C++ inlines, whatever).
*/
#define LONG_TO_WIDE(L, W) \
        do { (W).lo = (MoaUlong)(L); (W).hi = (L) >= 0 ? 0 : -1; } while (0);

/* WIDE_TO_LONG ignores overflow -- use WIDE_FITS */
#define WIDE_TO_LONG(W, L) \
        do { (L) = (MoaLong)(W).lo; } while (0);

#define WIDE_FITS(W) \
        (((W).hi == 0 && ((W).lo & 0x80000000) == 0) || \
        ((W).hi == -1 && ((W).lo & 0x80000000) != 0))

#define WIDE_GT_ZERO(x) \
        ((x).hi >= 0 && (x).lo != 0)

#define WIDE_EQ_ZERO(x) \
        ((x).hi == 0 && (x).lo == 0)

#define WIDE_LT_ZERO(x) \
        ((x).hi < 0)

/* effects "x += y" where both x and y are MoaWide */
#define WIDE_ADD_WIDE(x, y) \
    do { MoaUlong tmp = (x).lo; (x).hi += (y).hi; \
        (x).lo += (y).lo; if ((x).lo < tmp) (x).hi++; } while (0)

/* effects "x = -x", where x is a MoaWide */
#define WIDE_NEGATE(x) \
    do { (x).hi = ~(x).hi; (x).lo = ~(x).lo; ++(x).lo; \
        if ((x).lo == 0) ++(x).hi; } while (0)

/*-------------------------------------------------------------------------*/
/* Macros for converting to/from Mac types */

#define MoaToMacPoint(moa,mac) \
        do { (mac)->h = (short)(moa)->x; \
            (mac)->v = (short)(moa)->y; } while (0)

#define MacToMoaPoint(mac,moa) \
        do { (moa)->x = (MoaCoord)(mac)->h; \
            (moa)->y = (MoaCoord)(mac)->v; } while (0)

#define MoaToMacRect(a,b)   do { \
                            (b)->top    = (short)(a)->top;      \
                            (b)->left   = (short)(a)->left;     \
                            (b)->bottom = (short)(a)->bottom;   \
                            (b)->right  = (short)(a)->right;    \
                            } while (0)

#define MacToMoaRect(a,b)   do { \
                            (b)->top    = (MoaCoord)(a)->top;   \
                            (b)->left   = (MoaCoord)(a)->left;  \
                            (b)->bottom = (MoaCoord)(a)->bottom;\
                            (b)->right  = (MoaCoord)(a)->right; \
                            } while (0)

/*-------------------------------------------------------------------------*/
/*
    The value for a MoaFileRef that refers to no file (or no valid file).
*/
#define kMoaFileRef_NoRef ((MoaFileRef)0)

/*-------------------------------------------------------------------------*/
/*
    This should be defined to be a pointer-sized value that
    is always a "bad" pointer.
*/
#define MOA_CLOBBERVAL  ((PMoaVoid)0x50ff8001)

/*-------------------------------------------------------------------------*/
/*
    This is a big honkin' piece of code that will be inserted into
    every non-App Xtra (i.e., whenever MOA_APP_CODE is not defined).
    You'll want to put stuff like a standard DLL entry point (or whatever)
    into this code.
*/

#define _MOA_XCODE_PREFACE \
    MoaFileRef gXtraFileRef = kMoaFileRef_NoRef; \
    EXTERN_C void ppcSetFileRef(MoaFileRef fileRef); \
    void ppcSetFileRef(MoaFileRef fileRef) { gXtraFileRef = fileRef; }

#define _MOA_COMPILER_A4CODE_PREFACE

/*---------------------------------------------------------------------------*/
/*
    given a pointer to a MoaSystemFileSpec, return its size
    in bytes. if pointer is NULL, return 0 (don't crash).
*/

#define GetFileSpecLen(pspec) ((pspec) ? (sizeof(short) + sizeof(long) + ((FSSpec*)(pspec))->name[0] + 1) : 0)

#include <string.h>

/*---------------------------------------------------------------------------*/
/*
    versions of classic C library routines that use FAR-sized
    pointers. You can point these at standard C routines, or
    write them yourself.
*/

#define moa_memcmp(a,b,c)   memcmp((a),(b),(c))
#define moa_memcpy(a,b,c)   memcpy((a),(b),(c))
#define moa_memmove(a,b,c)  memmove((a),(b),(c))
#define moa_memset(a,b,c)   memset((a),(b),(c))
#define moa_strcat(a,b)     strcat((a),(b))
#define moa_strcmp(a,b)     strcmp((a),(b))
#define moa_strcpy(a,b)     strcpy((a),(b))
#define moa_strncpy(a,b)    strncpy((a),(b))
#define moa_strlen(a)       strlen((a))

/*---------------------------------------------------------------------------
/ 3. Declare structures and types.
/--------------------------------------------*/

/*-------------------------------------------------------------------------*/
/*
    signed 8-bit character.
*/
/*
    Mac compilers default to signed char, and Metrowerks
    sometimes thinks that char* is not compatible with signed char*,
    so I default it to this...
*/
typedef char				MoaChar;

/*-------------------------------------------------------------------------*/
/*
    unsigned 16-bit unicode character.
*/
typedef unsigned short      MoaUnichar;

/*-------------------------------------------------------------------------*/
/*
    unsigned 8-bit boolean
*/
typedef unsigned char       MoaBool;

/*-------------------------------------------------------------------------*/
/*
    unsigned 8-bit byte.
*/
typedef unsigned char       MoaByte;

/*-------------------------------------------------------------------------*/
/*
    signed 16-bit integer.
*/
typedef signed short        MoaShort;

/*-------------------------------------------------------------------------*/
/*
    unsigned 16-bit integer.
*/
typedef unsigned short      MoaUshort;

/*-------------------------------------------------------------------------*/
/*
    signed 32-bit integer.
*/
typedef long                MoaLong;

/*-------------------------------------------------------------------------*/
/*
    unsigned 32-bit integer.
*/
typedef unsigned long       MoaUlong;

/*-------------------------------------------------------------------------*/
/*
    signed 32-bit integer, treated as a 16.16 fixed-point number.
*/
typedef signed long         MoaFixed;

/*-------------------------------------------------------------------------*/
/*
    32-bit value; may be signed or unsigned, integral or pointer.
*/
typedef long                MoaError;

/*-------------------------------------------------------------------------*/
/*
    32-bit IEEE floating-point number.
*/
typedef float               MoaFloat;

/*-------------------------------------------------------------------------*/
/*
    64-bit IEEE floating-point number.
*/
typedef double				MoaDouble;

/*-------------------------------------------------------------------------*/
/*
	pointer to void.
*/
typedef void *				PMoaVoid;

/*-------------------------------------------------------------------------*/
/*
    const pointer to void.
*/
typedef const void *		ConstPMoaVoid;

/*-------------------------------------------------------------------------*/
/*
	pointer to pointer to void.
*/
typedef void * *			PPMoaVoid;

/*-------------------------------------------------------------------------*/
/* for types < 32 bits: versions for arg lists. Must be long on
    Macintosh systems. */
typedef MoaUlong            MoaUnicharParam;
typedef MoaLong             MoaCharParam;
typedef MoaUlong            MoaBoolParam;

/*-------------------------------------------------------------------------*/
/*
    Similar to MoaBoolParam, but must be binary-compatible
    with the Microsoft BOOL type (this is really only
    an issue on Win16 systems, that require it to be
    a 16-bit param)
*/
typedef MoaUlong            MoaMsBoolParam;

/*-------------------------------------------------------------------------*/
/*
    a 64-bit integer struct. "hi" must be signed
    and "lo" must be unsigned. You may arrange them
    as you like.
*/
/*
    This definition is a binary match with Apple's "wide" type.
*/
typedef struct MoaWide {
    MoaLong     hi;
    MoaUlong    lo;
} MoaWide;

/*-------------------------------------------------------------------------*/
/*
    this type is a "cookie" used to refer to an Xtra's file container.
    it need not be a useful type, though it might be; at minimum,
    it needs to be a cookie to pass to IMoaCallback::MoaBeginUsingResources
    that can be used to access the Xtra's resource area.
*/
typedef struct _MoaFileRef * MoaFileRef;

/*-------------------------------------------------------------------------*/
/*
    this type is returned by IMoaCallback::MoaBeginUsingResources
    and must be used to directly access the Xtra's resource area.
*/
/* a resource file refNum on the Mac. */
typedef long XtraResourceCookie;

/*-------------------------------------------------------------------------*/
/*
    a type large enough to hold the largest MoaSystemFileSpec.

    GetFileSpecLen(foo) <= sizeof(MoaSystemFileSpecBuf).

    it must be guaranteed that any buffer that is >= sizeof(MoaSystemFileSpecBuf)
    must be large enough to hold any system file spec.
*/
typedef FSSpec MoaSystemFileSpecBuf[1];

/*-------------------------------------------------------------------------*/
/*
    Pointers to the platform-specific file spec. This may be
    a pathname or other platform-dependent structure of
    arbitrary or variable size.
*/
typedef FSSpec * PMoaSystemFileSpec;
typedef const FSSpec * ConstPMoaSystemFileSpec;

/*-------------------------------------------------------------------------*/
/*
    define the MoaID type. It must be a long, two shorts,
    and 8 bytes, all unsigned, with NO padding, to be
    exactly 16 bytes. If COM is provided, it must exactly
    match a GUID.
*/
#ifdef _MOA_COM_PROVIDED_
	typedef GUID MoaID;
#else
	typedef struct {
	    MoaUlong    Data1;
	    MoaUshort   Data2;
	    MoaUshort   Data3;
	    MoaByte     Data4[8];
	} MoaID;
#endif

/*-------------------------------------------------------------------------*/
/*
    ??? Mac-only hack.
*/
EXTERN_C void ppcSetFileRef(MoaFileRef fileRef);

	#define STDPROCPTR(macro_CALLCONVENTION, macro_RETURNTYPE, macro_PROCNAME) \
		macro_CALLCONVENTION macro_RETURNTYPE (*macro_PROCNAME)

/*AddRef and Release methods in Xtra's should be thread safe*/
#ifndef MOA_INTERLOCKED_INCREMENT
#define MOA_INTERLOCKED_INCREMENT(x) OSAtomicIncrement32((int32_t*)(x))
#endif //MOA_INTERLOCKED_INCREMENT
 
#ifndef MOA_INTERLOCKED_DECREMENT
#define MOA_INTERLOCKED_DECREMENT(x) OSAtomicDecrement32((int32_t*)(x))
#endif //MOA_INTERLOCKED_DECREMENT

#endif /* _H_moatyedg */
