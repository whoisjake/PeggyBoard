//
//  PEGBoardViewController.m
//  PeggyBoard
//
//  Created by Jacob Good on 11/4/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import "PEGBoardViewController.h"
#import "PEGBoardView.h"
#import "PEGClient.h"

@interface PEGBoardViewController ()

@end

@implementation PEGBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        PEGBoardView *view = [[PEGBoardView alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            [[UIScreen mainScreen] applicationFrame].size.width,
                                                                            [[UIScreen mainScreen] applicationFrame].size.height)];
        
        self.view = view;
        self.view.transform = CGAffineTransformMakeRotation(M_PI + M_PI_2);
        self.board = [[PEGBoard alloc] init];
        [[PEGClient sharedClient] lease];
        view.board = self.board;
        [self clearBoard];
    }
    return self;
}

- (BOOL) shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self clearBoard];
    }
}

- (void) clearBoard {
    [self.board clear];
    [[PEGClient sharedClient] clear];
    [self.view setNeedsDisplay];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

@end
