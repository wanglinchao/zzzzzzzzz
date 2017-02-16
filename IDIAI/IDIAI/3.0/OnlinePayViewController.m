//
//  OnlinePayViewController.m
//  IDIAI
//
//  Created by Ricky on 16/2/17.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "OnlinePayViewController.h"
#import "CustomPromptView.h"
#import "LoginView.h"
#import "BankPayViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "IDIAIAppDelegate.h"
#import "util.h"
#import "TLToast.h"
#import "UPPaymentControl.h"
#import "WTBWebViewViewController.h"
@implementation Product1


@end
@interface OnlinePayViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate> {
    UITableView *_theTableView;
    CustomPromptView *customPromp;
}
@property(nonatomic,strong)UITextField *moneytxf;
@end

@implementation OnlinePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收银台";
    if (iOS_7_Above) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    
    _theTableView = [[UITableView alloc]initWithFrame:kTableViewFrame style:UITableViewStylePlain];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_theTableView];
    _theTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    _theTableView.tableFooterView = [[UIView alloc]init];
    if ([self.fromStr isEqualToString:@"orderDetailOfGoodsVC"]) {
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.nav setNavigationBarHidden:NO animated:NO];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backButtonPressed:(id)sender{
    if ([self.fromStr isEqualToString:@"orderDetailOfGoodsVC"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] animated:YES];
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
//    }else{
    } else if (section==1) {
        return 1;
    }else if (section ==2){
        return 2;
    }else if (section ==3){
        return 4;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        return 12;
    }else{
        return 12;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }else{
        return 57;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier  = [NSString stringWithFormat:@"%d---%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:101];
        if (nameLabel == nil)
            nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, 30)];
        nameLabel.tag = 101;
        nameLabel.text = [NSString stringWithFormat:@"订单名称:%@",self.serviceNameStr];
        nameLabel.textColor =[UIColor colorWithHexString:@"#575757"];
        if (self.istopup ==YES) {
            if (self.isamount==YES) {
                nameLabel.text =@"缴定金额:";
                nameLabel.textColor =[UIColor colorWithHexString:@"#ef6562"];
                nameLabel.font =[UIFont boldSystemFontOfSize:17];
                CGSize labelsize =[util calHeightForLabel:nameLabel.text width:kMainScreenWidth-20 font:[UIFont boldSystemFontOfSize:17]];
                nameLabel.frame =CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, labelsize.width, nameLabel.frame.size.height);
                UILabel *amountlbl =(UILabel *)[cell viewWithTag:110];
                if (amountlbl==nil) {
                    amountlbl =[[UILabel alloc] init];
                }
                amountlbl.text =[NSString stringWithFormat:@" ￥%.2f",self.amount];
                amountlbl.frame =CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+10, nameLabel.frame.origin.y, kMainScreenWidth-nameLabel.frame.origin.x+nameLabel.frame.size.width-20, 30);
                amountlbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
                amountlbl.font =[UIFont boldSystemFontOfSize:17.0];
                [cell.contentView addSubview:amountlbl];
            }else{
                if (self.moneytxf ==nil) {
                    nameLabel.text =@"缴定金额:";
                    nameLabel.textColor =[UIColor colorWithHexString:@"#ef6562"];
                    nameLabel.font =[UIFont boldSystemFontOfSize:17];
                    CGSize labelsize =[util calHeightForLabel:nameLabel.text width:kMainScreenWidth-20 font:[UIFont boldSystemFontOfSize:17]];
                    nameLabel.frame =CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, labelsize.width, nameLabel.frame.size.height);
                    self.moneytxf =[[UITextField alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+10, 7, kMainScreenWidth-nameLabel.frame.origin.x+nameLabel.frame.size.width-20, 40)];
                    self.moneytxf.delegate=self;
                    self.moneytxf.layer.cornerRadius=8;
                    self.moneytxf.clipsToBounds=YES;
                    self.moneytxf.layer.borderWidth =1;
                    self.moneytxf.layer.borderColor =[UIColor colorWithHexString:@"efeff4"].CGColor;
                    self.moneytxf.placeholder =@"请输入金额";
                    self.moneytxf.font =[UIFont systemFontOfSize:16];
//                    self.moneytxf.secureTextEntry = YES;
                    self.moneytxf.textColor =[UIColor colorWithHexString:@"#575757"];
                    self.moneytxf.returnKeyType=UIReturnKeyDone;
                    self.moneytxf.keyboardType =UIKeyboardTypeNumbersAndPunctuation;
                }
                [cell.contentView addSubview:self.moneytxf];
            }
        }
        UILabel *moneyLabel = (UILabel *)[cell viewWithTag:102];
        if (moneyLabel == nil)
            moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kMainScreenWidth-20, 30)];
        moneyLabel.tag = 102;
        NSString *money =[NSString stringWithFormat:@"%.2f",self.remaining];
        NSRange range = [money rangeOfString:@"."];//匹配得到的下标
        //        NSLog(@"rang:%@",NSStringFromRange(range));
        money =[money substringToIndex:range.location+3];;//截取范围类的字符串
        moneyLabel.text = [NSString stringWithFormat:@"托管金额:￥%@",money];
        moneyLabel.textColor = kThemeColor;
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:moneyLabel];
        if (self.istopup ==YES) {
            if (self.isamount ==NO) {
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"单笔交易定金额最高支持5万，缴定金额也会根据您的银行卡单笔交易上限而受限制"];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,11)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(11,2)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(13,16)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(29,4)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(33,str.length-33)];
                moneyLabel.attributedText = str;
                CGSize labelsize =[util calHeightForLabel:moneyLabel.text width:kMainScreenWidth-20 font:[UIFont boldSystemFontOfSize:12]];
                moneyLabel.font =[UIFont boldSystemFontOfSize:12];
                moneyLabel.numberOfLines =2;
                moneyLabel.frame =CGRectMake(moneyLabel.frame.origin.x, moneyLabel.frame.origin.y, labelsize.width, labelsize.height);
            }else{
                moneyLabel.text =@"";
            }
        }
        
        if ([self.typeStr isEqualToString:@"商城"]) {
            nameLabel.hidden = YES;
            moneyLabel.frame = CGRectMake(10, 30, kMainScreenWidth-20, 30);
            
            NSString *money =[NSString stringWithFormat:@"%f",self.remaining];
            NSRange range = [money rangeOfString:@"."];//匹配得到的下标
            NSLog(@"rang:%@",NSStringFromRange(range));
            money =[money substringToIndex:range.location+3];;//截取范围类的字符串
            moneyLabel.text = [NSString stringWithFormat:@"支付金额:￥%@",money];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.section ==1) {
        cell.imageView.image =[UIImage imageNamed:@"ic_yinlian.png"];
        cell.textLabel.text =@"银联支付";
    }
    if (indexPath.section ==2) {
        if (indexPath.row ==0) {
            cell.imageView.image =[UIImage imageNamed:@"ic_zhifubao_nor.png"];
            cell.textLabel.text =@"支付宝";
        }else{
            cell.imageView.image =[UIImage imageNamed:@"ic_weixinzhifu.png"];
            cell.textLabel.text =@"微信支付";
        }
        cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
        UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
        line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        [cell addSubview:line];
    }else if (indexPath.section==3){
        if (indexPath.row ==0) {
            cell.imageView.image =[UIImage imageNamed:@"ic_nenghang_nor.png"];
            cell.textLabel.text =@"中国农业银行";
            cell.textLabel.font =[UIFont boldSystemFontOfSize:15];
            UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
            line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
            [cell addSubview:line];
        }else if (indexPath.row ==1){
            cell.imageView.image =[UIImage imageNamed:@"ic_nenghang_nor.png"];
            cell.textLabel.text =@"中国农业银行(掌上银行K码支付)";
            cell.textLabel.font =[UIFont boldSystemFontOfSize:15];
            
            UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
            line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
            [cell addSubview:line];
        }else if (indexPath.row ==2){
            cell.imageView.image =[UIImage imageNamed:@"ic_gonghang_nor.png"];
            cell.textLabel.text =@"中国工商银行";
            cell.textLabel.font =[UIFont boldSystemFontOfSize:15];
            
            UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
            line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
            [cell addSubview:line];
        }else if (indexPath.row ==3){
            
            
            cell.imageView.image =[UIImage imageNamed:@"ic_gonghang_nor.png"];
            cell.textLabel.text =@"中国工商银行-U盾支付(需安装工行客户端)";
            cell.textLabel.font =[UIFont boldSystemFontOfSize:13];
        }
    }
