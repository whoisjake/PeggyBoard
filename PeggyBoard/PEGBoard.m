//
//  PEGBoard.m
//  PeggyBoard
//
//  Created by Jacob Good on 11/4/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import "PEGBoard.h"
#import "PEGClient.h"

@implementation PEGBoard

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

- (void) draw:(CGPoint) point {
    self.rows[(int)point.x][(int)point.y] = @YES;
}

- (void) clear {
    self.rows = [[NSMutableArray alloc] initWithCapacity:[PEGBoard rowCount]];
    for (int row = 0; row < [PEGBoard rowCount]; row++)
    {
        [self.rows addObject:[[NSMutableArray alloc] initWithCapacity:[PEGBoard columnCount]]];
        for (int col = 0; col < [PEGBoard columnCount]; col++)
        {
            [self.rows[row] addObject:@NO];
        }
    }
}

- (UIColor *) colorFor:(CGPoint)point {
    return ([self.rows[(int)point.x][(int)point.y]  isEqual: @YES]) ? [UIColor redColor] : [UIColor lightGrayColor];
}

@end
