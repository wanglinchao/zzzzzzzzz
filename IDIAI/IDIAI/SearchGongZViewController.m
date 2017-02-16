//
//  SearchGongZViewController.m
//  IDIAI
//
//  Created by iMac on 15-2-4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SearchGongZViewController.h"
#import "HexColor.h"
#import "util.h"
#import "DesignerHostViewController.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "GongzhangListObj.h"
#import "DesignerListCell.h"
#import "UIImageView+OnlineImage.h"
#import "OpenUDID.h"
#import "ForemanInfoViewController.h"
#import "TLToast.h"
#import "Macros.h"
#import "IDIAIAppDelegate.h"
#import "SubscribePeopleViewController.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "IDIAIAppDelegate.h"
#import "savelogObj.h"
#import "GongzhangDetailViewController.h"
#import "SubscribeListModel.h"
#import "MySubscribeDetailViewController.h"
#import "IDIAI3GongZhangDetaileViewController.h"
#import "SearchListCell.h"


#define kButton_topbtn 100
#define kButton_phone 1000
#define KButtonTag_phone 10000
#define KUILabelTag_YuYueCount 100000

#define KHISTORY_SS_DESIGNER @"MyHistory_gongzhang.plist"

@interface SearchGongZViewController ()<UITextFieldDelegate,LoginViewDelegate>
{
    UITextField *searchBar;
    NSString *_bookIdStr;

}

@end

@implementation SearchGongZViewController

@synthesize dataArray,dataArray_history,selected_mark;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:NO];
    
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(244, 244, 246)];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 0, 0)];
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 60, 40)];
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton setTitleColor:kColorWithRGB(188, 187, 192) forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:18];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}

-(void)PressBarItemLeft{
    
}

