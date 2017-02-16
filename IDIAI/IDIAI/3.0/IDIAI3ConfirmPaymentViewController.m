//
//  IDIAI3ConfirmPaymentViewController.m
//  IDIAI
//
//  Created by Ricky on 15/12/30.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3ConfirmPaymentViewController.h"
#import "CommentViewForGJS.h"
#import "IDIAIAppDelegate.h"
#import "InputLoginPsdViewController.h"
#import "TLToast.h"
#import "util.h"
#import "LoginView.h"
#import "CustomPromptView.h"
#import "commentAfterServiceViewController.h"
@interface IDIAI3ConfirmPaymentViewController ()<UITableViewDelegate,UITableViewDataSource,CommentsViewDelegate,UITextFieldDelegate>{
    CommentViewForGJS *comment;
    CustomPromptView *customPromp;
}
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UILabel *payForMoneylbl;
@property(nonatomic,strong)UITextField *passWord;
@end

@implementation IDIAI3ConfirmPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"确认付款";
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:NO animated:YES];
    self.table =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    self.table.delegate =self;
    self.table.dataSource =self;
    self.table.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    // Do any additional setup after loading the view.
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backView.backgroundColor =[UIColor clearColor];
    return backView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 50;
    }else if (indexPath.section==1){
        NSString *contentstr =@"亲，恭喜您的本项服务已顺利完成，请根据您的装修体验，对本次服务如实评审，您的评审结果，有助于屋托邦对服务提供方的检验考核，去行使您的权利吧：";
        CGSize labelSize = {0, 0};
        labelSize = [contentstr sizeWithFont:[UIFont systemFontOfSize:12]
                           constrainedToSize:CGSizeMake(kMainScreenWidth-40, 2000)
                               lineBreakMode:UILineBreakModeWordWrap];
        return 118+9+labelSize.height;
    }else if (indexPath.section ==2){
        return 95;
    }else{
        return 43;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier1 = @"ConfirmPayMentCell1";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (!cell1) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        if (indexPath.section==1) {
            UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 12, kMainScreenWidth-40, 17)];
            titlelbl.textColor =[UIColor colorWithHexString:@"#575757"];
            NSMutableAttributedString *totalFeestr =[[NSMutableAttributedString alloc] initWithString:@"服务考评( 滑动评分 )"];
            [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,4)];
            [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(4,totalFeestr.length-4)];
            titlelbl.attributedText =totalFeestr;
            titlelbl.font =[UIFont systemFontOfSize:17.0];
            [cell1 addSubview:titlelbl];
            
            UILabel *contentlbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 38, kMainScreenWidth-40, 12)];
            contentlbl.textColor =[UIColor colorWithHexString:@"#575757"];
            UIFont *font = [UIFont fontWithName:@"Arial" size:12];
            CGSize size = CGSizeMake(kMainScreenWidth-40,2000);
            NSString *context=@"亲，恭喜您的本项服务已顺利完成，请根据您的装修体验，对本次服务如实评审，您的评审结果，有助于屋托邦对服务提供方的检验考核，去行使您的权利吧：";
            CGSize labelsize = [context sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            contentlbl.lineBreakMode = UILineBreakModeWordWrap;
            contentlbl.numberOfLines =0;
            contentlbl.frame =CGRectMake(contentlbl.frame.origin.x, contentlbl.frame.origin.y, labelsize.width, labelsize.height);
            contentlbl.text =context;
            contentlbl.font =font;
            [cell1 addSubview:contentlbl];
            
            UILabel *lab_one=[[UILabel alloc]initWithFrame:CGRectMake(20, contentlbl.frame.origin.y+contentlbl.frame.size.height+9, 70, 20)];
            lab_one.font=[UIFont systemFontOfSize:15];
            lab_one.textAlignment=NSTextAlignmentLeft;
            lab_one.backgroundColor=[UIColor clearColor];
            lab_one.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
            lab_one.tag =100;
            [cell1 addSubview:lab_one];
            
            
            
            self.numberStart = 0;
            self.startView = [[UIView alloc] initWithFrame:CGRectMake(100, lab_one.frame.origin.y-1, 160, 20)];
            [self.startView setBackgroundColor:[UIColor clearColor]];
            [cell1 addSubview:self.startView];
            _imageViewArray = [[NSMutableArray alloc] initWithCapacity:5];
            for (int i = 0; i < 5; i++) {
                @autoreleasepool {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*20, 3,15, 15)];
                    [self.imageViewArray addObject:imageView];
                    [self.startView addSubview:imageView];
                }
            }
            [self numberStartReLoad:self.numberStart];
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
            [self.startView addGestureRecognizer:panGesture];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoGesture:)];
            [self.startView addGestureRecognizer:tapGesture];
            
            UILabel *lab_two=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.startView.frame)+6, 70, 20)];
            lab_two.font=[UIFont systemFontOfSize:15];
            lab_two.textAlignment=NSTextAlignmentLeft;
            lab_two.backgroundColor=[UIColor clearColor];
            lab_two.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
            lab_two.tag =101;
            [cell1 addSubview:lab_two];
            
            self.numberStart_two = 0;
            self.startView_two = [[UIView alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(self.startView.frame)+5, 160, 20)];
            [self.startView_two setBackgroundColor:[UIColor clearColor]];
            [cell1 addSubview:self.startView_two];
            _imageViewArray_two = [[NSMutableArray alloc] initWithCapacity:5];
            for (int i = 0; i < 5; i++) {
                @autoreleasepool {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*20, 3,15, 15)];
                    [self.imageViewArray_two addObject:imageView];
                    [self.startView_two addSubview:imageView];
                }
            }
            [self numberStartReLoad_two:self.numberStart_two];
            UIPanGestureRecognizer *panGesture_two = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture_two:)];
            [self.startView_two addGestureRecognizer:panGesture_two];
            
            UITapGestureRecognizer *tapGesture_tow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoGesture_two:)];
            [self.startView_two addGestureRecognizer:tapGesture_tow];
            
            UILabel *lab_three=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.startView_two.frame)+6, 70, 20)];
            lab_three.font=[UIFont systemFontOfSize:15];
            lab_three.textAlignment=NSTextAlignmentLeft;
            lab_three.backgroundColor=[UIColor clearColor];
            lab_three.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
            lab_three.tag=102;
            [cell1 addSubview:lab_three];
            
            self.numberStart_three = 0;
            self.startView_three = [[UIView alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(self.startView_two.frame)+5, 160, 20)];
            [self.startView_three setBackgroundColor:[UIColor clearColor]];
            [cell1 addSubview:self.startView_three];
            _imageViewArray_three = [[NSMutableArray alloc] initWithCapacity:5];
            for (int i = 0; i < 5; i++) {
                @autoreleasepool {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*20, 3,15, 15)];
                    [self.imageViewArray_three addObject:imageView];
                    [self.startView_three addSubview:imageView];
                }
            }
            [self numberStartReLoad_three:self.numberStart_three];
            UIPanGestureRecognizer *panGesture_three = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture_three:)];
            [self.startView_three addGestureRecognizer:panGesture_three];
            
            UITapGestureRecognizer *tapGesture_three = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoGesture_three:)];
            [self.startView_three addGestureRecognizer:tapGesture_three];
        }
        if (indexPath.section ==2) {
            UILabel *paypstitle =[[UILabel alloc] initWithFrame:CGRectMake(16, 23, 70, 16)];
            paypstitle.text =@"支付密码";
            paypstitle.textColor =[UIColor colorWithHexString:@"#575757"];
            [cell1 addSubview:paypstitle];
            
            self.passWord =[[UITextField alloc] initWithFrame:CGRectMake(90, paypstitle.frame.origin.y-12, kMainScreenWidth-111, 40)];
            self.passWord.delegate=self;
            self.passWord.layer.cornerRadius=8;
            self.passWord.clipsToBounds=YES;
            self.passWord.layer.borderWidth =1;
            self.passWord.layer.borderColor =[UIColor colorWithHexString:@"efeff4"].CGColor;
            self.passWord.placeholder =@"  请输入屋托邦平台支付密码";
            self.passWord.font =[UIFont systemFontOfSize:16];
            self.passWord.secureTextEntry = YES;
            self.passWord.textColor =[UIColor colorWithHexString:@"#575757"];
            self.passWord.returnKeyType=UIReturnKeyDone;
            [cell1 addSubview:self.passWord];
            
            UIButton *setting =[UIButton buttonWithType:UIButtonTypeCustom];
            setting.titleLabel.font =[UIFont systemFontOfSize:14];
            setting.frame =CGRectMake(kMainScreenWidth-15-154, self.passWord.frame.size.height+self.passWord.frame.origin.y+10, 154, 14);
            [setting setTitle:@"设置平台支付密码" forState:UIControlStateNormal];
            [setting setTitle:@"设置平台支付密码" forState:UIControlStateHighlighted];
            [setting setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
            [setting setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateHighlighted];
            [setting addTarget:self action:@selector(payPassWordChange:) forControlEvents:UIControlEventTouchUpInside];
            [cell1 addSubview:setting];
        }
        if (indexPath.section ==3) {
            UIButton *completebtn =[UIButton buttonWithType:UIButtonTypeCustom];
            completebtn.frame =CGRectMake(11,1.5, kMainScreenWidth-22, 40);
            [completebtn setBackgroundColor:kThemeColor];
            completebtn.layer.cornerRadius = 5;
            completebtn.layer.masksToBounds = YES;
            [completebtn addTarget:self action:@selector(balancePayment:) forControlEvents:UIControlEventTouchUpInside];
            [completebtn setTitle:@"提交" forState:UIControlStateNormal];
            [cell1 addSubview:completebtn];
            cell1.backgroundColor =[UIColor clearColor];
        }
    }
    if (indexPath.section ==0) {
        self.payForMoneylbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 17, kMainScreenWidth-30, 17)];
        self.payForMoneylbl.textColor=[UIColor colorWithHexString:@"#ef6562"];
        self.payForMoneylbl.font =[UIFont boldSystemFontOfSize:17.0];
        self.payForMoneylbl.text =[NSString stringWithFormat:@"付款金额 ¥ %.2f",self.payforMoney];
        [cell1 addSubview:self.payForMoneylbl];
    }
    if (indexPath.section ==1) {
        NSArray *arr_;
        if(self.orderType==1) arr_=@[@"服务态度",@"设计水平",@"沟通能力"];
        else if(self.orderType==4) arr_=@[@"服务态度",@"施工质量",@"进度控制"];
        else if(self.orderType==6) arr_=@[@"服务态度",@"专业技能",@"沟通能力"];
        UILabel *lab_one =(UILabel *)[cell1 viewWithTag:100];
        lab_one.text =arr_[0];
        //        lab_one.textColor =[UIColor darkGrayColor];
        //加载星级（0-10,0表示无星级）
        
        
        /*2222*/
        UILabel *lab_two =(UILabel *)[cell1 viewWithTag:101];
        lab_two.text =arr_[1];
        //        lab_two.textColor =[UIColor darkGrayColor];
        
        //加载星级（0-10,0表示无星级）
        
        
        /*3333*/
        
        
        UILabel *lab_three =(UILabel *)[cell1 viewWithTag:102];
        lab_three.text =arr_[2];
        //        lab_three.textColor =[UIColor darkGrayColor];
        
        //加载星级（0-10,0表示无星级）
        
    }
    cell1.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell1;
}
-(void)payPassWordChange:(id)sender{
    InputLoginPsdViewController *inputLoginPsdVC = [[InputLoginPsdViewController alloc]init];
    inputLoginPsdVC.fromStr =self.fromStr;
    [self.navigationController pushViewController:inputLoginPsdVC animated:YES];
}
-(void)balancePayment:(UIButton *)sender{
    if (self.passWord.text.length==0) {
        [TLToast showWithText:@"请输入平台支付密码"];
        return;
    }
    if (self.numberStart==0) {
        [TLToast showWithText:@"请评价第一个星级"];
        return;
    }
    if (self.numberStart_two==0) {
        [TLToast showWithText:@"请评价第二个星级"];
        return;
    }
    if (self.numberStart_three==0) {
        [TLToast showWithText:@"请评价第三个星级"];
        return;
    }
    sender.userInteractionEnabled =NO;
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
        [postDict setObject:@"ID0335" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"payPassword":[util md5:self.passWord.text]};
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
                    [self stopRequest];
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        self.view.tag = 1002;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                        });
                        
                        return;
                    }
                    
                    if (kResCode == 103351) {
                        [TLToast showWithText:@"验证成功"];
                        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
                        NSDictionary *bodyDic = @{@"phaseOrderCode":self.orderCode,@"objLevel1":[NSString stringWithFormat:@"%f",self.numberStart/2],@"objLevel2":[NSString stringWithFormat:@"%f",self.numberStart_two/2],@"objLevel3":[NSString stringWithFormat:@"%f",self.numberStart_three/2]};
                        
                        __weak  typeof(self) weakself =self;
                        [self sendRequestToServerUrl:^(id responseObject) {
                            [weakself performSelector:@selector(handleAfterCommittingCommentInfoSuccess:) withObject:responseObject afterDelay:0];
                        } failedBlock:^(id responseObject) {
                            [weakself stopRequest];
                            sender.userInteractionEnabled =YES;
                            customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                            customPromp.contenttxt =@"操作失败";
                            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                            [customPromp addGestureRecognizer:tap];
                            [customPromp show];
                        } RequestUrl:url CmdID:@"ID0337" PostDict:[NSMutableDictionary dictionaryWithDictionary:bodyDic] RequestType:@"POST"];
                    
                    } else if (kResCode == 103359) {
                        sender.userInteractionEnabled =YES;
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"验证异常失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"验证异常失败"];
                    } else if (kResCode == 103353) {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"验证异常失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"验证异常失败"];
                        sender.userInteractionEnabled =YES;
                    }else if (kResCode == 103353){
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"密码失败次数超过5次，请24小时候再试";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"密码失败次数超过5次，请24小时候再试"];
                        sender.userInteractionEnabled =YES;
                    }else if (kResCode == 103354){
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付密码未设置";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"支付密码未设置"];
                        sender.userInteractionEnabled =YES;
                    }else if (kResCode == 103355){
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"密码校验不通过";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
                        //                        [TLToast showWithText:@"密码校验不通过"];
                        sender.userInteractionEnabled =YES;
                    }
                    
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                  customPromp.contenttxt =@"密码校验不通过";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
                              });
                          }
                               method:url postDict:post];
    });
}




