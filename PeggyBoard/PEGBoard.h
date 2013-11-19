//
//  PEGBoard.h
//  PeggyBoard
//
//  Created by Jacob Good on 11/4/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEGBoard : NSObject

+ (int) columnCount;
+ (int) rowCount;

- (UIColor *) colorFor:(CGPoint)point;
- (BOOL) isEmpty:(CGPoint) point;
- (void) clear;
- (void) draw:(CGPoint)point withColor:(UIColor*)color;

@end
