//
//  ModifyPsdViewController.m
//  IDIAI
//
//  Created by Ricky on 14-12-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ModifyPsdViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "AutomaticLogin.h"
#import "NSStringAdditions.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "TLToast.h"
#import "util.h"

#define kPRBGColor [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:.7]

@interface ModifyPsdViewController () <LoginViewDelegate> {
    TPKeyboardAvoidingTableView *_theTableView;
    UITextField *_oldPsdTF;
    UITextField *_newPsdTF;
    UITextField *_newPsdTF2;
    NSArray *_psdTFArr;
}

@end

@implementation ModifyPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    _theTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:kTableViewWithTabBarFrame style:UITableViewStylePlain];
    _theTableView.dataSource = self;
    _theTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_theTableView];
    
    _oldPsdTF = [[UITextField alloc]initWithFrame:CGRectMake(115, 0, kMainScreenWidth - 115, 44)];
    _oldPsdTF.placeholder = @"请输入旧密码";
    _oldPsdTF.secureTextEntry = YES;
    _newPsdTF = [[UITextField alloc]initWithFrame:CGRectMake(115, 0, kMainScreenWidth - 115, 44)];
    _newPsdTF.placeholder = @"请输入新密码";
    _newPsdTF.secureTextEntry = YES;
    _newPsdTF2 = [[UITextField alloc]initWithFrame:CGRectMake(115, 0, kMainScreenWidth - 115, 44)];
    _newPsdTF2.placeholder = @"再次确认";
    _newPsdTF2.secureTextEntry = YES;
    _psdTFArr = @[_oldPsdTF, _newPsdTF, _newPsdTF2];
    
    //footerView
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 300)];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.layer.cornerRadius = 3;
    doneBtn.frame = CGRectMake(10, 50, kMainScreenWidth - 10 * 2, 40);
    doneBtn.backgroundColor = kThemeColor;
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(clickDoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:doneBtn];
    
    _theTableView.tableFooterView = footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ModifyPsdCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *titleArr = @[@"旧密码",@"新密码",@"确认密码"];
    
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
    
    cell.accessoryView = [_psdTFArr objectAtIndex:indexPath.row];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickDoneBtn:(UIButton *)btn {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:User_Password] isEqualToString:[util md5:_newPsdTF2.text]]) {
        [TLToast showWithText:@"新旧密码不能一致，请重新输入"];
        return;
    }
    if([util checkKey:_oldPsdTF.text] && [util checkKey:_newPsdTF.text] && [util checkKey:_newPsdTF2.text]){
        if([util isConnectionAvailable]){
            if ([_newPsdTF2.text isEqualToString:_newPsdTF.text]) {
                [self modifyPsdFromServer];
            } else {
                [TLToast showWithText:@"两次输入的密码不一致" duration:1.0];
            }
        }
        else
            [TLToast showWithText:@"无网络连接" duration:1.0];
    }
}

- (void)logout {
//    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
//    [[NSFileManager defaultManager] removeItemAtPath:aPath3 error:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:User_logo];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Name];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Password];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Token];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_ID];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Addrss];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Mobile];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_sex];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_nickName];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNCChangePasswordSuccess object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)modifyPsdFromServer {
    [self startRequestWithString:@"修改密码中..."];
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
        [postDict setObject:@"ID0047" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        
        NSDictionary *bodyDic = @{@"oldPwd":[util md5:_oldPsdTF.text],
                                  @"newPwd":[util md5:_newPsdTF2.text]
                                  };
        NSString *string02=[bodyDic JSONString];
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
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
                    
                    if (kResCode == 10471) {
                        [self stopRequest];
                        [TLToast showWithText:@"密码修改成功，请重新登录"];
                        [self logout];
                    } else if (kResCode == 10472) {
                        [self stopRequest];
                        [TLToast showWithText:@"请填写正确的旧密码"];
                    } else if (kResCode == 10473) {
                        [self stopRequest];
                        [TLToast showWithText:@"密码不符合要求"];
                    } else if (kResCode == 10479) {
                        [self stopRequest];
                        [TLToast showWithText:@"操作失败"];
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

#pragma mark -
#pragma mark - LoginDelegate
-(void)logged:(NSDictionary *)dict{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
