//
//  PEGClient.m
//  PeggyBoard
//
//  Created by Jacob Good on 11/14/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import "PEGClient.h"

NSString * const PEGApiBaseUrl = @"http://localhost:4567/litebrite/peggy";

@implementation PEGClient

+ (instancetype) sharedClient {
    static PEGClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PEGClient alloc] initWithBaseURL:[NSURL URLWithString:PEGApiBaseUrl]];
    });
    
    return _sharedClient;
}

- (void) lease
{
    [self GET:@"get_lease/1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        _leaseCode = [responseObject objectForKey:@"lease_code"];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
        NSString * date = [responseObject objectForKey:@"lease_expiry"];
        _expiration = [dateFormatter dateFromString:date];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) draw:(PEGBoard *)board {
    for (int row = 0; row < [PEGBoard rowCount]; row++)
    {
        NSMutableString * line = [[NSMutableString alloc] init];
        for (int col = 0; col < [PEGBoard columnCount]; col++)
        {
            if ([board isEmpty:(CGPoint){row,col}]) {
                [line appendString:@" "];
            } else {
                [line appendString:@"#"];
            }
        }
        [self draw:(CGPoint){0,row} character:line];
    }
}

- (void) draw:(CGPoint)point character:(NSString*) character {
    NSString *uri = [NSString stringWithFormat:@"write/%@/%d/%d/%@", [self leaseCode], (int)point.x, (int)point.y, character];
    uri = [uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:uri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) clear:(CGPoint)point {
    [self draw:point character:@" "];
}

- (void) clear {
    NSString *uri = [NSString stringWithFormat:@"clear/%@",[self leaseCode]];
    
    [self GET:uri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