-(void)PressBarItemRight{
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    [self customizeNavigationBar];
    
    [mtableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"工长--搜索" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:41];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    [self createUITextField];
    
    selected_mark=1;
    
    dataArray=[NSMutableArray arrayWithCapacity:0];
    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_ = [path_ objectAtIndex:0];
    NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:KHISTORY_SS_DESIGNER];
    dataArray_history=[NSMutableArray arrayWithContentsOfFile:_filename_];
    if (!dataArray_history) {
        dataArray_history=[NSMutableArray arrayWithCapacity:0];
    }
    if([dataArray_history count]>15) [dataArray_history removeObjectsInRange:NSMakeRange(15, [dataArray_history count]-15)];
    
    NSArray *arr_btnName=[NSArray arrayWithObjects:@"星级",@"热门", nil];
    for(int i=0;i<[arr_btnName count];i++){
        UIButton *btn=[[UIButton alloc]init];
        if(i==0) btn.frame=CGRectMake(kMainScreenWidth/2*i, 1, kMainScreenWidth/2, 40);
        else btn.frame=CGRectMake(kMainScreenWidth/2*i-1, 1, kMainScreenWidth/2+1.5, 40);
        [btn setTitle:[arr_btnName objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag=kButton_topbtn+i;
        if(i==0)[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        else [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(PressBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
    }
    UIView *line_slider=[[UIView alloc]initWithFrame:CGRectMake(kMainScreenWidth/6, 36, kMainScreenWidth/6, 2)];
    line_slider.tag=10;
    line_slider.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:line_slider];
    
    self.currentPage=0;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-40) pullingDelegate:self];
    mtableview.backgroundColor=[UIColor colorWithHexString:@"#f1f0f6"];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [self.view addSubview:mtableview];
    mtableview.hidden=YES;
    
    mtableview_sub=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
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
        line.frame=CGRectMake(kMainScreenWidth/6*(1+(selected_mark-1)*3), 36, kMainScreenWidth/6, 2);
    }completion:^(BOOL finished){
        
    }];
    
    for(int i=0;i<2;i++){
        UIButton *btn=(UIButton *)[self.view viewWithTag:kButton_topbtn+i];
        if(sender==btn) [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        else [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if([dataArray count]) {
        [dataArray removeAllObjects];
        [mtableview reloadData];
    }
    [mtableview launchRefreshing];
}

-(void)requestForemanlist{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0123\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"sortType\":\"%d\",\"keyword\":\"%@\",\"requestRow\":\"15\",\"currentPage\":\"%d\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],selected_mark,[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],self.currentPage+1];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"工长列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10461) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"foremanList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            if(self.refreshing==YES) [dataArray removeAllObjects];
                            for(NSDictionary *dict in arr_){
                                [dataArray addObject:[GongzhangListObj objWithDict:dict]];
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
                else if (code==10469) {
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
-(void)requestRecordCallinfo:(GongzhangListObj *)obj_{
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
        if([obj_.foremanMobile length]>2) str_called=obj_.foremanMobile;
        else str_called=@"";
        //获取被叫号码编号
        NSString *str_called_id;
        if([obj_.foremanId integerValue] >=0) str_called_id=[NSString stringWithFormat:@"%@",obj_.foremanId];
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
        [postDict02 setObject:@"1" forKey:@"calledIdenttityType"];
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
    mtableview_sub.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-kbSize.height);
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    //  NSString *str=[[UITextInputMode currentInputMode] primaryLanguage];  //语言
    
    CGSize kbSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"hide%f",kbSize.height);
    mtableview_sub.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64);
}

-(void)createUITextField{
    UIImageView *imv_ss=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_sousuo_s"]];
    imv_ss.frame=CGRectMake(10, 7.5, 15, 15);
    UIView *view_left_ss=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    view_left_ss.backgroundColor=[UIColor clearColor];
    [view_left_ss addSubview:imv_ss];
    
    searchBar=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-80, 30)];
    searchBar.borderStyle=UITextBorderStyleRoundedRect;
    searchBar.backgroundColor =kColorWithRGB(233, 233, 236);
    searchBar.delegate=self;
    searchBar.placeholder=@"请输入搜索内容";
    searchBar.returnKeyType=UIReturnKeySearch;
    searchBar.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    searchBar.font=[UIFont systemFontOfSize:15];
    searchBar.tintColor=kColorWithRGB(192, 192, 196);
    searchBar.clearsOnBeginEditing=YES;
    searchBar.clearButtonMode=UITextFieldViewModeWhileEditing;
    searchBar.leftView=view_left_ss;
    searchBar.leftViewMode=UITextFieldViewModeAlways;
    self.navigationItem.titleView=searchBar;
}

#pragma mark -
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIView *line=(UIView *)[self.view viewWithTag:10];
    line.hidden=YES;
    for(int i=0;i<2;i++){
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
  
    UIView *line=(UIView *)[self.view viewWithTag:10];
    line.hidden=NO;
    for(int i=0;i<2;i++){
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
        NSString* _filename = [doc_path stringByAppendingPathComponent:KHISTORY_SS_DESIGNER];
        [dataArray_history writeToFile:_filename atomically:NO];
    }
    
    return YES;
}

