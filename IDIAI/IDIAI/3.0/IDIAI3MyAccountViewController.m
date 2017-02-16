//
//  IDIAI3MyAccountViewController.m
//  IDIAI
//
//  Created by Ricky on 15/11/26.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3MyAccountViewController.h"
#import "HexColor.h"
#import "LoginView.h"
#import "TLToast.h"
#import "CommonFreeViewController.h"
#import "IDIAI3RechargeViewController.h"
#import "IDIAI3AccountListViewController.h"
#import "OnlinePayViewController.h"
#import "RechargeBargainMoneyViewController.h"
@interface IDIAI3MyAccountViewController ()<LoginViewDelegate>
@property(nonatomic,strong)UIView *headback;
@property(nonatomic,strong)NSDictionary *datadic;
@property(nonatomic,strong)UILabel *alltitle;
@property(nonatomic,strong)UILabel *totalAssets;
@property(nonatomic,strong)UILabel *walletAssets;
@property(nonatomic,strong)UILabel *decorationLoanAssets;
@property(nonatomic,assign)BOOL isrequst;
@end

@implementation IDIAI3MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];

    self.title =@"我的账户";
    self.view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.headback =[[UIView alloc] initWithFrame:CGRectMake(0,84, kMainScreenWidth, 108)];
    self.headback.backgroundColor =[UIColor whiteColor];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAccountAction:)];
    [self.headback addGestureRecognizer:tap];
    [self.view addSubview:self.headback];
    
    self.alltitle =[[UILabel alloc] initWithFrame:CGRectMake(16, 24, 74, 19)];
    self.alltitle.text =@"总资产:";
    self.alltitle.font =[UIFont boldSystemFontOfSize:19];
    self.alltitle.textColor =[UIColor colorWithHexString:@"#ef6562"];
    [self.headback addSubview:self.alltitle];
    
    
    self.totalAssets =[[UILabel alloc] initWithFrame:CGRectMake(self.alltitle.frame.origin.x+self.alltitle.frame.size.width, self.alltitle.frame.origin.y, kMainScreenWidth-34, 19)];
    self.totalAssets.text =@"¥ 0.00";
    self.totalAssets.textColor =[UIColor colorWithHexString:@"#ef6562"];
    
    self.totalAssets.font =[UIFont boldSystemFontOfSize:19];
    [self.headback addSubview:self.totalAssets];
    
    self.walletAssets =[[UILabel alloc] initWithFrame:CGRectMake(self.alltitle.frame.origin.x, self.alltitle.frame.origin.y+self.alltitle.frame.size.height+24, (kMainScreenWidth-34)/2, 17)];
    self.walletAssets.textColor =[UIColor colorWithHexString:@"#575757"];
    self.walletAssets.font =[UIFont systemFontOfSize:17];
    self.walletAssets.text =@"¥ 0.00";
    [self.headback addSubview:self.walletAssets];
    
    self.decorationLoanAssets =[[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-34)/2+self.alltitle.frame.origin.x,self.walletAssets.frame.origin.y, (kMainScreenWidth-34)/2, 17)];
    self.decorationLoanAssets.textColor =[UIColor colorWithHexString:@"#575757"];
    self.decorationLoanAssets.font =[UIFont systemFontOfSize:17];
    self.decorationLoanAssets.text =@"¥ 0.00";
    [self.headback addSubview:self.decorationLoanAssets];
    
