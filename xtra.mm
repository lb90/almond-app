#ifndef USING_INIT_FROM_DICT
#define USING_INIT_FROM_DICT
#endif

/*
ADOBE SYSTEMS INCORPORATED
Copyright 1994 - 2008 Adobe Macromedia Software LLC
All Rights Reserved

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
*/


#define INITGUID 1

#include "xtra.h"

#include <string.h>
#include <stdlib.h>
#include "xclassver.h"
#include "moatry.h"

#include "driservc.h"
#include "drivalue.h"

#include "mmivalue.h"
#include "mmillist.h"
#include "mmiplist.h"
#include "mmidate.h"
#include "mmiclr.h"

extern "C" {
#include "peanut.h"
}

/*******************************************************************************
 * SCRIPTING XTRA MESSAGE TABLE DESCRIPTION.
 *
 * The general format is:
 * xtra <nameOfXtra>
 * new object me [ args ... ]
 * <otherHandlerDefintions>
 * --
 * The first line must give the name of the Scripting xtra.
 * The remaining lines give the names of the handlers that this xtra implements
 * along with the required types of the arguments for each handler.
 * 
 * -- Pre-defined handler new 
 * The new handler will be called when a child object is created, 
 * the first argument is always the child object and you defined any remaining arguments.
 * The new handler is the place to initialize any memory required by the child object.
 * 
 * -- Simple Handler Definitions
 * Each handler definition line is format like this:
 * <handlerName> <argType1> <argName1>, <argType2> <argName2> ...
 * The first word is the handler name. Following this are types description for
 * the argument to the handler, each separated by a comma.
 * The argument name <argName>, may be omited.
 * Permited argument types are: 
 * 	integer 
 * 	float
 * 	string
 * 	symbol
 * 	object
 * 	any
 * 	*
 * For integer, float, string, symbol, and object, the type of the argument must 
 * match. The type any means allow any type. The asterisk (*) means any number and 
 * any type of arguments.
 * 
 * The first argument is the child object and is always declared to be of type object.
 * 
 * -- Global Handlers
 * An asterisk (*) preceeding the handler name signifies a global handler.
 * This handler is at the global scope level and can be called from any
 * movie.
 * 
 * -- Xtra level handlers
 * A plus (+) preceeding the handler name signifies an Xtra level handler. 
 * This kind of handler can be called directly from the Xtra reference,
 * without creating a child object.
 * 
 * The enumerated list that follows must correspond directly with the msgTable 
 * (i.e. they must be in the same order).
 * 
 *******************************************************************************/ 

static const char header[] = {
  "xtra Almond -- version 1.0.0\n"
	"new object me\n" /* standard first handler entry in all message tables */
	"* hazpeaget string path -- Retrieves file attributes informations. path: path to the file.\n"
	"* hazpeaset string path, string attributes -- Sets file attributes. path: path to the file. attributes: attributes to set (rwhvls)\n"
		/*
		 * ---> insert additional handler(s) MUST MATCH WITH ENUMS BELOW -->
		 */ 
	};


/* 	This is the enumerated scripting method list. This list should
 *	directly correspond to the msgTable defined above. It is used
 *	to dispatch method calls via the methodSelector. The 'm_XXXX' method must
 *	be last.
 */

enum 
{
	m_new = 0, /* standard first entry */
	m_hazpeaget,
	m_hazpeaset,
		/*
		 * ---> insert additional names(s) MUST MATCH MESSAGE TABLE ABOVE -->
		 */ 
	m_XXXX
};


/* ============================================================================= */
/* Xtra Glue Stuff */
/* ============================================================================= */

#define XTRA_VERSION_NUMBER XTRA_CLASS_VERSION

BEGIN_XTRA
	BEGIN_XTRA_DEFINES_CLASS(TStdXtra, XTRA_CLASS_VERSION)
		CLASS_DEFINES_INTERFACE(TStdXtra, IMoaRegister, XTRA_VERSION_NUMBER)
#ifdef USING_INIT_FROM_DICT
		CLASS_DEFINES_INTERFACE(TStdXtra, IMoaInitFromDict, XTRA_VERSION_NUMBER)	
