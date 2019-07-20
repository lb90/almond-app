//
//  ProjectorAppDelegate.h
//  Proj
//
//  Created by vjutur on 9/30/11.
//  Copyright 2011 __Adobe Systems Incorporated__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>

@interface ProjectorAppDelegate : UIResponder <UIApplicationDelegate>
{
@private    
    CADisplayLink   *displayLink;
    UIWindow        *window;
    UIView          *rootView;
}

@property (nonatomic, assign) CADisplayLink *displayLink;

@end

@interface UIResponder  (Input)
-(void)didAccelerate:(UIAcceleration *)acceleration orientation:(UIInterfaceOrientation)currentOrientation;
-(void)doGyroUpdate :(CMGyroData *)gyroData;
@end
