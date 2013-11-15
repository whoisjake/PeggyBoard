//
//  PEGBoardViewController.m
//  PeggyBoard
//
//  Created by Jacob Good on 11/4/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import "PEGBoardViewController.h"
#import "PEGBoardView.h"

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
        self.board = [[PEGBoard alloc] init];
        //[self.board lease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self.board clear];
    }
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
