//
//  ViewController.m
//  MVVMExample
//
//  Created by chenxiaosong on 2019/1/9.
//  Copyright © 2019年 chenxiaosong. All rights reserved.
//

#import "LoginViewController.h"

#import "ISWToolkit.h"
#import "Masonry.h"

#import "BizStyle.h"

#import "KVOController.h"
#import "LoginViewModel.h"

#define kSystemCountDownTimer 60

@interface LoginViewController ()
{
    UITextField       *telInput;
    UITextField       *captchaInput;

    UIButton           *submitBtn;
    JKCountDownButton  *countDownBtn;
}

@property (nonatomic,strong) LoginViewModel* viewModel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self bindWithViewModel];

    [self buildUI];
}

- (void)bindWithViewModel
{
    if(self.viewModel)
        return;
    
    self.viewModel = [[LoginViewModel alloc] init];
    
    ISW_WEAKSELF
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.KVOController = KVOController;
    [self.KVOController observe:self.viewModel
                       keyPaths:@[@"ntReqPhase",@"requestCaptchaSuc",@"validTel",@"validCaptcha"]
                        options:NSKeyValueObservingOptionNew
                          block:
     ^(id observer, LoginViewModel *viewModel, NSDictionary *change) {
         
         NSString *key = [change objectForKey:@"FBKVONotificationKeyPathKey"];
         
         if([key isEqualToString:@"ntReqPhase"]) {
             [weakSelf popToast:[viewModel.ntReqPhase unsignedIntegerValue]
                          title:viewModel.ntReqPrompt];
             
         } else if ([key isEqualToString:@"requestCaptchaSuc"]) {
             [weakSelf requestCaptchaSucValueUpdated];
             
         }  else if ([key isEqualToString:@"validTel"]) {
             [weakSelf validTelValueUpdated];
             
         } else if ([key isEqualToString:@"validCaptcha"]) {
             [weakSelf validCaptchaValueUpdated];

         }
         
     }];
}

#pragma mark == life cycle
- (void)dealloc
{
    [countDownBtn stopCountDown];
}

#pragma mark == ui setup

- (void)buildUI
{
    self.view.backgroundColor = kColorWhite;
    
    self.title = @"请登录";

    ISW_WEAKSELF
    
    UILabel *loginTitle = [[UILabel alloc] init];
    loginTitle.textColor = kColorDeepDark;
    loginTitle.font      = [UIFont isw_Pingfang:15];
    loginTitle.numberOfLines = 1;
    [self.view addSubview:loginTitle];
    [loginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.view).offset(12);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(weakSelf.view).offset(20+44);
        }
    
    }];
    
    loginTitle.text = @"手机号一键登录";
    
    UIView *separatorTel = [[UIView alloc] initWithFrame:CGRectZero];
    separatorTel.backgroundColor     = kColorSeparator;
    [self.view addSubview:separatorTel];
    [separatorTel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.view).offset(12);
        make.trailing.equalTo(weakSelf.view).offset(-12);
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(96);
        } else {
            make.top.equalTo(weakSelf.view).offset(96+44);
        }

        make.height.equalTo(@([UIScreen isw_pixel]));
    }];
    
    UIView *separatorCaptcha = [[UIView alloc] initWithFrame:CGRectZero];
    separatorCaptcha.backgroundColor     = kColorSeparator;
    [self.view addSubview:separatorCaptcha];
    [separatorCaptcha mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.view).offset(12);
        make.trailing.equalTo(weakSelf.view).offset(-12);
        make.top.equalTo(separatorTel).offset(55);
        
        make.height.equalTo(@([UIScreen isw_pixel]));
    }];
    
    telInput = [[UITextField alloc] initWithFrame:CGRectZero];
    telInput.textColor = kColorDeepDark;
    telInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    telInput.borderStyle=UITextBorderStyleNone;
    telInput.keyboardType = UIKeyboardTypePhonePad;
    telInput.text = _viewModel.currentTel;
    telInput.placeholder = @"请输入手机号码";
    telInput.clearButtonMode = UITextFieldViewModeAlways;
    [telInput addTarget:self action:@selector(telInputDidChange:) forControlEvents:UIControlEventEditingChanged];
    if(isEmptyString(telInput.text)) {
        telInput.font = [UIFont isw_Pingfang:15];
    } else {
        telInput.font = [UIFont isw_Pingfang:18];
    }
    [self.view addSubview:telInput];
    [telInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@37);
        make.bottom.equalTo(separatorTel);
        
        make.leading.equalTo(separatorTel);
        
        make.trailing.equalTo(separatorTel).offset(8);
    }];
    
    captchaInput = [[UITextField alloc] initWithFrame:CGRectZero];
    captchaInput.textColor = kColorDeepDark;
    captchaInput.keyboardType = UIKeyboardTypeNumberPad;
    captchaInput.font      = [UIFont isw_Pingfang:15];
    
    [self.view addSubview:captchaInput];
    [captchaInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@37);
        make.bottom.equalTo(separatorCaptcha);
        
        make.leading.equalTo(separatorCaptcha);
        make.trailing.equalTo(separatorCaptcha).offset(-150);
    }];
    captchaInput.borderStyle=UITextBorderStyleNone;
    captchaInput.placeholder = @"请输入验证码";
    [captchaInput addTarget:self action:@selector(captchaInputDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *separatorVCaptcha = [[UIView alloc] initWithFrame:CGRectZero];
    separatorVCaptcha.backgroundColor     = kColorSeparator;
    [self.view addSubview:separatorVCaptcha];
    [separatorVCaptcha mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(captchaInput);
        make.trailing.equalTo(separatorCaptcha).offset(-82);
        
        make.height.equalTo(@(20));
        make.width.equalTo(@([UIScreen isw_pixel]));
    }];
    
    countDownBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    [countDownBtn isw_addClickAction:@selector(captchaBtnPressed:) target:self];
    [countDownBtn isw_titleForAllState:@"获取验证码"];
    [countDownBtn isw_titleColorForAllState:kColorMajorNormal];
    countDownBtn.titleLabel.font = [UIFont isw_Pingfang:14];
    [self.view addSubview:countDownBtn];
    [countDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(captchaInput);
        
        make.left.equalTo(separatorVCaptcha);
        make.right.equalTo(weakSelf.view);
    }];
    [countDownBtn countDownChanging:
     ^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
         countDownButton.enabled = NO;
         NSString *title = [NSString stringWithFormat:@"%ld秒",(long)second];

         return title;
     }];
    [countDownBtn countDownFinished:
     ^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
         countDownButton.enabled = YES;
         return @"获取验证码";
     }];
    
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn isw_addClickAction:@selector(loginBtnPressed:) target:self];
    [submitBtn isw_titleForAllState:@"登录"];
    submitBtn.titleLabel.font = [UIFont isw_Pingfang:17];
    submitBtn.titleLabel.textColor = kColorWhite;
    [submitBtn isw_roundCorner:kLargeCorner borderWidth:1.0f borderColor:[UIColor clearColor]];
    [submitBtn isw_setBackgroundColor:kColorMajorNormal forState:UIControlStateNormal];
    [submitBtn isw_setBackgroundColor:kColorMajorHighlight forState:UIControlStateHighlighted];
    [submitBtn isw_setBackgroundColor:kColorLight forState:UIControlStateDisabled];
    submitBtn.enabled = NO;
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.leading.equalTo(weakSelf.view).offset(12);
        make.trailing.equalTo(weakSelf.view).offset(-12);
        make.top.equalTo(separatorCaptcha).offset(30);
    }];
    
}

