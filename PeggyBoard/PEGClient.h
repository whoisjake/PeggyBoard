//
//  PEGClient.h
//  PeggyBoard
//
//  Created by Jacob Good on 11/14/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface PEGClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end
