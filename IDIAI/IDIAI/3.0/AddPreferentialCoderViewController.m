//
//  AddPreferentialCoderViewController.m
//  IDIAI
//
//  Created by Ricky on 16/3/14.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "AddPreferentialCoderViewController.h"
#import "FlickingViewController.h"
#import "LoginView.h"
#import "TLToast.h"
@interface AddPreferentialCoderViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *preferential;
@end

@implementation AddPreferentialCoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FlickingSucceed:) name:@"FlickingSucceed" object:nil];
    self.view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    UIImageView *nameImage =[[UIImageView alloc] initWithFrame:CGRectMake(11, 18, kMainScreenWidth-22, 41)];

    nameImage.backgroundColor =[UIColor whiteColor];
    nameImage.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
    nameImage.layer.borderWidth = 1;
    nameImage.layer.masksToBounds = YES;
    nameImage.layer.cornerRadius = 5;
    [self.view addSubview:nameImage];
    

    
    self.preferential =[[UITextField alloc] initWithFrame:CGRectMake(22, 18, kMainScreenWidth-44, 41)];
    self.preferential.placeholder =@"请输入优惠券兑换码";
    self.preferential.delegate =self;
    self.preferential.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:self.preferential];
    
    UIButton *completebtn =[UIButton buttonWithType:UIButtonTypeCustom];
    completebtn.frame =CGRectMake(11, nameImage.frame.size.height+nameImage.frame.origin.y+32, kMainScreenWidth-22, 40);
    [completebtn setBackgroundColor:kThemeColor];
    completebtn.layer.cornerRadius = 5;
    completebtn.layer.masksToBounds = YES;
    [completebtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [completebtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completebtn];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(5, 5, 22, 22)];
    [rightButton setImage:[UIImage imageNamed:@"ic_saoyisao.png"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
//    [rightButton setTitle:@"添加优惠码" forState:UIControlStateNormal];
//    [rightButton setTitle:@"添加优惠码" forState:UIControlStateHighlighted];
//    rightButton.titleLabel.font =[UIFont systemFontOfSize:15.0];
//    [rightButton setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight)
          forControlEvents:UIControlEventTouchUpInside];
    //        rightButton.backgroundColor =[UIColor redColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem =rightItem;
    // Do any additional setup after loading the view.
}
-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)nextAction:(id)sender{
    if (self.preferential.text.length==0) {
        [TLToast showWithText:@"请输入优惠券兑换码"];
        return;
    }
    [self requstexchangeL:self.preferential.text];
}
//扫一扫
-(void)PressBarItemRight{
    FlickingViewController *fliVC=[[FlickingViewController alloc]init];
    fliVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:fliVC animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlickingSucceed" object:nil];
}
-(void)FlickingSucceed:(NSNotification *)notif{
    self.preferential.text =notif.object;
    [self requstexchangeL:notif.object];
}
-(void)requstexchangeL:(NSString *)couponCode{
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
        [postDict setObject:@"ID0348" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"couponCode":[NSString stringWithFormat:@"%@",couponCode]};
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
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 103481) {
                        [self stopRequest];
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlickingSucceed" object:nil];
                        [self performSelector:@selector(delayMethod:) withObject:nil afterDelay:0.5f];
                        
                        [TLToast showWithText:@"兑换成功"];
                    } else if (kResCode == 103489) {
                        [self stopRequest];
                        [TLToast showWithText:@"兑换失败"];
                    }else if (kResCode == 103482){
                        [self stopRequest];
                        [TLToast showWithText:@"该用户已兑换满该优惠券"];
                    }else if (kResCode == 103483){
                        [self stopRequest];
                        [TLToast showWithText:@"已经兑换完了"];
                    }else if (kResCode == 103484){
                        [self stopRequest];
                        [TLToast showWithText:@"该优惠码已过期（活动已结束）"];
                    }else if (kResCode ==103485){
                        [self stopRequest];
                        [TLToast showWithText:@"兑换码错误"];
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
}
-(void)delayMethod:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
