/*
ADOBE SYSTEMS INCORPORATED
Copyright 1994 - 2007 Adobe Macromedia Software LLC
All Rights Reserved

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
*/

/*****************************************************************************
 *
 *	Name: DrAcXtra.cpp
 *	
 * 	Purpose: The Xtra definition of the DrAccess Xtra example.
 *
 *
 ****************************************************************************/ 

/*****************************************************************************
 *  INCLUDE FILE(S)
 *  ---------------
 *	This .cpp file should automatically include all the support files needed
 *	for this particular class. In addition, this file may include other .h
 *	files defining additional callback interfaces for use by a third party.   
 ****************************************************************************/ 
#include "DrAcScrp.h"
#include "DrAcReg.h"
#include "xclassver.h"

/*****************************************************************************
 *  XTRA DEFINITION
 *  ---------------
 *  The Xtra definition specfies the classes and interfaces defined by your
 *  MOA Xtra.
 *
 *  Syntax:
 *	BEGIN_XTRA_DEFINES_CLASS(<class-name>,<version>)
 *	CLASS_DEFINES_INTERFACE(<class-name>, <interface-name>,<version>) 
 ****************************************************************************/ 
BEGIN_XTRA
	BEGIN_XTRA_DEFINES_CLASS(CDrAccessRegister, XTRA_CLASS_VERSION)
		CLASS_DEFINES_INTERFACE(CDrAccessRegister, IMoaRegister, XTRA_CLASS_VERSION) 
	END_XTRA_DEFINES_CLASS

	BEGIN_XTRA_DEFINES_CLASS(CDrAccessScript, XTRA_CLASS_VERSION)
		CLASS_DEFINES_INTERFACE(CDrAccessScript, IMoaMmXScript, XTRA_CLASS_VERSION)
		#ifdef USING_INIT_FROM_DICT
		CLASS_DEFINES_INTERFACE(CDrAccessScript, IMoaInitFromDict, XTRA_CLASS_VERSION)	
		#endif
		#ifdef USING_NOTIFICATION_CLIENT
		CLASS_DEFINES_INTERFACE(CDrAccessScript, IMoaNotificationClient, XTRA_CLASS_VERSION)	
		#endif
	END_XTRA_DEFINES_CLASS
END_XTRA

#ifdef _IOS
// @IOS_XDK_CHANGE

// This is iOS Xtras specific change. Following line needs to be added for iOS xtras to declare/define
// the iOS xtra entry points. This code should be placed after the BEGIN_XTRA END_XTRA block inside the xtra code.
DECLARE_REGISTER_XTRAS
#endif


