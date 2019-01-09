//
//  BizPtContext.m
//  youngcity
//
//  Created by chen xiaosong on 16/4/30.
//  Copyright © 2016年 Zhitian Network Tech. All rights reserved.
//

#import "BizPtContext.h"

#import "ISWPlistStorage.h"

#import "YCUserInfo.h"

#define kUid           @"uid"
#define kGsid          @"Gsid"
#define kDefaultMobile @"DefaultMobile"
#define kBonusCurr     @"bonusCurr"
#define kMapCommented  @"mapCommented"
#define kIndoorSearchHist  @"IndoorSearchHist"
#define kFreeParks     @"FreeParks"
#define kShareLink     @"ShareLink"

NSString      *sessionStr;
YCUserInfo    *myInfo = nil;
BOOL          walletInfoUpdated;

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

+ (NSString*)getMyInfoStr
{
    
    YCUserInfo *userInfo = [BizPtContext getMyInfo];
    
    if (userInfo == nil) {
        
        return nil ;
    } else {
        
        return  [self userInfoToJson:userInfo];
    }
    
    return nil;
    
}

+ (NSString*)userInfoToJson:(YCUserInfo *)userInfo
{
    BOOL first = userInfo.first;
    BOOL qqBind = userInfo.qqBind;
    BOOL wechatBind = userInfo.wechatBind;
    BOOL weiboBind  = userInfo.weiboBind;
    BOOL isOmg      = userInfo.isOmg;
    NSDictionary *userDict = @{
                               @"avatar":userInfo.avatar,
                               @"bonus" :[NSString stringWithFormat:@"%d",userInfo.bonus],
                               @"coin": [NSString stringWithFormat:@"%d",userInfo.coin],
                               @"first": @(first),
                               @"gsid":[BizPtContext retriveGsid],
                               @"isMaster" :[NSString stringWithFormat:@"%d",(int)userInfo.isMaster],
                               @"isOmg" : @(isOmg),
                               @"mob":userInfo.mob,
                               @"name" :  userInfo.name,
                               @"qqBind" :@(qqBind),
                               @"unreadCnt": [NSString stringWithFormat:@"%d",userInfo.unreadCnt],
                               @"uuid" :  [BizPtContext retriveUid],
                               @"wechatBind":@(wechatBind),
                               @"weiboBind" : @(weiboBind),
                               
                               };
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (YCUserInfo *)getMyInfo
{
    return myInfo;
}

+ (void)setMyInfo:(YCUserInfo *)info
{
    myInfo = info;
}

+ (void)resetMyInfo
{
    myInfo = nil;
    
    [self clearBonusCurr];
    
    [self cleanGsid];
    
    [self cleanUid];
}

+(BOOL)isLogin
{
    NSString *gsid = [BizPtContext retriveGsid];
    
    if (gsid == nil || [gsid length] == 0) {
        return NO;
    }
    
    return YES;
}

+(BOOL)hasMobile
{
    if((myInfo.mob == nil || myInfo.mob.length == 0))
        return NO;
    else
        return YES;
}

//login setting
+(void)cleanUid
{
    [[BizPtContext sharedInstance]->ptStorage removeWithKey:kUid];
}

+(void)setUid:(NSString*)uid
{
    [[BizPtContext sharedInstance]->ptStorage save:uid forKey:kUid];
}

+(void)setShareLink:(NSString*)link
{
    [[BizPtContext sharedInstance]->ptStorage save:link forKey:kShareLink];
}

+(NSString*)getShareLink
{
    return [[BizPtContext sharedInstance]->ptStorage readWithKey:kShareLink];
}


//地图评论
+(void)setMapCommented
{
    [[BizPtContext sharedInstance]->ptStorage save:@"yes" forKey:kMapCommented];
}

+(BOOL)getMapCommented
{
    NSString *commented = [[BizPtContext sharedInstance]->ptStorage
                           readWithKey:kMapCommented];
    
    if([commented isEqualToString:@"yes"])
        return YES;
    else
        return NO;
}

//室内地图历史搜索记录
//格式  中国移动|F1;一点点|F3;
+(void)addIndoorSearchHistory:(NSString*)title floor:(NSString*)floor
{
    if(title.length==0)
        return;
    
    if(floor.length==0)
        return;
    
    NSString *catHistory = @"";
    NSString *addedLoc = [NSString stringWithFormat:@"%@|%@;",title,floor];
    
    //读取之前的列表，进行重排序，加入新记录
    NSString *lastHistory = [[BizPtContext sharedInstance]->ptStorage
                             readWithKey:kIndoorSearchHist];
    if(lastHistory) {
        catHistory = lastHistory;
        catHistory = [catHistory stringByReplacingOccurrencesOfString:addedLoc withString:@""];
    }
    
    
    
    catHistory = [addedLoc stringByAppendingString:catHistory];
    
    //保存记录
    [[BizPtContext sharedInstance]->ptStorage save:catHistory forKey:kIndoorSearchHist];
}

+(NSArray*)retriveIndoorSearchHistoryList
{
    NSString *catHistory = [[BizPtContext sharedInstance]->ptStorage
                            readWithKey:kIndoorSearchHist];
    
    if(catHistory==nil)
        return nil;
    
    catHistory = [catHistory substringToIndex:catHistory.length-1];
    
    NSArray *historyArr = [catHistory componentsSeparatedByString:@";"];
    
    return historyArr;
}

+ (void)clearIndoorSearchHistoryList
{
    [[BizPtContext sharedInstance]->ptStorage removeWithKey:kIndoorSearchHist];
}

//会员积分
+ (void )setBonusCurr : (NSString *)bonusCurr
{
    [[BizPtContext sharedInstance]->ptStorage save:bonusCurr forKey:kBonusCurr];
}

//空车位
+ (void)setFreeParks :(NSString *)freeParks
{
    [[BizPtContext sharedInstance]->ptStorage save:freeParks forKey:kFreeParks];
}

+(NSString*)retriveBonusCurr
{
    NSString *bonusCurr = [[BizPtContext sharedInstance]->ptStorage
                           readWithKey:kBonusCurr];
    
    if(bonusCurr==nil)
        return @"0";
    else
        return bonusCurr;
}

+ (void)clearBonusCurr
{
    [[BizPtContext sharedInstance]->ptStorage removeWithKey:kBonusCurr];
}

+(NSString*)retriveUid
{
    NSString *gsid = [[BizPtContext sharedInstance]->ptStorage
                      readWithKey:kUid];
    
    return gsid;
}

//login setting
+(void)cleanGsid
{
    [[BizPtContext sharedInstance]->ptStorage removeWithKey:kGsid];
}

+(void)setGsid:(NSString*)gsid
{
    [[BizPtContext sharedInstance]->ptStorage save:gsid forKey:kGsid];
}


+(NSString*)retriveGsid
{
    NSString *gsid = [[BizPtContext sharedInstance]->ptStorage
                      readWithKey:kGsid];
    
    return gsid;
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
