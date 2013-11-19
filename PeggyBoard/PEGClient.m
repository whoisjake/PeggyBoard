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

+ (NSDictionary *) colorMap {
    static NSDictionary *_colorMap;
    static dispatch_once_t mapOnceToken;
    dispatch_once(&mapOnceToken, ^{
        _colorMap = @{[UIColor redColor]: @"red",
                      [UIColor greenColor]: @"green",
                      [UIColor orangeColor]: @"orange",
                      [UIColor blackColor]: @"black"};
    });
    
    return _colorMap;
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
    NSMutableString * currentLine;
    int x,y;
    UIColor * currentColor = [UIColor greenColor];
    for (int row = 0; row < [PEGBoard rowCount]; row++)
    {
        currentLine = [[NSMutableString alloc] init];
        x = 0;
        y = row;
        currentColor = [UIColor greenColor];
        for (int col = 0; col < [PEGBoard columnCount]; col++)
        {
            CGPoint pixel = (CGPoint){row,col};
            if ([board isEmpty:pixel]) {
                [currentLine appendString:@" "];
            } else {
                if ([currentColor isEqual:[board colorFor:pixel]]) {
                    [currentLine appendString:@"#"];
                } else {
                    [self draw:(CGPoint){x,y} withString:currentLine withColor:currentColor];
                    currentColor = [board colorFor:pixel];
                    currentLine = [[NSMutableString alloc] init];
                    x = col;
                    [currentLine appendString:@"#"];
                }
                
            }
        }
        [self draw:(CGPoint){x,y} withString:currentLine withColor:currentColor];
    }
}

- (void) draw:(CGPoint)point withString:(NSString*)string withColor:(UIColor*)color {
    
    NSString *colorUri = [NSString stringWithFormat:@"set_color/%@/%@",self.leaseCode,[self colorString:color]];
    colorUri = [colorUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:colorUri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    NSString *writeUri = [NSString stringWithFormat:@"write/%@/%d/%d/%@", self.leaseCode, (int)point.x, (int)point.y, string];
    writeUri = [writeUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:writeUri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void) clear:(CGPoint)point {
    [self draw:point withString:@" " withColor:[UIColor blackColor]];
}

- (void) clear {
    NSString *uri = [NSString stringWithFormat:@"clear/%@",self.leaseCode];
    
    [self GET:uri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSString *) colorString:(UIColor *)color {
    return [PEGClient colorMap][color];
}

@end
