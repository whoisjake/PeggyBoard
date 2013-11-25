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

extern NSString * const PEGApiBaseUrl;

@interface PEGClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@property (nonatomic,strong) NSString * leaseCode;
@property (nonatomic,strong) NSDate * expiration;

- (BOOL) hasValidLease;
- (BOOL) isExpired;
- (void) draw:(PEGBoard *) board;
- (void) lease;
- (void) lease:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, id responseObject))failure;
- (void) captureLeaseFromResponse:(id) responseObject;
- (void) draw:(CGPoint)point withString:(NSString*)string withColor:(UIColor*)color;
- (void) clear:(CGPoint) point;
- (void) clear;

@end
