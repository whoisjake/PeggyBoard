//
//  PEGBoard.m
//  PeggyBoard
//
//  Created by Jacob Good on 11/4/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import "PEGBoard.h"
#import "PEGClient.h"

@implementation PEGBoard {
    NSMutableArray * rows;
}

+ (int) rowCount {
    return 12;
}

+ (int) columnCount {
    return 80;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self clear];
    }
    return self;
}

- (BOOL) isEmpty:(CGPoint)point {
    return [rows[(int)point.x][(int)point.y] count] == 0;
}

- (void) draw:(CGPoint) point withColor:(UIColor *) color {
    rows[(int)point.x][(int)point.y] = @[color];
}

- (void) clear {
    rows = [[NSMutableArray alloc] initWithCapacity:[PEGBoard rowCount]];
    for (int row = 0; row < [PEGBoard rowCount]; row++)
    {
        [rows addObject:[[NSMutableArray alloc] initWithCapacity:[PEGBoard columnCount]]];
        for (int col = 0; col < [PEGBoard columnCount]; col++)
        {
            [rows[row] addObject:@[]];
        }
    }
}

- (PEGBoard *) copy {
    PEGBoard * newBoard = [[PEGBoard alloc] init];
    
    for (int row = 0; row < [PEGBoard rowCount]; row++)
    {
        [rows addObject:[[NSMutableArray alloc] initWithCapacity:[PEGBoard columnCount]]];
        for (int col = 0; col < [PEGBoard columnCount]; col++)
        {
            CGPoint pixel = (CGPoint) {row,col};
            if (![self isEmpty:pixel]) {
                [newBoard draw:pixel withColor:[self colorFor:pixel]];
            }
        }
    }
    
    return newBoard;
}

- (UIColor *) colorFor:(CGPoint)point {
    id p = rows[(int)point.x][(int)point.y];
    return (p && ([p count] == 0)) ? [UIColor grayColor] : [p firstObject];
}

@end
