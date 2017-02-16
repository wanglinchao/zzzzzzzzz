//
//  SearchWorkerViewController.m
//  IDIAI
//
//  Created by iMac on 14-12-11.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SearchWorkerViewController.h"
#import "HexColor.h"
#import "util.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "WorkerListObj.h"
#import "EmptyClearTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "OpenUDID.h"
#import "WorkerInfoViewController.h"
#import "TLToast.h"
#import "savelogObj.h"
#import "XiaoGongNewDetailViewController.h"
#import "SearchListCell.h"


#define kButton_topbtn 100
#define KButtonTag_phone 10000
#define KHISTORY_SS_WORKER @"MyHistory_worker.plist"
@interface SearchWorkerViewController ()<UITextFieldDelegate>
{
    UITextField *searchBar;
  
}


@end

@implementation SearchWorkerViewController
@synthesize dataArray,dataArray_history,selected_mark;
@synthesize lat_,lng_;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)customizeNavigationBar {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 0, 0)];
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(kMainScreenWidth-60, 20, 60, 40)];
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:18];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
}

-(void)PressBarItemLeft{
    
}

-(void)PressBarItemRight{
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [mtableview reloadData];
    
    [self customizeNavigationBar];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"小工--搜索" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:43];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self createUITextField];
    
    selected_mark=1;
    self.currentPage=0;
    
    dataArray=[NSMutableArray arrayWithCapacity:0];
    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_ = [path_ objectAtIndex:0];
    NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:KHISTORY_SS_WORKER];
    dataArray_history=[NSMutableArray arrayWithContentsOfFile:_filename_];
    if (!dataArray_history) {
        dataArray_history=[NSMutableArray arrayWithCapacity:0];
    }
    if([dataArray_history count]>15) [dataArray_history removeObjectsInRange:NSMakeRange(15, [dataArray_history count]-15)];
    
    NSArray *arr_btnName=[NSArray arrayWithObjects:@"星级",@"距离",@"热门", nil];
    for(int i=0;i<[arr_btnName count];i++){
        UIButton *btn=[[UIButton alloc]init];
        if(i!=1) btn.frame=CGRectMake(kMainScreenWidth/3*i, 64, kMainScreenWidth/3, 40);
        else btn.frame=CGRectMake(kMainScreenWidth/3*i-1, 64, kMainScreenWidth/3+2, 40);
         [btn setTitle:[arr_btnName objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
         btn.tag=kButton_topbtn+i;
         if(i==0)[btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
         else [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(PressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    UIView *line_slider=[[UIView alloc]initWithFrame:CGRectMake(kMainScreenWidth/9, 33+64, kMainScreenWidth/9, 2)];
    line_slider.tag=10;
    line_slider.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:line_slider];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 40+64, kMainScreenWidth, kMainScreenHeight-64-40) style:UITableViewStyleGrouped];
    mtableview.pullingDelegate=self;
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [self.view addSubview:mtableview];
    mtableview.hidden=YES;
    
    mtableview_sub=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    mtableview_sub.backgroundColor=[UIColor clearColor];
    mtableview_sub.delegate=self;
    mtableview_sub.dataSource=self;
    mtableview_sub.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mtableview_sub];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    [self loadImageviewBG];
    
    [searchBar becomeFirstResponder];
}



-(void)PressBtn:(UIButton *)sender{
    selected_mark=sender.tag-kButton_topbtn+1;

    UIView *line=(UIView *)[self.view viewWithTag:10];
    [UIView animateWithDuration:0.3 animations:^{
        line.frame=CGRectMake(kMainScreenWidth/9*(1+(selected_mark-1)*3), 33+64, kMainScreenWidth/9, 2);
    }completion:^(BOOL finished){
        
    }];
    
    for(int i=0;i<3;i++){
        UIButton *btn=(UIButton *)[self.view viewWithTag:kButton_topbtn+i];
        if(sender==btn) [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        else [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    if([dataArray count]) {
        [dataArray removeAllObjects];
        [mtableview reloadData];
    }
    [mtableview launchRefreshing];
}

//请求小工列表
-(void)requestworkerlist{
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
        
        if(lat_.length==0 || lng_.length==0) {
            lng_=@"";
            lat_=@"";
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0030\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"jobScopeId\":\"-1\",\"keyword\":\"%@\",\"currentPage\":\"%ld\",\"requestRow\":\"15\",\"sortType\":\"%ld\",\"userLongitude\":\"%@\",\"userLatitude\":\"%@\",\"requestArea\":\"-1\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],(long)self.currentPage+1,(long)selected_mark,lng_,lat_];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"小工列表：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10301) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"workersList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                [dataArray addObject:[WorkerListObj objWithDict:dict]];
                            }
                        }
                        if([dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [mtableview tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [mtableview tableViewDidFinishedLoading];
                        }
                        [mtableview reloadData];
                    });
                }
                else if (code==10309) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];
                        if(![dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];
                        if(![dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [mtableview tableViewDidFinishedLoading];
                                  if(![dataArray count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

//发送记录呼叫电话信息
-(void)requestRecordCallinfo:(WorkerListObj *)obj_{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict01 = [[NSMutableDictionary alloc] init];
        [postDict01 setObject:@"ID0032" forKey:@"cmdID"];
        [postDict01 setObject:string_token forKey:@"token"];
        [postDict01 setObject:string_userid forKey:@"userID"];
        [postDict01 setObject:@"ios" forKey:@"deviceType"];
        [postDict01 setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        NSString *string01=[postDict01 JSONString];
        
        //获取日期时间
        NSDate *senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *locationDate=[dateformatter stringFromDate:senddate];
        //获取主叫号码
        NSString *str_calling;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile] length]>2) str_calling=[[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile];
        else str_calling=@"";
        //获取主叫号码编号
        NSString *str_calling_id;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]) str_calling_id=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        else str_calling_id=@"";
        //获取被叫号码
        NSString *str_called;
        if([obj_.phoneNumber length]>2) str_called=obj_.phoneNumber;
        else str_called=@"";
        //获取被叫号码编号
        NSString *str_called_id;
        if(obj_.workerId >=0) str_called_id=[NSString stringWithFormat:@"%ld",(long)obj_.workerId];
        else str_called_id=@"";
        //获取设备编号
        NSString *str_uuid=[OpenUDID value];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:str_called forKey:@"calledPhone"];
        [postDict02 setObject:str_called_id forKey:@"calledId"];
        [postDict02 setObject:str_uuid forKey:@"mobileUUID"];
        [postDict02 setObject:str_calling_id forKey:@"callingId"];
        [postDict02 setObject:str_calling forKey:@"callingPhone"];
        [postDict02 setObject:locationDate forKey:@"callingDate"];
        [postDict02 setObject:@"3" forKey:@"calledIdenttityType"];
        NSString *string02=[postDict02 JSONString];
        
        NSMutableDictionary *req_dict= [[NSMutableDictionary alloc] init];
        [req_dict setObject:string01 forKey:@"header"];
        [req_dict setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"电话记录：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10321) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
                else if (code==10329) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                              });
                          }
                               method:url postDict:req_dict];
    });
    
    
}


