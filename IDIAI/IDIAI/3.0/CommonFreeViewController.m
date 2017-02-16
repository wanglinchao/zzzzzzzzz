//
//  CommonFreeViewController.m
//  UTopGD
//
//  Created by Ricky on 15/9/16.
//  Copyright (c) 2015年 yangfan. All rights reserved.
//

#import "CommonFreeViewController.h"
#import "HexColor.h"
#import "CustomProvinceCApicker.h"
#import "TLToast.h"
#import "VerificationCodeViewController.h"
#import "LoginView.h"
@interface CommonFreeViewController ()<CustomProvinceCApickerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UITextField *nameTxf;
@property(nonatomic,strong)UILabel *arealbl;
@property(nonatomic,strong)UITapGestureRecognizer *hidekeyboard;
@property(nonatomic,strong)UITextField *phonetxf;
@property(nonatomic,strong)UITextField *vftxf;
@property(nonatomic,strong)UILabel *vflbl;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)BOOL weatherBeSendVerification;//是否已经发送了验证码。
@property(nonatomic,assign)int secondsCountDown;

@property(nonatomic,strong)UIButton *backButton;

@end

@implementation CommonFreeViewController



-(void)viewWillAppear:(BOOL)animated{
    //    if (self.isres ==YES) {
    self.backButton = [[UIButton alloc] initWithFrame:[self BackButtonRect]];
    [self.backButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImage:[UIImage imageNamed:@"ic_fanhui"] forState:UIControlStateNormal];
    //navigation item左移一点
    _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc]initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = backBarBtn;
    //    }
}

- (CGRect)BackButtonRect
{
  
    return CGRectMake(10, 6, 50, 34);
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title_nav;
    switch (self.type) {
        case 0:
            title_nav =@"免费验房";
            break;
        case 1:
            title_nav =@"免费报价";
            break;
        case 2:
            title_nav =@"装修贷款";
            break;
        default:
            break;
    }
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor blackColor];
    lab_nav_title.text=title_nav;
    self.navigationItem.titleView = lab_nav_title;
    
    self.view.backgroundColor =[UIColor colorWithHexString:@"F0EFF5"];
    [self initView];
    
     self.secondsCountDown = 60;//60秒倒计时
    // Do any additional setup after loading the view.
}
-(void)initView{
    UIImageView *nameImage =[[UIImageView alloc] initWithFrame:CGRectMake(11, 18, kMainScreenWidth-22, 41)];
    if (self.isdelegate ==YES) {
        nameImage.frame =CGRectMake(11, 18+64, kMainScreenWidth-22, 41);
    }
    nameImage.backgroundColor =[UIColor whiteColor];
    nameImage.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
    nameImage.layer.borderWidth = 1;
    nameImage.layer.masksToBounds = YES;
    nameImage.layer.cornerRadius = 5;
    [self.view addSubview:nameImage];
    
    UILabel *namehead =[[UILabel alloc] initWithFrame:CGRectMake(22, 31, 60, 14)];
    if (self.isdelegate ==YES){
        namehead.frame =CGRectMake(22, 31+64, 60, 14);
    }
    namehead.text =@"姓    名";
    namehead.textColor =[UIColor blackColor];
    namehead.textAlignment =NSTextAlignmentLeft;
    namehead.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:namehead];
    
    self.nameTxf =[[UITextField alloc] initWithFrame:CGRectMake(namehead.frame.size.width+namehead.frame.origin.x+2, nameImage.frame.origin.y, nameImage.frame.size.width-110-namehead.frame.size.width+namehead.frame.origin.x+20, 41)];
    self.nameTxf.placeholder =@"请输入姓名";
    self.nameTxf.delegate =self;
    self.nameTxf.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:self.nameTxf];
    
    UIImageView *areaImage =[[UIImageView alloc] initWithFrame:CGRectMake(11, nameImage.frame.size.height+nameImage.frame.origin.y+10, kMainScreenWidth-22, 41)];