//    if (self.istopup ==NO) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    return cell;
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.istopup==YES) {
        if (self.isamount ==NO){
            if ([self.moneytxf.text doubleValue]<=0||[self.moneytxf.text doubleValue]>50000) {
                [TLToast showWithText:@"请输入1-50000的整数金额"];
                return;
            }
            if (![self isPureInt:self.moneytxf.text]) {
                [TLToast showWithText:@"请输入1-50000的整数金额"];
                return;
            }
        }
    }
    
    if (self.istopup ==NO) {
        if (indexPath.section ==1) {
            if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"unionpay" OrderType:@"2" isPayType:NO];
            else [self ConfirmThePayment:@"unionpay" OrderType:@"1" isPayType:NO];
        }
        if (indexPath.section ==2){
            if (indexPath.row ==0) {
                if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"alipay" OrderType:@"2" isPayType:NO];
                else [self ConfirmThePayment:@"alipay" OrderType:@"1" isPayType:NO];
            }else{
                if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"wxpay" OrderType:@"2" isPayType:NO];
                else [self ConfirmThePayment:@"wxpay" OrderType:@"1" isPayType:NO];
            }
        }else if (indexPath.section ==3){
            if (indexPath.row ==0) {
                if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"abc" OrderType:@"2" isPayType:NO];
                else [self ConfirmThePayment:@"abc" OrderType:@"1" isPayType:NO];
            }else if (indexPath.row ==1){
                if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"abc" OrderType:@"2" isPayType:NO];
                else [self ConfirmThePayment:@"abc" OrderType:@"1" isPayType:YES];
            }else if (indexPath.row ==2){
                if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"icbc" OrderType:@"2" isPayType:NO];
                else [self ConfirmThePayment:@"icbc" OrderType:@"1" isPayType:NO];
            }else if (indexPath.row ==3){
                if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"icbc" OrderType:@"2" isPayType:YES];
                else [self ConfirmThePayment:@"icbc" OrderType:@"1" isPayType:YES];
            }
        }
    }else{
        if (indexPath.section ==1) {
            //预留银联
            [self RechargeThePayment:@"unionpay"isPayType:NO];
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                //调用支付宝支付
                [self RechargeThePayment:@"alipay"isPayType:NO];
            }else{
                if (indexPath.row ==1) {
                    //微信支付
                    [self RechargeThePayment:@"wxpay"isPayType:NO];
//                    NSMutableString *stamp  = [[NSMutableString alloc] initWithString:@"1455517732"];
//                    PayReq* req  = [[PayReq alloc] init];
//                    //    req.openID =kWeiXinAppID;
//                    req.partnerId  = @"1312175601";
//                    req.prepayId   = @"wx20160215142912ee1b52d3e10902312552";
//                    req.nonceStr   = @"27kgmOgJMWHOBdN2";
//                    req.timeStamp  = stamp.intValue;
//                    req.package    = @"Sign=WXPay";
//                    req.sign       = @"F10D2132C4C02989FCFAB1338B347B54";
//                    [WXApi safeSendReq:req];
                }
            }
        }else if (indexPath.section ==3){
            if (indexPath.row ==0) {
                //农业银行
                //                if (self.isRecharge ==NO) {
                //                    if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"abc" OrderType:@"2"];
                //                    else [self ConfirmThePayment:@"abc" OrderType:@"1"];
                //                }else{
                [self RechargeThePayment:@"abc"isPayType:NO];
                //                }
                
            }else if (indexPath.row ==1){
                //                if (self.isRecharge ==NO) {
                //                    if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"icbc" OrderType:@"2"];
                //                    else [self ConfirmThePayment:@"icbc" OrderType:@"1"];
                //                }else{
                
                //                }
                [self RechargeThePayment:@"abc"isPayType:YES];
            }else if (indexPath.row ==2){
                [self RechargeThePayment:@"icbc"isPayType:NO];
            }else if (indexPath.row ==3){
                [self RechargeThePayment:@"icbc"isPayType:YES];
            }
            
        }
    }
    
}
#pragma mark -  支付宝、工行，农行付款前的订单验证
-(void)ConfirmThePayment:(NSString *)bankType OrderType:(NSString *)orderType isPayType:(BOOL)isPayType{
    [self startRequestWithString:@"支付中..."];
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
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0310\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"orderCodes\":\"%@\",\"amounts\":\"%@\",\"payWays\":\"%@\",\"payMoneys\":\"%.2f\",\"payPassword\":\"\",\"orderType\":\%@}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.orderNo,self.amounts,bankType,self.remaining,orderType];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"支付返回返回信息：%@",jsonDict);
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
                        if([bankType isEqualToString:@"alipay"]){
                            [self aliPayOrderNo:[jsonDict objectForKey:@"payOrderCode"] alipayNotifyURL:[jsonDict objectForKey:@"payUrl"]];
                        }
                        else if ([bankType isEqualToString:@"abc"]||[bankType isEqualToString:@"icbc"]){
                            [self stopRequest];
                            NSString *payUrl =[jsonDict objectForKey:@"payUrl"];
                            if (isPayType ==YES) {
                                payUrl =[NSString stringWithFormat:@"%@&payType=1",[jsonDict objectForKey:@"payUrl"]];
                            }
                     BankPayViewController*bankPayVC=[[BankPayViewController alloc]init];
                            bankPayVC.payUrl=payUrl;
                            if ([self.typeStr isEqualToString:@"商城"]) bankPayVC.typeStr=@"商城";
                            [self.navigationController pushViewController:bankPayVC animated:YES];
                        }else if ([bankType isEqualToString:@"wxpay"]){
                            [self stopRequest];
                            NSMutableString *stamp  = [[NSMutableString alloc] initWithString:[[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"timeStamp"]];
                            PayReq* req  = [[PayReq alloc] init];
                            //    req.openID =kWeiXinAppID;
                            req.partnerId  = [[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"partnerId"];
                            req.prepayId   = [[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"prepayId"];
                            req.nonceStr   = [[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"nonceStr"];
                            req.timeStamp  = stamp.intValue;
                            req.package    = [[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"package"];
                            req.sign       = [[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"sign"];
                            [WXApi safeSendReq:req];             
                        }else{
                           [[UPPaymentControl defaultControl] startPay:[jsonDict objectForKey:@"payTn"] fromScheme:@"UPPayDemo" mode:@"00" viewController:self];
                        }
                        
                    });
                }
                
                else if (code==103107) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付密码与设置不符";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"支付密码与设置不符"];
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
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"订单不合法";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"订单不合法"];
                    });
                }else if (code ==103106){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付密码被冻结";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"支付失败"];
                    });
                }else if (code ==103109) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付异常";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"支付异常"];
                    });
                }else if (code ==103108){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"不允许重复支付";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"不允许重复支付"];
                    });
                }else if (code ==103103){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"密码失败次数超过5次，请24小时后再试！";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"支付密码尚未设置，请设置！"];
                    });
                }else if (code ==103104){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付密码未设置！";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"支付异常请联系客户：4008887372！"];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                  customPromp.contenttxt =@"支付异常请联系客服：4008887372！";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
                              });
                          }
                               method:url postDict:nil];
    });

    
}
#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
//    NSString* msg = [NSString stringWithFormat:kResult, result];
    NSLog(@"%@",result);
}
#pragma mark -
#pragma mark - 支付宝付款
- (void)aliPayOrderNo:(NSString *)alipayOrderNo alipayNotifyURL:(NSString *)alipayNotifyUrl{
    
    Product1 *product = [[Product1 alloc] init];
    if ([self.typeStr isEqualToString:@"商城"]) {    //2.0商城的
        //product.subject = @"商城";
        product.subject =self.serviceNameStr;   //订单名字，传的总订单下拆分开的所有子订单id编号
        product.price = self.remaining;   //价格，服务器返回的单位元
    }
    else{    //1.0设计师、工长、监理的
        if (self.serviceNameStr.length>0) {
            product.subject = [NSString stringWithFormat:@"阶段：%@",self.serviceNameStr];//订单名字，传的当前阶段名
        }else{
            product.subject = @"阶段：账户充值";
        }
        
        product.price = self.remaining;   //价格，服务器返回的单位分，转换为单位元
    }
    
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088511724568474";         //合作者ID
    NSString *seller = @"zhangy@trond.cn";          //收款账号
    NSString *privateKey = @"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBANFjiE+9Gvfk6lkLnekwqMYzYTSTgb1/ywUYoM26/XbJhTTtysPQ70n081zNd93rJ7eedYNIg5MlFSa91pxQ8r80jx7AhAX6AaLsxwL8NwRGXxU9Up3PpvAYqYr5+eFGwouSST4uAIaQw5gi20Vo+Zrl+nTzrZL2O0lLsxTaCy07AgMBAAECgYEAqsCENKJ+D5G6GguDJtrrh1X2+y0fLC2+ndVLrPnEIM6NtnAEXlNQD/uVSiS0j2Bo7zBlnD3SLnibGxDMpoTMru3ml2oCDqBhJ8qEAD3GVSvQVCz43QBxH4vXjJX/LVn8ZwuZZpe66FwP9LFPQp/+6r8ziePw3cTQyRN2HSggSGECQQD4EZFidT1a+TFaFS2nxbKuiD/DMKoxTHuQdPh08eI0gUq094ku1BzSHBgmQ/3+9VCrPxDZdh/VNSoQXUVUXoBVAkEA2BVfJmjLowncVeGMW/DuVTFT6McuG8kHbdN3V9BvTnKujpGE7/3Lt0uVq4YwNvKD6Sfozwmq70p1ID8aUCJHTwJBAKxbkHcnXGT8JTUg5+Lc8uRfWGYnRukP6f6ZtxOSCIhQmPaZ0uANkqTNzl2v+ieOjOke3Xcqor2BveM22vfe3S0CQQCuEXlW/bCdpEHkxQ9GuW2lH1mS+XFBXM4pQOKw0O35ahUIMF3A3tiOzcrCJBUPDooI9udqcUVMAtUbpvnRd+utAkEAkQRy561YY/R5L5ttMjTfQKxRR9tS2MgWin6yr0g3MwBKTkRcuUg6siiFjdHyBb12hnyEcX0Jk6B7pqWXOYwn4w==";      //私钥
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少合作者ID或者收款账号"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO = alipayOrderNo; //订单ID（由商家自行制定）
//    order.productName = product.subject; //商品标题
//    order.productDescription = product.body; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
//    order.notifyURL =  alipayNotifyUrl;   //支付宝回调URL
//    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//    
//    //调用支付的app注册在info。plist中的scheme
//    NSString *appScheme = @"qttecx.utop";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//            if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNCUpdateOrderStatus object:nil];
//            }
//        }];
//        
//    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = alipayOrderNo; //订单ID（由商家自行制定）
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  alipayNotifyUrl;   //支付宝回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //调用支付的app注册在info。plist中的scheme
    NSString *appScheme = @"qttecx.utop";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNCUpdateOrderStatus object:nil];
            }
        }];
        
    }
}
-(void)hideAction:(id)sender{
    [customPromp dismiss];
}
#pragma mark - 账户充值
-(void)RechargeThePayment:(NSString *)bankType isPayType:(BOOL)isPayType{
    if (self.isamount ==NO) {
        if (self.moneytxf.text.length<=0) {
            [TLToast showWithText:@"请输入金额"];
            return;
        }
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
        [postDict setObject:@"ID0274" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        NSString *string=[postDict JSONString];
        
        NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
        if (self.isamount ==YES) {
            [bodyDic setObject:[NSString stringWithFormat:@"%.2f",self.amount] forKey:@"money"];
        }else{
            [bodyDic setObject:[NSString stringWithFormat:@"%.2f",[self.moneytxf.text doubleValue]] forKey:@"money"];
            self.remaining =[self.moneytxf.text doubleValue];
        }
        
        [bodyDic setObject:bankType forKey:@"bankType"];
        [bodyDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Mobile] forKey:@"mobile"];
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
                NSLog(@"验证订单返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRequest];
                    if (kResCode == 10002 || kResCode == 10003) {
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        [login show];
                        return;
                    }
                    else if (kResCode == 102741) {
                        if([bankType isEqualToString:@"alipay"]){
                            [self aliPayOrderNo:[jsonDict objectForKey:@"payOrderCode"] alipayNotifyURL:[jsonDict objectForKey:@"payUrl"]];
                        }
                        else if ([bankType isEqualToString:@"icbc"]||[bankType isEqualToString:@"abc"]){
                            WTBWebViewViewController *bankPayVC=[[WTBWebViewViewController alloc]init];
                            NSString *payUrl =[jsonDict objectForKey:@"payUrl"];
                            if (isPayType ==YES) {
                                payUrl =[NSString stringWithFormat:@"%@&payType=1",[jsonDict objectForKey:@"payUrl"]];
                            }
                            bankPayVC.requesUrl=payUrl;
//                            if ([self.typeStr isEqualToString:@"商城"]) bankPayVC.typeStr=@"商城";
                            [self.navigationController pushViewController:bankPayVC animated:YES];
                        }else if ([bankType isEqualToString:@"wxpay"]){
                            NSMutableString *stamp  = [[NSMutableString alloc] initWithString:[[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"timeStamp"]];
                            PayReq* req  = [[PayReq alloc] init];
                            //    req.openID =kWeiXinAppID;
                            req.partnerId  = [[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"partnerId"];
                            req.prepayId   = [[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"prepayId"];
                            req.nonceStr   = [[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"nonceStr"];
                            req.timeStamp  = stamp.intValue;
                            req.package    = [[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"package"];
                            req.sign       = [[jsonDict objectForKey:@"wxPayInfo"] objectForKey:@"sign"];
                            [WXApi safeSendReq:req];
                        }else{
                            [[UPPaymentControl defaultControl] startPay:[jsonDict objectForKey:@"payTn"] fromScheme:@"UPPayDemo" mode:@"00" viewController:self];
                        }
                    }
                    else if (kResCode == 102742) {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"充值失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:];
                    }
                    else{
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"操作异常";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                  customPromp.contenttxt =@"操作异常";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
//                                  [TLToast showWithText:@"操作异常"];
                              });
                          }
                               method:url postDict:post];
    });
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.moneytxf resignFirstResponder];
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