#endif
		CLASS_DEFINES_INTERFACE(TStdXtra, IMoaMmXScript, XTRA_VERSION_NUMBER)
		/*
		 * ---> insert additional interface(s) -->
		 */ 
	END_XTRA_DEFINES_CLASS
END_XTRA


/* ============================================================================= */
/* Create/Destroy for class TStdXtra */
/* ============================================================================= */

STDMETHODIMP_(MoaError) MoaCreate_TStdXtra (TStdXtra * This)
{
moa_try
		
	ThrowErr (This->pCallback->QueryInterface(&IID_IMoaMmValue, (PPMoaVoid) &This->pValueInterface));
	ThrowErr (This->pCallback->QueryInterface(&IID_IMoaMmUtils2, (PPMoaVoid) &This->pMoaUtils));
	
moa_catch
moa_catch_end
moa_try_end
}

STDMETHODIMP_(void) MoaDestroy_TStdXtra(TStdXtra * This)
{
moa_try

	if (This->pMoaUtils != NULL)
		ThrowErr (This->pMoaUtils->Release());
	if (This->pValueInterface != NULL) 
		ThrowErr (This->pValueInterface->Release());

moa_catch
moa_catch_end
moa_try_end_void
}


/* ============================================================================= */
/* Methods in TStdXtra_IMoaRegister */
/* ============================================================================= */

/*****************************************************************************
 *  Data needed for Registering
 *	---------------------------
 *	Specific code needed to register different types of Xtras.  The skeleton
 *	source files include minimal implementations appropriate for each Xtra
 *	type.  Current necessary actions:
 *
 *	Scripting Xtra:				Add the Scripting Xtra Message Table
 *	Sprite Asset Xtra:			Nothing
 *	Tool Xtra:					Nothing
 *	Transition Asset Xtra		Nothing
 *
 *  ****optional: Register as Safe for Shockwave!
 *****************************************************************************/ 

STD_INTERFACE_CREATE_DESTROY(TStdXtra, IMoaRegister)

BEGIN_DEFINE_CLASS_INTERFACE(TStdXtra, IMoaRegister)
END_DEFINE_CLASS_INTERFACE

/* ----------------------------------------------------------------------------- */
STDMETHODIMP TStdXtra_IMoaRegister::Register(
	PIMoaCache pCache, 
	PIMoaXtraEntryDict pXtraDict
)
{
	MoaError err = kMoaErr_NoErr;
	PIMoaRegistryEntryDict pReg;
	PMoaVoid pMemStr = NULL;

	/* Register as scripting xtra (manifest that we implement IMoaMmXScript iface) */
	err = pCache->AddRegistryEntry(pXtraDict, &CLSID_TStdXtra, &IID_IMoaMmXScript, &pReg);
	if (err != kMoaErr_NoErr) {
		goto cleanup;
	}

	/* Register the method table */
	pMemStr = pObj->pCalloc->NRAlloc(sizeof(header)+1);
	if (pMemStr == NULL) {
		goto cleanup;
	}

	strcpy((char*)pMemStr, header);

	err = pReg->Put(kMoaDrDictType_MessageTable, pMemStr, 0, kMoaDrDictKey_MessageTable);
	if (err != kMoaErr_NoErr) {
		goto cleanup;
	}

cleanup:
	if (pMemStr) {
		pObj->pCalloc->NRFree(pMemStr);
	}
	return kMoaErr_NoErr;
}


#ifdef USING_INIT_FROM_DICT

/* ============================================================================= */
/*  Methods in TStdXtra_IMoaInitFromDict */
/* ============================================================================= */

BEGIN_DEFINE_CLASS_INTERFACE(TStdXtra, IMoaInitFromDict)
END_DEFINE_CLASS_INTERFACE

//******************************************************************************
TStdXtra_IMoaInitFromDict::TStdXtra_IMoaInitFromDict(MoaError * pErr)
{
	*pErr = kMoaErr_NoErr;
}

//******************************************************************************
TStdXtra_IMoaInitFromDict::~TStdXtra_IMoaInitFromDict()
{
}


/* --------------------------------- CScript_IMoaInitFromDict::InitFromDict */
STDMETHODIMP TStdXtra_IMoaInitFromDict::InitFromDict(PIMoaRegistryEntryDict pRegistryDict)
{
	MoaError err = kMoaErr_NoErr;

	/*
	 *  --> insert additional code -->
	 */

	return(err);
}