//    UIImageView *arrow =[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-15-25, (self.headback.frame.size.height-25)/2, 25, 25)];
//    arrow.image =[UIImage imageNamed:@"ic_jiantou.png"];
//    [self.headback addSubview:arrow];
    
    UIButton *topupbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    topupbtn.frame =CGRectMake(0, self.headback.frame.origin.y+self.headback.frame.size.height+10, kMainScreenWidth/2, 50);
    topupbtn.backgroundColor =[UIColor whiteColor];
    [topupbtn addTarget:self action:@selector(topUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topupbtn];
    
    UIImageView *accountimage =[[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 28, 28)];
    accountimage.image =[UIImage imageNamed:@"ic_dingjin.png"];
    [topupbtn addSubview:accountimage];
    
    UILabel *accounttitle =[[UILabel alloc] initWithFrame:CGRectMake(accountimage.frame.origin.x+accountimage.frame.size.width+15, 17.5, kMainScreenWidth/2-accountimage.frame.origin.x+accountimage.frame.size.width-15, 15)];
    accounttitle.text =@"自定义缴定";
    accounttitle.textColor =[UIColor colorWithHexString:@"#575757"];
    [topupbtn addSubview:accounttitle];
    
    UIImageView *lineimage =[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-1, 10, 1, 30)];
    lineimage.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [topupbtn addSubview:lineimage];
    
    UIButton *loanbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loanbtn.frame =CGRectMake(kMainScreenWidth/2, self.headback.frame.origin.y+self.headback.frame.size.height+10, kMainScreenWidth/2, 50);
    loanbtn.backgroundColor =[UIColor whiteColor];
    [loanbtn addTarget:self action:@selector(loanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loanbtn];
    
    UIImageView *loanimage =[[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 28, 28)];
    loanimage.image =[UIImage imageNamed:@"ic_zhuangxiudai_nor.png"];
    [loanbtn addSubview:loanimage];
    
    UILabel *loantitle =[[UILabel alloc] initWithFrame:CGRectMake(loanimage.frame.origin.x+loanimage.frame.size.width+15, 17.5, kMainScreenWidth/2-loanimage.frame.origin.x+loanimage.frame.size.width-15, 15)];
    loantitle.text =@"申请贷款";
    loantitle.textColor =[UIColor colorWithHexString:@"#575757"];
    [loanbtn addSubview:loantitle];
    
    
//    UIScrollView *backscroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, loanbtn.frame.origin.y+loanbtn.frame.size.height, kMainScreenWidth, self.view.frame.size.height-loanbtn.frame.origin.y-loanbtn.frame.size.height)];
//    UIImageView *lineimage2 =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
//    lineimage2.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//    [backscroll addSubview:lineimage2];
//    backscroll.backgroundColor =[UIColor whiteColor];
//    for (int i=0; i<2; i++) {
//        UIButton *money =[UIButton buttonWithType:UIButtonTypeCustom];
//        money.tag =i+1;
//        money.frame =CGRectMake((kMainScreenWidth-292.5*kMainScreenWidth/320)/2, 10+(10+84.5*kMainScreenWidth/320)*i, 292.5*kMainScreenWidth/320, 84.5*kMainScreenWidth/320);
//        [money setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_youhuiqian_%d",i+1]] forState:UIControlStateNormal];
//        [money addTarget:self action:@selector(amountAction:) forControlEvents:UIControlEventTouchUpInside];
////        money.backgroundColor =[UIColor orangeColor];
//        [backscroll addSubview:money];
//    }
//    [self.view addSubview:backscroll];
    self.isrequst =YES;
    // Do any additional setup after loading the view.
}
-(void)showAccountAction:(UIGestureRecognizer *)sender{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:User_Token]) {
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
    IDIAI3AccountListViewController *account =[[IDIAI3AccountListViewController alloc] init];
    self.isrequst=NO;
    [self.navigationController pushViewController:account animated:YES];
}
-(void)amountAction:(UIButton *)sender{
    OnlinePayViewController *online =[[OnlinePayViewController alloc] init];
    online.istopup =YES;
    online.isamount =YES;
    online.amount =sender.tag *1000;
    online.remaining =sender.tag *1000;
    [self.navigationController pushViewController:online animated:YES];
}
- (void)PressBarItemLeft {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.isrequst ==YES) {
        [self requestMyAccount];
        [self reloadData];
    }
    self.isrequst =YES;
}
-(void)topUpAction:(UIButton *)sender{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:User_Token]) {
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
//    RechargeBargainMoneyViewController * rechargeVC  = [[RechargeBargainMoneyViewController alloc]init];
//    rechargeVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:rechargeVC animated:YES];
    OnlinePayViewController *online =[[OnlinePayViewController alloc] init];
    online.istopup =YES;
    [self.navigationController pushViewController:online animated:YES];
//    IDIAI3RechargeViewController*recharge =[[IDIAI3RechargeViewController alloc] init];
//    [self.navigationController pushViewController:recharge animated:YES];
}
-(void)loanAction:(UIButton *)sender{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:User_Token]) {
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
    
    CommonFreeViewController *common =[[CommonFreeViewController alloc] init];
    common.type =2;
    common.isdelegate =YES;
    [self.navigationController pushViewController:common animated:YES];
}
-(void)reloadData{
    NSString *totalAssetsstr =[NSString string];
    if (!self.datadic) {
        totalAssetsstr =@"¥ 0.00";
        self.totalAssets.text =totalAssetsstr;
    }else{
        totalAssetsstr =[NSString stringWithFormat:@"¥ %@",[self.datadic objectForKey:@"totalAssets"]];
        self.totalAssets.text =[self getAmount:totalAssetsstr othercount:1];
    }
    
    
    
    NSString *walletAssetsstr =[NSString string];
    if (!self.datadic) {
        walletAssetsstr =@"¥ 0.00";
        self.walletAssets.text =walletAssetsstr;
    }else{
        walletAssetsstr =[NSString stringWithFormat:@"定金:¥ %@",[self.datadic objectForKey:@"walletAssets"]];
        self.walletAssets.text =[self getAmount:walletAssetsstr othercount:4];
    }
    
    NSString *decorationLoanAssetsstr =[NSString string];
    if (!self.datadic) {
        decorationLoanAssetsstr =@"¥ 0.00";
        self.decorationLoanAssets.text =decorationLoanAssetsstr;
    }else{
        decorationLoanAssetsstr =[NSString stringWithFormat:@"贷款:¥ %@",[self.datadic objectForKey:@"decorationLoanAssets"]];
        self.decorationLoanAssets.text =[self getAmount:decorationLoanAssetsstr othercount:4];
    }
    
    
}
-(NSMutableString *)getAmount:(NSString *)str othercount:(int)othercount{
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:str];
    int lenth =(int)str.length-othercount-3;
    int count =0;
    while (lenth-3>0) {
        lenth-=3;
        [String1 insertString:@"," atIndex:str.length-6-3*count];
        count++;
    }
    return String1;
}
-(void)requestMyAccount{
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
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }
                if (code==102731) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        self.datadic =jsonDict;
                        [self reloadData];
                    });
                }
                else if (code==102809) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"获取账户信息失败"];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"获取账户信息失败"];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [TLToast showWithText:@"获取账户信息失败"];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
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
