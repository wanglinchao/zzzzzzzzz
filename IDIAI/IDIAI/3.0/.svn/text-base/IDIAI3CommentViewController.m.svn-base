//
//  IDIAI3CommentViewController.m
//  IDIAI
//
//  Created by Ricky on 16/1/15.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3CommentViewController.h"
#import "CommentViewForGJS.h"
#import "IDIAIAppDelegate.h"
#import "TLToast.h"
#import "util.h"
#import "LoginView.h"
#import "CustomPromptView.h"
#import "SWShareImageDetailViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@interface IDIAI3CommentViewController ()<UITableViewDelegate,UITableViewDataSource,CommentsViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    CommentViewForGJS *comment;
    CustomPromptView *customPromp;
}
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UILabel *payForMoneylbl;
@property(nonatomic,strong)UITextField *passWord;
@property(nonatomic,strong)UIView *isfootView;
@property(nonatomic,strong)UITextView *contenttxt;
@property(nonatomic,strong)UILabel *placeholder;
@property(nonatomic,assign)CGRect keyframe;
@property(nonatomic,assign)BOOL iskey;
@property(nonatomic,assign)NSInteger photocount;
@end

@implementation IDIAI3CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"评论";
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
    
    self.isfootView =[[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-64-44, kMainScreenWidth, 44)];
    self.isfootView.backgroundColor =[UIColor whiteColor];
    self.isfootView.hidden =NO;
    [self.view addSubview:self.isfootView];
    
    UIButton *canclebtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [canclebtn setTitle:@"取消" forState:UIControlStateNormal];
    [canclebtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
    canclebtn.layer.masksToBounds = YES;
    canclebtn.layer.cornerRadius = 5;
    canclebtn.layer.borderColor =[UIColor colorWithHexString:@"#ef6562"].CGColor;
    canclebtn.layer.borderWidth = 1;
    canclebtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
    canclebtn.frame =CGRectMake(25, 8, 90, 30);
    [canclebtn addTarget:self action:@selector(canclebtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.isfootView addSubview:canclebtn];
    
    UIButton *confirmbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [confirmbtn setTitle:@"提交" forState:UIControlStateNormal];
    [confirmbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmbtn setBackgroundColor:[UIColor colorWithHexString:@"#ef6562"]];
    confirmbtn.layer.masksToBounds = YES;
    confirmbtn.layer.cornerRadius = 5;
    confirmbtn.layer.borderColor =[UIColor colorWithHexString:@"#ef6562"].CGColor;
    confirmbtn.layer.borderWidth = 1;
    confirmbtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
    confirmbtn.frame =CGRectMake(kMainScreenWidth-25-90, 8, 90, 30);
    [confirmbtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.isfootView addSubview:confirmbtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyFrameAction:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyShow:) name:UIKeyboardWillShowNotification object:nil];
    // Do any additional setup after loading the view.
}
-(void)keyFrameAction:(NSNotification *)sender{
    NSValue *aValue = [sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    keyboardSize.height =keyboardSize.height -64;
    if (self.iskey ==YES) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
//        [UIView setAnimationRepeatCount:INFINITY];
//        [UIView setAnimationRepeatAutoreverses:YES];
        
//        self.table.contentOffset =CGPointMake(0, 0);
        self.view.frame =CGRectMake(0, -keyboardSize.height, self.view.frame.size.width, self.view.frame.size.height);
        self.table.frame =CGRectMake(0, keyboardSize.height, self.table.frame.size.width, self.table.frame.size.height);
        self.table.contentSize =CGSizeMake(0, kMainScreenHeight+keyboardSize.height);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
//        [UIView setAnimationRepeatCount:INFINITY];
//        [UIView setAnimationRepeatAutoreverses:YES];
        self.table.contentSize =CGSizeMake(0, 0);
        self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
        self.table.frame =CGRectMake(0, 0, self.table.frame.size.width, self.table.frame.size.height);
        self.table.contentSize =CGSizeMake(0, kMainScreenHeight-64);
//        self.table.contentOffset =CGPointMake(0,0);
        [UIView commitAnimations];
    }
}
-(void)keyHide:(NSNotification *)sender{
    self.iskey =NO;
}
-(void)keyShow:(NSNotification *)sender{
    self.iskey =YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backView.backgroundColor =[UIColor clearColor];
    return backView;
}
-(void)canclebtnAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)confirmAction:(id)sender{
    if (self.contenttxt.text.length==0) {
        [TLToast showWithText:@"请输入评价内容"];
        return;
    }
    if (self.numberStart==0) {
        [TLToast showWithText:@"请评价第一个星级"];
        return;
    }
    if (self.orderType !=3) {
        if (self.numberStart_two==0) {
            [TLToast showWithText:@"请评价第二个星级"];
            return;
        }
        if (self.numberStart_three==0) {
            [TLToast showWithText:@"请评价第三个星级"];
            return;
        }
    }
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
    
    NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
    
    NSMutableDictionary *postDict01 = [[NSMutableDictionary alloc] init];
    [postDict01 setObject:@"ID0004" forKey:@"cmdID"];
    [postDict01 setObject:string_token forKey:@"token"];
    [postDict01 setObject:string_userid forKey:@"userID"];
    [postDict01 setObject:@"ios" forKey:@"deviceType"];
    [postDict01 setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
    NSString *string01=[postDict01 JSONString];
    
    
    NSString *orderTypeStr = [NSString stringWithFormat:@"%ld",(long)self.orderType];
    NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
    [postDict02 setObject:[NSString stringWithFormat:@"%d",self.servantId] forKey:@"objectId"];
    [postDict02 setObject:self.contenttxt.text forKey:@"objectString"];
    [postDict02 setObject:orderTypeStr forKey:@"objectTypeId"];
    NSInteger firstStar=(NSInteger)self.numberStart;
    if(firstStar%2==0)
        [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)firstStar/2] forKey:@"objectLevel"];
    else
        [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",firstStar/2+0.5] forKey:@"objectLevel"];
    NSInteger secondStar=(NSInteger)self.numberStart_two;
    if (self.orderType!=3) {
        if(secondStar%2==0)
            [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)secondStar/2] forKey:@"professionalLevel"];
        else
            [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",secondStar/2+0.5] forKey:@"professionalLevel"];
    }
    
    NSInteger thirdStar=(NSInteger)self.numberStart_three;
    if (self.orderType!=3) {
        if(thirdStar%2==0)
            [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)thirdStar/2] forKey:@"customerServiceLevel"];
        else
            [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",thirdStar/2+0.5] forKey:@"customerServiceLevel"];
    }
    
    NSString *string02=[postDict02 JSONString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: url]];
    
    [request setPostValue:string01 forKey:@"header"];
    [request setPostValue:string02 forKey:@"body"];
    request.showAccurateProgress=YES;
    int count=0;
    
    for (UIImage *image in self.addPhotoView.photos) {
        BOOL success;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSLog(@"found an image");
        
        NSString *_imageFile1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"temp%d.jpg",count]];
        
        NSLog(@"%@",_imageFile1);
        
        success = [fileManager fileExistsAtPath:_imageFile1];
        
        if(success) {
            
            success = [fileManager removeItemAtPath:_imageFile1 error:&error];
            
        }
        
        [UIImageJPEGRepresentation(image, 0.1f) writeToFile:_imageFile1 atomically:YES];
        
        [request addFile:_imageFile1 forKey:@"filedata"];
        count++;
    }
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setUploadProgressDelegate:self];
    [request startAsynchronous];