- (void)updateSubmitBtnUI
{
    if(_viewModel.requestCaptchaSuc==YES && _viewModel.validCaptcha && _viewModel.validTel){
        submitBtn.enabled = YES;
    } else {
        submitBtn.enabled = NO;
    }
}


#pragma mark == ui event
- (void)captchaBtnPressed:(id)sender
{
    [self.view endEditing:YES];
    
    if(!_viewModel.validTel){
        [ISWToast showFailToast:_viewModel.malFormatTelReason];
        return;
    }
    
    [countDownBtn startCountDownWithSecond:kSystemCountDownTimer];
    
    [_viewModel requestCaptchCode:telInput.text];
}

- (void)loginBtnPressed:(id)sender
{
    [self.view endEditing:YES];
    
    [_viewModel requestLoginWithCaptcha:telInput.text andCaptcha:captchaInput.text];
    
}

-(void)captchaInputDidChange:(UITextField *)textField {
    
    [self.viewModel onCaptchaChanged:textField.text];
    
}

-(void)telInputDidChange:(UITextField *)textField {
    if(isEmptyString(textField.text)) {
        textField.font = [UIFont isw_Pingfang:15];
    } else {
        textField.font = [UIFont isw_Pingfang:18];
    }
    
    [self.viewModel onTelChanged:textField.text];
    
}

#pragma mark - model event
- (void)requestCaptchaSucValueUpdated
{
    [self updateSubmitBtnUI];
}

- (void)validCaptchaValueUpdated
{
    [self updateSubmitBtnUI];
}

- (void)validTelValueUpdated
{
    [self updateSubmitBtnUI];
}

#pragma pop/dismiss UI

- (void)popToast:(NtPhaseType)type title:(NSString*)title
{
    switch (type) {
        case NtPhaseNone:
            [ISWToast dismissToast];
            break;
            
        case NtPhaseResponseSuc:
            [ISWToast showSuccToast:title];
            break;
            
        case NtPhaseConnectionTimeout:
        case NtPhaseNoConnection:
        case NtPhaseResponseFail:
            [ISWToast showFailToast:title];
            break;
            
        case NtPhaseRequesting:
            [ISWToast showLoadingToast];
            break;
            
        default:
            break;
    }
}

@end
