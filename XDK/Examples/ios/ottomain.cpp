/*==========================================================================\
|                                                                           |
|       Copyright (c) 1994-2007 Adobe Macromedia Software LLC, Inc.         |
|                                                                           |
|      This material is the confidential trade secret and proprietary       |
|      information of Adobe Macromedia Software LLC.  It may not be			|
|	   reproduced, used, sold or transferred to any third party without   	|
|      the prior written consent of Adobe Macromedia Software LLC.   		|
|      All rights reserved.                    								|
|                                                                           |
\==========================================================================*/

/****************************************************************************
/ Filename
/	ottomain.cpp
/
/ Purpose
/   Non-portable player startup code for iOS.
/   
****************************************************************************/
			
/*---------------------------------------------------------------------------
/ 1. Include system header files.
/--------------------------------------------*/
#import <UIKit/UIKit.h>
#import "ProjectorAppDelegate.h"

#include "moamemxtras.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([ProjectorAppDelegate class]));
    [pool release];
    return retVal;
}

extern "C" MoaError Register_IOS_ThirdParty_Xtras (MoaContext context);
MoaError Register_IOS_ThirdParty_Xtras (MoaContext context)
{
    MoaError err = kMoaErr_NoErr;
    
    // @IOS_XDK_CHANGE
    //Register all the thrid party xtras here using the following syntax.
    //Replace 'BitmapFilters' with your xtra name. 
    //This should be same as what is specified with '#define DLL(name)' in the xtra
    //CALL_REGISTER_XTRAS(BitmapFilters_);
    CALL_REGISTER_XTRAS(XArray_);
    CALL_REGISTER_XTRAS(DrAccess_);    
    CALL_REGISTER_XTRAS(ValueChecker_);
    CALL_REGISTER_XTRAS(Oval_);
    //CALL_REGISTER_XTRAS(PlaySound_);
    CALL_REGISTER_XTRAS(TileFilter_);
    //CALL_REGISTER_XTRAS(EventTest_);
    //CALL_REGISTER_XTRAS(TallWide_);
    //CALL_REGISTER_XTRAS(InkTest_);    
    
    return  err;
}
