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

#include "log.h"

/* --------------------------------------------------- */

// {FCABF286-F38C-4C97-921C-4D8E3662E96F}
DEFINE_GUID(CLSID_TStdXtra, 0xfcabf286L, 0xf38c, 0x4c97, 0x92, 0x1c, 0x4d, 0x8e, 0x36, 0x62, 0xe9, 0x6f);

EXTERN_BEGIN_DEFINE_CLASS_INSTANCE_VARS(TStdXtra)

	PIMoaMmValue	pValueInterface;
	PIMoaMmUtils2 	pMoaUtils;

	log_ctx_t	log;
	
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