//    areaImage.image =[UIImage imageNamed:@"bg_dibu.png"];
    areaImage.backgroundColor =[UIColor whiteColor];
    areaImage.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
    areaImage.layer.borderWidth = 1;
    areaImage.layer.masksToBounds = YES;
    areaImage.layer.cornerRadius = 5;
    [self.view addSubview:areaImage];
    
    UILabel *areahead =[[UILabel alloc] initWithFrame:CGRectMake(22,  nameImage.frame.size.height+nameImage.frame.origin.y+10+13, 42, 14)];
    areahead.text =@"省市区";
    areahead.textColor =[UIColor blackColor];
    areahead.textAlignment =NSTextAlignmentRight;
    areahead.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:areahead];
    
    self.arealbl =[[UILabel alloc] initWithFrame:CGRectMake(areahead.frame.size.width+areahead.frame.origin.x+20, areahead.frame.origin.y, areaImage.frame.size.width-110-areahead.frame.size.width+areahead.frame.origin.x+20, 14)];
    self.arealbl.font =[UIFont systemFontOfSize:14];
    self.arealbl.textColor =kColorWithRGB(163, 163, 163);
    self.arealbl.text =@"请选择省市区";
    [self.view addSubview:self.arealbl];
    
    
    
    
    UIButton *areabtn =[UIButton buttonWithType:UIButtonTypeCustom];
    areabtn.frame =CGRectMake(areaImage.frame.origin.x, areaImage.frame.origin.y, areaImage.frame.size.width, areaImage.frame.size.height);
    [areabtn addTarget:self action:@selector(cityAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:areabtn];
    
    UIButton *completebtn =[UIButton buttonWithType:UIButtonTypeCustom];
    completebtn.frame =CGRectMake(11, areaImage.frame.size.height+areaImage.frame.origin.y+32, kMainScreenWidth-22, 40);
    [completebtn setBackgroundColor:kThemeColor];
    completebtn.layer.cornerRadius = 5;
    completebtn.layer.masksToBounds = YES;
    [completebtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    switch (self.type) {
        case 0:
            [completebtn setTitle:@"立即预约" forState:UIControlStateNormal];
            break;
        case 1:
            [completebtn setTitle:@"立即申请报价" forState:UIControlStateNormal];
            break;
        case 2:
            [completebtn setTitle:@"立即申请" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [self.view addSubview:completebtn];

    
    if (self.type==0) {
        //免费验房
        //未登录状态下
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]) {
            
            UIImageView *phoneImage =[[UIImageView alloc] initWithFrame:CGRectMake(11, CGRectGetMaxY(areaImage.frame)+10, kMainScreenWidth-22, 41)];
            //    nameImage.image =[UIImage imageNamed:@"bg_dibu.png"];
            phoneImage.backgroundColor =[UIColor whiteColor];
            phoneImage.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
            phoneImage.layer.borderWidth = 1;
            phoneImage.layer.masksToBounds = YES;
            phoneImage.layer.cornerRadius = 5;
            //    if (self.type!=0) {
            //        phoneImage.hidden =YES;
            //    }
            [self.view addSubview:phoneImage];
            
            UILabel *phonehead =[[UILabel alloc] initWithFrame:CGRectMake(22,CGRectGetMinY(phoneImage.frame)+13, 42, 14)];
            phonehead.text =@"手机号";
            phonehead.textColor =[UIColor blackColor];
            phonehead.textAlignment =NSTextAlignmentRight;
            phonehead.font =[UIFont systemFontOfSize:14];
            //    if (self.type!=0) {
            //        phonehead.hidden =YES;
            //    }
            [self.view addSubview:phonehead];
            
            self.phonetxf =[[UITextField alloc] initWithFrame:CGRectMake(phonehead.frame.size.width+phonehead.frame.origin.x+20, phonehead.frame.origin.y, phoneImage.frame.size.width-110-phonehead.frame.size.width+phonehead.frame.origin.x+20, 14)];
            self.phonetxf.placeholder =@"请输入手机号";
            self.phonetxf.delegate =self;
            self.phonetxf.font =[UIFont systemFontOfSize:14];
            self.phonetxf.keyboardType =UIKeyboardTypeNumberPad;
            //    if (self.type!=0) {
            //        self.phonetxf.hidden =YES;
            //    }
            [self.view addSubview:self.phonetxf];
            
            UIImageView *vfImage =[[UIImageView alloc] initWithFrame:CGRectMake(11, phoneImage.frame.size.height+phoneImage.frame.origin.y+10, (kMainScreenWidth-22-12)/11*7, 41)];
            //    if (self.type!=0) {
            //        vfImage.frame =CGRectMake(11, 18+64, (kMainScreenWidth-22-12)/11*7, 41);
            //    }
            //    nameImage.image =[UIImage imageNamed:@"bg_dibu.png"];
            vfImage.backgroundColor =[UIColor whiteColor];
            vfImage.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
            vfImage.layer.borderWidth = 1;
            vfImage.layer.masksToBounds = YES;
            vfImage.layer.cornerRadius = 5;
            vfImage.userInteractionEnabled =YES;
            [self.view addSubview:vfImage];
            
            self.vftxf =[[UITextField alloc] initWithFrame:CGRectMake(10, 13, vfImage.frame.size.width-20, 14)];
            self.vftxf.placeholder =@"请输入验证码";
            self.vftxf.delegate =self;
            self.vftxf.font =[UIFont systemFontOfSize:14];
            //    self.vftxf.textAlignment =NSTextAlignmentCenter;
            self.vftxf.keyboardType =UIKeyboardTypeNumberPad;
            [vfImage addSubview:self.vftxf];
            
            UIImageView *getvfImage =[[UIImageView alloc] initWithFrame:CGRectMake(vfImage.frame.origin.x+vfImage.frame.size.width+10, vfImage.frame.origin.y, (kMainScreenWidth-22-12)/11*4, 41)];
            //    nameImage.image =[UIImage imageNamed:@"bg_dibu.png"];
            getvfImage.backgroundColor =[UIColor whiteColor];
            getvfImage.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
            getvfImage.layer.borderWidth = 1;
            getvfImage.layer.masksToBounds = YES;
            getvfImage.layer.cornerRadius = 5;
            getvfImage.userInteractionEnabled =YES;
            getvfImage.tag =100;
            [self.view addSubview:getvfImage];
            
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getVFCoder:)];
            [getvfImage addGestureRecognizer:tap];
            
            self.vflbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 13, getvfImage.frame.size.width-20, 14)];
            self.vflbl.text =@"获取验证码";
            self.vflbl.font =[UIFont systemFontOfSize:14];
            self.vflbl.textColor =[UIColor redColor];
            self.vflbl.textAlignment =NSTextAlignmentCenter;
            [getvfImage addSubview:self.vflbl];
            
            completebtn.frame = CGRectMake(11,CGRectGetMaxY(vfImage.frame)+32, kMainScreenWidth-22, 40);
            
            
        }
        
        
    }
   
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceCode] length]>1) self.provinceCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceCode];
    else self.provinceCode=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_CityCode] length]>1) self.cityCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_CityCode];
    else self.cityCode=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaCode] length]>1) self.areaCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaCode];
    else self.areaCode=@"";
    //获取省市区名字
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceName] length]>0) self.provinceName=[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceName];
    else self.provinceName=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_CityName] length]>0) self.cityName=[[NSUserDefaults standardUserDefaults] objectForKey:User_CityName];
    else self.cityName=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaName] length]>0) self.areaName=[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaName];
    else self.areaName=@"";
    
    if(!arr_Province) arr_Province=[NSMutableArray arrayWithObjects:@[self.provinceName,self.provinceCode],@[self.cityName,self.cityCode],@[self.areaName,self.areaCode],nil];
    self.hidekeyboard =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
    
    UILabel *onelbl =[[UILabel alloc] initWithFrame:CGRectMake(completebtn.frame.origin.x, completebtn.frame.origin.y+completebtn.frame.size.height+35, kMainScreenWidth-22, 40)];
    NSMutableAttributedString *str =[[NSMutableAttributedString alloc] init];
    CGSize labelSize = {0, 0};
    if (self.type!=2) {
        if (self.type ==1) {
            str = [[NSMutableAttributedString alloc] initWithString:@"1.资深工长免费上门验房报价，最高比装修公司省50%"];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,5)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(8,13)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(22,4)];
            onelbl.attributedText =str;
            //        NSLog(@"%@",onelbl.text);
            labelSize = [onelbl.text sizeWithFont:[UIFont systemFontOfSize:15]
                                constrainedToSize:CGSizeMake(kMainScreenWidth-22, 40)
                                    lineBreakMode:UILineBreakModeWordWrap];
            onelbl.frame = CGRectMake(onelbl.frame.origin.x, onelbl.frame.origin.y, onelbl.frame.size.width, labelSize.height);
        }else{
            str = [[NSMutableAttributedString alloc] initWithString:@"1.在线预约免费上门验房"];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,6)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(8,str.length-8)];
            onelbl.attributedText =str;
            //        NSLog(@"%@",onelbl.text);
            labelSize = [onelbl.text sizeWithFont:[UIFont systemFontOfSize:15]
                                constrainedToSize:CGSizeMake(kMainScreenWidth-22, 40)
                                    lineBreakMode:UILineBreakModeWordWrap];
            onelbl.frame = CGRectMake(onelbl.frame.origin.x, onelbl.frame.origin.y, onelbl.frame.size.width, labelSize.height);
        }
        
        
    }else{
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"1.放款快,最快7天拿到钱"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,7)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8,2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(10,3)];
        onelbl.attributedText =str;
        onelbl.frame =CGRectMake(onelbl.frame.origin.x, onelbl.frame.origin.y, onelbl.frame.size.width,15);
        //        onelbl.textAlignment =NSTextAlignmentCenter;
    }
    
    onelbl.font =[UIFont systemFontOfSize:15.0];
    onelbl.numberOfLines = 2;
    [self.view addSubview:onelbl];
    
    UILabel *towlbl =[[UILabel alloc] initWithFrame:CGRectMake(onelbl.frame.origin.x, onelbl.frame.origin.y+onelbl.frame.size.height+7, kMainScreenWidth-22, 15)];
    towlbl.font =[UIFont systemFontOfSize:15.0];
    if (self.type!=2) {
        if (self.type ==1) {
            towlbl.text =@"2.在线查看工程进度，全程监管";
            towlbl.textColor =[UIColor blackColor];
        }else{
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"2.专业验房师一对一贴心服务"];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,7)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7,3)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(10,4)];
            //        towlbl.textAlignment =NSTextAlignmentCenter;
            towlbl.attributedText =str;
        }
    }else{
        towlbl.frame =CGRectMake(towlbl.frame.origin.x, towlbl.frame.origin.y, towlbl.frame.size.width, towlbl.frame.size.height);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"2.额度高,最高可贷500万"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,10)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10,4)];
        //        towlbl.textAlignment =NSTextAlignmentCenter;
        towlbl.attributedText =str;
    }
    [self.view addSubview:towlbl];
    
    UILabel *threelbl =[[UILabel alloc] initWithFrame:CGRectMake(towlbl.frame.origin.x, towlbl.frame.origin.y+towlbl.frame.size.height+7, kMainScreenWidth-22, 15)];
    if (self.type!=2){
        if (self.type ==1) {
            str = [[NSMutableAttributedString alloc] initWithString:@"3.分阶段支付装修款，直到装修满意再付款"];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,12)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(13,7)];
        }else{
            str =[[NSMutableAttributedString alloc] initWithString:@""];
        }
    }else{

        str = [[NSMutableAttributedString alloc] initWithString:@"3.门槛低,只要有房就可贷"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,8)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8,2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(10,3)];
    }
    threelbl.font =[UIFont systemFontOfSize:15.0];
    threelbl.attributedText =str;
    [self.view addSubview:threelbl];
    if (self.type==2) {
        UILabel *fourlbl =[[UILabel alloc] initWithFrame:CGRectMake(threelbl.frame.origin.x, threelbl.frame.origin.y+threelbl.frame.size.height+7, kMainScreenWidth-22, 15)];
        str = [[NSMutableAttributedString alloc] initWithString:@"4.年限长,最长可贷5年"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,10)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10,2)];
        fourlbl.font =[UIFont systemFontOfSize:15.0];
        fourlbl.attributedText =str;
        [self.view addSubview:fourlbl];
        //        fourlbl.textAlignment =NSTextAlignmentCenter;
    }
}
//-(void)initintroduce{
//    
//}


