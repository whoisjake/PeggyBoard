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
    
    PEGBoardView * pegBoardView = (PEGBoardView *)self.view;
    pegBoardView.board = self.board;
    pegBoardView.transform = CGAffineTransformMakeRotation(M_PI + M_PI_2);
    [self setBackgroundColor];
    [self clearBoard];
}

- (void) setBackgroundColor {
    PEGBoardView * pegBoardView = (PEGBoardView *)self.view;
    UIColor * c = colorSelections[selectedColor];
    pegBoardView.backgroundColor = [c colorWithAlphaComponent:0.3];
    
    [self.view setNeedsDisplay];
}

- (IBAction)rightSwipe:(UISwipeGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateEnded) {
        if (selectedColor < ([colorSelections count] - 1)) {
            selectedColor += 1;
        }
        [self setBackgroundColor];
    }
}

- (IBAction)leftSwipe:(UISwipeGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateEnded) {
        if (selectedColor > 0) {
            selectedColor -= 1;
        }
        [self setBackgroundColor];
    }
}

- (IBAction)touched:(UITapGestureRecognizer *)sender {
    [self handlePoint:[sender locationInView:self.view] withState:sender.state];
}

- (IBAction)panGestureRecognizer:(UIPanGestureRecognizer *)sender {
    [self handlePoint:[sender locationInView:self.view] withState:sender.state];
}

- (void) handlePoint:(CGPoint)touchPoint withState:(UIGestureRecognizerState)gestureRecognizerState {
    PEGBoardView * pegBoardView = (PEGBoardView *)self.view;
    CGPoint p = [pegBoardView rowAndColumnFromPoint:touchPoint];
    if(p.x >= 0) {
        [self.board draw:p withColor:colorSelections[selectedColor]];
        [self.view setNeedsDisplay];
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

- (void) pushBoard:(NSTimer *)timer {
    PEGBoard * copiedBoard = [self.board copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PEGClient sharedClient] draw:0 board:copiedBoard];
    });
}

- (void) clearBoard {
    [self.board clear];
    [[PEGClient sharedClient] clear:0];
    [self.view setNeedsDisplay];
}

@end
