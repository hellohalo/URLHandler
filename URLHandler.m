//
//  URLHandler.m
//  
//
//  Created by zhang zheng on 6/3/13.
//
//

#import "URLHandler.h"
#import "NSString+Extras.h"

@interface URLHandler ()

@property (nonatomic, retain) NSMutableDictionary *handlers;

@end

static const URLHandler *gManager = nil;

@implementation URLHandler

@synthesize handlers;

+ (const URLHandler *)sharedManager
{
    @synchronized (self) {
        if (!gManager) {
            gManager = [[URLHandler alloc] init];
        }
    }
    return gManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        handlers = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (BOOL)isFunctionRegisted:(NSString *)string
                    scheme:(NSString *)scheme
{
    NSDictionary *handlers4Scheme = [handlers objectForKey:scheme];
    if (!handlers4Scheme) {
        return NO;
    }
    return !![handlers4Scheme objectForKey:string];
}

- (void)registerTarget:(NSObject *)target
              selector:(SEL)selector
         parameterList:(NSArray *)parameters
             forScheme:(NSString *)scheme
           function:(NSString *)functionName
{
    @try {
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:target];
        [invocation setSelector:selector];
        NSDictionary *info = nil;
        if (!parameters) {
            info =
            [NSDictionary dictionaryWithObjectsAndKeys:invocation, @"invocation", nil];
        } else {
            info =
            [NSDictionary dictionaryWithObjectsAndKeys:
             invocation, @"invocation",
             parameters, @"params", nil];
        }
        NSMutableDictionary *handlers4Scheme = [handlers objectForKey:scheme];
        if (!handlers4Scheme) {
            handlers4Scheme = [NSMutableDictionary dictionaryWithCapacity:0];
            [handlers setObject:handlers4Scheme
                         forKey:scheme];
        }
        [handlers4Scheme setObject:info forKey:functionName];
    } @catch (NSException *exception) {
        NSLog(@"exception is %@", exception);
    }
}

- (void)excuseFunction:(NSString *)functionName
                scheme:(NSString *)scheme
           withObjects:(NSString *)objects
{
    if (![self isFunctionRegisted:functionName scheme:scheme]) {
        return;
    }
    NSDictionary *handler4Scheme = [handlers objectForKey:scheme];
    NSDictionary *info = [handler4Scheme objectForKey:functionName];
    NSDictionary *parameters =nil;
    NSArray *parameterList = [info objectForKey:@"params"];
    if (objects && [parameterList count] == 1 &&
        [[parameterList lastObject] isEqualToString:@"queryString"]) {
        parameters = [NSDictionary dictionaryWithObject:objects
                                                 forKey:@"queryString"];
    } else {
        parameters= [NSString parseQueryString:objects];
    }
    NSInvocation *invocation = [info objectForKey:@"invocation"];

    // set params
    NSEnumerator *enumrator = [parameters keyEnumerator];
    NSString *key = nil;
    @try {
        NSMutableArray *remainParas = [parameterList mutableCopy];
        while (key = [enumrator nextObject]) {
            id object = [parameters objectForKey:key];
            if ([object isKindOfClass:[NSString class]]) {
                object = [object urlDecoded];
            }
            NSUInteger index = [parameterList indexOfObject:key];
            if (index != NSNotFound) {
                [invocation setArgument:&object
                                atIndex: index + 2];
            }
            [remainParas removeObject:key];
        }
        // set other parameters to nil
        for (NSString *remainKey in remainParas) {
            id null = nil;
            NSUInteger index = [parameterList indexOfObject:remainKey];
            if (index != NSNotFound) {
                [invocation setArgument:&null
                                atIndex:[parameterList indexOfObject:remainKey] + 2];
            }
        }
        [invocation invoke];
    }
    @catch (NSException *exception) {
        NSLog(@"Error when setting local function params, maybe you set wrong params."
                 @"detail %@, %@", exception.name, exception.reason);
    }
    return;
}

- (void)dealloc
{
    self.handlers = nil;
}

@end
