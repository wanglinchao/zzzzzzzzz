//
//  PayingConfirmViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-27.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PayingConfirmViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "TLToast.h"
#import "IDIAIAppDelegate.h"
#import "NetworkRequest.h"
#import "LoginView.h"
#import "JSONKit.h"
//#import "BankPayViewController.h"
#import "WTBWebViewViewController.h"
#import "IDIAI3BalancePayViewController.h"
#import "IDIAI3RechargeViewController.h"
#import "CustomPromptView.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "util.h"
#import "InputLoginPsdViewController.h"
#import "OnlinePayViewController.h"
@implementation Product


@end

@interface PayingConfirmViewController () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate> {
    UITableView *_theTableView;
    CustomPromptView *customPromp;
}
@property(nonatomic,strong)NSDictionary *datadic;
@property(nonatomic,strong)UILabel *walletAssetslbl;
@property(nonatomic,strong)UILabel *decorationLoanAssetslbl;
@property(nonatomic,strong)UISwitch *walletAssetsSwitch;
@property(nonatomic,strong)UISwitch *decorationLoanAssetsSwitch;
@property(nonatomic,assign)double remaining;
@property(nonatomic,assign)BOOL isShowPass;
@property(nonatomic,strong)UITextField *passWord;
@property(nonatomic,assign)double walletMoney;
@property(nonatomic,assign)double decorationMoney;
@end

@implementation PayingConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (iOS_7_Above) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.isShowPass =YES;
    self.datadic =[NSDictionary dictionary];
    self.view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleKNCShoppingMallPaySuccess) name:kNCShoppingMallPaySuccess object:nil];
    
    if ([self.fromStr isEqualToString:@"orderDetailOfGoodsVC"]) {
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.nav setNavigationBarHidden:NO animated:NO];
    }
    
    self.title = @"收银台";
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    _theTableView = [[UITableView alloc]initWithFrame:kTableViewFrame style:UITableViewStylePlain];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    if (self.isRecharge ==NO) {
        _theTableView.hidden =YES;
        [self requstMyAccount];
    }else{
        [self.view addSubview:_theTableView];
    }
    self.walletAssetslbl =[[UILabel alloc] initWithFrame:CGRectMake(60, 33, 120, 15)];
    self.decorationLoanAssetslbl =[[UILabel alloc] initWithFrame:CGRectMake(60, 33, 120, 15)];
    _theTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    _theTableView.tableFooterView = [[UIView alloc]init];
}


-(void)requstMyAccount{
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
        NSString *url =[NSString string];
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0273\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"mobile\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],[[NSUserDefaults standardUserDefaults] objectForKey:User_Mobile]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"日记列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
//                        login.delegate=self;
//                        [login show];
                        [self performSelector:@selector(DisPlayLoginView) withObject:nil afterDelay:0.5f];
                    });
                }
                if (code==102731) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        self.datadic =jsonDict;
                        if (_theTableView) {
                            [self.view addSubview:_theTableView];
                        }
                        [self reloadLabel];
                        _theTableView.hidden =NO;
                    });
                }
                else if (code==102732) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"获取账户信息失败"];
                    });
                }
                else if (code==102729){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"获取账户信息失败"];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"获取账户信息失败"];
                              });
                          }
                               method:url postDict:nil];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)DisPlayLoginView{
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    [login show];
    return;
}
-(void)reloadLabel {
    self.walletAssetslbl.text =[NSString stringWithFormat:@"余额:￥%@",[self.datadic objectForKey:@"walletAssets"] ];
    CGSize labelsize =[util calHeightForLabel:self.walletAssetslbl.text width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:11]];
    self.walletAssetslbl.frame =CGRectMake(self.walletAssetslbl.frame.origin.x, self.walletAssetslbl.frame.origin.y, labelsize.width, self.walletAssetslbl.frame.size.height);
//    self.walletAssetslbl.backgroundColor =[UIColor orangeColor];
    self.decorationLoanAssetslbl.text =[NSString stringWithFormat:@"余额:￥%@",[self.datadic objectForKey:@"decorationLoanAssets"] ];
    CGSize labelsize1 =[util calHeightForLabel:self.decorationLoanAssetslbl.text width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:11]];
    self.decorationLoanAssetslbl.frame =CGRectMake(self.decorationLoanAssetslbl.frame.origin.x, self.decorationLoanAssetslbl.frame.origin.y, labelsize1.width, self.decorationLoanAssetslbl.frame.size.height);
