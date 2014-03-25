//
//  PEGClient.m
//  PeggyBoard
//
//  Created by Jacob Good on 11/14/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import "PEGClient.h"

//NSString * const PEGApiBaseUrl = @"http://localhost:3000/peggy";
NSString * const PEGApiBaseUrl = @"http://10.105.4.251/peggy";

@implementation PEGClient

+ (instancetype) sharedClient {
    static PEGClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PEGClient alloc] initWithBaseURL:[NSURL URLWithString:PEGApiBaseUrl]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        [self setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [[self responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    }
    
    return self;
}

+ (NSDictionary *) colorMap {
    static NSDictionary *_colorMap;
    static dispatch_once_t mapOnceToken;
    dispatch_once(&mapOnceToken, ^{
        _colorMap = @{[UIColor redColor]: @"{r}",
                      [UIColor greenColor]: @"{g}",
                      [UIColor orangeColor]: @"{o}",
                      [UIColor blackColor]: @"{b}"};
    });
    
    return _colorMap;
}

- (void) draw:(int)boardId board:(PEGBoard *)board {
    NSMutableString * currentLine;
    int x,y;
    for (int row = 0; row < [PEGBoard rowCount]; row++)
    {
        currentLine = [[NSMutableString alloc] init];
        x = 0;
        y = row;
        for (int col = 0; col < [PEGBoard columnCount]; col++)
        {
            CGPoint pixel = (CGPoint){row,col};
            if ([board isEmpty:pixel]) {
                [currentLine appendString:@" "];
            } else {
                [currentLine appendString:[self colorString:[board colorFor:pixel]]];
                [currentLine appendString:@"#"];
            }
        }
        [self draw:boardId at:(CGPoint){x,y} withString:currentLine];
    }
}

- (void) draw:(int)boardId at:(CGPoint)point withString:(NSString*)string {
    NSLog(@"Writing: %@ to (%d,%d)", string,(int)point.x,(int)point.y);
    NSString *writeUri = [NSString stringWithFormat:@"write?board=%d&y=%d&x=%d&text=%@", boardId, (int)point.y, (int)point.x, string];
    writeUri = [writeUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"GET: %@", writeUri);
    
    [self GET:writeUri parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"RESP: %@", responseObject);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) clear:(int) boardId at:(CGPoint)point {
    [self draw:boardId at:point withString:@" "];
}

- (void) clear:(int) boardId {
    NSString *uri = [NSString stringWithFormat:@"clear?board=%d",boardId];
    NSLog(@"GET: %@", uri);
    [self GET:uri parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"RESP: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSString *) colorString:(UIColor *)color {
    return [PEGClient colorMap][color];
}

@end
