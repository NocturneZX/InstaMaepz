//
//  NSString+Helpers.m
//  InstaMaepz
//
//  Created by Julio Reyes on 8/29/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "NSString+Helpers.h"

@implementation NSString (Helpers)

+(NSString*) QueryStringWithParams:(NSDictionary*) params{
    if (!params || ![[params allKeys] count])
        return @"";
    
    NSMutableString *queryString = [NSMutableString string];
    
    __block BOOL beginning = YES;
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (beginning) [queryString appendFormat:@"%@=%@", key, obj];
        else [queryString appendFormat:@"&%@=%@", key, obj];
        
        beginning = NO;
    }];
    
    return queryString;
}

@end