//    [self startRequestWithString:@"加载中..."];
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
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
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
//        
//        NSMutableDictionary *postDict01 = [[NSMutableDictionary alloc] init];
//        [postDict01 setObject:@"ID0004" forKey:@"cmdID"];
//        [postDict01 setObject:string_token forKey:@"token"];
//        [postDict01 setObject:string_userid forKey:@"userID"];
//        [postDict01 setObject:@"ios" forKey:@"deviceType"];
//        [postDict01 setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
//        NSString *string01=[postDict01 JSONString];
//        
//        
//        NSString *orderTypeStr = [NSString stringWithFormat:@"%ld",(long)self.orderType];
//        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
//        [postDict02 setObject:[NSString stringWithFormat:@"%d",self.servantId] forKey:@"objectId"];
//        [postDict02 setObject:self.contenttxt.text forKey:@"objectString"];
//        [postDict02 setObject:orderTypeStr forKey:@"objectTypeId"];
//        NSInteger firstStar=(NSInteger)self.numberStart;
//        if(firstStar%2==0)
//            [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)firstStar/2] forKey:@"objectLevel"];
//        else
//            [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",firstStar/2+0.5] forKey:@"objectLevel"];
//        NSInteger secondStar=(NSInteger)self.numberStart_two;
//        if (self.orderType!=3) {
//            if(secondStar%2==0)
//                [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)secondStar/2] forKey:@"professionalLevel"];
//            else
//                [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",secondStar/2+0.5] forKey:@"professionalLevel"];
//        }
//        
//        NSInteger thirdStar=(NSInteger)self.numberStart_three;
//        if (self.orderType!=3) {
//            if(thirdStar%2==0)
//                [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)thirdStar/2] forKey:@"customerServiceLevel"];
//            else
//                [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",thirdStar/2+0.5] forKey:@"customerServiceLevel"];
//        }
//        
//        NSString *string02=[postDict02 JSONString];
//        
//        NSMutableDictionary *req_dict= [[NSMutableDictionary alloc] init];
//        [req_dict setObject:string01 forKey:@"header"];
//        [req_dict setObject:string02 forKey:@"body"];
//        
//        NetworkRequest *req = [[NetworkRequest alloc] init];
//        [req setHttpMethod:PostMethod];
//        
//        [req sendToServerInBackground:^{
//            dispatch_async(parsingQueue, ^{
//                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
//                [request setResponseEncoding:NSUTF8StringEncoding];
//                NSString *respString = [request responseString];
//                NSDictionary *jsonDict = [respString objectFromJSONString];
//                NSLog(@"评星：返回信息：%@",jsonDict);
//                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
//                if (code==10041) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self stopRequest];
//                        [TLToast showWithText:@"评价成功，感谢您的支持" bottomOffset:220.0f duration:1.0];
//                        [self.navigationController popViewControllerAnimated:YES];
//                    });
//                }
//                else if (code==10042) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self stopRequest];
//                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
//                        customPromp.contenttxt =@"亲，不符合评价的规则";
//                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
//                        [customPromp addGestureRecognizer:tap];
//                        [customPromp show];
////                        [TLToast showWithText:@"亲，不符合评价的规则" bottomOffset:220.0f duration:1.0];
//                    });
//                }
//                else if (code==10043) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self stopRequest];
//                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
//                        customPromp.contenttxt =@"亲，评价的内容过长";
//                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
//                        [customPromp addGestureRecognizer:tap];
//                        [customPromp show];
////                        [TLToast showWithText:@"亲，评价的内容过长" bottomOffset:220.0f duration:1.0];
//                    });
//                }
//                
//                else if (code==10049) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self stopRequest];
//                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
//                        customPromp.contenttxt =@"亲，评价失败哦";
//                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
//                        [customPromp addGestureRecognizer:tap];
//                        [customPromp show];
////                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
//                    });
//                }
//                else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self stopRequest];
////                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
//                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
//                        customPromp.contenttxt =@"亲，评价失败哦";
//                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
//                        [customPromp addGestureRecognizer:tap];
//                        [customPromp show];
//                    });
//                }
//            });
//        }
//                          failedBlock:^{
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [self stopRequest];
//                                  [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
//                              });
//                          }
//                               method:url postDict:req_dict];
//    });
}
#pragma mark -
#pragma mark -ASIHTTPRequestDelegate

