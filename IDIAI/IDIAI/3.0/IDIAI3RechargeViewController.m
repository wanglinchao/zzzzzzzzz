//
//  IDIAI3RechargeViewController.m
//  IDIAI
//
//  Created by Ricky on 15/11/26.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3RechargeViewController.h"
#import "PayingConfirmViewController.h"
#import "TLToast.h"
@interface IDIAI3RechargeViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *amounttxf;
@property(nonatomic,strong)UITapGestureRecognizer *hidekeyboard;
@end

@implementation IDIAI3RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.title =@"充值";
    self.view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIImageView *amountImage =[[UIImageView alloc] initWithFrame:CGRectMake(11, 48, kMainScreenWidth-22, 41)];
    //    nameImage.image =[UIImage imageNamed:@"bg_dibu.png"];
    amountImage.backgroundColor =[UIColor whiteColor];
    amountImage.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
    amountImage.layer.borderWidth = 1;
    amountImage.layer.masksToBounds = YES;
    amountImage.layer.cornerRadius = 5;
    [self.view addSubview:amountImage];
    
    UILabel *amounthead =[[UILabel alloc] initWithFrame:CGRectMake(22, 61, 60, 14)];
    amounthead.text =@"金额(元)";
    amounthead.textColor =[UIColor blackColor];
    amounthead.textAlignment =NSTextAlignmentRight;
    amounthead.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:amounthead];
    
    self.amounttxf =[[UITextField alloc] initWithFrame:CGRectMake(amounthead.frame.size.width+amounthead.frame.origin.x+20, amountImage.frame.origin.y, amountImage.frame.size.width-110-amounthead.frame.size.width+amounthead.frame.origin.x+20, 41)];
    self.amounttxf.delegate =self;
    self.amounttxf.font =[UIFont systemFontOfSize:14];
    self.amounttxf.keyboardType =UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:self.amounttxf];
    
    UILabel *onelbl =[[UILabel alloc] initWithFrame:CGRectMake(amountImage.frame.origin.x, amountImage.frame.origin.y+amountImage.frame.size.height+10, kMainScreenWidth-22, 40)];
    NSMutableAttributedString *str =[[NSMutableAttributedString alloc] init];
    CGSize labelSize = {0, 0};
    str = [[NSMutableAttributedString alloc] initWithString:@"单笔充值金额最高支持5万，充值金额也会根据您的银行卡单笔交易上限而收到限制"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,6)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(6,6)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(12,9)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(21,11)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(32,5)];
    onelbl.attributedText =str;
        //        NSLog(@"%@",onelbl.text);
    labelSize = [onelbl.text sizeWithFont:[UIFont systemFontOfSize:15]
                            constrainedToSize:CGSizeMake(kMainScreenWidth-22, 40)
                                lineBreakMode:UILineBreakModeWordWrap];
    onelbl.frame = CGRectMake(onelbl.frame.origin.x, onelbl.frame.origin.y, onelbl.frame.size.width, labelSize.height);
    onelbl.font =[UIFont systemFontOfSize:15.0];
    onelbl.numberOfLines = 2;
    [self.view addSubview:onelbl];
    
    UIButton *completebtn =[UIButton buttonWithType:UIButtonTypeCustom];
    completebtn.frame =CGRectMake(11, onelbl.frame.size.height+onelbl.frame.origin.y+32, kMainScreenWidth-22, 40);
    [completebtn setBackgroundColor:kThemeColor];
    completebtn.layer.cornerRadius = 5;
    completebtn.layer.masksToBounds = YES;
    [completebtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [completebtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:completebtn];
    
    self.hidekeyboard =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
    // Do any additional setup after loading the view.
}
-(void)nextAction:(id)sender{
    if ([self isIntOrFloat] ==NO) {
        return ;
    }
    PayingConfirmViewController *payingConfirmVC = [[PayingConfirmViewController alloc]init];
    payingConfirmVC.serviceNameStr=@"钱包充值";
//    NSLog(@"%f",[self.amounttxf.text floatValue]);
//    NSLog(@"%@",self.amounttxf.text);
    payingConfirmVC.typeStr =@"商城";
    payingConfirmVC.moneyFloat = [self.amounttxf.text floatValue];
    payingConfirmVC.isRecharge =YES;
    [self.navigationController pushViewController:payingConfirmVC animated:YES];
}
- (void)PressBarItemLeft {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//- (BOOL)checkNum:(NSString *)str
//{
//    NSString *regex = @"^\d+(\.\d{2})?$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isMatch = [pred evaluateWithObject:str];
//    if (!isMatch) {
////        [self showHint:@"价格只能输入数字"];
//        return NO;
//    }
//    return YES;
//}

-(BOOL)isIntOrFloat{
    if( ![self isPureInt:self.amounttxf.text] && ![self isPureFloat:self.amounttxf.text])
    {
        [TLToast showWithText:@"请输入正确金额"];
        return NO;
    }else{
        if ([self.amounttxf.text floatValue]<1||[self.amounttxf.text floatValue]>50000) {
            [TLToast showWithText:@"请充值1到5万的金额"];
            return NO;
        }
    }
    return YES;
}
-(void)hideAction:(id)sender{
    [self.amounttxf resignFirstResponder];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.view addGestureRecognizer:self.hidekeyboard];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view removeGestureRecognizer:self.hidekeyboard];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.amounttxf resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
