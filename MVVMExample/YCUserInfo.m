//
//  AddressInfo.m
//  Besides
//
//  Created by 陈小松 on 14-1-1.
//  Copyright (c) 2014年 Stony Chen. All rights reserved.
//

#import "YCUserInfo.h"

@implementation YCUserInfo

- (BOOL)hasMob
{
    if(_mob==nil || _mob.length==0) {
        return NO;
    }
    
    return YES;
}

- (NSString*)securedMob
{
    if(![self hasMob])
        return nil;
    
    NSRange replaceRange;
    replaceRange.location = 3;
    replaceRange.length   = 4;
    
    return [_mob stringByReplacingCharactersInRange:replaceRange withString:@"****"];
}

- (BOOL)canUnbindPhone
{
    //无手机号，不可解绑
    if(_mob==nil || _mob.length==0) {
        return NO;
    }
    
    //社交账号至少绑定一个
    if(_qqBind||_wechatBind||_weiboBind) {
        return YES;
    } else {
        return NO;
    }
}

+(YCUserInfo *) parseBriefUserInfo:(NSDictionary*)messageDic
{
    YCUserInfo *userInfo = [[YCUserInfo alloc]init];
    
    userInfo.uid         =   (long)[[messageDic objectForKey:@"uid"] longLongValue];
    userInfo.qqBind      =   [[messageDic objectForKey:@"qqBind"] boolValue];
    userInfo.wechatBind  =   [[messageDic objectForKey:@"wechatBind"] boolValue];
    userInfo.weiboBind   =   [[messageDic objectForKey:@"weiboBind"] boolValue];
    
    userInfo.mob    =   [messageDic objectForKey:@"mob"];
    userInfo.name   =   [messageDic objectForKey:@"name"];
    userInfo.avatar =   [messageDic objectForKey:@"avatar"];
    
    userInfo.coin   =   [[messageDic objectForKey:@"coin"] intValue];
    userInfo.bonus  =   [[messageDic objectForKey:@"bonus"] intValue];
    userInfo.unreadCnt =[[messageDic objectForKey:@"unreadCnt"] intValue];
    
    userInfo.isMaster = [[messageDic objectForKey:@"isMaster"] intValue];
    userInfo.first    = [[messageDic objectForKey:@"first"] intValue];
    
    return userInfo;
}

+(YCUserInfo *) parseDetailedUserInfo:(NSDictionary*)messageDic
{
    YCUserInfo *userInfo = [[YCUserInfo alloc]init];
    
    userInfo.uid    =   [[messageDic objectForKey:@"uid"] intValue];
    userInfo.qqBind      =   [[messageDic objectForKey:@"qqBind"] boolValue];
    userInfo.wechatBind  =   [[messageDic objectForKey:@"wechatBind"] boolValue];
    userInfo.weiboBind   =   [[messageDic objectForKey:@"weiboBind"] boolValue];
    
    userInfo.mob    =   [messageDic objectForKey:@"mob"];
    userInfo.name   =   [messageDic objectForKey:@"name"];
    userInfo.avatar =   [messageDic objectForKey:@"avatar"];
    
    userInfo.coin   =   [[messageDic objectForKey:@"coin"] intValue];
    userInfo.bonus  =   [[messageDic objectForKey:@"bonus"] intValue];
    userInfo.unreadCnt =[[messageDic objectForKey:@"unreadCnt"] intValue];
    userInfo.postsCnt = [[messageDic objectForKey:@"postsCnt"] intValue];
    
    userInfo.isMaster = [[messageDic objectForKey:@"isMaster"] intValue];
    userInfo.first    = [[messageDic objectForKey:@"first"] intValue];
    
    userInfo.birthday   =   [messageDic objectForKey:@"birthday"];
    userInfo.realname   =   [messageDic objectForKey:@"realname"];
    userInfo.gender     =   [messageDic objectForKey:@"gender"];
    
    return userInfo;
}

@end