#endif


/* ============================================================================= */
/*  Methods in TStdXtra_IMoaMmXScript */
/* ============================================================================= */

BEGIN_DEFINE_CLASS_INTERFACE(TStdXtra, IMoaMmXScript)
END_DEFINE_CLASS_INTERFACE

//******************************************************************************
TStdXtra_IMoaMmXScript::TStdXtra_IMoaMmXScript(MoaError * pError)
//------------------------------------------------------------------------------
{
	*pError = kMoaErr_NoErr;
}	

//******************************************************************************
TStdXtra_IMoaMmXScript::~TStdXtra_IMoaMmXScript()
//------------------------------------------------------------------------------
{
}


/* ----------------------------------------------------------------------------- */
STDMETHODIMP TStdXtra_IMoaMmXScript::Call (PMoaDrCallInfo callPtr)
{
	switch	( callPtr->methodSelector ) 
	{
		case m_new:
			{
			/* Setup any instance vars for you Xtra here. new() is
			called via Lingo when creating a new instance. */
			/*
			 * --> insert additional code -->
		 	 */
			}
			break;
					
		/* Here is where new methods are added to the switch statement. Each
		   method should be defined in the msgTable defined in and have a 
		   constant defined in the associated enum. 
		*/  

		case m_hazpeaget:
			{
				MoaMmValue arg_value;
				ConstPMoaChar arg_value_string;
				MoaError err = kMoaErr_NoErr;

				if (!pObj->pValueInterface)
					return kMoaErr_NoErr;

				/* This shows how to access an argument
				/  the first argument in the list is the "me" value, so the user arguments
				/  start at the second position in the list */
				pciGetArgByIndex(callPtr, 1, &arg_value);

				err = pObj->pValueInterface->ValueToStringPtr(&arg_value, &arg_value_string);
				if (err == kMoaErr_NoErr && arg_value_string != NULL)
				{
					const char *file_name = arg_value_string;
					char *result = NULL;

					peanut_get(file_name, &result);

					if (result)
						pObj->pValueInterface->StringToValue(result, &(callPtr->resultValue));
					else
						pObj->pValueInterface->StringToValue("", &(callPtr->resultValue));

					if (result)
					{
						free(result);
						result = NULL;
					}
				}
				else
				{
					pObj->pValueInterface->StringToValue("", &(callPtr->resultValue));
				}
			}
			break;
		case m_hazpeaset:
			{
				MoaMmValue arg_value_1;
				ConstPMoaChar arg_value_string_1 = NULL;
				MoaMmValue arg_value_2;
				ConstPMoaChar arg_value_string_2 = NULL;
				MoaError err = kMoaErr_NoErr;

				if (!pObj->pValueInterface)
					return kMoaErr_NoErr;

				/* This shows how to access an argument
				/  the first argument in the list is the "me" value, so the user arguments
				/  start at the second position in the list */
				pciGetArgByIndex(callPtr, 1, &arg_value_1);

				err = pObj->pValueInterface->ValueToStringPtr(&arg_value_1, &arg_value_string_1);
				if (err != kMoaErr_NoErr || arg_value_string_1 == NULL)
				{
					pObj->pValueInterface->StringToValue("", &(callPtr->resultValue));
					break;
				}

				pciGetArgByIndex(callPtr, 2, &arg_value_2);

				err = pObj->pValueInterface->ValueToStringPtr(&arg_value_2, &arg_value_string_2);
				if (err != kMoaErr_NoErr || arg_value_string_2 == NULL)
				{
					pObj->pValueInterface->StringToValue("", &(callPtr->resultValue));
					break;
				}
				else {
					const char *file_name = arg_value_string_1;
					const char *mode_string = arg_value_string_2;
					int result = 0;

					peanut_set(file_name, mode_string, &result);

					if (result == 1)
						pObj->pValueInterface->IntegerToValue(1, &(callPtr->resultValue));
					else
						pObj->pValueInterface->IntegerToValue(0, &(callPtr->resultValue));
				}
			}
			break;
		/*
		 * --> insert additional methodSelector cases -->
		 */
	}
	return kMoaErr_NoErr;
}