-(void)getVFCoder:(UIGestureRecognizer *)sender{
    UIImageView *getvfImage =(UIImageView *)sender.view;
    getvfImage.userInteractionEnabled =NO;
    if([util checkTel:self.phonetxf.text]==NO){
        getvfImage.userInteractionEnabled =YES;
        return;
    }
    if(![util isConnectionAvailable]){
        [TLToast showWithText:@"无网络连接" topOffset:200.0f duration:1.0];
        return;
    }
    [self createProgressView];
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSString *string_token;
        NSString *string_userid;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0264" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *bodyDic = @{@"mobile":self.phonetxf.text};
        NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:bodyDic
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:nil];
        NSString *str1 =[[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:str forKey:@"header"];
        [post setObject:str1 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        self.weatherBeSendVerification = YES;
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setTimeOutSeconds:15];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (kResCode == 102641) {
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"获取验证码成功" topOffset:220.0f duration:1.0];
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
                        getvfImage.userInteractionEnabled =YES;
                    } else {
                        [self stopRequest];
                        [phud hide:YES];
                        getvfImage.userInteractionEnabled =YES;
                        [TLToast showWithText:@"提交申请失败"];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [phud hide:YES];
                                  [TLToast showWithText:@"获取验证码失败" topOffset:220.0f duration:1.0];
                                  getvfImage.userInteractionEnabled =YES;
                              });
                          }
                               method:url postDict:post];
    });
    
}

