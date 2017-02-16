//
//  RefusedViewController.m
//  IDIAI
//
//  Created by Ricky on 16/5/23.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "RefusedViewController.h"
#import "CustomPromptView.h"
#import "LoginView.h"
#import "TLToast.h"
@interface RefusedViewController ()<UITextViewDelegate>{
    CustomPromptView *customPromp;
}
@property(nonatomic,strong)UITextView *contenttxt;
@property(nonatomic,strong)UIButton *releasebtn;
@property(nonatomic,strong)UIView *hiddenView;
@property(nonatomic,strong)UILabel *placeholder;
@end

@implementation RefusedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.title =@"拒绝变更理由";
    self.contenttxt=[[UITextView alloc] initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, 100)];
    self.contenttxt.backgroundColor =[UIColor whiteColor];
    self.contenttxt.font =[UIFont systemFontOfSize:14];
    self.contenttxt.layer.cornerRadius=5;
    self.contenttxt.clipsToBounds=YES;
    self.contenttxt.delegate =self;
    self.contenttxt.layer.borderColor =[UIColor colorWithHexString:@"#cccccc"].CGColor;
    self.contenttxt.layer.borderWidth = 1;
    self.contenttxt.returnKeyType =UIReturnKeyDefault;
    [self.view addSubview:self.contenttxt];
    
    self.placeholder =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contenttxt.frame.size.width-20, 14)];
    self.placeholder.textColor =kColorWithRGB(217, 217, 221);
    NSString *placeholderstr =@"拒绝变更理由不能为空请输入5-500字";
    UIFont *font1= [UIFont fontWithName:@"Arial" size:14];
    self.placeholder.text =placeholderstr;
    self.placeholder.font =font1;
    self.placeholder.numberOfLines =0;
    //    self.placeholder.lineBreakMode = UILineBreakModeWordWrap;
    [self.contenttxt addSubview:self.placeholder];
    
    self.releasebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.releasebtn.frame = CGRectMake(0, 0, 42, 42);
    [self.releasebtn setTitle:@"发布" forState:UIControlStateNormal];
    [self.releasebtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
    //右移
    [self.releasebtn addTarget:self action:@selector(releaseAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.releasebtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.hiddenView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.hiddenView.backgroundColor =[UIColor clearColor];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.hiddenView addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
-(void)hideKeyboard:(UIGestureRecognizer *)sender{
    [self.contenttxt resignFirstResponder];
    [self.hiddenView removeFromSuperview];
}
-(void)releaseAction:(id)sender{
    if (self.contenttxt.text.length<5||self.contenttxt.text.length>500) {
        [TLToast showWithText:@"拒绝变更理由不能为空请输入5-500字"];
        return;
    }
    [self startRequestWithString:@"提交中..."];
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
        [postDict setObject:@"ID0356" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"contractId":[NSNumber numberWithInt:self.contractId],@"actionType":@0,@"refuseReason":self.contenttxt.text};
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
                NSLog(@"login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRequest];
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        self.view.tag = 1002;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            
                            [login show];
                            
                        });
                        
                        return;
                    }
                    
                    if (kResCode == 103561) {
                        [self stopRequest];
                        //                        [self.mtableview launchRefreshing];
//                        [self requestContractDetail];
                        self.backDone(YES);
                        [self.navigationController popViewControllerAnimated:YES];
                        [TLToast showWithText:@"拒绝变更成功"];
                    } else if (kResCode == 103569) {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"拒绝变更失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"合同取消失败"];
                    } else  {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"拒绝变更失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"该合同已被拒绝"];
                    }
                    //                            }else if (kResCode == 11305) {
                    //                                [TLToast showWithText:@"支付密码不正确"];
                    //                            }else{
                    //                                [TLToast showWithText:@"订单确认失败"];
                    //                            }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                  customPromp.contenttxt =@"操作失败";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
                                  //                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });

}
-(void)hideAction:(id)sender{
    [customPromp dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view addSubview:self.hiddenView];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.hiddenView removeFromSuperview];
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    //    self.contenttxt.text =  textView.text;
    if (textView.text.length == 0) {
        NSString *placeholderstr =@"拒绝变更理由不能为空请输入5-500字";
        self.placeholder.text =placeholderstr;
    }else{
        self.placeholder.text = @"";
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
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
