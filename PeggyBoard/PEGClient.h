//
//  PEGClient.h
//  PeggyBoard
//
//  Created by Jacob Good on 11/14/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PEGBoard.h"

extern NSString * const PEGApiBaseUrl;

@interface PEGClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@property (nonatomic,strong) NSString * leaseCode;
@property (nonatomic,strong) NSDate * expiration;

- (void) draw:(int) boardId board:(PEGBoard *) board;
- (void) draw:(int) boardId at:(CGPoint)point withString:(NSString*)string;
- (void) clear:(int) boardId at:(CGPoint) point;
- (void) clear:(int) boardId;

@end
