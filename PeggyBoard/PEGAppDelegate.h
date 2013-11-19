//
//  PEGAppDelegate.h
//  PeggyBoard
//
//  Created by Jacob Good on 11/14/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) tellUser:(NSString*)message withTitle:(NSString*) title;

@end
