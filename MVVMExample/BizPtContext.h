//
//  BizPtContext.h
//  youngcity
//
//  Created by chen xiaosong on 16/4/30.
//  Copyright © 2016年 Zhitian Network Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCUserInfo;

extern BOOL walletInfoUpdated;

@interface BizPtContext : NSObject

+ (NSString*)getMyInfoStr;
+ (YCUserInfo *)getMyInfo;
+ (void)setMyInfo:(YCUserInfo *)info;
+ (void)resetMyInfo;

+(void)setGsid:(NSString*)gsid;
+(NSString*)retriveGsid;
+(void)cleanGsid;

+(void)cleanUid;
+(void)setUid:(NSString*)uid;
+(NSString*)retriveUid;

+(void)setDefaultMobile:(NSString*)mob;
+(NSString*)retriveDefaultMobile;

+(BOOL)isLogin;
+(BOOL)hasMobile;

//会员积分
+ (void )setBonusCurr : (NSString *)bonusCurr;
+(NSString*)retriveBonusCurr;
+(void)clearBonusCurr;

+(void)setMapCommented;
+(BOOL)getMapCommented;

//分享链接
+(void)setShareLink:(NSString*)link;
+(NSString*)getShareLink;

//室内地图历史收藏
+(void)    addIndoorSearchHistory:(NSString*)title floor:(NSString*)floor;
+(NSArray*)retriveIndoorSearchHistoryList;
+(void)    clearIndoorSearchHistoryList;

//空车位
+ (void)setFreeParks :(NSString *)freeParks;

@end

