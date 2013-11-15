//
//  PEGBoardView.m
//  PeggyBoard
//
//  Created by Jacob Good on 11/4/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import "PEGBoardView.h"
#import "PegBoard.h"

@implementation PEGBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    int x_padding = 5;
    int y_padding = 25;
    int x_gap = 1;
    int y_gap = 1;
    int box_w = ((rect.size.width - (2 * x_padding) - (([PEGBoard columns] - 1) * x_gap)) / [PEGBoard columns]);
    int box_h = ((rect.size.height - (2 * y_padding) - (([PEGBoard rows] - 1) * y_gap)) / [PEGBoard rows]);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int row = 0; row < [PEGBoard rows]; row++)
    {
        for (int col = 0; col < [PEGBoard columns]; col++)
        {
            // | x_padding + [col] + [x_gap] + my_x |
            int x = x_padding + (col * box_w) + (col * x_gap);
            // | y_padding + [row] + [y_gap] + my_y |
            int y = y_padding + (row * box_h) + (row * y_gap);
        
            CGRect box = (CGRect){{x,y},{box_w,box_h}};
            UIBezierPath * path = [UIBezierPath bezierPathWithRect:box];
            CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
            CGContextAddPath(ctx, path.CGPath);
            CGContextFillPath(ctx);
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
