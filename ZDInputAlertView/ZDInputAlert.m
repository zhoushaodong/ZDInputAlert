//
//  ZDInputAlert.m
//  ZDInputAlert
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 com.zhouzhaodong. All rights reserved.
//

#import "ZDInputAlert.h"
#import "UITextView+Placeholder.h"
#define TopWindow [UIApplication sharedApplication].keyWindow

@interface ZDInputAlert ()
{
    //是否重新发送短信
    BOOL _isResend;
}

/** 确认按钮回调 */
@property (nonatomic, copy) confirmCallback confirmBlock;
/** 蒙版 */
@property (nonatomic, weak) UIView *becloudView;
@property (nonatomic, assign)NSInteger           leftTimer;
@property (nonatomic, strong) NSTimer            *timer;
@end


@implementation ZDInputAlert

+ (instancetype)alertView
{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _isResend=NO;
    
    [self setBtnDisabled];
    [self setCornerRadius:self];
    [self setCornerRadius:self.inputTextView];
    [self setCornerRadius:self.confirmBtn];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyboard)];
    [self addGestureRecognizer:tapGR];
    //处于编辑状态
    [self.inputTextView becomeFirstResponder];
    
    // 设置输入框边线
    self.inputTextView.layer.borderWidth = 0;
    self.inputTextView.layer.borderColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1].CGColor;
    // 发送键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputTextViewDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)inputTextViewDidChange
{
    if (self.inputTextView.text.length == 0) {
        [self setBtnDisabled];
    } else {
        self.confirmBtn.enabled = YES;
        if (self.confirmBgColor) {
            self.confirmBtn.backgroundColor = self.confirmBgColor;
            self.confirmBtn.layer.opacity = 1.0;
        } else {
            self.confirmBtn.backgroundColor = [UIColor blueColor];
            //self.confirmBtn.layer.opacity = 0.5;
            //            self.confirmBtn.highlighted=YES;
        }
    }
}

#pragma mark - 设置无效状态
- (void)setBtnDisabled
{ //self.inputTextView.secureTextEntry=YES;
    [_checkBtn setBackgroundImage:[UIImage imageNamed:@"common_icon_set_password_normal.png"] forState:(UIControlStateSelected)];
    [_checkBtn setBackgroundImage:[UIImage imageNamed:@"common_icon_set_password_press.png"] forState:(UIControlStateNormal)];
    self.checkBtn.hidden=YES;
    self.inputTextView.placeholder = self.placeholder;
    //self.inputTextView.placeholderColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1];
    self.confirmBtn.enabled = NO;
    self.confirmBtn.backgroundColor = [UIColor grayColor];
    //self.confirmBtn.layer.opacity = 0.5;
    [self.closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:(UIControlStateNormal)];
}

#pragma mark - 设置控件圆角
- (void)setCornerRadius:(UIView *)view
{
    if (self.radius) {
        view.layer.cornerRadius = self.radius;
    } else {
        view.layer.cornerRadius = 5.0;
    }
    
    view.layer.masksToBounds = YES;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.inputTextView.placeholder = self.placeholder;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.titleL.text = self.title;
    
}

- (void)setSecureTextEntry{
    
         self.checkBtn.hidden=NO;
        [self.confirmBtn setTitle:@"登录" forState:(UIControlStateNormal)];
    
}

- (void)setKeyboardType:(NSInteger *)KeyboardType{
    if (KeyboardType) {
        self.inputTextView.keyboardType=KeyboardType;
    }
    
}


- (void)setTimerWithPhone:(NSString *)phone{
    _phone=[phone copy];
    _phoneL.text=self.phone;
    _phoneL.hidden=NO;
    _verifiCodeButton.hidden=NO;
    if (self.phone) {
        
        [self setupTimer];
        
    }
}
- (IBAction)checkPWBtn:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (sender.selected==YES) {
        self.inputTextView.secureTextEntry=YES;
    }else{
        self.inputTextView.secureTextEntry=NO;
    }
    
}


- (void)show
{
    // 蒙版
    UIView *becloudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    becloudView.backgroundColor = [UIColor whiteColor];
    becloudView.layer.opacity = 0.3;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAlertView:)];
    [becloudView addGestureRecognizer:tapGR];
    // 是否显示蒙版
    if (_hideBecloud) {
        becloudView.hidden = YES;
    } else {
        becloudView.hidden = NO;
    }
    [TopWindow addSubview:becloudView];
    self.becloudView = becloudView;
    
    self.confirmBtn.backgroundColor = [UIColor lightGrayColor];
    //    self.confirmBtn.layer.opacity = 0.5;
    
    // 输入框
    self.frame = CGRectMake(0, 0, becloudView.frame.size.width * 0.8, becloudView.frame.size.height * 0.3);
    self.center = CGPointMake(becloudView.center.x, becloudView.frame.size.height * 0.4);
    [TopWindow addSubview:self];
    
}

- (void)exitKeyboard
{
    [self endEditing:YES];
}

#pragma mark - 移除ZYInputAlertView
- (void)dismiss
{
    [self removeFromSuperview];
    [self.becloudView removeFromSuperview];
}

#pragma mark - 点击关闭按钮
- (IBAction)closeAlertView:(UIButton *)sender {
    [self dismiss];
}

#pragma mark - 接收传过来的block
- (void)confirmBtnClickBlock:(confirmCallback)block
{
    self.confirmBlock = block;
}

#pragma mark - 点击确认按钮
- (IBAction)confirmBtnClick:(UIButton *)sender {
    //[self dismiss];
    if (self.confirmBlock) {
        self.confirmBlock(self.inputTextView.text);
    }
}
//是否为手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

//是否为验证码
- (BOOL)isVerificationCode:(NSString *)verificationCode{
    if (verificationCode.length != 4) {
        
        return NO;
    }
    return YES;
}

//密码是否正确
-(BOOL)isPassword:(NSString *)password
{
    if (password.length == 0 )
    {
       
        return NO;
    }
    else if(password.length < 6 || password.length > 20  )
    {
       
        return NO;
    }
    
    return YES;
}


- (IBAction)verifyButtonDidClicked:(id)sender {
    
        [self setupTimer];
    
    
}

- (void)setupTimer
{
    _leftTimer = 90;
    [self.verifiCodeButton setTitle:[NSString stringWithFormat:@"验证码(%ld)",_leftTimer] forState:UIControlStateNormal];
    self.verifiCodeButton.enabled = NO;
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(subThreadHandler) object:nil];
    [thread start];
}

- (void)subThreadHandler
{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [runLoop run];
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (void)timerHandler:(NSTimer *)timer
{
    while (_leftTimer > 0) {
        _leftTimer--;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.verifiCodeButton setTitle:[NSString stringWithFormat:@"验证码(%ld)",_leftTimer] forState:UIControlStateNormal];
        });
        return;
    }
    
    self.verifiCodeButton.enabled = YES;
    [_timer invalidate];
    _timer = nil;
    [[NSThread currentThread] cancel];
    dispatch_async(dispatch_get_main_queue(), ^{
        _isResend=YES;
        [self.verifiCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    });
    //    if (_leftTimer==0) {
    //        [self.verifiCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    //    }
}
- (void)dealloc
{
    // 移除监听者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
