//
//  BrushAppDelegate.h
//  Brush
//
//  Created by chenyang on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"


@interface BrushAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	MainViewController *_mainViewController;
}

@property (nonatomic, retain)  UIWindow *window;

@end