//    self.decorationLoanAssetslbl.backgroundColor =[UIColor orangeColor];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNCShoppingMallPaySuccess object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isRecharge==NO) {
        if (self.isShowPass ==YES) {
            if (self.walletAssetsSwitch.on ==NO&&self.decorationLoanAssetsSwitch.on ==NO){
                return 4;
            }
            return 5;
        }else{
            if (self.walletAssetsSwitch.on ==YES||self.decorationLoanAssetsSwitch.on ==YES) {
                return 4;
            }
            return 3;
        }
        
    }else{
        return 3;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isRecharge ==NO) {
//        if (section == 0) {
//            return 1;
//        } else if (section==1) {
//            return 2;
//        }else if (section ==2){
//            return 2;
//        }else{
//            return 2;
//        }
        if (section == 0) {
            return 1;
        } else if (section==1){
            int count =0;
            if ([[self.datadic objectForKey:@"walletAssets"] doubleValue]==0||[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]==0) {
                count =-1;
            }
            return 2+count;
        }else{
            return 1;
        }
    }else{
        if (section == 0) {
            return 1;
        } else if (section==1) {
            return 2;
        }else{
            return 2;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isRecharge ==NO) {
        if (section ==1) {
            return 12;
        }else if (section ==2){
            return 12;
        }else{
            return 12;
        }
    }else{
        if (section ==1) {
            return 12;
        }else{
            return 12;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    } else {
        if (self.isRecharge==NO) {
            if (self.isShowPass ==NO) {
                if (self.walletAssetsSwitch.on ==YES||self.decorationLoanAssetsSwitch.on ==YES) {
                    if (indexPath.section ==2) {
                        return 77;
                    }
                }
            }else{
                if (self.walletAssetsSwitch.on ==YES||self.decorationLoanAssetsSwitch.on ==YES) {
                    if (indexPath.section ==3) {
                        return 77;
                    }
                }

            }
        
        }
        return 57;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        nameLabel.font =[UIFont boldSystemFontOfSize:19];
        UILabel *moneyLabel = (UILabel *)[cell viewWithTag:102];
        if (moneyLabel == nil)
        moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kMainScreenWidth-20, 30)];
        moneyLabel.tag = 102;
        NSString *money =[NSString stringWithFormat:@"%f",self.moneyFloat];
        NSRange range = [money rangeOfString:@"."];//匹配得到的下标
//        NSLog(@"rang:%@",NSStringFromRange(range));
        money =[money substringToIndex:range.location+3];;//截取范围类的字符串
        moneyLabel.text = [NSString stringWithFormat:@"支付金额:￥%@",money];
        moneyLabel.textColor = kThemeColor;
        moneyLabel.font =[UIFont boldSystemFontOfSize:19];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:moneyLabel];
        
        if ([self.typeStr isEqualToString:@"商城"]) {
            if (self.isRecharge==YES) {
            }else{
                nameLabel.hidden = YES;
                moneyLabel.frame = CGRectMake(10, 30, kMainScreenWidth-20, 30);
            }
            
            NSString *money =[NSString stringWithFormat:@"%f",self.moneyFloat];
            NSRange range = [money rangeOfString:@"."];//匹配得到的下标
            NSLog(@"rang:%@",NSStringFromRange(range));
            money =[money substringToIndex:range.location+3];;//截取范围类的字符串
            moneyLabel.text = [NSString stringWithFormat:@"支付金额:￥%@",money];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        if (self.isRecharge ==NO) {
            if (indexPath.section ==1) {
                if (indexPath.row ==0) {
                    if ([[self.datadic objectForKey:@"walletAssets"] doubleValue]!=0) {
                        cell.imageView.image =[UIImage imageNamed:@"ic_dingjin.png"];
                        //                    cell.textLabel.text =@"钱包支付";
                        UILabel *titlelbl =[cell viewWithTag:1000];
                        if (titlelbl ==nil) {
                            titlelbl=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 17)];
                            titlelbl.tag =1000;
                        }
                        titlelbl.text =@"定金支付";
                        titlelbl.font =[UIFont boldSystemFontOfSize:17];
                        titlelbl.textColor =[UIColor blackColor];
                        [cell addSubview:titlelbl];
                        //                    cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
                        UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
                        line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                        [cell addSubview:line];
                        //                    float money =0;
                        
                        NSLog(@"%@",[self.datadic objectForKey:@"walletAssets"]);
                        UILabel *moneylbl =[cell viewWithTag:1001];
                        if (moneylbl ==nil) {
                            moneylbl=[[UILabel alloc] initWithFrame:CGRectMake(self.walletAssetslbl.frame.origin.x+self.walletAssetslbl.frame.size.width+10, self.walletAssetslbl.frame.origin.y, 110, 12)];
                            moneylbl.tag =1001;
                            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥0"]];
                            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                            moneylbl.attributedText = str;
                        }
                        moneylbl.font =[UIFont boldSystemFontOfSize:11];
                        [cell addSubview:moneylbl];
                        
                        
                        
                        self.walletAssetslbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        self.walletAssetslbl.font =[UIFont systemFontOfSize:11];
                        [cell addSubview:self.walletAssetslbl];
                        if (self.walletAssetsSwitch ==nil) {
                            self.walletAssetsSwitch =[[UISwitch alloc] initWithFrame:CGRectMake(kMainScreenWidth-61, 11, 51, 31)];
                            [self.walletAssetsSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:self.walletAssetsSwitch];
                        }
                        
                        //                    if (self.walletAssetsSwitch.on ==YES) {
                        //                        if ([[self.datadic objectForKey:@"walletAssets"] floatValue]>=self.moneyFloat) {
                        //
                        //
                        //                            //                        cell.userInteractionEnabled =YES;
                        //                            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",self.moneyFloat]];
                        //                            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                        //                            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(4,str.length-4)];
                        //                            moneylbl.attributedText = str;
                        //                        }else{
                        //                            cell.textLabel.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        //                            cell.imageView.image =[UIImage imageNamed:@"ic_qianbao_no.png"];
                        //                            //                        self.walletAssetslbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-43-100, 12, 100, 12)];
                        //                            self.walletAssetslbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        //                            self.walletAssetslbl.font =[UIFont systemFontOfSize:12];
                        //                            [cell addSubview:self.walletAssetslbl];
                        //
                        //                            //                        UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-43-156, self.walletAssetslbl.frame.origin.y+self.walletAssetslbl.frame.size.height, 156, 12)];
                        //                            //                        titlelbl.textColor =[UIColor colorWithHexString:@"#cccccc"];
                        //                            //                        titlelbl.font =[UIFont systemFontOfSize:12];
                        //                            //                        titlelbl.textAlignment =NSTextAlignmentRight;
                        //                            //                        titlelbl.text =@"请前往[我的账户]进行充值";
                        //                            //                        [cell addSubview:titlelbl];
                        //                            //                        cell.userInteractionEnabled =NO;
                        //                        }
                        //
                        //                    }else{
                        //                        
                        //                    }
                        //                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.imageView.image =[UIImage imageNamed:@"ic_zhuangxiudai_nor.png"];
                        //                    cell.textLabel.text =@"贷款支付";
                        //                    cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
                        UILabel *titlelbl =[cell viewWithTag:1000];
                        if (titlelbl ==nil) {
                            titlelbl=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 17)];
                            titlelbl.tag =1000;
                        }
                        titlelbl.text =@"贷款支付";
                        titlelbl.font =[UIFont boldSystemFontOfSize:17];
                        titlelbl.textColor =[UIColor blackColor];
                        [cell addSubview:titlelbl];
                        
                        UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
                        line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                        [cell addSubview:line];
                        
                        UILabel *moneylbl =[cell viewWithTag:1001];
                        if (moneylbl ==nil) {
                            moneylbl=[[UILabel alloc] initWithFrame:CGRectMake(self.decorationLoanAssetslbl.frame.origin.x+self.decorationLoanAssetslbl.frame.size.width+10, self.decorationLoanAssetslbl.frame.origin.y, 110, 11)];
                            moneylbl.tag =1001;
                            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥0"]];
                            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                            moneylbl.attributedText = str;
                        }
                        moneylbl.font =[UIFont boldSystemFontOfSize:11];
                        [cell addSubview:moneylbl];
                        
                        
                        
                        
                        //                    if ([[self.datadic objectForKey:@"decorationLoanAssets"] floatValue]>=self.moneyFloat) {
                        //
                        //                        self.decorationLoanAssetslbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
                        //                        self.decorationLoanAssetslbl.font =[UIFont systemFontOfSize:15];
                        //                        self.decorationLoanAssetslbl.textAlignment =NSTextAlignmentRight;
                        //                        [cell addSubview:self.decorationLoanAssetslbl];
                        //                        cell.userInteractionEnabled =YES;
                        //                    }else{
                        //                        cell.textLabel.textColor =[UIColor colorWithHexString:@"#cccccc"];
                        //                        cell.imageView.image =[UIImage imageNamed:@"ic_zhuangxiudai_nor_d.png"];
                        //                        self.decorationLoanAssetslbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-43-100, 12, 100, 12)];
                        self.decorationLoanAssetslbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                        self.decorationLoanAssetslbl.font =[UIFont systemFontOfSize:11];
                        [cell addSubview:self.decorationLoanAssetslbl];
                        
                        if (self.decorationLoanAssetsSwitch ==nil) {
                            self.decorationLoanAssetsSwitch =[[UISwitch alloc] initWithFrame:CGRectMake(kMainScreenWidth-61, 11, 51, 31)];
                            [self.decorationLoanAssetsSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:self.decorationLoanAssetsSwitch];
                        }
                    }
                    
                }else{
                    cell.imageView.image =[UIImage imageNamed:@"ic_zhuangxiudai_nor.png"];
//                    cell.textLabel.text =@"贷款支付";
//                    cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
                    UILabel *titlelbl =[cell viewWithTag:1000];
                    if (titlelbl ==nil) {
                        titlelbl=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 17)];
                        titlelbl.tag =1000;
                    }
                    titlelbl.text =@"贷款支付";
                    titlelbl.font =[UIFont boldSystemFontOfSize:17];
                    titlelbl.textColor =[UIColor blackColor];
                    [cell addSubview:titlelbl];
                    
                    UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
                    line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                    [cell addSubview:line];
                    
                    UILabel *moneylbl =[cell viewWithTag:1001];
                    if (moneylbl ==nil) {
                        moneylbl=[[UILabel alloc] initWithFrame:CGRectMake(self.decorationLoanAssetslbl.frame.origin.x+self.decorationLoanAssetslbl.frame.size.width+10, self.decorationLoanAssetslbl.frame.origin.y, 110, 11)];
                        moneylbl.tag =1001;
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥0"]];
                        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                        moneylbl.attributedText = str;
                    }
                    moneylbl.font =[UIFont boldSystemFontOfSize:11];
                    [cell addSubview:moneylbl];
                    
                    
                    
                    
