//
//  PEGBoardView.m
//  PeggyBoard
//
//  Created by Jacob Good on 11/4/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import "PEGBoardView.h"
#import "PEGClient.h"
#import <math.h>

@implementation PEGBoardView {
    NSMutableArray * rects;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self calculateRects:CGRectApplyAffineTransform(frame, [self transform])];
}

- (void) calculateRects:(CGRect)rect {
    int x_padding = (int) (rect.size.width * 0.05); // 5% margin
    int y_padding = (int) (rect.size.height * 0.20); // 25% margin
    
    int x_gap = 1;
    int y_gap = 1;
    
    float box_w = ((rect.size.width - (2 * x_padding) - (([PEGBoard columnCount] - 1) * x_gap)) / [PEGBoard columnCount]);
    float box_h = ((rect.size.height - (2 * y_padding) - (([PEGBoard rowCount] - 1) * y_gap)) / [PEGBoard rowCount]);
    
    x_padding += (int)(fmod(box_w,1) * [PEGBoard columnCount] / 2.0);
    y_padding += (int)(fmod(box_h,1) * [PEGBoard rowCount] / 2.0);

    rects = [[NSMutableArray alloc] initWithCapacity:[PEGBoard rowCount]];
    for (int row = 0; row < [PEGBoard rowCount]; row++)
    {
        [rects addObject:[[NSMutableArray alloc] initWithCapacity:[PEGBoard columnCount]]];
        for (int col = 0; col < [PEGBoard columnCount]; col++)
        {
            int x = x_padding + (col * (int)box_w) + (col * x_gap);
            int y = y_padding + (row * (int)box_h) + (row * y_gap);
            CGRect box = (CGRect){{x,y},{(int)box_w,(int)box_h}};
            [rects[row] addObject:[NSValue valueWithCGRect:box]];
        }
    }
}

- (CGPoint) rowAndColumnFromPoint:(CGPoint) point {
    for (int row = 0; row < [PEGBoard rowCount]; row++)
    {
        for (int col = 0; col < [PEGBoard columnCount]; col++)
        {
            CGRect rect = [self rectForRow:row column:col];
            if (CGRectContainsPoint(rect,point)) {
                return (CGPoint){row,col};
            }
        }
    }
    return (CGPoint){-1,-1};
}

- (CGRect) rectForRow:(int)row column:(int)col {
    return [rects[row][col] CGRectValue];
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int row = 0; row < [PEGBoard rowCount]; row++)
    {
        for (int col = 0; col < [PEGBoard columnCount]; col++)
        {
            UIColor * c = [self.board colorFor:(CGPoint){row,col}];
            
            CGRect box = [self rectForRow:row column:col];
            UIBezierPath * path = [UIBezierPath bezierPathWithRect:box];
            CGContextSetFillColorWithColor(ctx, [c CGColor]);
            CGContextAddPath(ctx, path.CGPath);
            CGContextFillPath(ctx);
        }
    }
}

- (void) pushBoard:(NSTimer *)timer {
    [[PEGClient sharedClient] draw:self.board];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint point = [self rowAndColumnFromPoint:touchPoint];
    if (point.x >= 0) {
        [self.board draw:point];
        [self setNeedsDisplay];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint point = [self rowAndColumnFromPoint:touchPoint];
    if (point.x >= 0) {
        [self.board draw:point];
        [self setNeedsDisplay];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(pushBoard:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end
