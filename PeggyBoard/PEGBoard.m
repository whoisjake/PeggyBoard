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

+ (int) rows {
    return 12;
}

+ (int) columns {
    return 80;
}

- (BOOL) lease
{
    [[PEGClient sharedClient] GET:@"get_lease/1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        _leaseCode = [responseObject objectForKey:@"lease_code"];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
        NSString * date = [responseObject objectForKey:@"lease_expiry"];
        _expiration = [dateFormatter dateFromString:date];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return YES;
}

- (BOOL) draw:(CGPoint)point character:(NSString*) character {
    NSString *uri = [NSString stringWithFormat:@"write/%@/%d/%d/%@", [self leaseCode], (int)point.x, (int)point.y, character];
    
    [[PEGClient sharedClient] GET:uri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return YES;
}

- (BOOL) clear:(CGPoint)point {
    return [self draw:point character:@" "];
}

- (BOOL) clear {
    NSString *uri = [NSString stringWithFormat:@"clear/%@",[self leaseCode]];
    
    [[PEGClient sharedClient] GET:uri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    return YES;
}

@end
