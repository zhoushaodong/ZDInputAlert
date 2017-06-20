//
//  ViewController.m
//  ZDInputAlert
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 com.zhouzhaodong. All rights reserved.
//

#import "ViewController.h"
#import "ZDInputAlert.h"
@interface ViewController ()
@property(nonatomic, copy)NSString* phoneNum;
@property(nonatomic, copy)NSString* password;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    self.view.backgroundColor=[UIColor purpleColor];
    
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [btn setTitle:@"点击我扫一扫" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"bluegogo"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(haha:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}
-(void)haha:(id)sender{
    [self showInputPhoneAler];
}
- (void)showInputPhoneAler{
    __weak typeof(self) weakSelf = self;
    
    ZDInputAlert *alertView = [ZDInputAlert alertView];
    alertView.title=@"输入手机号码";
    alertView.placeholder = @"请输入手机号码";
    [alertView setKeyboardType:(long *)UIKeyboardTypeNumberPad];
    [alertView confirmBtnClickBlock:^(NSString *inputString) {
        NSLog(@"phone->%@",inputString);
        if ([alertView isMobileNumber:inputString]) {
            [alertView dismiss];
            weakSelf.phoneNum=inputString;
            [weakSelf showInputVerifiCode];
        }else{
            //非手机号
        }
    }];
    [alertView show];
    // 添加到最外层视图
    [self.view bringSubviewToFront:alertView] ;
    
}
- (void)showInputVerifiCode{
    __weak typeof(self) weakSelf = self;
    ZDInputAlert *alertView = [ZDInputAlert alertView];
    alertView.title=@"输入验证码";
    alertView.placeholder = @"请输入验证码";
    [alertView setTimerWithPhone:self.phoneNum];
    [alertView setKeyboardType:(long *)UIKeyboardTypeNumberPad];
    [alertView confirmBtnClickBlock:^(NSString *inputString) {
        
        if ([alertView isVerificationCode:inputString]) {
            [alertView dismiss];
            [weakSelf showNewPwdAler];
        }else{
            //非验证码
        }
    }];
    [alertView show];
}

- (void)showNewPwdAler{
    __weak typeof(self) weakSelf = self;
    ZDInputAlert *alertView = [ZDInputAlert alertView];
    alertView.title = @"设置密码";
    alertView.placeholder = @"请输入6~20位新密码";
    [alertView setSecureTextEntry];
    [alertView confirmBtnClickBlock:^(NSString *inputString) {
        if ([alertView isPassword:inputString]) {
            weakSelf.password=inputString;
            [alertView dismiss];
            [weakSelf toDoLogin];
        }
    }];
    [alertView show];
}
- (void)toDoLogin{
    NSLog(@"登录成功");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