-(void)createProgressView{
        if (!phud) {
            phud = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:phud];
            phud.mode=MBProgressHUDModeIndeterminate;
            //self.pHUD.dimBackground=YES; //是否开启背景变暗
            // phud.labelText = @"数据加载中...";
            //        phud.blur=NO;  //是否开启ios7毛玻璃风格
            //        phud.darkBlur=YES; //受blur限制（blur为YES时设置darkBlur才有用）
            [phud show:YES];
        }
        else{
            [phud show:YES];
        }
}



-(void)leftButtonPressed:(id)sender{
    self.backButton.enabled=NO;
    [self.nameTxf resignFirstResponder];
    [self.vftxf resignFirstResponder];
    [self.phonetxf resignFirstResponder];
    //已经发送验证码
    if (self.weatherBeSendVerification==YES) {
          [self performSelector:@selector(showAlert) withObject:nil afterDelay:0.6];
    }
    else {//没有发送验证码
     
         [self.navigationController popViewControllerAnimated:YES];
    
    }
  
}
-(void)showAlert{
    
    UIAlertView *aler =[[UIAlertView alloc] initWithTitle:@"验证码可能有延迟，确定返回？" message:@"" delegate:self cancelButtonTitle:@"等待" otherButtonTitles:@"返回", nil];
    [aler show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==alertView.cancelButtonIndex) {
        self.backButton.enabled = YES;
    }
    else{
        self.backButton.enabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)nextAction:(id)sender{
    if (self.nameTxf.text.length==0) {
        [phud hide:YES];
        [TLToast showWithText:@"请输入姓名" topOffset:220.0f duration:1.0];
        return;
    }
    if (self.nameTxf.text.length<2||self.nameTxf.text.length>4) {
        [phud hide:YES];
        [TLToast showWithText:@"姓名只能为2-4位的中文" topOffset:220.0f duration:1.0];
        return;
    }
    if (self.areaName.length==0) {
        [phud hide:YES];
        [TLToast showWithText:@"请选择省市区" topOffset:220.0f duration:1.0];
        return;
    }
    NSString *userMobile =[[NSUserDefaults standardUserDefaults] objectForKey:User_Mobile];
    //已登录
    if (userMobile.length>0) {
        if (self.type ==0) {
            [MobClick event:@"Click_yf_submit"];
        }else if (self.type ==1){
            [MobClick event:@"Click_bj_submit"];
        }else{
            [MobClick event:@"Click_dk_submit"];
        }
        [self startRequestWithString:@"加载中..."];
        dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(parsingQueue, ^{
            NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
            
            NSString *string_token;
            NSString *string_userid;
            if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
                string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
                string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
            }
            else{
                string_token=@"";
                string_userid=@"";
            }
            
            
            NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
            [postDict setObject:@"ID0260" forKey:@"cmdID"];
            [postDict setObject:string_token forKey:@"token"];
            [postDict setObject:string_userid forKey:@"userID"];
            [postDict setObject:@"ios" forKey:@"deviceType"];
            [postDict setObject:kCityCode forKey:@"cityCode"];
            
            NSString *string=[postDict JSONString];
            NSDictionary *bodyDic = @{@"userName":self.nameTxf.text,@"userMobile":userMobile,@"provinceCode":self.provinceCode,@"cityCode":self.cityCode,@"areaCode":self.areaCode,@"serviceType":[NSString stringWithFormat:@"%d",self.type]};
            NSString *string02=[bodyDic JSONString];
            NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
            [post setObject:string forKey:@"header"];
            [post setObject:string02 forKey:@"body"];
            
            NetworkRequest *req = [[NetworkRequest alloc] init];
            [req setHttpMethod:PostMethod];
            
            [req sendToServerInBackground:^{
                dispatch_async(parsingQueue, ^{
                    ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                    [request setTimeOutSeconds:15];
                    [request setResponseEncoding:NSUTF8StringEncoding];
                    NSString *respString = [request responseString];
                    NSDictionary *jsonDict = [respString objectFromJSONString];
                    // NSLog(@"login返回信息：%@",jsonDict);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (kResCode == 10002 || kResCode == 10003) {
                            [self stopRequest];
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                            return;
                        }
                        
                        if (kResCode == 102601) {
                            [self stopRequest];
                            [TLToast showWithText:@"提交申请成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            [self stopRequest];
                            [TLToast showWithText:@"提交申请失败"];
                        }
                    });
                });
            }
                              failedBlock:^{
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self stopRequest];
                                      [TLToast showWithText:@"操作失败"];
                                  });
                              }
                                   method:url postDict:post];
        });