- (void)requestFailed:(ASIHTTPRequest *)request {
    [self stopRequest];
    [TLToast showWithText:@"操作失败"];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self stopRequest];
    NSString *respString = [request responseString];
    NSDictionary *jsonDict = [respString objectFromJSONString];
    
    if ([[jsonDict objectForKey:@"resCode"]integerValue] == 10041) {
        [TLToast showWithText:@"评价成功，感谢您的支持" bottomOffset:220.0f duration:1.0];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([[jsonDict objectForKey:@"resCode"]integerValue] == 10042) {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"亲，不符合评价的规则";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
            //                        [TLToast showWithText:@"亲，不符合评价的规则" bottomOffset:220.0f duration:1.0];
    }
    else if ([[jsonDict objectForKey:@"resCode"]integerValue] == 10043) {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"亲，请输入1～200字的评论内容";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
            //                        [TLToast showWithText:@"亲，评价的内容过长" bottomOffset:220.0f duration:1.0];
    }
    
    else if ([[jsonDict objectForKey:@"resCode"]integerValue] == 10049) {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"亲，评价失败哦";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
            //                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
    }
    else{
            //                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
            customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
            customPromp.contenttxt =@"亲，评价失败哦";
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
            [customPromp addGestureRecognizer:tap];
            [customPromp show];
    }    
}
-(void)setProgress:(float)newProgress{
    
    //    [self.pvsetProgress:newProgress];
    //
    //    self.lbPercent.text=[NSString stringWithFormat:@"%0.f%%",newProgress*100];
    //    hud =[[MBProgressHUD alloc] initWithView:self.view];
    //    [hud setMode:MBProgressHUDModeIndeterminate];
    //    [hud setLabelText:[NSString stringWithFormat:@"%0.f%%",newProgress*100]];
    //    [hud show:YES];
    //    if (newProgress ==1) {
    //        [hud hide:YES];
    //    }
    [self startRequestWithString:[NSString stringWithFormat:@"上传进度%0.f%%",newProgress*100]];
    if (newProgress==1) {
        [self stopRequest];
    }
}
-(void)hideAction:(id)sender{
    [customPromp dismiss];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.orderType ==3) {
        return 2;
    }
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (self.orderType==3) {
            return 68;
        }
        return 67;
    }else if (indexPath.section==1){
        if (self.orderType ==3) {
            return 257;
        }
        return 118;
    }else if (indexPath.section ==2){
        return 257;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier1 = @"ConfirmPayMentCell1";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (!cell1) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        if (indexPath.section==1) {
            if (self.orderType!=3) {
                UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 12, kMainScreenWidth-40, 17)];
                titlelbl.textColor =[UIColor colorWithHexString:@"#575757"];
                NSMutableAttributedString *totalFeestr =[[NSMutableAttributedString alloc] initWithString:@"服务考评( 滑动评分 )"];
                [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,4)];
                [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(4,totalFeestr.length-4)];
                titlelbl.attributedText =totalFeestr;
                titlelbl.font =[UIFont systemFontOfSize:17.0];
                [cell1 addSubview:titlelbl];
                
                UILabel *lab_one=[[UILabel alloc]initWithFrame:CGRectMake(20, 38, 70, 20)];
                lab_one.font=[UIFont systemFontOfSize:15];
                lab_one.textAlignment=NSTextAlignmentLeft;
                lab_one.backgroundColor=[UIColor clearColor];
                lab_one.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
                lab_one.tag =100;
                [cell1 addSubview:lab_one];
                
                self.numberStart = 0;
                self.startView = [[UIView alloc] initWithFrame:CGRectMake(100, 37, 160, 20)];
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
                
                UITapGestureRecognizer *tapGesture_three = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleThreeGesture:)];
                [self.startView_three addGestureRecognizer:tapGesture_three];
            }else{
                UILabel *paypstitle =[[UILabel alloc] initWithFrame:CGRectMake(16, 23, 70, 16)];
                paypstitle.text =@"我要评";
                paypstitle.textColor =[UIColor colorWithHexString:@"#575757"];
                [cell1 addSubview:paypstitle];
                
                self.contenttxt=[[UITextView alloc] initWithFrame:CGRectMake(15, paypstitle.frame.origin.y+paypstitle.frame.size.height+10, kMainScreenWidth-30, 100)];
                self.contenttxt.backgroundColor =[UIColor whiteColor];
                self.contenttxt.font =[UIFont systemFontOfSize:14];
                self.contenttxt.layer.cornerRadius=5;
                self.contenttxt.clipsToBounds=YES;
                self.contenttxt.delegate =self;
                self.contenttxt.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
                self.contenttxt.layer.borderWidth = 1;
                self.contenttxt.returnKeyType =UIReturnKeyDone;
                [cell1 addSubview:self.contenttxt];
                
                self.placeholder =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contenttxt.frame.size.width-20, self.contenttxt.frame.size.height-20)];
                NSString *placeholderstr =@"最多评论200个字";
                UIFont *font1= [UIFont fontWithName:@"Arial" size:14];
                CGSize size1 = CGSizeMake(self.contenttxt.frame.size.width-20,self.contenttxt.frame.size.height-20);
                CGSize labelsize1 = [placeholderstr sizeWithFont:font1 constrainedToSize:size1 lineBreakMode:UILineBreakModeWordWrap];
                self.placeholder.text =placeholderstr;
                self.placeholder.font =font1;
                self.placeholder.numberOfLines =0;
                self.placeholder.lineBreakMode = UILineBreakModeWordWrap;
                self.placeholder.frame =CGRectMake(self.placeholder.frame.origin.x, self.placeholder.frame.origin.y, labelsize1.width, labelsize1.height);
                self.placeholder.textColor =kColorWithRGB(217, 217, 221);
                [self.contenttxt addSubview:self.placeholder];
                
                self.addPhotoView =[[SWAddPhotoView alloc] initWithFrame: CGRectMake(15, self.contenttxt.frame.origin.y+self.contenttxt.frame.size.height+14, kMainScreenWidth-30, 0)];
                self.addPhotoView.delegate =self;
                self.addPhotoView.photocount =3;
                self.addPhotoView.photos =[NSMutableArray array];
                [cell1 addSubview:self.addPhotoView];
            }
        }
        if (indexPath.section ==2) {
            UILabel *paypstitle =[[UILabel alloc] initWithFrame:CGRectMake(16, 23, 70, 16)];
            paypstitle.text =@"我要评";
            paypstitle.textColor =[UIColor colorWithHexString:@"#575757"];
            [cell1 addSubview:paypstitle];
            
            self.contenttxt=[[UITextView alloc] initWithFrame:CGRectMake(15, paypstitle.frame.origin.y+paypstitle.frame.size.height+10, kMainScreenWidth-30, 100)];
            self.contenttxt.backgroundColor =[UIColor whiteColor];
            self.contenttxt.font =[UIFont systemFontOfSize:14];
            self.contenttxt.layer.cornerRadius=5;
            self.contenttxt.clipsToBounds=YES;
            self.contenttxt.delegate =self;
            self.contenttxt.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
            self.contenttxt.layer.borderWidth = 1;
            self.contenttxt.returnKeyType =UIReturnKeyDone;
            [cell1 addSubview:self.contenttxt];
            
            self.placeholder =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contenttxt.frame.size.width-20, self.contenttxt.frame.size.height-20)];
            NSString *placeholderstr =@"最多评论200个字";
            UIFont *font1= [UIFont fontWithName:@"Arial" size:14];
            CGSize size1 = CGSizeMake(self.contenttxt.frame.size.width-20,self.contenttxt.frame.size.height-20);
            CGSize labelsize1 = [placeholderstr sizeWithFont:font1 constrainedToSize:size1 lineBreakMode:UILineBreakModeWordWrap];
            self.placeholder.text =placeholderstr;
            self.placeholder.font =font1;
            self.placeholder.numberOfLines =0;
            self.placeholder.lineBreakMode = UILineBreakModeWordWrap;
            self.placeholder.frame =CGRectMake(self.placeholder.frame.origin.x, self.placeholder.frame.origin.y, labelsize1.width, labelsize1.height);
            self.placeholder.textColor =kColorWithRGB(217, 217, 221);
            [self.contenttxt addSubview:self.placeholder];
            
            self.addPhotoView =[[SWAddPhotoView alloc] initWithFrame: CGRectMake(15, self.contenttxt.frame.origin.y+self.contenttxt.frame.size.height+14, kMainScreenWidth-30, 0)];
            self.addPhotoView.delegate =self;
            self.addPhotoView.photocount =3;
            self.addPhotoView.photos =[NSMutableArray array];
            [cell1 addSubview:self.addPhotoView];
        }
    }
    if (indexPath.section ==0) {
        if (self.orderType!=3) {
            self.payForMoneylbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 17, kMainScreenWidth-30, 34)];
            self.payForMoneylbl.textColor=[UIColor colorWithHexString:@"#ef6562"];
            UIFont *font = [UIFont fontWithName:@"Arial" size:17];
            CGSize size = CGSizeMake(kMainScreenWidth-30,2000);
            NSString *context=@"恭喜你项目已经完成！感谢您对屋托邦的支持,请对这次服务体验做出评价";
            CGSize labelsize = [context sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            self.payForMoneylbl.lineBreakMode = UILineBreakModeWordWrap;
            self.payForMoneylbl.numberOfLines =2;
            self.payForMoneylbl.font =font;
            self.payForMoneylbl.text =context;
            self.payForMoneylbl.frame =CGRectMake(15, 17, labelsize.width, labelsize.height);
            [cell1 addSubview:self.payForMoneylbl];
        }else{
            UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 12, kMainScreenWidth-40, 17)];
            titlelbl.textColor =[UIColor colorWithHexString:@"#575757"];
            NSMutableAttributedString *totalFeestr =[[NSMutableAttributedString alloc] initWithString:@"服务考评( 滑动评分 )"];
            [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0,4)];
            [totalFeestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange(4,totalFeestr.length-4)];
            titlelbl.attributedText =totalFeestr;
            titlelbl.font =[UIFont systemFontOfSize:17.0];
            [cell1 addSubview:titlelbl];
            
            UILabel *lab_one=[[UILabel alloc]initWithFrame:CGRectMake(20, 38, 70, 20)];
            lab_one.font=[UIFont systemFontOfSize:15];
            lab_one.textAlignment=NSTextAlignmentLeft;
            lab_one.backgroundColor=[UIColor clearColor];
            lab_one.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
            lab_one.tag =100;
            [cell1 addSubview:lab_one];
            
            self.numberStart = 0;
            self.startView = [[UIView alloc] initWithFrame:CGRectMake(100, 37, 160, 20)];
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
        }
        
    }
    if (self.orderType ==3) {
        if (indexPath.row ==0) {
            NSArray *arr_;
            arr_ =@[@"服务考评"];
            UILabel *lab_one =(UILabel *)[cell1 viewWithTag:100];
            lab_one.text =arr_[0];
        }
    }else{
        if (indexPath.section ==1) {
            NSArray *arr_;
            if(self.orderType==1) arr_=@[@"服务态度",@"设计水平",@"沟通能力"];
            else if(self.orderType==4) arr_=@[@"服务态度",@"施工质量",@"进度控制"];
            else if(self.orderType==6) arr_=@[@"服务态度",@"专业技能",@"沟通能力"];
            else if(self.orderType==3) arr_ =@[@"服务考评"];
            UILabel *lab_one =(UILabel *)[cell1 viewWithTag:100];
            lab_one.text =arr_[0];
            //        lab_one.textColor =[UIColor darkGrayColor];
            //加载星级（0-10,0表示无星级）
            
            if (self.orderType!=3) {
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
        }
    }
    
    cell1.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell1;
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
- (void)handlePanGesture_two:(UIGestureRecognizer *)sender {
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
-(void)handleThreeGesture:(UIGestureRecognizer *)sender{
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
-(void)textViewDidChange:(UITextView *)textView
{
    //    self.contenttxt.text =  textView.text;
    if (textView.text.length == 0) {
        NSString *placeholderstr =@"最多评论200个字";
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
#pragma mark addPhotoViewDelegate

-(void)addPhotoCount:(NSInteger)count
{
    self.photocount =count;
    [self.contenttxt resignFirstResponder];
    UIActionSheet *action =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    action.actionSheetStyle =UIActionSheetStyleBlackTranslucent;
    [action showInView:self.view];
    
    
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            if (self.photocount ==0) {
                [TLToast showWithText:@"最多允许上传9张图片"];
                return;
            }
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            //指定源类型前，检查图片源是否可用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                //指定源的类型
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
                imagePicker.allowsEditing = YES;
                
                //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
                imagePicker.delegate = self;
                
                //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
                imagePicker.allowsEditing = YES;
                
                //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
                imagePicker.delegate = self;
                
                //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
            break;
        case 1:
        {
            if (self.photocount ==0) {
                [TLToast showWithText:@"最多允许上传9张图片"];
                return;
            }
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            
            imagePickerController.limitsMaximumNumberOfSelection = YES;
            imagePickerController.maximumNumberOfSelection = self.photocount;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
            [self presentViewController:navigationController animated:YES completion:NULL];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 删除图片
-(void)detelePhotoCount:(NSInteger)count
{
    SWShareImageDetailViewController *sharedetail =[[SWShareImageDetailViewController alloc] init];
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:sharedetail];
    NSMutableArray *photosArray =[[NSMutableArray alloc] init];
    [photosArray addObjectsFromArray:[self.addPhotoView.photos copy]];
    sharedetail.photos =photosArray;
    sharedetail.index =(int)count-100;
    sharedetail.selectDone =^(NSMutableArray *photosArray){
        [self.addPhotoView setPhotos:photosArray];
    };
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:nav animated:YES completion:nil];


//    NSMutableArray *photos =[NSMutableArray array];
//    MJPhoto *photo = [[MJPhoto alloc] init];
//    photo.image =[self.addPhotoView.photos objectAtIndex:count-100];
//    NSLog(@"%@",[self.addPhotoView viewWithTag:count]);
//    UIButton *contentbtn =(UIButton *)[self.addPhotoView viewWithTag:count];
//    photo.srcImageView = contentbtn.imageView; // 来源于哪个UIImageView
//    [photos addObject:photo];
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    //    browser.describe =selectpic.phasePicDescription;
//    [browser show];
}
//-(void)longTouchPhotoCount:(NSInteger)count{
//    NSMutableArray *photosArray =[[NSMutableArray alloc] init];
//    [photosArray addObjectsFromArray:[self.addPhotoView.photos copy]];
//    [photosArray removeObjectAtIndex:count-100];
//    [self.addPhotoView setPhotos:photosArray];
//}
#pragma mark - 选择照片数量
-(void)pickPhotoCount:(NSInteger)count
{
    if (count ==0) {
        [TLToast showWithText:@"最多允许上传9张图片"];
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    //指定源类型前，检查图片源是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //指定源的类型
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
        imagePicker.allowsEditing = YES;
        
        //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
        imagePicker.delegate = self;
        
        //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
        imagePicker.allowsEditing = YES;
        
        //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
        imagePicker.delegate = self;
        
        //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if ([imagePickerController isKindOfClass:[QBImagePickerController class]]) {
        if(imagePickerController.allowsMultipleSelection) {
            NSMutableArray *images =[NSMutableArray array];
            for (NSDictionary *dic in info) {
                UIImage *image =[dic objectForKey:@"UIImagePickerControllerOriginalImage"];
                NSData *origImageData = UIImageJPEGRepresentation(image, 1.0);
                for (int i=0; i<1; i++) {
                    if ([origImageData length] <= 4*1024*1024) {
                        image =[UIImage imageWithData:origImageData];
                        [images addObject:image];
                    }else {
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                        origImageData =imageData;
                        i--;
                    }
                }
            }
            [self.addPhotoView addImages:images];
        }
    }else{
        NSMutableArray *images =[NSMutableArray array];
        UIImage *image =[info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *origImageData = UIImageJPEGRepresentation(image, 1.0);
        for (int i=0; i<1; i++) {
            if ([origImageData length] <= 4*1024*1024) {
                image =[UIImage imageWithData:origImageData];
                [images addObject:image];
            }else {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                origImageData =imageData;
                i--;
            }
        }
        [self.addPhotoView addImages:images];
    }
    //    self.isselectbtn.frame =CGRectMake(self.isselectbtn.frame.origin.x, rect.origin.y, self.isselectbtn.frame.size.width, self.isselectbtn.frame.size.height);
    //    self.selectlbl.frame =CGRectMake(self.isselectbtn.frame.origin.x+25, rect.origin.y+3, self.selectlbl.frame.size.width, self.selectlbl.frame.size.height);
    [self dismissViewControllerAnimated:YES completion:^{
        UISegmentedControl *segment =(UISegmentedControl *)[self.navigationController.navigationBar viewWithTag:100];
        segment.hidden =YES;
        //        [segment removeFromSuperview];
    }];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:^{
        UISegmentedControl *segment =(UISegmentedControl *)[self.navigationController.navigationBar viewWithTag:100];
        segment.hidden =YES;
        //        [segment removeFromSuperview];
    }];
    
}
- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"";
}

- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"";
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"图片%d张", (int)numberOfPhotos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"视频%d", (int)numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"图片%d 视频%d", (int)numberOfPhotos, (int)numberOfVideos];
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