//                    if ([[self.datadic objectForKey:@"decorationLoanAssets"] floatValue]>=self.moneyFloat) {
//                        
//                        self.decorationLoanAssetslbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
//                        self.decorationLoanAssetslbl.font =[UIFont systemFontOfSize:15];
//                        self.decorationLoanAssetslbl.textAlignment =NSTextAlignmentRight;
//                        [cell addSubview:self.decorationLoanAssetslbl];
//                        cell.userInteractionEnabled =YES;
//                    }else{
//                        cell.textLabel.textColor =[UIColor colorWithHexString:@"#cccccc"];
//                        cell.imageView.image =[UIImage imageNamed:@"ic_zhuangxiudai_nor_d.png"];
//                        self.decorationLoanAssetslbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-43-100, 12, 100, 12)];
                    self.decorationLoanAssetslbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    self.decorationLoanAssetslbl.font =[UIFont systemFontOfSize:11];
                    [cell addSubview:self.decorationLoanAssetslbl];
                    
                    if (self.decorationLoanAssetsSwitch ==nil) {
                        self.decorationLoanAssetsSwitch =[[UISwitch alloc] initWithFrame:CGRectMake(kMainScreenWidth-61, 11, 51, 31)];
                        [self.decorationLoanAssetsSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:self.decorationLoanAssetsSwitch];
                    }
                    