//        [HomePageParser postApply:@"ID0260" userName:self.nameTxf.text userMobile:userMobile provinceCode:self.provinceCode cityCode:self.cityCode areaCode:self.areaCode serviceType:[NSString stringWithFormat:@"%d",self.type] theBlock:^(id user, NSError *error) {
//            if (!error) {
//                [phud hide:YES];
//                [TLToast showWithText:@"提交申请成功" topOffset:220.0f duration:1.0];
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
//                [phud hide:YES];
//                [TLToast showWithText:@"提交申请失败" topOffset:220.0f duration:1.0];
//            }
//        }];
    }else{
        
        //未登录
        
        if (self.type ==0) {
            [MobClick event:@"Click_yf_submit_phone"];
        }else if (self.type ==1){
            [MobClick event:@"Click_bj_submit_phone"];
        }else{
            [MobClick event:@"Click_dk_submit_phone"];
        }
//        VerificationCodeViewController *verfication =[[VerificationCodeViewController alloc] init];
//        verfication.userName =self.nameTxf.text;
//        verfication.provinceCode =self.provinceCode;
//        verfication.areaCode =self.areaCode;
//        verfication.cityCode =self.cityCode;
//        verfication.type =self.type;
//        verfication.serviceType =[NSString stringWithFormat:@"%d",self.type];
//        verfication.title =@"手机验证";
//        [self.navigationController pushViewController:verfication animated:YES];
        
        if([util checkTel:self.phonetxf.text]==NO){
            
            return;
        }
        if (self.vftxf.text.length ==0) {
            [phud hide:YES];
            [TLToast showWithText:@"请输入验证码" topOffset:220.0f duration:1.0];
            return;
        }
        
        [self startRequestWithString:@"加载中..."];
        dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(parsingQueue, ^{
            //        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
            
            NSString *string_token;
            NSString *string_userid;
            if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
                string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
                string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
            }
            else{
                string_token=@"";
                string_userid=@"";
            }
            
            
            //        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
            //        [postDict setObject:@"ID0009" forKey:@"cmdID"];
            //        [postDict setObject:string_token forKey:@"token"];
            //        [postDict setObject:string_userid forKey:@"userID"];
            //        [postDict setObject:@"ios" forKey:@"deviceType"];
            //        [postDict setObject:kCityCode forKey:@"cityCode"];
            //
            //        NSString *string=[postDict JSONString];
            //        NSDictionary *bodyDic = @{@"userMobile":self.phonetxf.text,@"smsCode":self.vftxf.text};
            //        NSString *string02=[bodyDic JSONString];
            //        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
            //        [post setObject:string forKey:@"header"];
            //        [post setObject:string02 forKey:@"body"];
            NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0009\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"smsCode\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.phonetxf.text,self.vftxf.text];
            
            NetworkRequest *req = [[NetworkRequest alloc] init];
            [req setHttpMethod:GetMethod];
            
            //        NetworkRequest *req = [[NetworkRequest alloc] init];
            //        [req setHttpMethod:GetMethod];
            
            [req sendToServerInBackground:^{
                dispatch_async(parsingQueue, ^{
                    ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                    [request setTimeOutSeconds:15];
                    [request setResponseEncoding:NSUTF8StringEncoding];
                    NSString *respString = [request responseString];
                    NSDictionary *jsonDict = [respString objectFromJSONString];
                    // NSLog(@"login返回信息：%@",jsonDict);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (kResCode == 10101) {
                            [self stopRequest];
                            [self startRequestWithString:@"加载中..."];
                            dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            dispatch_async(parsingQueue, ^{
                                NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
                                
                                NSString *string_token;
                                NSString *string_userid;
                                if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
                                    string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
                                    string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
                                }
                                else{
                                    string_token=@"";
                                    string_userid=@"";
                                }
                                
                                
                                NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
                                [postDict setObject:@"ID0260" forKey:@"cmdID"];
                                [postDict setObject:string_token forKey:@"token"];
                                [postDict setObject:string_userid forKey:@"userID"];
                                [postDict setObject:@"ios" forKey:@"deviceType"];
                                [postDict setObject:kCityCode forKey:@"cityCode"];
                                
                                NSString *string=[postDict JSONString];
                                NSDictionary *bodyDic = @{@"userName":self.nameTxf.text,@"userMobile":self.phonetxf.text,@"provinceCode":self.provinceCode,@"cityCode":self.cityCode,@"areaCode":self.areaCode,@"serviceType":[NSString stringWithFormat:@"%d",self.type]};
                                NSString *string02=[bodyDic JSONString];
                                NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
                                [post setObject:string forKey:@"header"];
                                [post setObject:string02 forKey:@"body"];
                                
                                NetworkRequest *req = [[NetworkRequest alloc] init];
                                [req setHttpMethod:PostMethod];
                                
                                [req sendToServerInBackground:^{
                                    dispatch_async(parsingQueue, ^{
                                        ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                                        [request setTimeOutSeconds:15];
                                        [request setResponseEncoding:NSUTF8StringEncoding];
                                        NSString *respString = [request responseString];
                                        NSDictionary *jsonDict = [respString objectFromJSONString];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (kResCode == 102601) {
                                                [self stopRequest];
                                                self.vflbl.text =@"重新发送";
                                                UIImageView *getimage =(UIImageView*)[self.view viewWithTag:100];
                                                getimage.userInteractionEnabled =YES;
                                                self.secondsCountDown = 60;
                                                [self.timer invalidate];
                                                [phud hide:YES];
                                                [TLToast showWithText:@"申请成功" topOffset:220.0f duration:1.0];
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                                
                                            } else {
                                                [self stopRequest];
                                                [phud hide:YES];
                                                [TLToast showWithText:@"申请失败" topOffset:220.0f duration:1.0];
                                                
                                            }
                                        });
                                    });
                                }
                                                  failedBlock:^{
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self stopRequest];
                                                          [phud hide:YES];
                                                          [TLToast showWithText:@"申请失败" topOffset:220.0f duration:1.0];
                                                          
                                                      });
                                                  }
                                                       method:url postDict:post];
                            });
                        } else {
                            [self stopRequest];
                            [phud hide:YES];
                            [TLToast showWithText:@"请输入正确的手机验证码" topOffset:220.0f duration:1.0];
                            
                        }
                    });
                });
            }
                              failedBlock:^{
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self stopRequest];
                                      [TLToast showWithText:@"操作失败"];
                                  });
                              }
                                   method:url postDict:nil];
        });
        
        
        
        
        
        
    }
}