-(void)handleAfterCommittingCommentInfoSuccess:(id)responseObject{
    //token为空或验证未通过处理 huangrun
    NSInteger resCode = [[responseObject objectForKey:@"resCode"] integerValue];
    if (resCode == 10002 || resCode == 10003) {
        self.view.tag = 1002;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loginViewShow];
            
        });
        
        return;
    }
    
    if (resCode == 103371) {
        [TLToast showWithText:@"付款成功"];
        commentAfterServiceViewController *  commentAfterServiceVC = [[commentAfterServiceViewController alloc]init];
        commentAfterServiceVC.phaseOrderCode =self.orderCode;
        [self.navigationController pushViewController:commentAfterServiceVC animated:YES];
        
    } else if (resCode == 103379) {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"付款失败";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
        //                                            [TLToast showWithText:@"付款失败"];
    } else if (resCode == 103372) {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"订单状态不对";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
        //                                            [TLToast showWithText:@"订单状态不对"];
    }else if (resCode == 103374) {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"订单不存在";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
        //                                            [TLToast showWithText:@"订单不存在"];
    }
    
    
}

-(void)hideAction:(id)sender{
    [customPromp dismiss];
}
#pragma mark -
#pragma mark - gestrue 11111

- (void)handlePanGesture:(UIGestureRecognizer *)sender {
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart = 0;
        }
        else if (translation.x >10 &&translation.x <25) {
            self.numberStart = 1;
        }
        else if (translation.x >= 25 &&translation.x <40) {
            self.numberStart = 2;
        }
        else if(translation.x >= 40 &&translation.x < 55){
            self.numberStart = 3;
        }
        else if (translation.x >= 55 &&translation.x < 70) {
            self.numberStart = 4;
        }
        else if(translation.x >=70 &&translation.x < 85)
        {
            self.numberStart = 5;
        }
        else if (translation.x >=85 &&translation.x <100) {
            self.numberStart = 6;
        }
        else if (translation.x >= 100 &&translation.x <115) {
            self.numberStart = 7;
        }
        else if(translation.x >= 115 &&translation.x < 130){
            self.numberStart = 8;
        }
        else if (translation.x >= 130 &&translation.x < 145) {
            self.numberStart = 9;
        }
        else if(translation.x >= 145 &&translation.x < 160)
        {
            self.numberStart = 10;
        }
        else if(translation.x >=160)
        {
            self.numberStart = 10;
        }
        [self numberStartReLoad:self.numberStart];
    }
}
-(void)handleTwoGesture:(UIGestureRecognizer *)sender{
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart = 0;
        }
        else if (translation.x >10 &&translation.x <20) {
            self.numberStart = 1;
        }
        else if (translation.x >= 20 &&translation.x <30) {
            self.numberStart = 2;
        }
        else if(translation.x >= 30 &&translation.x < 40){
            self.numberStart = 3;
        }
        else if (translation.x >= 40 &&translation.x < 50) {
            self.numberStart = 4;
        }
        else if(translation.x >=50 &&translation.x < 60)
        {
            self.numberStart = 5;
        }
        else if (translation.x >=60 &&translation.x <70) {
            self.numberStart = 6;
        }
        else if (translation.x >= 70 &&translation.x <80) {
            self.numberStart = 7;
        }
        else if(translation.x >= 80 &&translation.x < 90){
            self.numberStart = 8;
        }
        else if (translation.x >= 90 &&translation.x < 100) {
            self.numberStart = 9;
        }
        else if(translation.x >= 100 &&translation.x < 110)
        {
            self.numberStart = 10;
        }
        else if(translation.x >=110)
        {
            self.numberStart = 10;
        }
        [self numberStartReLoad:self.numberStart];
    }
    
}
- (void)numberStartReLoad:(NSInteger)number {
    int fullNum = (int)number/2;
    int halfNum = number%2;
    int emptyNum = 5 - fullNum -halfNum;
    NSMutableArray *starArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            if (fullNum != 0 ) {
                fullNum --;
                [starArray addObject:@"0"];
            }else if(fullNum == 0 &&halfNum != 0)
            {
                halfNum --;
                [starArray addObject:@"1"];
            }
            else if(fullNum == 0 &&halfNum == 0 &&emptyNum!= 0)
            {
                emptyNum --;
                [starArray addObject:@"2"];
            }
            UIImageView *imageView = [self.imageViewArray objectAtIndex:i];
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_xing_%@",[starArray objectAtIndex:i]]]];
        }
    }
}

