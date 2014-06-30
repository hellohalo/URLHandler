//
//  NSString+Utility.h
//  URLHandlerTest
//
//  Created by Zheng on 6/30/14.
//  Copyright (c) 2014 Zheng Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

- (NSDictionary *)parsedQuery;
- (NSString *)urlDecoded;

@end
