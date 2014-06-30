//
//  URLHandler.h
//  
//
//  Created by zhang zheng on 6/3/13.
//
//

#import <Foundation/Foundation.h>

@interface URLHandler : NSObject

+ (const URLHandler *)sharedManager;

- (void)registerTarget:(NSObject *)target
              selector:(SEL)selector
         parameterList:(NSArray *)parameters
             forScheme:(NSString *)scheme
              function:(NSString *)functionName;

- (void)excuseFunction:(NSString *)functionName
                scheme:(NSString *)scheme
           withObjects:(NSString *)objects;

- (BOOL)isFunctionRegisted:(NSString *)string
                    scheme:(NSString *)scheme;

@end