#pragma mark -
#pragma mark -  Others

- (void)keyboardWillShow:(NSNotification *)aNotification {
    //  NSString *str=[[UITextInputMode currentInputMode] primaryLanguage];  //语言
    
    CGSize kbSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"show%f",kbSize.height);
    mtableview_sub.frame=CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64-kbSize.height);
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    //  NSString *str=[[UITextInputMode currentInputMode] primaryLanguage];  //语言
    
    CGSize kbSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"hide%f",kbSize.height);
    mtableview_sub.frame=CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64);
}

-(void)createUITextField{
    UIImageView *imv_ss=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_sousuo_s"]];
    imv_ss.frame=CGRectMake(10, 7.5, 15, 15);
    UIView *view_left_ss=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    view_left_ss.backgroundColor=[UIColor clearColor];
    [view_left_ss addSubview:imv_ss];
    
    UIView *bg_view=[[UIView alloc]initWithFrame:CGRectMake(20, 25, kMainScreenWidth-80, 30)];
    bg_view.backgroundColor=[UIColor colorWithHexString:@"#E9E9EC" alpha:0.7];
    //设置弧度,这里将按钮变成了圆形
    bg_view.layer.cornerRadius = 5.0f;
    bg_view.layer.masksToBounds = YES;
    [self.view addSubview:bg_view];
    
    searchBar=[[UITextField alloc]initWithFrame:CGRectMake(20, 25, kMainScreenWidth-80, 30)];
    searchBar.backgroundColor=[UIColor clearColor];
   // searchBar.borderStyle=UITextBorderStyleRoundedRect;
    searchBar.delegate=self;
    searchBar.placeholder=@"请输入搜索内容";
    searchBar.returnKeyType=UIReturnKeySearch;
    searchBar.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    searchBar.font=[UIFont systemFontOfSize:15];
    searchBar.tintColor=[UIColor colorWithHexString:@"#ADABB1" alpha:1.0];
    searchBar.clearsOnBeginEditing=YES;
    searchBar.clearButtonMode=UITextFieldViewModeWhileEditing;
    searchBar.leftView=view_left_ss;
    searchBar.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:searchBar];
}

