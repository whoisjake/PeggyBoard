//
//  PEGBoard.h
//  PeggyBoard
//
//  Created by Jacob Good on 11/4/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEGBoard : NSObject

@property (nonatomic,strong) NSString * leaseCode;
@property (nonatomic,strong) NSDate * expiration;

+ (int) columns;
+ (int) rows;

- (BOOL) lease;
- (BOOL) draw:(CGPoint)point character:(NSString*) character;
- (BOOL) clear:(CGPoint) point;
- (BOOL) clear;

@end