#pragma mark -
#pragma mark - gestrue 222222

- (void)handlePanGesture_two:(UIGestureRecognizer *)sender {
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart_two = 0;
        }
        else if (translation.x >10 &&translation.x <25) {
            self.numberStart_two = 1;
        }
        else if (translation.x >= 25 &&translation.x <40) {
            self.numberStart_two = 2;
        }
        else if(translation.x >= 40 &&translation.x < 55){
            self.numberStart_two = 3;
        }
        else if (translation.x >= 55 &&translation.x < 70) {
            self.numberStart_two = 4;
        }
        else if(translation.x >=70 &&translation.x < 85)
        {
            self.numberStart_two = 5;
        }
        else if (translation.x >=85 &&translation.x <100) {
            self.numberStart_two = 6;
        }
        else if (translation.x >= 100 &&translation.x <115) {
            self.numberStart_two = 7;
        }
        else if(translation.x >= 115 &&translation.x < 130){
            self.numberStart_two = 8;
        }
        else if (translation.x >= 130 &&translation.x < 145) {
            self.numberStart_two = 9;
        }
        else if(translation.x >= 145 &&translation.x < 160)
        {
            self.numberStart_two = 10;
        }
        else if(translation.x >=160)
        {
            self.numberStart_two = 10;
        }
        [self numberStartReLoad_two:self.numberStart_two];
    }
}
-(void)handleTwoGesture_two:(UIGestureRecognizer *)sender{
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart_two = 0;
        }
        else if (translation.x >10 &&translation.x <20) {
            self.numberStart_two = 1;
        }
        else if (translation.x >= 20 &&translation.x <30) {
            self.numberStart_two = 2;
        }
        else if(translation.x >= 30 &&translation.x < 40){
            self.numberStart_two = 3;
        }
        else if (translation.x >= 40 &&translation.x < 50) {
            self.numberStart_two = 4;
        }
        else if(translation.x >=50 &&translation.x < 60)
        {
            self.numberStart_two = 5;
        }
        else if (translation.x >=60 &&translation.x <70) {
            self.numberStart_two = 6;
        }
        else if (translation.x >= 70 &&translation.x <80) {
            self.numberStart_two = 7;
        }
        else if(translation.x >= 80 &&translation.x < 90){
            self.numberStart_two = 8;
        }
        else if (translation.x >= 90 &&translation.x < 100) {
            self.numberStart_two = 9;
        }
        else if(translation.x >= 100 &&translation.x < 110)
        {
            self.numberStart_two = 10;
        }
        else if(translation.x >=110)
        {
            self.numberStart_two = 10;
        }
        [self numberStartReLoad_two:self.numberStart_two];
    }
    
}
- (void)numberStartReLoad_two:(NSInteger)number {
    int fullNum = (int)number/2;
    int halfNum = number%2;
    int emptyNum = 5 - fullNum -halfNum;
    NSMutableArray *starArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            if (fullNum != 0 ) {
                fullNum --;
                [starArray addObject:@"0"];
            }else if(fullNum == 0 &&halfNum != 0)
            {
                halfNum --;
                [starArray addObject:@"1"];
            }
            else if(fullNum == 0 &&halfNum == 0 &&emptyNum!= 0)
            {
                emptyNum --;
                [starArray addObject:@"2"];
            }
            UIImageView *imageView = [self.imageViewArray_two objectAtIndex:i];
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_xing_%@",[starArray objectAtIndex:i]]]];
        }
    }
}