#pragma mark -UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView==mtableview) {
        if (section ==0) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
            view.backgroundColor=[UIColor clearColor];
            return view;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==mtableview) {
        if (section ==0) {
            return 10;
        }
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(tableView==mtableview){
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
        view.backgroundColor=[UIColor clearColor];
        return view;
    }
    else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
        view.backgroundColor=[UIColor clearColor];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView==mtableview) return 10;
    else return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==mtableview)return 166;
    else {
        if([dataArray_history count]==indexPath.row) return kMainScreenHeight-64-200;
        else return 50;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==mtableview) return [dataArray count];
    else return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==mtableview) return 1;
    else  {
        if([dataArray_history count]<=15) return [dataArray_history count]+1;
        else return 15+1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==mtableview){
        static NSString *cellid=@"mycellid";
        DesignerListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"DesignerListCell" owner:nil options:nil]lastObject];
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = YES;
        }
        
        if([dataArray count]){
            GongzhangListObj *obj=[dataArray objectAtIndex:indexPath.section];
            
            UIImageView *photo=(UIImageView *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section];
            if(!photo) photo=[[UIImageView alloc]initWithFrame:CGRectMake(14, 15, 45, 45)];
            photo.tag=KButtonTag_phone*2+indexPath.section;
            photo.layer.cornerRadius=22;
            photo.clipsToBounds=YES;
            [photo setOnlineImage:obj.foremanIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
            [cell addSubview:photo];
            
            if((![obj.foremanMobile length])) cell.designer_phone.hidden=YES;
            CGSize size_name=[util calHeightForLabel:obj.nickName width:170 font:[UIFont systemFontOfSize:17]];
            cell.designer_name.text=obj.nickName;
            cell.designer_name.frame =CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_name.frame.origin.y, cell.designer_name.frame.size.width, cell.designer_name.frame.size.height);
            if(obj.foremanExperience==nil)
                cell.designer_express.text=[NSString stringWithFormat:@"经验：%@",@"暂无"];
            else
                cell.designer_express.text=[NSString stringWithFormat:@"经验：%@",obj.foremanExperience];
            //[cell.designer_photo setOnlineImage:obj.designerIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
            cell.designer_express.frame =CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y, cell.designer_express.frame.size.width, cell.designer_express.frame.size.height);
            if([obj.foremanAuthzs  count]){
                for(int i=0;i<[obj.foremanAuthzs  count];i++){
                    NSDictionary *dict=[obj.foremanAuthzs  objectAtIndex:i];
                    UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(cell.designer_name.frame.origin.x+size_name.width+i*34+5, 16, 29, 13)];
                    //                image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_s_%@.png",[dict objectForKey:@"authzId"]]];
#warning 只有实名欠缺其他
                    if ([[dict objectForKey:@"authzId"] integerValue]==1) {
                        image_rz.image =[UIImage imageNamed:@"ic_shiming_n.png"];
                    }
                    [cell.contentView addSubview:image_rz];
                }
            }
            UILabel *credibilitylbl=(UILabel *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section+1];
            if(!credibilitylbl) credibilitylbl=[[UILabel alloc]initWithFrame:CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+cell.designer_express.frame.size.height+24, 30, 12)];
            credibilitylbl.tag=KButtonTag_phone*2+indexPath.section+1;
            credibilitylbl.font =[UIFont systemFontOfSize:12];
            credibilitylbl.text=@"口碑";
            credibilitylbl.textColor =[UIColor lightGrayColor];
            [cell addSubview:credibilitylbl];
            cell.view_star.frame =CGRectMake(credibilitylbl.frame.size.width+credibilitylbl.frame.origin.x+5, credibilitylbl.frame.origin.y-4, cell.view_star.frame.size.width, cell.view_star.frame.size.height);
            if(selected_mark!=2){
                NSInteger srat_full=0;
                NSInteger srat_half=0;
                if([obj.popularityLevel integerValue]<[obj.popularityLevel floatValue]){
                    srat_full=[obj.popularityLevel integerValue];
                    srat_half=1;
                }
                else if([obj.popularityLevel integerValue]==[obj.popularityLevel floatValue]){
                    srat_full=[obj.popularityLevel integerValue];
                    srat_half=0;
                }
                for(int i=0;i<5;i++){
                    if (i <srat_full) {
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                        [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
                        [cell.view_star addSubview:imageView];
                    }
                    else if (i==srat_full && srat_half!=0) {
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                        [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
                        [cell.view_star addSubview:imageView];
                        
                    }
                    else {
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                        [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
                        [cell.view_star addSubview:imageView];
                        
                    }
                }
                cell.image_collect.hidden=YES;
                cell.image_brower.hidden=YES;
            }
            else{
                cell.view_star.hidden=YES;
            }
            
            UIImageView *img_dhua=(UIImageView *)[cell viewWithTag:KButtonTag_phone*3+indexPath.section];
            if(!img_dhua) img_dhua=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3+((kMainScreenWidth-20)/4-40)/2-2, 17, 40, 20)];
            img_dhua.tag=KButtonTag_phone*3+indexPath.section;
            if([obj.state integerValue]==1) img_dhua.image=[UIImage imageNamed:@"bt_yuyue_nor.png"];
            else img_dhua.image=[UIImage imageNamed:@"btn_yuyue_no"];
            [cell addSubview:img_dhua];
            
            if([obj.state integerValue]==1){
                UIButton *btn_phone=(UIButton *)[cell viewWithTag:kButton_phone+indexPath.section];
                if(!btn_phone) btn_phone=[[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3, 17, (kMainScreenWidth-20)/4, 110)];
                btn_phone.tag=kButton_phone+indexPath.section;
                [btn_phone addTarget:self action:@selector(pressbtnTodesigner:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn_phone];
            }
            
            UILabel *yuyue_lab=(UILabel *)[cell viewWithTag:KUILabelTag_YuYueCount+indexPath.section];
            if(!yuyue_lab) yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(18, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25, 80, 13)];
            if (selected_mark ==2) {
                yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(18, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25,80, 13)];
            }
            yuyue_lab.tag=KUILabelTag_YuYueCount+indexPath.section;
            yuyue_lab.backgroundColor=[UIColor clearColor];
            yuyue_lab.textAlignment=NSTextAlignmentLeft;
            yuyue_lab.font=[UIFont systemFontOfSize:13];
            yuyue_lab.textColor=[UIColor lightGrayColor];
            int length =0;
            if([obj.appointmentNum integerValue]>=100000000) {yuyue_lab.text=[NSString stringWithFormat:@"%.1f亿",[obj.appointmentNum floatValue]/100000000.0];
                length =(int)yuyue_lab.text.length -1;
            }
            else if([obj.appointmentNum integerValue]>=10000){ yuyue_lab.text=[NSString stringWithFormat:@"%.1f万",[obj.appointmentNum floatValue]/10000.0];
                length =(int)yuyue_lab.text.length -1;
            }
            else {yuyue_lab.text=[NSString stringWithFormat:@"%@",obj.appointmentNum];
                length =(int)yuyue_lab.text.length;
            }
            yuyue_lab.frame =CGRectMake(18, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25,length*13, 13);
            //        yuyue_lab.backgroundColor =[UIColor redColor];
            yuyue_lab.textAlignment =NSTextAlignmentCenter;
            [cell addSubview:yuyue_lab];
            
            UILabel *yuyue_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(yuyue_lab.frame.origin.x, yuyue_lab.frame.origin.y+yuyue_lab.frame.size.height+9, MAX(length*13, 33), 11)];
            yuyue_foot_lab.textAlignment =NSTextAlignmentCenter;
            yuyue_foot_lab.text =@"预约数";
            yuyue_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            yuyue_foot_lab.font =[UIFont systemFontOfSize:11];
            //        yuyue_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:yuyue_foot_lab];
            
            cell.designer_phone.hidden=YES;
            cell.lab_brower.frame =CGRectMake(yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width-length/2*13+100+(5-length)*13, yuyue_lab.frame.origin.y, 0, 13);
            cell.lab_brower.backgroundColor=[UIColor clearColor];
            cell.lab_brower.textAlignment=NSTextAlignmentCenter;
            cell.lab_brower.font=[UIFont systemFontOfSize:13];
            cell.lab_brower.textColor=[UIColor lightGrayColor];
            length =0;
            if([obj.browsePoints integerValue]>=100000000){
                cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f亿",[obj.browsePoints floatValue]/100000000];
                length =(int)cell.lab_brower.text.length-1;
            }
            else if([obj.browsePoints integerValue]>=10000){ cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f万",[obj.browsePoints floatValue]/10000];
                length =(int)cell.lab_brower.text.length-1;
            }
            else{ cell.lab_brower.text=obj.browsePoints;
                length =(int)cell.lab_brower.text.length;;
            }
            
            cell.lab_brower.frame =CGRectMake((yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width-length/2*13+100+(5-length)*13)*kMainScreenWidth/375, yuyue_lab.frame.origin.y, length*13, 13);
            UILabel *brower_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(cell.lab_brower.frame.origin.x, cell.lab_brower.frame.origin.y+cell.lab_brower.frame.size.height+9, MAX(length*13, 33), 11)];
            brower_foot_lab.textAlignment =NSTextAlignmentCenter;
            brower_foot_lab.text =@"浏览数";
            brower_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            brower_foot_lab.font =[UIFont systemFontOfSize:11];
            //        brower_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:brower_foot_lab];
            cell.lab_collect.frame =CGRectMake((cell.lab_brower.frame.origin.x+cell.lab_brower.frame.size.width-length/2*13+80+(5-length)*13)*kMainScreenWidth/375, cell.lab_brower.frame.origin.y, 0, 13);
            cell.lab_collect.backgroundColor=[UIColor clearColor];
            cell.lab_collect.textAlignment=NSTextAlignmentCenter;
            cell.lab_collect.font=[UIFont systemFontOfSize:13];
            cell.lab_collect.textColor=[UIColor lightGrayColor];
            length =0;
            if([obj.collectPoints integerValue]>=100000000) {cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f亿",[obj.collectPoints floatValue]/100000000];
                length =(int)cell.lab_collect.text.length-1;
            }
            else if([obj.collectPoints integerValue]>=10000) {cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f万",[obj.collectPoints floatValue]/10000];
                length =(int)cell.lab_collect.text.length-1;
            }
            else{ cell.lab_collect.text=obj.collectPoints;
                length =(int)cell.lab_collect.text.length;
            };
            cell.lab_collect.frame =CGRectMake((cell.lab_brower.frame.origin.x+cell.lab_brower.frame.size.width-length/2*13+80+(5-length)*13)*kMainScreenWidth/375, cell.lab_brower.frame.origin.y, length*13, 13);
            
            UILabel *collect_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(cell.lab_collect.frame.origin.x, cell.lab_collect.frame.origin.y+cell.lab_collect.frame.size.height+9, MAX(length*13, 33), 11)];
            collect_foot_lab.textAlignment =NSTextAlignmentCenter;
            collect_foot_lab.text =@"收藏数";
            collect_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            collect_foot_lab.font =[UIFont systemFontOfSize:11];
            //        collect_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:collect_foot_lab];
            
            //        if([obj.state integerValue]==1){
            //            cell.designer_phone.tag=kButton_phone+indexPath.row;
            //            [cell.designer_phone addTarget:self action:@selector(pressbtnTodesigner:) forControlEvents:UIControlEventTouchUpInside];
            //        }
            //        else{
            //            cell.designer_phone.hidden=YES;
            //        }
        }
        
        return cell;
