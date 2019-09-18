/*
ADOBE SYSTEMS INCORPORATED
Copyright 1994 - 2008 Adobe Macromedia Software LLC
All Rights Reserved

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
*/

#ifndef _H_Script
#define _H_Script

#include <Carbon/Carbon.h>
#include "MACMach/moatyedg.h"
#include "moastdif.h"
#include "xmmvalue.h"
#include "mmiutil.h"


/* --------------------------------------------------- */

#error "change GUID"
DEFINE_GUID(CLSID_TStdXtra, 0xe8b80e0aL, 0xbafb, 0x423c, 0xb9, 0x64, 0x74, 0x60, 0xfb, 0xa3, 0x15, 0x8e); /*{E8B80E0A-BAFB-423C-B964-7460FBA3158E}*/

EXTERN_BEGIN_DEFINE_CLASS_INSTANCE_VARS(TStdXtra)

	PIMoaMmValue	pValueInterface;
	/*
	 * ---> insert additional variable(s) -->
	 */ 

EXTERN_END_DEFINE_CLASS_INSTANCE_VARS



/*****************************************************************************
 * Xtra Moa Registration Interface - Class definition
 ****************************************************************************/

EXTERN_BEGIN_DEFINE_CLASS_INTERFACE(TStdXtra, IMoaRegister)

	EXTERN_DEFINE_METHOD(MoaError, Register, (PIMoaCache, PIMoaXtraEntryDict))

EXTERN_END_DEFINE_CLASS_INTERFACE


#ifdef USING_INIT_FROM_DICT
/*****************************************************************************
 * Xtra Moa InitFromDict Interface - Class definition
 ****************************************************************************/

EXTERN_BEGIN_DEFINE_CLASS_INTERFACE(TStdXtra, IMoaInitFromDict)
	EXTERN_DEFINE_METHOD(MoaError, InitFromDict, (PIMoaRegistryEntryDict))
EXTERN_END_DEFINE_CLASS_INTERFACE
#endif


/*****************************************************************************
 * Xtra Moa Scripting Interface - Class definition
 ****************************************************************************/

EXTERN_BEGIN_DEFINE_CLASS_INTERFACE(TStdXtra, IMoaMmXScript)

	EXTERN_DEFINE_METHOD(MoaError, Call, (PMoaDrCallInfo))
	 
EXTERN_END_DEFINE_CLASS_INTERFACE

#endif /* _H_Script */
