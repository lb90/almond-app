/*==========================================================================\
|                                                                           |
|       Copyright (c) 1994-2008 Adobe Macromedia Software LLC, Inc.         |
|                                                                           |
|      This material is the confidential trade secret and proprietary       |
|      information of Adobe Macromedia Software LLC.  It may not be			|
|	   reproduced, used, sold or transferred to any third party without   	|
|      the prior written consent of Adobe Macromedia Software LLC.   		|
|      All rights reserved.                    								|
|                                                                           |
\==========================================================================*/

#ifndef _H_moamemxtras
#define _H_moamemxtras
/*
	File: moamemxtras.h (core)

	Abstract:

	This file provides public interface to the memory xtras functionality
	provided by the library.
*/

#include "moaxtra.h"
#include "moastdif.h"

/* ========================================================================== */
/* ======================== Adaptive Declarations =========================== */
/* ========================================================================== */

/* ========================================================================== */
/* ============================ Fundamental Types =========================== */
/* ========================================================================== */

/* Opaque type for referring to the overall MOA context. */
typedef struct _MoaContext * MoaContext;
typedef MoaContext * PMoaContext;

/* options for MoaStartUpOptions */
/* the default is for all these options to be OFF */
#define MOA_OPTION_DISABLE_PROGRESS			0x0001	/* no progress bar during Moa init */
#define MOA_OPTION_DISALLOW_OLE_INIT		0x0002	/* don't allow MOA to init OLE if not already */

/* ========================================================================== */
/* ============================== Function types ============================ */
/* ========================================================================== */

/* STDMETHOD-protocol functions. */
typedef STDPROCPTR(STDMETHODCALLTYPE, MoaError, MoaEnumNewXtraRefProc)(
	PIMoaXtraEntryDict pXtra,
	PMoaVoid refCon
);

typedef STDPROCPTR(STDMETHODCALLTYPE, MoaError, MoaDiskFilterProc)(
	ConstPMoaSystemFileSpec pFileSpec,
	MoaWide fileDate,
	MoaUlong fileType,
	PMoaVoid refCon
);

/* STDAPI-protocol functions. */
typedef STDPROCPTR(STDAPICALLTYPE, MoaError, MoaGetClassObjectProc)(
	ConstPMoaClassID pClassID,
	ConstPMoaInterfaceID pInterfaceID,
	PPMoaVoid pObject
);

typedef STDPROCPTR(STDAPICALLTYPE, MoaError, MoaGetInterfaceProc)(
	const void *pExistingObject,
	ConstPMoaClassID pClassID,
	ConstPMoaInterfaceID pInterfaceID,
	PPMoaVoid pObject
);

typedef STDPROCPTR(STDAPICALLTYPE, MoaError, MoaGetCanUnloadProc)(
	void
);

typedef STDPROCPTR(STDAPICALLTYPE, MoaError, MoaGetClassFormProc)(
	ConstPMoaClassID pClassID,
	MoaLong * pObjSize,
	MoaCreatedProc * pCreateProc,
	MoaDestroyedProc * pDestroyProc
);

typedef STDPROCPTR(STDAPICALLTYPE, MoaError, MoaGetClassInfoProc)(
	PIMoaCalloc pCalloc,
	ConstPMoaClassInterfaceInfo * ppClassInfo
);

/* ========================================================================== */
/* =========================== Interface Routines =========================== */
/* ========================================================================== */

STDAPI_(MoaError) MoaRegisterMemXtra(
	MoaContext context,
	const MoaGetClassObjectProc pClassObjectProc,
	const MoaGetInterfaceProc pInterfaceProc,
	const MoaGetClassFormProc pClassFormProc,
	const MoaGetCanUnloadProc pCanUnloadProc,
	const MoaGetClassInfoProc pClassInfoProc
);
#endif // _H_moamemxtras