//        if([dataArray count]){
//            GongzhangListObj *obj=[dataArray objectAtIndex:indexPath.section];
//            CGSize size_name=[util calHeightForLabel:obj.nickName width:170 font:[UIFont systemFontOfSize:17]];
//            cell.designer_name.text=obj.nickName;
//            if(obj.foremanExperience==nil)
//                cell.designer_express.text=[NSString stringWithFormat:@"从业经验：%@",@"暂无"];
//            else
//                cell.designer_express.text=[NSString stringWithFormat:@"从业经验：%@",obj.foremanExperience];
//            cell.designer_photo.clipsToBounds=YES;
//            cell.designer_photo.contentMode=UIViewContentModeScaleAspectFill;
//           // [cell.designer_photo setOnlineImage:obj.foremanIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
//            if([obj.foremanAuthzs count]){
//                for(int i=0;i<[obj.foremanAuthzs count];i++){
//                    NSDictionary *dict=[obj.foremanAuthzs objectAtIndex:i];
//                    UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(25+size_name.width+i*20, 15, 15, 15)];
//                    image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_s_%@.png",[dict objectForKey:@"authzId"]]];
//                    [cell addSubview:image_rz];
//                }
//            }
//            if(selected_mark==1){
//                NSInteger srat_full=0;
//                NSInteger srat_half=0;
//                if([obj.foremanLevel integerValue]<[obj.foremanLevel floatValue]){
//                    srat_full=[obj.foremanLevel integerValue];
//                    srat_half=1;
//                }
//                else if([obj.foremanLevel integerValue]==[obj.foremanLevel floatValue]){
//                    srat_full=[obj.foremanLevel integerValue];
//                    srat_half=0;
//                }
//                for(int i=0;i<5;i++){
//                    if (i <srat_full) {
//                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
//                        [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
//                        [cell.view_star addSubview:imageView];
//                        
//                    }
//                    else if (i==srat_full && srat_half!=0) {
//                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
//                        [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
//                        [cell.view_star addSubview:imageView];
//                        
//                    }
//                    else {
//                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
//                        [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
//                        [cell.view_star addSubview:imageView];
//                        
//                    }
//                }
//                cell.image_collect.hidden=YES;
//                cell.image_brower.hidden=YES;
//            }
//            else{
//                cell.view_star.hidden=YES;
//                if([obj.collectPoints integerValue]>=100000000) cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f亿",[obj.collectPoints floatValue]/100000000];
//                else if([obj.collectPoints integerValue]>=10000) cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f万",[obj.collectPoints floatValue]/10000];
//                else cell.lab_collect.text=obj.collectPoints;
//                
//                if([obj.browsePoints integerValue]>=100000000) cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f亿",[obj.browsePoints floatValue]/100000000];
//                else if([obj.browsePoints integerValue]>=10000) cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f万",[obj.browsePoints floatValue]/10000];
//                else cell.lab_brower.text=obj.browsePoints;
//            }
//            
//            UIImageView *photo=(UIImageView *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section];
//            if(!photo) photo=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3+((kMainScreenWidth-20)/4-50)/2-2, 15, 50, 50)];
//            photo.tag=KButtonTag_phone*2+indexPath.section;
//            photo.layer.cornerRadius=25;
//            photo.clipsToBounds=YES;
//            [photo setOnlineImage:obj.foremanIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
//            [cell addSubview:photo];
//            
//            UIImageView *img_dhua=(UIImageView *)[cell viewWithTag:KButtonTag_phone*3+indexPath.section];
//            if(!img_dhua) img_dhua=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3+((kMainScreenWidth-20)/4-40)/2-2, 75, 40, 20)];
//            img_dhua.tag=KButtonTag_phone*3+indexPath.section;
//            if([obj.state integerValue]==1) img_dhua.image=[UIImage imageNamed:@"bt_yuyue_nor.png"];
//            else img_dhua.image=[UIImage imageNamed:@"btn_yuyue_no"];
//            [cell addSubview:img_dhua];
//            
//            if([obj.state integerValue]==1){
//                UIButton *btn_phone=(UIButton *)[cell viewWithTag:kButton_phone+indexPath.section];
//                if(!btn_phone) btn_phone=[[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3, 0, (kMainScreenWidth-20)/4, 110)];
//                btn_phone.tag=kButton_phone+indexPath.section;
//                [btn_phone addTarget:self action:@selector(pressbtnTodesigner:) forControlEvents:UIControlEventTouchUpInside];
//                [cell addSubview:btn_phone];
//            }
//            
//            UILabel *yuyue_lab=(UILabel *)[cell viewWithTag:KUILabelTag_YuYueCount+indexPath.section];
//            if(!yuyue_lab) yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 85, kMainScreenWidth/2+20, 20)];
//            if (selected_mark ==1) {
//                yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 59, kMainScreenWidth/2+20, 20)];
//            }
//            yuyue_lab.tag=KUILabelTag_YuYueCount+indexPath.section;
//            yuyue_lab.backgroundColor=[UIColor clearColor];
//            yuyue_lab.textAlignment=NSTextAlignmentLeft;
//            yuyue_lab.font=[UIFont systemFontOfSize:16];
//            yuyue_lab.textColor=[UIColor lightGrayColor];
//            if([obj.appointmentNum integerValue]>=100000000) yuyue_lab.text=[NSString stringWithFormat:@"预  约  数：%.1f亿",[obj.appointmentNum floatValue]/100000000.0];
//            else if([obj.appointmentNum integerValue]>=10000) yuyue_lab.text=[NSString stringWithFormat:@"预  约  数：%.1f万",[obj.appointmentNum floatValue]/10000.0];
//            else yuyue_lab.text=[NSString stringWithFormat:@"预  约  数：%@",obj.appointmentNum];
//            [cell addSubview:yuyue_lab];
//            
//            cell.designer_phone.hidden=YES;
////            
////            if([obj.state integerValue]==1){
////            cell.designer_phone.tag=kButton_phone+indexPath.row;
////            [cell.designer_phone addTarget:self action:@selector(pressbtnTodesigner:) forControlEvents:UIControlEventTouchUpInside];
////            }
////            else{
////                cell.designer_phone.hidden=YES;
////            }
//        }
//        
//        return cell;
    }
    else{
        static NSString *cellid=@"mycellid_";
        SearchListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SearchListCell" owner:nil options:nil]lastObject];
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        for(id btn in cell.subviews) {
            if([btn isKindOfClass:[UIButton class]])[btn removeFromSuperview];
        }
        
        if([dataArray_history count]!=indexPath.row){
            UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 49.5, kMainScreenWidth-40, 0.5)];
            line.backgroundColor=[UIColor lightGrayColor];
            line.alpha=0.6;
            [cell addSubview:line];
            
            cell.ser_his_lab.hidden=NO;
            cell.ser_his_lab.text=[dataArray_history objectAtIndex:indexPath.row];
        }
        else {
            cell.ser_his_lab.hidden=YES;
            if([dataArray_history count]){
                UIButton *clear_btn=[UIButton buttonWithType:UIButtonTypeCustom];
                clear_btn.frame=CGRectMake((kMainScreenWidth-20-134)/2, 100, 134, 31);
                [clear_btn setTitle:@"清除历史" forState:UIControlStateNormal];
                [clear_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                clear_btn.titleLabel.font=[UIFont systemFontOfSize:15];
                //给按钮加一个白色的板框
                clear_btn.layer.borderColor = [[UIColor redColor] CGColor];
                clear_btn.layer.borderWidth = 1.0f;
                //给按钮设置弧度,这里将按钮变成了圆形
                clear_btn.layer.cornerRadius = 4.0f;
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
        GongzhangListObj *obj=[dataArray objectAtIndex:indexPath.section];
//        ForemanInfoViewController *infovc=[[ForemanInfoViewController alloc]init];
        IDIAI3GongZhangDetaileViewController *infovc = [[IDIAI3GongZhangDetaileViewController alloc]init];
//        infovc.formanid=obj.foremanId;
        infovc.obj = obj;
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
        [appDelegate.nav pushViewController:infovc animated:YES];
//         [self.navigationController pushViewController:infovc animated:YES];
    }
    else{
        if([dataArray_history count]!=indexPath.row){
            UIView *line=(UIView *)[self.view viewWithTag:10];
            line.hidden=NO;
            for(int i=0;i<2;i++){
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
            NSString* _filename = [doc_path stringByAppendingPathComponent:KHISTORY_SS_DESIGNER];
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
        [self requestForemanlist];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestForemanlist];
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

-(void)pressbtnTodesigner:(UIButton *)btn{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]) {
        self.selected_btn=btn.tag;
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
    
    GongzhangListObj *obj=[dataArray objectAtIndex:btn.tag-kButton_phone];
    
    [self requestCheckSubcribeStatus:obj.foremanId];
}

#pragma mark -
#pragma mark - UIButton

-(void)pressClear_btn{
    if([dataArray_history count]){
        [dataArray_history removeAllObjects];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:KHISTORY_SS_DESIGNER];
        [dataArray_history writeToFile:_filename atomically:NO];
    }
    [mtableview_sub reloadData];
}

#pragma mark -LoginDelegate

//-(void)logged:(NSDictionary *)dict{
//    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate.nav dismissViewControllerAnimated:YES completion:^{
//        GongzhangListObj *obj=[dataArray objectAtIndex:self.selected_btn-kButton_phone];
//        
//        SubscribeViewController *subscribeVC = [[SubscribeViewController alloc]initWithNibName:@"SubscribeViewController" bundle:nil];
//        subscribeVC.businessIDStr = [NSString stringWithFormat:@"%@",obj.foremanId];
//        subscribeVC.servantRoleIdStr = @"4";
//        [appDelegate.nav pushViewController:subscribeVC animated:YES];
//    }];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
    [appDelegate.nav dismissViewControllerAnimated:YES completion:^{
        GongzhangListObj *obj=[dataArray objectAtIndex:self.selected_btn-kButton_phone];
        
       SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
        subscribeVC.businessIDStr = [NSString stringWithFormat:@"%@",obj.foremanId];
        subscribeVC.servantRoleIdStr = @"4";
        [appDelegate.nav pushViewController:subscribeVC animated:YES];
    }];

}

-(void)cancel{
    
}

#pragma mark - 检查预约状态
-(void)requestCheckSubcribeStatus:(NSString *)designerIdStr {
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
        [postDict setObject:@"ID0131" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"businessID":designerIdStr,@"servantRoleId":@"4"};
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
                        self.view.tag = 1001;
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 101311) {
                        [self stopRequest];
                        SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
                        subscribeVC.businessIDStr = designerIdStr;
                        subscribeVC.servantRoleIdStr = @"4";
                        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
                        [appDelegate.nav pushViewController:subscribeVC animated:YES];
//                        [self.navigationController pushViewController:subscribeVC animated:YES];
                        
                    } else if (kResCode == 101319) {
                        [self stopRequest];
                        [TLToast showWithText:@"检查预约状态失败"];
                    } else if (kResCode == 101312) {
                        [self stopRequest];
                        _bookIdStr = [jsonDict objectForKey:@"bookId"];
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"亲，您已预约该师傅" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
                        alertView.delegate = self;
                        [alertView show];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else {
        [self requestSubcribeDetail:_bookIdStr];
    }
}

#pragma mark - 预约详情
-(void)requestSubcribeDetail:(NSString *)bookIdStr {
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
        [postDict setObject:@"ID0107" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"bookId":bookIdStr};
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
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        self.view.tag = 1001;
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 101071) {
                        [self stopRequest];
                        SubscribeListModel *model = [SubscribeListModel objectWithKeyValues:[jsonDict objectForKey:@"BookBean"]];
                        
                        MySubscribeDetailViewController *mySubscribeDetailVC = [[MySubscribeDetailViewController alloc]init];
                        SubscribeListModel *subcribeListModel = model;
                        //                        mySubscribeDetailVC.delegate = self;
                        mySubscribeDetailVC.subscribeListModel = subcribeListModel;
                        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                        [delegate.nav pushViewController:mySubscribeDetailVC animated:YES];
                        
                    } else if (kResCode == 101079) {
                        [self stopRequest];
                        [TLToast showWithText:@"查询失败"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