-(void)timeFireMethod{
    self.secondsCountDown--;
    self.vflbl.text =[NSString stringWithFormat:@"%ds",self.secondsCountDown];
    UIImageView *getimage =(UIImageView*)[self.view viewWithTag:100];
    getimage.userInteractionEnabled =NO;
    if(self.secondsCountDown==0){
        self.vflbl.text =@"重新发送";
        UIImageView *getimage =(UIImageView*)[self.view viewWithTag:100];
        getimage.userInteractionEnabled =YES;
        self.secondsCountDown = 60;
        [self.timer invalidate];
    }
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cityAction:(id)sender{
    [self.view endEditing:YES];
    CustomProvinceCApicker *picker_pro = [[CustomProvinceCApicker alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"选择省市区"];
    picker_pro.delegate=self;
    [picker_pro setSelectedTitles:arr_Province animated:YES];
    [picker_pro show];
}

#pragma mark -
#pragma mark -PickerViewDelegate

-(void)actionSheetProvinceCAPickerView:(CustomProvinceCApicker *)pickerView didSelectTitles:(NSArray *)titles{
    
    NSMutableString *province_name=[NSMutableString string];
    if([arr_Province count]) [arr_Province removeAllObjects];
    for(int i=0;i<[titles count];i++){
        NSArray *arr=[titles objectAtIndex:i];
        [arr_Province addObject:arr];
        
        if(i==1 && [@"上海市北京市天津市重庆市" rangeOfString:[arr objectAtIndex:0]].length>0)[province_name appendFormat:@"%@",@""]; //获取省市区名字
        else [province_name appendFormat:@"%@",[arr objectAtIndex:0]]; //获取省市区名字
        
        //获取省市区code码
        if(i==0) {
            self.provinceCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
            self.provinceName=[arr objectAtIndex:0];
        }
        else if(i==1) {
            self.cityCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
            self.cityName=[arr objectAtIndex:0];
        }
        else if(i==2) {
            self.areaCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
            self.areaName=[arr objectAtIndex:0];
        }
    }

  
    //台湾、澳门、香港没有市区
    if([titles count]==1){
        self.cityCode=@"";
        self.areaCode=@"";
        self.cityName=@"";
        self.areaName=@"";
    }
    
    self.arealbl.text=province_name;
    self.arealbl.textColor=[UIColor darkTextColor];
//    [self SendpersonalDistrictInfo];
}

-(void)hideAction:(id)sender{
    [self.nameTxf resignFirstResponder];
    [self.phonetxf resignFirstResponder];
    [self.vftxf resignFirstResponder];

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
    [self.nameTxf resignFirstResponder];
    [self.phonetxf resignFirstResponder];
    [self.vftxf resignFirstResponder];

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
