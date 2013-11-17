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

@property (nonatomic,strong) NSMutableArray * rows;

- (UIColor *) colorFor:(CGPoint)point;
- (void) clear;
- (void) draw:(CGPoint)point;

@end