#pragma mark -
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIView *line=(UIView *)[self.view viewWithTag:10];
    line.hidden=YES;
    for(int i=0;i<3;i++){
        UIButton *btn=(UIButton *)[self.view viewWithTag:kButton_topbtn+i];
        btn.hidden=YES;
    }
    
    mtableview.hidden=YES;
    mtableview_sub.hidden=NO;
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    [mtableview_sub reloadData];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"搜索");
    UIView *line=(UIView *)[self.view viewWithTag:10];
    line.hidden=NO;
    for(int i=0;i<3;i++){
        UIButton *btn=(UIButton *)[self.view viewWithTag:kButton_topbtn+i];
        btn.hidden=NO;
    }
    
    [searchBar resignFirstResponder];
    mtableview.hidden=NO;
    mtableview_sub.hidden=YES;
    if([dataArray count]) {
        [dataArray removeAllObjects];
        [mtableview reloadData];
    }
    if(![util isConnectionAvailable]) {
        [TLToast showWithText:@"亲，网络连接断开啦。。" topOffset:220.0f duration:1.0];
        imageview_bg.hidden=NO;
        label_bg.hidden = NO;
    }
    else [mtableview launchRefreshing];
    
    BOOL isDefault=YES;
    if(textField.text.length){
        for(int i=0;i<[dataArray_history count];i++){
            NSString *str=[dataArray_history objectAtIndex:i];
            if([str isEqualToString:textField.text]) {
                [dataArray_history exchangeObjectAtIndex:0 withObjectAtIndex:i];
                isDefault=NO;
                break;
            }
        }
        if(isDefault==YES) {
            if([dataArray_history count]>=15) [dataArray_history removeObjectsInRange:NSMakeRange(14, [dataArray_history count]-14)];
            [dataArray_history insertObject:textField.text atIndex:0];
        }
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:KHISTORY_SS_WORKER];
        [dataArray_history writeToFile:_filename atomically:NO];
    }
    
    return YES;
}

