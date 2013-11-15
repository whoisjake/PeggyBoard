//
//  PEGClient.m
//  PeggyBoard
//
//  Created by Jacob Good on 11/14/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import "PEGClient.h"

static NSString * const PEGApiBaseUrl = @"http://10.105.4.251/litebrite/peggy";

@implementation PEGClient

+ (instancetype) sharedClient {
    static PEGClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PEGClient alloc] initWithBaseURL:[NSURL URLWithString:PEGApiBaseUrl]];
    });
    
    return _sharedClient;
}

@end