//                        UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-43-156, self.decorationLoanAssetslbl.frame.origin.y+self.decorationLoanAssetslbl.frame.size.height, 156, 12)];
//                        titlelbl.textColor =[UIColor colorWithHexString:@"#cccccc"];
//                        titlelbl.font =[UIFont systemFontOfSize:12];
//                        titlelbl.textAlignment =NSTextAlignmentRight;
//                        titlelbl.text =@"请前往[我的账户]进行充值";
//                        [cell addSubview:titlelbl];
//                        cell.userInteractionEnabled =NO;
//                    }
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
            }else if (indexPath.section ==2){
                if (self.isShowPass ==YES) {
                    UIButton *setting =(UIButton *)[cell viewWithTag:1002];
                    if (setting) {
                        [setting removeFromSuperview];
                        setting =nil;
                        [self.passWord removeFromSuperview];
                        self.passWord =nil;
                    }
                    cell.textLabel.text =[NSString stringWithFormat:@"还需支付:%.2f",self.moneyFloat];
                    self.remaining =self.moneyFloat;
                    if (self.walletAssetsSwitch.on==YES) {
                        cell.textLabel.text =[NSString stringWithFormat:@"还需支付:%.2f",self.moneyFloat-[[self.datadic objectForKey:@"walletAssets"] doubleValue]];
                        self.remaining =self.moneyFloat-[[self.datadic objectForKey:@"walletAssets"] doubleValue];
                    }
                    if (self.decorationLoanAssetsSwitch.on ==YES) {
                        cell.textLabel.text =[NSString stringWithFormat:@"还需支付:%.2f",self.moneyFloat-[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]];
                        self.remaining =self.moneyFloat-[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue];
                    }
                    if (self.walletAssetsSwitch.on ==YES&&self.decorationLoanAssetsSwitch.on ==YES) {
                        cell.textLabel.text =[NSString stringWithFormat:@"还需支付:%.2f",self.moneyFloat-[[self.datadic objectForKey:@"walletAssets"] doubleValue]-[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]];
                        self.remaining =self.moneyFloat-[[self.datadic objectForKey:@"walletAssets"] doubleValue]-[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue];
                    }
//                    cell.backgroundColor =[UIColor whiteColor];
                }else{
                    self.remaining =0;
                    if (self.passWord ==nil) {
                        self.passWord =[[UITextField alloc] initWithFrame:CGRectMake(15, 8, kMainScreenWidth-30, 40)];
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
                    }
                    [cell addSubview:self.passWord];
                    
                    UIButton *setting =(UIButton *)[cell viewWithTag:1002];
                    if (setting ==nil) {
                        setting=[UIButton buttonWithType:UIButtonTypeCustom];
                        setting.tag =1002;
                        setting.titleLabel.font =[UIFont systemFontOfSize:14];
                        setting.frame =CGRectMake(kMainScreenWidth-15-154, self.passWord.frame.size.height+self.passWord.frame.origin.y+10, 154, 14);
                        [setting setTitle:@"设置屋托邦平台支付密码" forState:UIControlStateNormal];
                        [setting setTitle:@"设置屋托邦平台支付密码" forState:UIControlStateHighlighted];
                        [setting setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                        [setting setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                        [setting addTarget:self action:@selector(payPassWordChange:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:setting];
                    }
                    
                    cell.textLabel.text =@"";
                }
                
            }else if (indexPath.section ==3){
                if (self.isShowPass ==YES){
                    cell.backgroundColor =[UIColor whiteColor];
                    UIButton *completebtn =(UIButton *)[cell viewWithTag:1003];
                    if (completebtn) {
                        [completebtn removeFromSuperview];
                        completebtn =nil;
                    }
                    if (self.walletAssetsSwitch.on==YES ||self.decorationLoanAssetsSwitch.on ==YES) {
                        if (self.passWord ==nil) {
                            self.passWord =[[UITextField alloc] initWithFrame:CGRectMake(15, 8, kMainScreenWidth-30, 40)];
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
                        }
                        [cell addSubview:self.passWord];
                        UIButton *setting =(UIButton *)[cell viewWithTag:1002];
                        if (setting ==nil) {
                            setting=[UIButton buttonWithType:UIButtonTypeCustom];
                            setting.tag =1002;
                            setting.titleLabel.font =[UIFont systemFontOfSize:14];
                            setting.frame =CGRectMake(kMainScreenWidth-15-154, self.passWord.frame.size.height+self.passWord.frame.origin.y+10, 154, 14);
                            [setting setTitle:@"设置屋托邦平台支付密码" forState:UIControlStateNormal];
                            [setting setTitle:@"设置屋托邦平台支付密码" forState:UIControlStateHighlighted];
                            [setting setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
                            [setting setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
                            [setting addTarget:self action:@selector(payPassWordChange:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:setting];
                        }
                    }else{
                        cell.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                        UIButton *setting =(UIButton *)[cell viewWithTag:1002];
                        if (setting) {
                            [setting removeFromSuperview];
                            setting =nil;
                            [self.passWord removeFromSuperview];
                            self.passWord =nil;
                        }
                        UIButton *completebtn =(UIButton *)[cell viewWithTag:1003];
                        if (completebtn ==nil) {
                            completebtn=[UIButton buttonWithType:UIButtonTypeCustom];
                            completebtn.frame =CGRectMake(11, 11, kMainScreenWidth-22, 40);
                            [completebtn setBackgroundColor:kThemeColor];
                            completebtn.layer.cornerRadius = 5;
                            completebtn.layer.masksToBounds = YES;
                            completebtn.tag =1003;
                            [completebtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
                            [completebtn setTitle:@"立即支付" forState:UIControlStateNormal];
                            [cell addSubview:completebtn];
                        }
                    }
                }else{
                    cell.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                    UIButton *setting =(UIButton *)[cell viewWithTag:1002];
                    if (setting) {
                        [setting removeFromSuperview];
                        setting =nil;
                        UITableViewCell *cell1 =(UITableViewCell *)self.passWord.superview;
                        if (cell1 ==cell) {
                            [self.passWord removeFromSuperview];
                            self.passWord =nil;
                        }
                    }
                    UIButton *completebtn =(UIButton *)[cell viewWithTag:1003];
                    if (completebtn ==nil) {
                        completebtn=[UIButton buttonWithType:UIButtonTypeCustom];
                        completebtn.frame =CGRectMake(11, 11, kMainScreenWidth-22, 40);
                        [completebtn setBackgroundColor:kThemeColor];
                        completebtn.layer.cornerRadius = 5;
                        completebtn.layer.masksToBounds = YES;
                        completebtn.tag =1003;
                        [completebtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
                        [completebtn setTitle:@"立即支付" forState:UIControlStateNormal];
                        [cell addSubview:completebtn];
                    }
                }
                
            }else if (indexPath.section==4){
                cell.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                UIButton *completebtn =(UIButton *)[cell viewWithTag:1003];
                if (completebtn ==nil) {
                    completebtn=[UIButton buttonWithType:UIButtonTypeCustom];
                    completebtn.frame =CGRectMake(11, 11, kMainScreenWidth-22, 40);
                    [completebtn setBackgroundColor:kThemeColor];
                    completebtn.layer.cornerRadius = 5;
                    completebtn.layer.masksToBounds = YES;
                    completebtn.tag =1003;
                    [completebtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
                    [completebtn setTitle:@"立即支付" forState:UIControlStateNormal];
                    [cell addSubview:completebtn];
                }
            }
            
//            }else if (indexPath.section ==2){
//                if (indexPath.row ==0) {
//                    cell.imageView.image =[UIImage imageNamed:@"ic_zhifubao_nor.png"];
//                    cell.textLabel.text =@"支付宝";
//                }else{
//                    cell.imageView.image =[UIImage imageNamed:@"ic_weixinzhifu.png"];
//                    cell.textLabel.text =@"微信支付";
//                }
//                
//                cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
//                UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
//                line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//                [cell addSubview:line];
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            }else if (indexPath.section ==3){
//                if (indexPath.row ==0) {
//                    cell.imageView.image =[UIImage imageNamed:@"ic_nenghang_nor.png"];
//                    cell.textLabel.text =@"中国农业银行";
//                    cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
//                    UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
//                    line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//                    [cell addSubview:line];
//                    
//                }else if (indexPath.row==1){
//                    cell.imageView.image =[UIImage imageNamed:@"ic_gonghang_nor.png"];
//                    cell.textLabel.text =@"中国工商银行";
//                    cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
//                    //                UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
//                    //                line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//                    //                [cell addSubview:line];
//                    
//                }
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            }
            
        }else{
            if (indexPath.section ==1) {
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
            }else{
                if (indexPath.row ==0) {
                    cell.imageView.image =[UIImage imageNamed:@"ic_nenghang_nor.png"];
                    cell.textLabel.text =@"中国农业银行";
                    cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
                    UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
                    line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                    [cell addSubview:line];
                }else if (indexPath.row ==1){
                    cell.imageView.image =[UIImage imageNamed:@"ic_gonghang_nor.png"];
                    cell.textLabel.text =@"中国工商银行";
                    cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
                }
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    
//    } else {
//        if (indexPath.row == 0) {
//            cell.imageView.image =[UIImage imageNamed:@"ic_zhifubao_nor.png"];
//            cell.textLabel.text =@"支付宝";
//            cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
//            UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
//            line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//            [cell addSubview:line];
//
//            UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 57, kMainScreenWidth, 10)];
//            footView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//            [cell addSubview:footView];
//
//        }
//        else if (indexPath.row == 1) {
//
//            cell.imageView.image =[UIImage imageNamed:@"ic_nenghang_nor.png"];
//            cell.textLabel.text =@"中国农业银行";
//            cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
//            UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
//            line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//            [cell addSubview:line];
//        }
//        else {
//            cell.imageView.image =[UIImage imageNamed:@"ic_gonghang_nor.png"];
//            cell.textLabel.text =@"中国工商银行";
//            cell.textLabel.font =[UIFont boldSystemFontOfSize:17];
//            UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(15, 56, kMainScreenWidth-15, 1)];
//            line.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//            [cell addSubview:line];
//        }
    
//    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 1) {
//        return @"";
//    } else {
//        return nil;
//    }
//}
-(void)payPassWordChange:(id)sender{
    InputLoginPsdViewController *inputLoginPsdVC = [[InputLoginPsdViewController alloc]init];
    inputLoginPsdVC.fromStr =self.fromStr;
    [self.navigationController pushViewController:inputLoginPsdVC animated:YES];
}
-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    UITableViewCell *cell =(UITableViewCell *)self.walletAssetsSwitch.superview;
    UITableViewCell *cell1 =(UITableViewCell *)self.decorationLoanAssetsSwitch.superview;
    if(self.walletAssetsSwitch ==switchButton){
        UILabel *moneylbl =[cell viewWithTag:1001];
        UILabel *moneylbl1 =[cell1 viewWithTag:1001];
        if (self.walletAssetsSwitch.on ==YES) {
            if (self.decorationLoanAssetsSwitch.on ==YES) {
                if (self.moneyFloat-[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]<=0) {
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"支付金额已达到订单金额" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                    self.walletMoney =0;
                    self.walletAssetsSwitch.on =NO;
                    return;
                }
//                NSString *walletAssets =[NSString stringWithFormat:@"%@0000",[self.datadic objectForKey:@"walletAssets"]];
//                NSLog(@"%.2g",walletAssets.floatValue);
//                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                NSNumber *num =[f numberFromString:[self.datadic objectForKey:@"walletAssets"] ];
//                NSLog(@"%.2f",[num doubleValue]);
//                NSLog(@"%.2f",[[self.datadic objectForKey:@"walletAssets"] doubleValue]);
                if ([[self.datadic objectForKey:@"walletAssets"] doubleValue]>=self.moneyFloat-[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]) {
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",self.moneyFloat-[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]]];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    moneylbl.attributedText = str;
                    self.walletMoney =self.moneyFloat-[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue];
                    self.isShowPass =NO;
                }else{
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",[[self.datadic objectForKey:@"walletAssets"] doubleValue]]];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    moneylbl.attributedText = str;
                    self.walletMoney =[[self.datadic objectForKey:@"walletAssets"] doubleValue];
                    self.isShowPass =YES;
                }
            }else{
                if ([[self.datadic objectForKey:@"walletAssets"] doubleValue]>=self.moneyFloat) {
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",self.moneyFloat]];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    self.walletMoney =self.moneyFloat;
                    moneylbl.attributedText = str;
                    self.isShowPass =NO;
                }else{
                    NSLog(@"=======================%@",[self.datadic objectForKey:@"walletAssets"]);
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",[[self.datadic objectForKey:@"walletAssets"] doubleValue]]];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    self.walletMoney =[[self.datadic objectForKey:@"walletAssets"] doubleValue];
                    moneylbl.attributedText = str;
                    self.isShowPass =YES;
                }
            }
            
            
        }else{
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥0"]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
            self.walletMoney =0;
            moneylbl.attributedText = str;
            
            if (self.decorationLoanAssetsSwitch.on ==YES){
                if ([[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]>=self.moneyFloat) {
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",self.moneyFloat]];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    self.decorationMoney =self.moneyFloat;
                    moneylbl1.attributedText = str;
                    self.isShowPass =NO;
                }else{
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]]];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    moneylbl1.attributedText = str;
                    self.decorationMoney =[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue];
                    self.isShowPass =YES;
                }
            }else{
                self.isShowPass =YES;
            }
            
        }

    }
    
    if(self.decorationLoanAssetsSwitch ==switchButton){
        UILabel *moneylbl =[cell viewWithTag:1001];
        UILabel *moneylbl1 =[cell1 viewWithTag:1001];
        if (self.decorationLoanAssetsSwitch.on ==YES) {
            if (self.walletAssetsSwitch.on ==YES) {
                if (self.moneyFloat-[[self.datadic objectForKey:@"walletAssets"] doubleValue]<=0) {
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"支付金额已达到订单金额" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                    self.decorationMoney =0;
                    self.decorationLoanAssetsSwitch.on =NO;
                    return;
                }
                if ([[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]>=self.moneyFloat-[[self.datadic objectForKey:@"walletAssets"] doubleValue]) {
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",self.moneyFloat-[[self.datadic objectForKey:@"walletAssets"] doubleValue]]];
                    self.decorationMoney =self.moneyFloat-[[self.datadic objectForKey:@"walletAssets"] doubleValue];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    moneylbl1.attributedText = str;
                    self.isShowPass =NO;
                }else{
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]]];
                    self.decorationMoney =[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    moneylbl1.attributedText = str;
                    self.isShowPass =YES;
                }
            }else{
                if ([[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]>=self.moneyFloat) {
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",self.moneyFloat]];
                    self.decorationMoney =self.moneyFloat;
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    moneylbl1.attributedText = str;
                    self.isShowPass =NO;
                }else{
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue]]];
                    self.decorationMoney =[[self.datadic objectForKey:@"decorationLoanAssets"] doubleValue];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    moneylbl1.attributedText = str;
                    self.isShowPass =YES;
                }
            }
            
            
        }else{
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥0"]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
            self.decorationMoney =0;
            moneylbl1.attributedText = str;
            if (self.walletAssetsSwitch.on ==YES){
                if ([[self.datadic objectForKey:@"walletAssets"] doubleValue]>=self.moneyFloat) {
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",self.moneyFloat]];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    self.walletMoney =self.moneyFloat;
                    moneylbl.attributedText = str;
                    self.isShowPass =NO;
                }else{
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付:￥%.2f",[[self.datadic objectForKey:@"walletAssets"] doubleValue]]];
                    self.walletMoney =[[self.datadic objectForKey:@"walletAssets"] doubleValue];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(0,3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str.length-3)];
                    moneylbl.attributedText = str;
                    self.isShowPass =YES;
                }
            }else{
                self.isShowPass =YES;
            }

        }
        
    }
    [_theTableView  reloadData];
}
-(void)nextAction:(id)sender{
    if (self.walletAssetsSwitch.on==NO && self.decorationLoanAssetsSwitch.on ==NO) {
        OnlinePayViewController *onlinepay =[[OnlinePayViewController alloc] init];
        onlinepay.serviceNameStr =self.serviceNameStr;
        onlinepay.remaining =self.remaining;
        onlinepay.typeStr =self.typeStr;
        onlinepay.orderNo =self.orderNo;
        onlinepay.amounts =self.amounts;
        [self.navigationController pushViewController:onlinepay animated:YES];
        return;
    }
    NSString *bankType =[NSString string];
    if (self.walletAssetsSwitch.on==YES) {
        bankType =@"yue";
    }
    if (self.decorationLoanAssetsSwitch.on ==YES) {
        if (bankType.length>0) {
            bankType =[NSString stringWithFormat:@"%@,zxd",bankType];
        }else{
            bankType =@"zxd";
        }
        
    }
    if (self.walletAssetsSwitch.on==YES||self.decorationLoanAssetsSwitch.on ==YES) {
        if (self.passWord.text.length<=0) {
            [TLToast showWithText:@"请输入支付密码"];
            return;
        }
    }
    if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:bankType OrderType:@"2"];
    else [self ConfirmThePayment:bankType OrderType:@"1"];
    

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isRecharge==YES) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                //调用支付宝支付
//                if (self.isRecharge ==NO) {
//                    if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"alipay" OrderType:@"2"];
//                    else [self ConfirmThePayment:@"alipay" OrderType:@"1"];
//                }else{
                    [self RechargeThePayment:@"alipay"];
//                }
                
                
            }else{
                if (indexPath.row ==1) {
                    //微信支付
                    NSMutableString *stamp  = [[NSMutableString alloc] initWithString:@"1455517732"];
                    PayReq* req  = [[PayReq alloc] init];
                    //    req.openID =kWeiXinAppID;
                    req.partnerId  = @"1312175601";
                    req.prepayId   = @"wx20160215142912ee1b52d3e10902312552";
                    req.nonceStr   = @"27kgmOgJMWHOBdN2";
                    req.timeStamp  = stamp.intValue;
                    req.package    = @"Sign=WXPay";
                    req.sign       = @"F10D2132C4C02989FCFAB1338B347B54";
                    [WXApi safeSendReq:req];
                }
            }
        }else if (indexPath.section ==2){
            if (indexPath.row ==0) {
                //农业银行
//                if (self.isRecharge ==NO) {
//                    if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"abc" OrderType:@"2"];
//                    else [self ConfirmThePayment:@"abc" OrderType:@"1"];
//                }else{
                    [self RechargeThePayment:@"abc"];
//                }

            }else{
//                if (self.isRecharge ==NO) {
//                    if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"icbc" OrderType:@"2"];
//                    else [self ConfirmThePayment:@"icbc" OrderType:@"1"];
//                }else{
                    [self RechargeThePayment:@"icbc"];
//                }
            }
            
        }
    }else{
//        if (indexPath.section ==1) {
//            if (indexPath.row ==0) {
//                NSLog(@"钱包支付");
//                if ([[self.datadic objectForKey:@"walletAssets"] floatValue]>=self.moneyFloat){
//                    IDIAI3BalancePayViewController *balance =[[IDIAI3BalancePayViewController alloc] init];
//                    balance.title =@"钱包支付";
//                    balance.iswallet =YES;
//                    float money =0;
//                    NSString *ordertype =[NSString string];
//                    if (![self.typeStr isEqualToString:@"商城"]) {
//                        money =self.moneyFloat;
//                        ordertype =@"1";
//                    }else{
//                        ordertype =@"2";
//                        money =self.moneyFloat;
//                    }
//                    balance.orderNo =self.orderNo;
//                    balance.walletAssets =[self.datadic objectForKey:@"walletAssets"];
//                    balance.moneyFloat =money;
//                    balance.orderType =ordertype;
//                    balance.amounts =self.amounts;
//                    balance.fromStr =self.fromController;
//                    balance.hidesBottomBarWhenPushed =NO;
//                    [self.navigationController pushViewController:balance animated:YES];
//                }else{
//                    
//                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的钱包余额不足！可前往［我的账户］进行充值，或使用其他支付方式" delegate:self cancelButtonTitle:@"去充值"otherButtonTitles:@"知道了" , nil];
//                    alert.tag =100;
//                    [alert show];
//                }
//                
//            }else{
//                if ([[self.datadic objectForKey:@"decorationLoanAssets"] floatValue]>=self.moneyFloat){
//                    IDIAI3BalancePayViewController *balance =[[IDIAI3BalancePayViewController alloc] init];
//                    balance.title =@"贷款支付";
//                    float money =0;
//                    NSString *ordertype =[NSString string];
//                    if (![self.typeStr isEqualToString:@"商城"]) {
//                        money =self.moneyFloat;
//                        ordertype =@"1";
//                    }else{
//                        ordertype =@"2";
//                        money =self.moneyFloat;
//                    }
//                    balance.decorationLoanAssets =[self.datadic objectForKey:@"decorationLoanAssets"];
//                    balance.moneyFloat =money;
//                    balance.orderNo =self.orderNo;
//                    balance.orderType =ordertype;
//                    balance.amounts =self.amounts;
//                    balance.fromStr =self.fromController;
//                    balance.hidesBottomBarWhenPushed =NO;
//                    [self.navigationController pushViewController:balance animated:YES];
//                }else{
//                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的贷款余额不足！可前往［我的账户］申请装修贷款，或使用其他支付方式" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//                    alert.tag =101;
//                    [alert show];
//                }
//                
//                NSLog(@"贷款支付");
//            }
//        }else if (indexPath.section ==2){
            //调用支付宝支付
//            if (indexPath.row ==0) {
//                if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"alipay" OrderType:@"2"];
//                else [self ConfirmThePayment:@"alipay" OrderType:@"1"];
//            }else{
//                //微信支付
//                NSMutableString *stamp  = [[NSMutableString alloc] initWithString:@"1455517732"];
//                PayReq* req  = [[PayReq alloc] init];
//                //    req.openID =kWeiXinAppID;
//                req.partnerId  = @"1312175601";
//                req.prepayId   = @"wx20160215142912ee1b52d3e10902312552";
//                req.nonceStr   = @"27kgmOgJMWHOBdN2";
//                req.timeStamp  = stamp.intValue;
//                req.package    = @"Sign=WXPay";
//                req.sign       = @"F10D2132C4C02989FCFAB1338B347B54";
//                [WXApi safeSendReq:req];
//            }
//            
//        }else if (indexPath.section ==3){
//            if (indexPath.row ==0) {
//                //农业银行
//                if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"abc" OrderType:@"2"];
//                else [self ConfirmThePayment:@"abc" OrderType:@"1"];
//            }else{
//                //工商银行
//                if ([self.typeStr isEqualToString:@"商城"]) [self ConfirmThePayment:@"icbc" OrderType:@"2"];
//                else [self ConfirmThePayment:@"icbc" OrderType:@"1"];
//            }
//            
//        }
    }
    
}
#pragma mark - 账户充值
-(void)RechargeThePayment:(NSString *)bankType{
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
        [bodyDic setObject:[NSString stringWithFormat:@"%.2f",self.moneyFloat] forKey:@"money"];
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
                        else{
                            WTBWebViewViewController *bankPayVC=[[WTBWebViewViewController alloc]init];
                            bankPayVC.requesUrl=[jsonDict objectForKey:@"payUrl"];
//                            if ([self.typeStr isEqualToString:@"商城"]) bankPayVC.typeStr=@"商城";
                            [self.navigationController pushViewController:bankPayVC animated:YES];
                        }
                    }
                    else if (kResCode == 102742) {
                        [TLToast showWithText:@"充值失败"];
                    }
                    else{
                        [TLToast showWithText:@"操作异常"];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"操作异常"];
                              });
                          }
                               method:url postDict:post];
    });
}
#pragma mark -  支付宝、工行，农行付款前的订单验证
-(void)ConfirmThePayment:(NSString *)bankType OrderType:(NSString *)orderType{
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
        NSString *payMoneys =[NSString string];
        if (self.walletAssetsSwitch.on==YES) {
            payMoneys =[NSString stringWithFormat:@"%.2f",self.walletMoney];
        }
        if (self.decorationLoanAssetsSwitch.on ==YES) {
            if (payMoneys.length>0) {
                payMoneys =[NSString stringWithFormat:@"%@,%.2f",payMoneys,self.decorationMoney];
            }else{
                payMoneys =[NSString stringWithFormat:@"%.2f",self.decorationMoney];
            }
            
        }
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0310\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"orderCodes\":\"%@\",\"amounts\":\"%@\",\"payWays\":\"%@\",\"payMoneys\":\"%@\",\"payPassword\":\"%@\",\"orderType\":\%@}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.orderNo,self.amounts,bankType,payMoneys,[util md5:self.passWord.text],orderType];
        
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
                            WTBWebViewViewController *bankPayVC=[[WTBWebViewViewController alloc]init];
                            bankPayVC.requesUrl=[jsonDict objectForKey:@"payUrl"];
//                            if ([self.typeStr isEqualToString:@"商城"]) bankPayVC.typeStr=@"商城";
                            [self.navigationController pushViewController:bankPayVC animated:YES];
                        }else{
                            [self stopRequest];
                            if (self.remaining ==0) {
//                                customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
//                                customPromp.contenttxt =@"支付成功";
//                                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
//                                [customPromp addGestureRecognizer:tap];
                                [TLToast showWithText:@"支付成功"];
                                [self.navigationController popViewControllerAnimated:YES];
//                                [customPromp show];
                            }else{
                                OnlinePayViewController *onlinepay =[[OnlinePayViewController alloc] init];
                                onlinepay.serviceNameStr =self.serviceNameStr;
                                onlinepay.remaining =self.remaining;
                                onlinepay.typeStr =self.typeStr;
                                onlinepay.orderNo =self.orderNo;
                                onlinepay.amounts =self.amounts;
                                [self.navigationController pushViewController:onlinepay animated:YES];
                            }
                            
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
                                  customPromp.contenttxt =@"支付异常请联系客户：4008887372！";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
                              });
                          }
                               method:url postDict:nil];
    });
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
//        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//        [postDict setObject:@"ID0251" forKey:@"cmdID"];
//        [postDict setObject:string_token forKey:@"token"];
//        [postDict setObject:string_userid forKey:@"userID"];
//        [postDict setObject:@"ios" forKey:@"deviceType"];
//        [postDict setObject:kCityCode forKey:@"cityCode"];
//        NSString *string=[postDict JSONString];
//        
//        NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
//        [bodyDic setObject:self.orderNo forKey:@"orderNo"];
//        [bodyDic setObject:[NSString stringWithFormat:@"%f",self.moneyFloat] forKey:@"amount"];
//        [bodyDic setObject:bankType forKey:@"bankType"];
//        [bodyDic setObject:orderType forKey:@"orderType"];
//        NSString *string02=[bodyDic JSONString];
//        
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
//                 NSLog(@"验证订单返回信息：%@",jsonDict);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self stopRequest];
//                    if (kResCode == 10002 || kResCode == 10003) {
//                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
//                        [login show];
//                        return;
//                    }
//                    else if (kResCode == 102511) {
//                        if([bankType isEqualToString:@"alipay"]){
//                            [self aliPayOrderNo:[jsonDict objectForKey:@"payOrderCode"] alipayNotifyURL:[jsonDict objectForKey:@"payUrl"]];
//                        }
//                        else{
//                            BankPayViewController *bankPayVC=[[BankPayViewController alloc]init];
//                            bankPayVC.payUrl=[jsonDict objectForKey:@"payUrl"];
//                            if ([self.typeStr isEqualToString:@"商城"]) bankPayVC.typeStr=@"商城";
//                            [self.navigationController pushViewController:bankPayVC animated:YES];
//                        }
//                    }
//                    else if (kResCode == 102512) {
//                        [TLToast showWithText:@"订单不合法"];
//                    }else if (kResCode == 102515) {
//                        [TLToast showWithText:@"订单异常,请联系客服"];
//                    }
//                    else{
//                        [TLToast showWithText:@"操作异常"];
//                    }
//                });
//            });
//        }
//                          failedBlock:^{
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [self stopRequest];
//                                  [TLToast showWithText:@"操作异常"];
//                              });
//                          }
//                               method:url postDict:post];
//    });
    
}

