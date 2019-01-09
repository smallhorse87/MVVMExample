//
//  AddressInfo.h
//  Besides
//
//  Created by 陈小松 on 14-1-1.
//  Copyright (c) 2014年 Stony Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YCTalentMasterState) {
    YCTalentNotMaster = 0,
    YCTalentAlreadyMaster = 1,                         // no button type
    YCTalentRequestingMaster =2
};

@interface YCUserInfo : NSObject

@property long  uid;

@property(nonatomic,assign)BOOL qqBind;
@property(nonatomic,assign)BOOL wechatBind;
@property(nonatomic,assign)BOOL weiboBind;

@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *mob;
@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *birthday;
@property(nonatomic,strong)NSString *realname;
@property(nonatomic,strong)NSString * gender;
@property (nonatomic,strong) NSString *cardClassNm;

@property int   bonus;
@property int   coin;
@property int   unreadCnt;
@property int   postsCnt;
@property int   first;
@property int   isOmg;

@property YCTalentMasterState  isMaster;

- (BOOL)canUnbindPhone;
- (BOOL)hasMob;
- (NSString*)securedMob;

+(YCUserInfo *) parseBriefUserInfo:(NSDictionary*)messageDic;
+(YCUserInfo *) parseDetailedUserInfo:(NSDictionary*)messageDic;

@end

