//
//  ZDInputAlert.h
//  ZDInputAlert
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 com.zhouzhaodong. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 确认按钮回调的block */
typedef void(^confirmCallback)(NSString *inputString);


@interface ZDInputAlert : UIView
/** 确认按钮 */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
/** 输入框 */
@property (weak, nonatomic) IBOutlet UITextField *inputTextView;
//@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
// 键盘



@property (nonatomic, copy) NSString *phone;
//phone
@property (weak, nonatomic) IBOutlet UILabel *phoneL;

/** 关闭按钮 */
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (weak, nonatomic) IBOutlet UIButton *verifiCodeButton;

/** 是否显示蒙版，默认显示 */
@property (nonatomic, assign) BOOL hideBecloud;
/** 圆角半径，默认5.0 */
@property (nonatomic, assign) CGFloat radius;
/** 确认按钮颜色 */
@property (nonatomic, strong) UIColor *confirmBgColor;
/** placeholder */
@property (nonatomic, strong) NSString *placeholder;
/** title */
@property (nonatomic, strong) NSString *title;




/** 类方法创建ZYInputAlertView */
+ (instancetype)alertView;
/** 弹出输入框 */
- (void)show;
/** 移除输入框 */
- (void)dismiss;
/** 点击确认按钮回调 */
- (void)confirmBtnClickBlock:(confirmCallback) block;
//是否为手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum;
//验证码是否合法
- (BOOL)isVerificationCode:(NSString *)verificationCode;

//密码是否合法
-(BOOL)isPassword:(NSString *)password;

//开启定时器
- (void)setTimerWithPhone:(NSString *)phone;
//设置键盘
- (void)setKeyboardType:(NSInteger *)KeyboardType;
//明文密文输入
- (void)setSecureTextEntry;
@end
