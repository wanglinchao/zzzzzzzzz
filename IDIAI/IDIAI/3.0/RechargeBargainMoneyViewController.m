//
//  RechargeBargainMoneyViewController.m
//  IDIAI
//
//  Created by PM on 16/7/27.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "RechargeBargainMoneyViewController.h"
#import "OnlinePayViewController.h"
@interface RechargeBargainMoneyViewController ()
@property (nonatomic,strong)UITextField * TF;
@end

@implementation RechargeBargainMoneyViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createUI{
    self.title = @"定金充值";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.TF = [[UITextField alloc]initWithFrame:CGRectMake(15, 94, kMainScreenWidth-30,50)];
    [self.view addSubview:_TF];
     _TF.borderStyle = UITextBorderStyleRoundedRect;

    UILabel * moneLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.TF.frame)/4 ,CGRectGetHeight(self.TF.frame))];
    moneLabel.adjustsFontSizeToFitWidth = YES;
    moneLabel.minimumFontSize =16;
    moneLabel.textColor = [UIColor blackColor];
    moneLabel.text = [NSString stringWithFormat:@"   金额  (元)"];
    _TF.leftViewMode = UITextFieldViewModeAlways;
    _TF.leftView = moneLabel;
    _TF.placeholder = @"请输入金额";
    _TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    UILabel * promptlabel =[[UILabel alloc]init];
    [self.view addSubview:promptlabel];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:@"单笔充值金额最高支持5万,充值金额也会根据您的银行卡单笔交易上限而受限制"];
    NSLog(@"%lu",(unsigned long)str.length);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,6)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(6,6)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(12,9)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(21,11)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(32,4)];
    
    promptlabel.attributedText = str;
    
    CGSize labelsize =[util calHeightForLabel:promptlabel.text width:CGRectGetWidth(self.TF.frame) font:[UIFont boldSystemFontOfSize:14]];
    promptlabel.numberOfLines = 2;
    promptlabel.font = [UIFont systemFontOfSize:14];
    promptlabel.frame =CGRectMake(15,CGRectGetMaxY(self.TF.frame)+15, labelsize.width, labelsize.height);
//    promptlabel.adjustsFontSizeToFitWidth = YES;
//    promptlabel.minimumFontSize = 14;
    
    UIButton *nextStepBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextStepBtn.frame = CGRectMake(10, CGRectGetMaxY(promptlabel.frame)+70, kMainScreenWidth - 20, 50);
    [nextStepBtn addTarget: self action:@selector(clickNextStepBtn:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextStepBtn.backgroundColor = kThemeColor;
    nextStepBtn.layer.masksToBounds = YES;
    nextStepBtn.layer.cornerRadius = 3;
    [self.view addSubview:nextStepBtn];
    
}

- (void)clickNextStepBtn:(UIButton*)sender{
       
    
}

@end