#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView==mtableview) return 0.1;
    else return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView==mtableview) return 10;
    else return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==mtableview){
        if(selected_mark==3) return 110;
        else return 90;
    }
    else {
        if([dataArray_history count]==indexPath.row) return 80+(kMainScreenWidth-200)/3+20;
        else return 50;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==mtableview) return [dataArray count];
    else return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==mtableview) return 1;
    else {
        if([dataArray_history count]<=15) return [dataArray_history count]+1;
        else return 15+1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==mtableview){
        static NSString *cellid=@"mycellid";
        EmptyClearTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"EmptyClearTableViewCell" owner:nil options:nil]lastObject];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if([self.dataArray count]){
            WorkerListObj *obj=[self.dataArray objectAtIndex:indexPath.section];
            
            float height=90;
            if(selected_mark==3) height=110;
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, height)];
            view.backgroundColor=[UIColor whiteColor];
            view.layer.cornerRadius=5;
            [cell addSubview:view];
            
            UIImageView *UserLogo=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 50, 50)];
            UserLogo.contentMode=UIViewContentModeScaleAspectFill;
            UserLogo.layer.cornerRadius=25;
            UserLogo.layer.masksToBounds=YES;
            [UserLogo sd_setImageWithURL:[NSURL URLWithString:obj.workerIconPath] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
            [cell addSubview:UserLogo];
            
            CGSize size_name=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",obj.nickName] width:kMainScreenWidth-170 font:[UIFont systemFontOfSize:20]];
            UILabel *UserName=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, 10, size_name.width, 20)];
            UserName.backgroundColor=[UIColor clearColor];
            UserName.textAlignment=NSTextAlignmentLeft;
            UserName.textColor=[UIColor blackColor];
            UserName.font=[UIFont systemFontOfSize:20];
            UserName.text=obj.nickName;
            [cell addSubview:UserName];
            
            if([obj.authentication_arr count]){
                for(int i=0;i<[obj.authentication_arr count];i++){
                    NSDictionary *dict=[obj.authentication_arr objectAtIndex:i];
                    UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserName.frame)+i*40, 12, 35, 18)];
                    image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_new_%@.png",[dict objectForKey:@"authzId"]]];
                    [cell addSubview:image_rz];
                }
            }
            
            if(selected_mark==3){
                UILabel *Collects=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(UserName.frame)+7, kMainScreenWidth-CGRectGetMaxX(UserLogo.frame)-80, 20)];
                Collects.backgroundColor=[UIColor clearColor];
                Collects.textAlignment=NSTextAlignmentLeft;
                Collects.textColor=[UIColor lightGrayColor];
                Collects.font=[UIFont systemFontOfSize:16];
                Collects.text=[NSString stringWithFormat:@"收藏量  %.1fkm",obj.distance];
                [cell addSubview:Collects];
                
                UILabel *Browers=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(Collects.frame)+5, kMainScreenWidth-CGRectGetMaxX(UserLogo.frame)-80, 20)];
                Browers.backgroundColor=[UIColor clearColor];
                Browers.textAlignment=NSTextAlignmentLeft;
                Browers.textColor=[UIColor lightGrayColor];
                Browers.font=[UIFont systemFontOfSize:16];
                Browers.text=[NSString stringWithFormat:@"浏览量  %.1fkm",obj.distance];
                [cell addSubview:Browers];
                
                if([obj.workerCollect integerValue]>=100000000) Collects.text=[NSString stringWithFormat:@"收藏量  %0.1f亿",[obj.workerCollect floatValue]/100000000];
                else if([obj.workerCollect integerValue]>=10000) Collects.text=[NSString stringWithFormat:@"收藏量  %0.1f万",[obj.workerCollect floatValue]/10000];
                else Collects.text=[NSString stringWithFormat:@"收藏量  %@",obj.workerCollect];
                
                if([obj.workerBrower integerValue]>=100000000) Browers.text=[NSString stringWithFormat:@"浏览量  %0.1f亿",[obj.workerBrower floatValue]/100000000];
                else if([obj.workerBrower integerValue]>=10000) Browers.text=[NSString stringWithFormat:@"浏览量  %0.1f万",[obj.workerBrower floatValue]/10000];
                else Browers.text=[NSString stringWithFormat:@"浏览量  %@",obj.workerBrower];
                
                UILabel *Distance=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(Browers.frame)+3, kMainScreenWidth-CGRectGetMaxX(UserLogo.frame)-80, 20)];
                Distance.backgroundColor=[UIColor clearColor];
                Distance.textAlignment=NSTextAlignmentLeft;
                Distance.textColor=[UIColor lightGrayColor];
                Distance.font=[UIFont systemFontOfSize:16];
                Distance.text=[NSString stringWithFormat:@"距离  %.1fkm",obj.distance];
                [cell addSubview:Distance];
            }
            else{
                UILabel *Distance=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(UserName.frame)+8, kMainScreenWidth-CGRectGetMaxX(UserLogo.frame)-80, 20)];
                Distance.backgroundColor=[UIColor clearColor];
                Distance.textAlignment=NSTextAlignmentLeft;
                Distance.textColor=[UIColor lightGrayColor];
                Distance.font=[UIFont systemFontOfSize:16];
                Distance.text=[NSString stringWithFormat:@"距离  %.1fkm",obj.distance];
                [cell addSubview:Distance];
                
                UILabel *MouthWord=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(Distance.frame)+5, 40, 20)];
                MouthWord.backgroundColor=[UIColor clearColor];
                MouthWord.textAlignment=NSTextAlignmentLeft;
                MouthWord.textColor=[UIColor lightGrayColor];
                MouthWord.font=[UIFont systemFontOfSize:16];
                MouthWord.text=@"口碑   ";
                [cell addSubview:MouthWord];
                
                NSInteger srat_full=0;
                NSInteger srat_half=0;
                if([obj.workerLevel integerValue]<[obj.workerLevel floatValue]){
                    srat_full=[obj.workerLevel integerValue];
                    srat_half=1;
                }
                else if([obj.workerLevel integerValue]==[obj.workerLevel floatValue]){
                    srat_full=[obj.workerLevel integerValue];
                    srat_half=0;
                }
                
                for(int i=0;i<5;i++){
                    if (i <srat_full) {
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(MouthWord.frame) + i * 18, CGRectGetMinY(MouthWord.frame)+1, 15, 15)];
                        [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
                        [cell addSubview:imageView];
                    }
                    else if (i==srat_full && srat_half!=0) {
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(MouthWord.frame) + i * 18, CGRectGetMinY(MouthWord.frame)+1, 15, 15)];
                        [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
                        [cell addSubview:imageView];
                    }
                    else {
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(MouthWord.frame) + i * 18, CGRectGetMinY(MouthWord.frame)+1, 15, 15)];
                        [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
                        [cell addSubview:imageView];
                    }
                }
            }
            
            UIButton *btn_phone=(UIButton *)[cell viewWithTag:KButtonTag_phone+indexPath.section];
            if(!btn_phone) btn_phone=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-60, 10, 50, 40)];
            btn_phone.tag=KButtonTag_phone+indexPath.section;
            [btn_phone setImage:[UIImage imageNamed:@"ic_dianhua"] forState:UIControlStateNormal];
            [btn_phone addTarget:self action:@selector(CallPhone:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn_phone];
        }
        
        return cell;
    }
    else{
        static NSString *cellid=@"SearchListCell1";
        SearchListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SearchListCell" owner:nil options:nil]lastObject];
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        for(id btn in cell.subviews) {
            if([btn isKindOfClass:[UIButton class]]) [btn removeFromSuperview];
        }
        
        if([dataArray_history count]!=indexPath.row){
            UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 49.5, kMainScreenWidth-40, 0.5)];
            line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
            line.alpha=0.6;
            [cell addSubview:line];
            
            cell.ser_his_lab.hidden=NO;
            cell.ser_his_lab.text=[dataArray_history objectAtIndex:indexPath.row];
        }
        else {
            cell.ser_his_lab.hidden=YES;
            if([dataArray_history count]){
                UIButton *clear_btn=[UIButton buttonWithType:UIButtonTypeCustom];
                clear_btn.frame=CGRectMake((kMainScreenWidth-20-(kMainScreenWidth-200))/2, 80, kMainScreenWidth-200, (kMainScreenWidth-200)/3);
                [clear_btn setTitle:@"清除历史" forState:UIControlStateNormal];
                [clear_btn setTitleColor:[UIColor colorWithHexString:@"#FB5051" alpha:1.0] forState:UIControlStateNormal];
                clear_btn.titleLabel.font=[UIFont systemFontOfSize:18];
                //给按钮加一个白色的板框
                clear_btn.layer.borderColor = [[UIColor colorWithHexString:@"#FB5051" alpha:1.0] CGColor];
                clear_btn.layer.borderWidth = 1.0f;
                //给按钮设置弧度,这里将按钮变成了圆形
                clear_btn.layer.cornerRadius = 5.0f;
                clear_btn.layer.masksToBounds = YES;
                [clear_btn addTarget:self action:@selector(pressClear_btn) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:clear_btn];
            }
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==mtableview) {
        WorkerListObj *obj_=[dataArray objectAtIndex:indexPath.section];
//        WorkerInfoViewController *desvc=[[WorkerInfoViewController alloc]init];
        XiaoGongNewDetailViewController *desvc = [[XiaoGongNewDetailViewController alloc]init];
        desvc.obj=obj_;
        [self.navigationController pushViewController:desvc animated:YES];
    }
    else{
        if([dataArray_history count]!=indexPath.row){
            UIView *line=(UIView *)[self.view viewWithTag:10];
            line.hidden=NO;
            for(int i=0;i<3;i++){
                UIButton *btn=(UIButton *)[self.view viewWithTag:kButton_topbtn+i];
                btn.hidden=NO;
            }
            
            [searchBar resignFirstResponder];
            mtableview.hidden=NO;
            mtableview_sub.hidden=YES;
            if([dataArray count]) {
                [dataArray removeAllObjects];
                [mtableview reloadData];
            }
            searchBar.text=[dataArray_history objectAtIndex:indexPath.row];
            if(![util isConnectionAvailable]) {
                [TLToast showWithText:@"亲，网络连接断开啦。。" topOffset:220.0f duration:1.0];
                imageview_bg.hidden=NO;
                label_bg.hidden = NO;
            }
            else [mtableview launchRefreshing];
            
            BOOL isDefault=YES;
            if(searchBar.text.length){
                for(int i=0;i<[dataArray_history count];i++){
                    NSString *str=[dataArray_history objectAtIndex:i];
                    if([str isEqualToString:searchBar.text]) {
                        [dataArray_history exchangeObjectAtIndex:0 withObjectAtIndex:i];
                        isDefault=NO;
                        break;
                    }
                }
            if(isDefault==YES) {
                if([dataArray_history count]>=15) [dataArray_history removeObjectsInRange:NSMakeRange(14, [dataArray_history count]-14)];
                [dataArray_history insertObject:searchBar.text atIndex:0];
            }
            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* doc_path = [path objectAtIndex:0];
            NSString* _filename = [doc_path stringByAppendingPathComponent:KHISTORY_SS_WORKER];
            [dataArray_history writeToFile:_filename atomically:NO];
            }
        }
    }
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=0;
        if([dataArray count]) {
            [dataArray removeAllObjects];
        }
        [self requestworkerlist];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestworkerlist];
        }
        else{
            
            [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            mtableview.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=YES;
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    //NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

//上拉加载  Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(mtableview==scrollView){
        if (mtableview.contentOffset.y<-60) {
            mtableview.reachedTheEnd = NO;  //是否加载到底了
        }
        //手指开始拖动方法
        [mtableview tableViewDidScroll:scrollView];
    }
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
     if(mtableview==scrollView) [mtableview tableViewDidEndDragging:scrollView];
}

-(void)CallPhone:(UIButton *)btn{
    
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    WorkerListObj *obj=[dataArray objectAtIndex:btn.tag-KButtonTag_phone];
    [self requestRecordCallinfo:obj];
    if ([osVersion floatValue] >= 3.1) {
        UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[obj.phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]]];
        webview.hidden = YES;
        // Assume we are in a view controller and have access to self.view
        [self.view addSubview:webview];
        
    }else {
        // On 3.0 and below, dial as usual
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[obj.phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    }
}

#pragma mark -
#pragma mark - UIButton

-(void)pressClear_btn{
    if([dataArray_history count]){
        [dataArray_history removeAllObjects];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:KHISTORY_SS_WORKER];
        [dataArray_history writeToFile:_filename atomically:NO];
    }
    [mtableview_sub reloadData];
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
