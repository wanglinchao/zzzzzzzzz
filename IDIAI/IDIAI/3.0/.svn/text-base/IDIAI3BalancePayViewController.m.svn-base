//
//  IDIAI3BalancePayViewController.m
//  IDIAI
//
//  Created by Ricky on 15/11/27.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3BalancePayViewController.h"
#import "InputLoginPsdViewController.h"
#import "TLToast.h"
#import "LoginView.h"
#import "util.h"
#import "CustomPromptView.h"
@interface IDIAI3BalancePayViewController ()<UITextFieldDelegate>{
    CustomPromptView *customPromp;
}
@property(nonatomic,strong)UILabel *alltitle;
@property(nonatomic,strong)UITextField *passWord;
@end

@implementation IDIAI3BalancePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    UIView *headback =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 58)];
    headback.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:headback];
    
    UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(16, 21, 64, 16)];
    titlelbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
    titlelbl.font =[UIFont systemFontOfSize:16];
    [headback addSubview:titlelbl];
    
    NSString *titlestr =[NSString string];
    if (self.iswallet ==YES) {
        titlestr =@"钱包余额";
    }else{
        titlestr =@"贷款余额";
    }
    titlelbl.text =titlestr;
    self.alltitle =[[UILabel alloc] initWithFrame:CGRectMake(titlelbl.frame.origin.x+titlelbl.frame.size.width+5, 24, kMainScreenWidth-111, 15)];
    self.alltitle.font =[UIFont boldSystemFontOfSize:15];
    self.alltitle.textColor =[UIColor colorWithHexString:@"#ef6562"];
    NSString *allstr =[NSString string];
    if (self.iswallet ==YES) {
        allstr=[NSString stringWithFormat:@"¥ %@",self.walletAssets];
    }else{
        allstr=[NSString stringWithFormat:@"¥ %@",self.decorationLoanAssets];
    }
    self.alltitle.text =allstr;
    [headback addSubview:self.alltitle];
    
    
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, headback.frame.origin.y+headback.frame.size.height+10, kMainScreenWidth, 93)];
    footView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:footView];
    
    UILabel *payMoneytitle =[[UILabel alloc] initWithFrame:CGRectMake(16, 20, 70, 16)];
    payMoneytitle.text =@"支付金额";
    payMoneytitle.textColor =[UIColor colorWithHexString:@"#575757"];
    [footView addSubview:payMoneytitle];
    
    UILabel *payMoney =[[UILabel alloc] initWithFrame:CGRectMake(titlelbl.frame.origin.x+titlelbl.frame.size.width+10, payMoneytitle.frame.origin.y, kMainScreenWidth-111, 16)];
    payMoney.textColor =[UIColor colorWithHexString:@"#575757"];
    payMoney.text =[NSString stringWithFormat:@"¥ %.2f",self.moneyFloat];
    [footView addSubview:payMoney];
    
    UILabel *paypstitle =[[UILabel alloc] initWithFrame:CGRectMake(16, payMoneytitle.frame.origin.y+payMoneytitle.frame.size.height+24, 70, 16)];
    paypstitle.text =@"支付密码";
    paypstitle.textColor =[UIColor colorWithHexString:@"#575757"];
    [footView addSubview:paypstitle];
    
    self.passWord =[[UITextField alloc] initWithFrame:CGRectMake(payMoney.frame.origin.x, paypstitle.frame.origin.y-12, kMainScreenWidth-111, 40)];
    self.passWord.delegate=self;
    self.passWord.layer.cornerRadius=8;
    self.passWord.clipsToBounds=YES;
    self.passWord.layer.borderWidth =1;
    self.passWord.layer.borderColor =[UIColor colorWithHexString:@"efeff4"].CGColor;
    self.passWord.placeholder =@"请输入屋托邦平台支付密码";
    self.passWord.font =[UIFont systemFontOfSize:16];
    self.passWord.secureTextEntry = YES;
    self.passWord.textColor =[UIColor colorWithHexString:@"#575757"];
    self.passWord.returnKeyType=UIReturnKeyDone;
    [footView addSubview:self.passWord];
    
    UIButton *setting =[UIButton buttonWithType:UIButtonTypeCustom];
    setting.titleLabel.font =[UIFont systemFontOfSize:14];
    setting.frame =CGRectMake(kMainScreenWidth-15-154, footView.frame.size.height+footView.frame.origin.y+10, 154, 14);
    [setting setTitle:@"设置屋托邦平台支付密码" forState:UIControlStateNormal];
    [setting setTitle:@"设置屋托邦平台支付密码" forState:UIControlStateHighlighted];
    [setting setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
    [setting setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
    [setting addTarget:self action:@selector(payPassWordChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setting];
    
    UIButton *completebtn =[UIButton buttonWithType:UIButtonTypeCustom];
    completebtn.frame =CGRectMake(11, footView.frame.size.height+footView.frame.origin.y+84, kMainScreenWidth-22, 40);
    [completebtn setBackgroundColor:kThemeColor];
    completebtn.layer.cornerRadius = 5;
    completebtn.layer.masksToBounds = YES;
    [completebtn addTarget:self action:@selector(balancePayment:) forControlEvents:UIControlEventTouchUpInside];
    [completebtn setTitle:@"提交支付" forState:UIControlStateNormal];
    [self.view addSubview:completebtn];
    // Do any additional setup after loading the view.
}
- (void)PressBarItemLeft {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)payPassWordChange:(id)sender{
    InputLoginPsdViewController *inputLoginPsdVC = [[InputLoginPsdViewController alloc]init];
    inputLoginPsdVC.fromStr =self.fromStr;
    [self.navigationController pushViewController:inputLoginPsdVC animated:YES];
}

#pragma mark - 余额支付
-(void)balancePayment:(UIButton *)sender{
    if (self.passWord.text.length==0) {
        [TLToast showWithText:@"请输入平台支付密码"];
        return;
    }
    //    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_async(parsingQueue, ^{
    //        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
    //
    //        NSString *string_token;
    //        NSString *string_userid;
    //        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
    //            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
    //            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
    //        }
    //        else{
    //            string_token=@"";
    //            string_userid=@"";
    //        }
    //
    //
    //        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    //        [postDict setObject:@"ID0335" forKey:@"cmdID"];
    //        [postDict setObject:string_token forKey:@"token"];
    //        [postDict setObject:string_userid forKey:@"userID"];
    //        [postDict setObject:@"ios" forKey:@"deviceType"];
    //        [postDict setObject:kCityCode forKey:@"cityCode"];
    //
    //        NSString *string=[postDict JSONString];
    //        NSDictionary *bodyDic = @{@"payPassword":[util md5:self.passWord.text]};
    //        NSString *string02=[bodyDic JSONString];
    //        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
    //        [post setObject:string forKey:@"header"];
    //        [post setObject:string02 forKey:@"body"];
    //
    //        NetworkRequest *req = [[NetworkRequest alloc] init];
    //        [req setHttpMethod:PostMethod];
    //
    //        [req sendToServerInBackground:^{
    //            dispatch_async(parsingQueue, ^{
    //                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
    //                [request setTimeOutSeconds:15];
    //                [request setResponseEncoding:NSUTF8StringEncoding];
    //                NSString *respString = [request responseString];
    //                NSDictionary *jsonDict = [respString objectFromJSONString];
    //                // NSLog(@"login返回信息：%@",jsonDict);
    //                dispatch_async(dispatch_get_main_queue(), ^{
    //                    [self stopRequest];
    //                    //token为空或验证未通过处理 huangrun
    //                    if (kResCode == 10002 || kResCode == 10003) {
    //                        self.view.tag = 1002;
    //                        dispatch_async(dispatch_get_main_queue(), ^{
    //                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    //                            login.delegate=self;
    //                            [login show];
    //                        });
    //
    //                        return;
    //                    }
    //
    //                    if (kResCode == 103351) {
    //                        [TLToast showWithText:@"验证成功"];
    //
    //
    //                    } else if (kResCode == 103359) {
    //                        [TLToast showWithText:@"验证异常失败"];
    //                    } else if (kResCode == 103354) {
    //                        [TLToast showWithText:@"支付密码未设置"];
    //                    }else if (kResCode == 103353) {
    //                        [TLToast showWithText:@"密码失败次数超过5次，请24小时候再试"];
    //                    }else if (kResCode == 103355) {
    //                        [TLToast showWithText:@"密码校验不通过"];
    //                    }
    //
    //                });
    //            });
    //        }
    //                          failedBlock:^{
    //                              dispatch_async(dispatch_get_main_queue(), ^{
    //                                  [self stopRequest];
    //                              });
    //                          }
    //                               method:url postDict:post];
    //    });
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
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
        NSString *bankType =[NSString string];
        if (self.iswallet) {
            bankType =@"yue";
        }else{
            bankType =@"zxd";
        }
        float money =0;
        if ([self.orderType isEqualToString:@"1"]) {
            money =self.moneyFloat;
        }else{
            money =self.moneyFloat;
        }
        //        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0277\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"orderNo\":\"%@\",\"money\":\"%f\",\"bankType\":\"%@\",\"payPassword\":\"%@\",\"orderType\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.orderNo,money,bankType,[util md5:self.passWord.text],self.orderType];
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0310\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"orderCodes\":\"%@\",\"amounts\":\"%@\",\"payWays\":\"%@\",\"payMoneys\":\"%.2f\",\"payPassword\":\"%@\",\"orderType\":\%@}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.orderNo,self.amounts,bankType,self.moneyFloat,[util md5:self.passWord.text],self.orderType];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"评论列表返回信息：%@",jsonDict);
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    });
                }
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==103101) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"支付成功"];
                        if ([self.fromStr isEqualToString:@"contract"]){
                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                        }else{
                           [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                    });
                }
                else if (code==103108) {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [TLToast showWithText:@"不允许重复支付"];
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"不允许重复支付";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                    });
                }
                else if (code ==103102){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"余额不足";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"余额不足"];
                    });
                }else if (code ==103105){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
//                        [TLToast showWithText:@"订单不合法"];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"订单不合法";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                    });
                }else if (code ==103106){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
//                        [TLToast showWithText:@"支付失败"];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                    });
                }else if (code ==103109) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付异常请联系客户：4008887372！";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"支付异常请联系客户：4008887372！"];
                    });
                }else if (code ==103353){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"你的支付密码已错误5次，支付功能已停用，请明日再试！";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"你的支付密码已错误5次，支付功能已停用，请明日再试！"];
                    });
                }else if (code ==103104){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付密码尚未设置，请设置！";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"支付密码尚未设置，请设置！"];
                    });
                }else if (code ==103107){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付密码错误，请重新输入";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"支付密码错误，请重新输入"];
                    });
                }else if (code ==103106){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付密码被冻结请联系客户：4008887372！";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"支付密码被冻结请联系客户：4008887372！"];
                    });
                }else if (code ==1031010){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"订单状态不对，请更新订单";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"支付密码被冻结请联系客户：4008887372！"];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                  customPromp.contenttxt =@"支付错误";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
                              });
                          }
                               method:url postDict:nil];
    });
}
-(void)hideAction:(id)sender{
    [customPromp dismiss];
}
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.passWord resignFirstResponder];
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
