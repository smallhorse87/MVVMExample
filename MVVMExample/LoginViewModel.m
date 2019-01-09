//
//  LoginViewModel.m
//  MVVMExample
//
//  Created by chenxiaosong on 2019/1/9.
//  Copyright © 2019年 chenxiaosong. All rights reserved.
//

#import "LoginViewModel.h"

#import "ISWToolkit.h"

#import "BizPtContext.h"

#define REGEX_MOBILE_LIMIT @"^.{11}$"
#define REGEX_MOBILE @"1[0-9]{10}"

#define REGEX_CAPTCHA_LIMIT @"^.{4}$"
#define REGEX_CAPTCHA @"[0-9]{4}"

@interface LoginViewModel()
{
    NSString *thirdPartType;
    
    NSString *currentCaptcha;
    
    ISWValidator *telValidator;
    ISWValidator *captchaValidator;
}

@property (nonatomic, strong) NSNumber   *ntReqPhase;
@property (nonatomic, strong) NSString   *ntReqPrompt;

@property (nonatomic, strong) YCUserInfo *myInfo;

@property (nonatomic, assign) BOOL  requestCaptchaSuc;

@property (nonatomic, assign) BOOL validTel;
@property (nonatomic, assign) BOOL validCaptcha;

@property (nonatomic, strong) NSString *malFormatTelReason;
@property (nonatomic, strong) NSString *malFormatCaptchaReason;

@property (nonatomic, strong) NSString *currentTel;

@end

@implementation LoginViewModel

- (instancetype)init{
    self = [super init];
    
    if (self) {
        NSAssert(![BizPtContext isLogin], @"suppose no User context");

        _requestCaptchaSuc = NO;
        
        _validTel     = NO;
        _validCaptcha = NO;
        
        _malFormatCaptchaReason = @"请输入4位数验证码";
        _malFormatTelReason     = @"请输入正确的11位手机号";
        
        telValidator = [[ISWValidator alloc] init];
        [telValidator addRegx:REGEX_MOBILE_LIMIT withMsg:@"请输入正确的11位手机号"];
        [telValidator addRegx:REGEX_MOBILE withMsg:@"该手机号码无效"];
        
        captchaValidator = [[ISWValidator alloc] init];
        [captchaValidator addRegx:REGEX_CAPTCHA_LIMIT withMsg:@"请输入4位数验证码"];
        [captchaValidator addRegx:REGEX_CAPTCHA withMsg:@"请输入4位数验证码"];
        
        _currentTel = [BizPtContext retriveDefaultMobile];
        if(_currentTel) {
            _validTel = YES;
            _malFormatTelReason = @"";
        }
        
    }
    return self;
}

- (void)doesSupportThirdPartLogin:(BOOL)support
{

}

- (void)requestCaptchCode:(NSString*)telNum
{
    if(!self.validTel){
        [self ntRequestFail:FastErr(_malFormatTelReason,0)];
        return;
    }
    
    self.requestCaptchaSuc = NO;
    
    ISW_WEAKSELF
    
    [self ntRequesting];

//stony todo
//    [BizApi requestTextPasscodeWhileLogin:telNum
//                                  success:^(NSDictionary *retDic)
//     {
//         [weakSelf ntRequestSuc:[retDic objectForKey:@"captcha"]];
//         weakSelf.requestCaptchaSuc = YES;
//
//     } failure:^(NSError *err) {
//         [weakSelf ntRequestFail:err];
//
//     }];
}

- (void)onLogin:(NSString*)telNum andCaptcha:(NSString*)captcha
{
    if(!self.validTel){
        [self ntRequestFail:FastErr(_malFormatTelReason,0)];
        return;
    }
    
    if(!self.validCaptcha){
        [self ntRequestFail:FastErr(_malFormatCaptchaReason,0)];
        return;
    }
    
    [self ntRequesting];
    
    ISW_WEAKSELF
    
//stony todo
//    [BizApi loginViaMob:telNum andPasscode:captcha
//                success:^(NSDictionary *retDic)
//     {
//         [weakSelf ntRequestSuc:@"手机登录"];
//         [weakSelf loginSuccess:retDic];
//         [BizPtContext setDefaultMobile:telNum];
//
//     } failure:^(NSError * err) {
//         [weakSelf ntRequestFail:err];
//
//     }];
}

- (void)loginSuccess:(NSDictionary *)retDic
{
//stony todo
//    NSDictionary *briefUserInfoDic = (NSDictionary *)[retDic objectForKey:@"briefUserInfo"];
//    YCUserInfo  *myInfo  = [YCUserInfo parseBriefUserInfo:briefUserInfoDic];
//
//    [BizPtContext setMyInfo:myInfo];
//    [BizPtContext setUid:[NSString stringWithFormat:@"%ld",myInfo.uid]];
//    [BizPtContext setGsid:[retDic objectForKey:@"gsid"]];
//
//    // 极光推送
//    [JPUSHService setAlias:[NSString stringWithFormat:@"%ld",myInfo.uid] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//
//    } seq:1];
//
//    self.myInfo = myInfo;
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:YCAccountLoginNotification object:self];
    
}


- (void)onTelChanged:(NSString*)tel
{
    _currentTel = [tel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSError *validationErr;
    
    if(![telValidator validateOn:_currentTel err:&validationErr])
    {
        self.validTel = NO;
        self.malFormatTelReason = validationErr.domain;
    } else {
        self.malFormatTelReason = nil;
        self.validTel = YES;
    }
}

- (void)onCaptchaChanged:(NSString*)captcha
{
    currentCaptcha = [captcha stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSError *err;
    if(![captchaValidator validateOn:currentCaptcha err:&err])
    {
        self.validCaptcha = NO;
        self.malFormatCaptchaReason = err.domain;
    } else {
        self.malFormatCaptchaReason = nil;
        self.validCaptcha = YES;
    }
    
}

- (NSString *)thirdPartName
{
    if ([thirdPartType isEqualToString:@"wechatUid"]) {
        return @"微信";
    } else if ([thirdPartType isEqualToString:@"qqUid"]) {
        return @"QQ";
    } else if ([thirdPartType isEqualToString:@"weiboUid"]) {
        return @"微博";
    }
    
    return @"";
}

#pragma mark - utilities
- (void)ntRequesting
{
    self.ntReqPrompt = nil;
    self.ntReqPhase  = @(NtPhaseRequesting);
}

- (void)ntRequestSuc:(NSString*)str
{
    self.ntReqPrompt = str;
    self.ntReqPhase  = @(NtPhaseResponseSuc);
}

- (void)ntRequestFail:(NSError *)err
{
    if (err.code==-1009) {
        self.ntReqPrompt = @"网络未连接";
        self.ntReqPhase  = @(NtPhaseNoConnection);
    } else if(err.code<0) {
        self.ntReqPrompt = @"网络连接超时";
        self.ntReqPhase  = @(NtPhaseConnectionTimeout);
    } else {
        self.ntReqPrompt = err.domain;
        self.ntReqPhase  = @(NtPhaseResponseFail);
    }
    
}

@end
