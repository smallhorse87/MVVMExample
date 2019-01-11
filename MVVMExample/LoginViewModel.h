//
//  LoginViewModel.h
//  MVVMExample
//
//  Created by chenxiaosong on 2019/1/9.
//  Copyright © 2019年 chenxiaosong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewModel : NSObject

- (void)requestCaptchCode:(NSString*)telNum;
- (void)requestLoginWithCaptcha:(NSString*)telNum andCaptcha:(NSString*)captcha;

- (void)onTelChanged:(NSString*)tel;
- (void)onCaptchaChanged:(NSString*)captcha;

@property (nonatomic,readonly)  BOOL  requestCaptchaSuc;

@property (nonatomic, readonly) NSNumber   *ntReqPhase;
@property (nonatomic, readonly) NSString   *ntReqPrompt;

@property (nonatomic, readonly) NSString *currentTel;

@property (nonatomic, readonly) BOOL validTel;
@property (nonatomic, readonly) BOOL validCaptcha;

@property (nonatomic, readonly) NSString *malFormatTelReason;
@property (nonatomic, readonly) NSString *malFormatCaptchaReason;

@end

NS_ASSUME_NONNULL_END