#pragma mark -
#pragma mark - 支付宝付款
- (void)aliPayOrderNo:(NSString *)alipayOrderNo alipayNotifyURL:(NSString *)alipayNotifyUrl{
    
    Product *product = [[Product alloc] init];
    if ([self.typeStr isEqualToString:@"商城"]) {    //2.0商城的
        //product.subject = @"商城";
        product.subject =self.serviceNameStr;   //订单名字，传的总订单下拆分开的所有子订单id编号
        product.price = self.moneyFloat;   //价格，服务器返回的单位元
    }
    else{    //1.0设计师、工长、监理的
        product.subject = [NSString stringWithFormat:@"阶段：%@",self.serviceNameStr]; //订单名字，传的当前阶段名
        product.price = self.moneyFloat;   //价格，服务器返回的单位分，转换为单位元
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
    NSString *seller = @"yangf@qttecx.com";          //收款账号
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
#pragma mark - 商城支付成功后的通知处理
- (void)handleKNCShoppingMallPaySuccess {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==100) {
        if (buttonIndex == 0) {
            IDIAI3RechargeViewController*recharge =[[IDIAI3RechargeViewController alloc] init];
            [self.navigationController pushViewController:recharge animated:YES];
        } else {
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
    }
}
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.passWord resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    _theTableView.frame =CGRectMake(0, -126*568/kMainScreenHeight, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight);
    [UIView commitAnimations];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    _theTableView.frame =CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight);
    [UIView commitAnimations];
    return YES;
}
@end
