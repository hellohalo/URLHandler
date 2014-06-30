//
//  NSString+Utility.m
//  URLHandlerTest
//
//  Created by Zheng on 6/30/14.
//  Copyright (c) 2014 Zheng Zhang. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

- (NSDictionary *)parsedQuery
{
    NSArray *queryPairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:queryPairs.count];
    for (NSString *pair in queryPairs) {
        NSRange range = [pair rangeOfString:@"="
                                    options:NSLiteralSearch];
        if (range.location == NSNotFound) {
            return nil;
        }
        NSString *key = [pair substringToIndex:range.location];
        NSString *value = [pair substringFromIndex:range.location + 1];
        
        [dic setValue:value forKey:key];
    }
    return dic;
}

- (NSString *)urlDecoded
{
    CFStringRef cfUrlDecodingString =
    CFURLCreateStringByReplacingPercentEscapes (NULL,
                                                (CFStringRef)self, CFSTR(""));
    NSString *urlDecoded = [NSString stringWithString:(__bridge NSString *)cfUrlDecodingString];
    CFRelease(cfUrlDecodingString);
    return urlDecoded;
}

@end
