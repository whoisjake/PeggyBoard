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
#import <math.h>

@interface PEGBoardViewController ()

@end

@implementation PEGBoardViewController {
    NSUInteger selectedColor;
    NSArray * colorSelections;
}

- (void) awakeFromNib {
    self.board = [[PEGBoard alloc] init];
    colorSelections = @[[UIColor greenColor],[UIColor redColor],[UIColor orangeColor]];
    selectedColor = [colorSelections indexOfObject:[UIColor greenColor]];
}

- (void) dealloc {
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureRecognizers];
    [self copyBoardToViewAndInvalidate];
    [self setViewTransform:CGAffineTransformMakeRotation(M_PI + M_PI_2)];
    [self setBackgroundColor];
    [self clearBoard];
}

- (void) setupGestureRecognizers {
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapGesture:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    self.tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    self.rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToRightSwipeGesture:)];
    self.rightSwipeRecognizer.numberOfTouchesRequired = 2;
    self.rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.rightSwipeRecognizer];
    
    self.leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToLeftSwipeGesture:)];
    self.leftSwipeRecognizer.numberOfTouchesRequired = 2;
    self.leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftSwipeRecognizer];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPanGesture:)];
    self.panRecognizer.minimumNumberOfTouches = 1;
    self.panRecognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:self.panRecognizer];
}

- (void) respondToTapGesture:(UIGestureRecognizer *) gestureRecognizer {
    [self handlePoint:[gestureRecognizer locationInView:self.view] withState:gestureRecognizer.state];
}

- (void) respondToRightSwipeGesture:(UIGestureRecognizer *) gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        if (selectedColor < ([colorSelections count] - 1)) {
            selectedColor += 1;
        }
        [self setBackgroundColor];
    }
}

- (void) respondToLeftSwipeGesture:(UIGestureRecognizer *) gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        if (selectedColor > 0) {
            selectedColor -= 1;
        }
        [self setBackgroundColor];
    }
}

- (void) respondToPanGesture:(UIGestureRecognizer *) gestureRecognizer {
    [self handlePoint:[gestureRecognizer locationInView:self.view] withState:gestureRecognizer.state];
}


- (void) setBackgroundColor {
    PEGBoardView * pegBoardView = (PEGBoardView *)self.view;
    UIColor * c = colorSelections[selectedColor];
    pegBoardView.backgroundColor = [c colorWithAlphaComponent:0.3];
    
    [self.view setNeedsDisplay];
}

- (void) handlePoint:(CGPoint)touchPoint withState:(UIGestureRecognizerState)gestureRecognizerState {
    PEGBoardView * pegBoardView = (PEGBoardView *)self.view;
    CGPoint p = [pegBoardView rowAndColumnFromPoint:touchPoint];
    if(p.x >= 0) {
        [self.board draw:p withColor:colorSelections[selectedColor]];
        [self copyBoardToViewAndInvalidate];
    }
    
    if (gestureRecognizerState == UIGestureRecognizerStateEnded) {
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(pushBoard:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self clearBoard];
    }
}

- (void) setViewTransform:(CGAffineTransform) transform {
    PEGBoardView * pegBoardView = (PEGBoardView *)self.view;
    pegBoardView.transform = transform;
}

- (void) copyBoardToViewAndInvalidate {
    PEGBoardView * pegBoardView = (PEGBoardView *)self.view;
    pegBoardView.board = [self.board copy];
    [self.view setNeedsDisplay];
}

- (void) pushBoard:(NSTimer *)timer {
    PEGBoard * copiedBoard = [self.board copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PEGClient sharedClient] draw:0 board:copiedBoard];
    });
}

- (void) clearBoard {
    [self.board clear];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PEGClient sharedClient] clear:0];
    });
    [self.view setNeedsDisplay];
}

@end
