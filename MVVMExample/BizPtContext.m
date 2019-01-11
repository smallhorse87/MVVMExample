//
//  BizPtContext.m
//  youngcity
//
//  Created by chen xiaosong on 16/4/30.
//  Copyright © 2016年 Zhitian Network Tech. All rights reserved.
//

#import "BizPtContext.h"

#import "ISWPlistStorage.h"

#define kDefaultMobile @"DefaultMobile"

@interface  BizPtContext()
{
    ISWPlistStorage *ptStorage;
}
@end

@implementation BizPtContext

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static BizPtContext *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [(BizPtContext *)[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        ptStorage = [[ISWPlistStorage alloc] initWithFileName:@"BizPtContext.plist"];
    }
    return self;
}

//记住登录手机号
+(void)setDefaultMobile:(NSString*)mob
{
    [[BizPtContext sharedInstance]->ptStorage save:mob forKey:kDefaultMobile];
}

+(NSString*)retriveDefaultMobile
{
    NSString *mob = [[BizPtContext sharedInstance]->ptStorage
                     readWithKey:kDefaultMobile];
    
    if (mob == nil) mob = @"";
    
    return mob;
}

@end