#pragma mark -
#pragma mark - gestrue 333333

- (void)handlePanGesture_three:(UIGestureRecognizer *)sender {
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart_three = 0;
        }
        else if (translation.x >10 &&translation.x <25) {
            self.numberStart_three = 1;
        }
        else if (translation.x >= 25 &&translation.x <40) {
            self.numberStart_three = 2;
        }
        else if(translation.x >= 40 &&translation.x < 55){
            self.numberStart_three = 3;
        }
        else if (translation.x >= 55 &&translation.x < 70) {
            self.numberStart_three = 4;
        }
        else if(translation.x >=70 &&translation.x < 85)
        {
            self.numberStart_three = 5;
        }
        else if (translation.x >=85 &&translation.x <100) {
            self.numberStart_three = 6;
        }
        else if (translation.x >= 100 &&translation.x <115) {
            self.numberStart_three = 7;
        }
        else if(translation.x >= 115 &&translation.x < 130){
            self.numberStart_three = 8;
        }
        else if (translation.x >= 130 &&translation.x < 145) {
            self.numberStart_three = 9;
        }
        else if(translation.x >= 145 &&translation.x < 160)
        {
            self.numberStart_three = 10;
        }
        else if(translation.x >=160)
        {
            self.numberStart_three = 10;
        }
        [self numberStartReLoad_three:self.numberStart_three];
    }
}
-(void)handleTwoGesture_three:(UIGestureRecognizer *)sender{
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart_three = 0;
        }
        else if (translation.x >10 &&translation.x <20) {
            self.numberStart_three = 1;
        }
        else if (translation.x >= 20 &&translation.x <30) {
            self.numberStart_three = 2;
        }
        else if(translation.x >= 30 &&translation.x < 40){
            self.numberStart_three = 3;
        }
        else if (translation.x >= 40 &&translation.x < 50) {
            self.numberStart_three = 4;
        }
        else if(translation.x >=50 &&translation.x < 60)
        {
            self.numberStart_three = 5;
        }
        else if (translation.x >=60 &&translation.x <70) {
            self.numberStart_three = 6;
        }
        else if (translation.x >= 70 &&translation.x <80) {
            self.numberStart_three = 7;
        }
        else if(translation.x >= 80 &&translation.x < 90){
            self.numberStart_three = 8;
        }
        else if (translation.x >= 90 &&translation.x < 100) {
            self.numberStart_three = 9;
        }
        else if(translation.x >= 100 &&translation.x < 110)
        {
            self.numberStart_three = 10;
        }
        else if(translation.x >=110)
        {
            self.numberStart_three = 10;
        }
        [self numberStartReLoad_three:self.numberStart_three];
    }
    
}
- (void)numberStartReLoad_three:(NSInteger)number {
    int fullNum = (int)number/2;
    int halfNum = number%2;
    int emptyNum = 5 - fullNum -halfNum;
    NSMutableArray *starArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            if (fullNum != 0 ) {
                fullNum --;
                [starArray addObject:@"0"];
            }else if(fullNum == 0 &&halfNum != 0)
            {
                halfNum --;
                [starArray addObject:@"1"];
            }
            else if(fullNum == 0 &&halfNum == 0 &&emptyNum!= 0)
            {
                emptyNum --;
                [starArray addObject:@"2"];
            }
            UIImageView *imageView = [self.imageViewArray_three objectAtIndex:i];
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_xing_%@",[starArray objectAtIndex:i]]]];
        }
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.passWord resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
