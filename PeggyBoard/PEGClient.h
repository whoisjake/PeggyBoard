//
//  PEGClient.h
//  PeggyBoard
//
//  Created by Jacob Good on 11/14/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "PEGBoard.h"

@interface PEGClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@property (nonatomic,strong) NSString * leaseCode;
@property (nonatomic,strong) NSDate * expiration;

- (void) draw:(PEGBoard *) board;
- (void) lease;
- (void) draw:(CGPoint)point character:(NSString*) character;
- (void) clear:(CGPoint) point;
- (void) clear;

@end
