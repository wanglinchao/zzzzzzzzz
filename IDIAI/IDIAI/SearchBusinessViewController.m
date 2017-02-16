//
//  SearchBusinessViewController.m
//  IDIAI
//
//  Created by iMac on 14-12-10.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SearchBusinessViewController.h"
#import "HexColor.h"
#import "util.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "GoodslistObj.h"
#import "GoodsListCell.h"
#import "UIImageView+WebCache.h"
#import "OpenUDID.h"
#import "BusinessInfoVC.h"
#import "TLToast.h"


#define kButton_topbtn 100
#define kButton_phone 1000
#define KHISTORY_SS_BUSINESS @"MyHistory_business.plist"
@interface SearchBusinessViewController ()<UITextFieldDelegate>
{
    UITextField *searchBar;
    UIImageView *imageview_bg;
    UILabel *label_bg;
}


@end

@implementation SearchBusinessViewController
@synthesize dataArray,dataArray_history,selected_mark;
@synthesize lat_,lng_;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:NO];
    
//    UIColor *color = [UIColor colorWithHexString:@"#EF6562" alpha:1.0];
//    UIImage *image = [util imageWithColor:color];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
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
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:20];
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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
        self.edgesForExtendedLayout=UIRectEdgeNone;
    [mtableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self customizeNavigationBar];
    
    [self createUITextField];
    
    selected_mark=1;
    self.currentPage=0;
    
    dataArray=[NSMutableArray arrayWithCapacity:0];
    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_ = [path_ objectAtIndex:0];
    NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:KHISTORY_SS_BUSINESS];
    dataArray_history=[NSMutableArray arrayWithContentsOfFile:_filename_];
    if (!dataArray_history) {
        dataArray_history=[NSMutableArray arrayWithCapacity:0];
    }
    
    NSArray *arr_btnName=[NSArray arrayWithObjects:@"星级",@"距离",@"热门", nil];
    for(int i=0;i<[arr_btnName count];i++){
        UIButton *btn=[[UIButton alloc]init];
        if(i!=1) btn.frame=CGRectMake(kMainScreenWidth/3*i, 1, kMainScreenWidth/3, 40);
        else btn.frame=CGRectMake(kMainScreenWidth/3*i-1, 1, kMainScreenWidth/3+2, 40);
        //给按钮加一个白色的板框
        btn.layer.borderColor = [[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5] CGColor];
        btn.layer.borderWidth = 1.0f;
        //给按钮设置弧度,这里将按钮变成了圆形
        btn.layer.cornerRadius = 0.0f;
        btn.layer.masksToBounds = YES;
        [btn setTitle:[arr_btnName objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag=kButton_topbtn+i;
        if(i==0)[btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        else [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];        [btn addTarget:self action:@selector(PressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight -64-40) style:UITableViewStyleGrouped];
    mtableview.pullingDelegate = self;
    //mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [self.view addSubview:mtableview];
    mtableview.hidden=YES;
    
    mtableview_sub=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-40) style:UITableViewStylePlain];
    mtableview_sub.delegate=self;
    mtableview_sub.dataSource=self;
    [self.view addSubview:mtableview_sub];
    
    UIView *footer_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 100)];
    mtableview_sub.tableFooterView=footer_view;
    
    UIButton *clear_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    clear_btn.frame=CGRectMake((kMainScreenWidth-100)/2, 30, 100, 30);
    [clear_btn setTitle:@"清除历史" forState:UIControlStateNormal];
    [clear_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    clear_btn.titleLabel.font=[UIFont systemFontOfSize:18];
    //给按钮加一个白色的板框
    clear_btn.layer.borderColor = [[UIColor grayColor] CGColor];
    clear_btn.layer.borderWidth = 1.0f;
    //给按钮设置弧度,这里将按钮变成了圆形
    clear_btn.layer.cornerRadius = 2.0f;
    clear_btn.layer.masksToBounds = YES;
    [clear_btn addTarget:self action:@selector(pressClear_btn) forControlEvents:UIControlEventTouchUpInside];
    [footer_view addSubview:clear_btn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    [self loadImageviewBG];
    
    [searchBar becomeFirstResponder];
}

-(void)loadImageviewBG{
    UIImage *image_failed = [UIImage imageNamed:@"ic_moren"];
    if(!imageview_bg)
        imageview_bg=[[UIImageView alloc] initWithImage:image_failed ];
    imageview_bg.frame=CGRectMake((kMainScreenWidth-image_failed.size.width)/2, (kMainScreenHeight-64-40-image_failed.size.height)/2, image_failed.size.width, image_failed.size.height);
    imageview_bg.tag=111;
    imageview_bg.hidden=YES;
    [self.view addSubview:imageview_bg];
    if (!label_bg)
        label_bg = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview_bg.frame.origin.y + imageview_bg.frame.size.height + 5, kMainScreenWidth, 21)];
    label_bg.textAlignment = NSTextAlignmentCenter;
    label_bg.font = [UIFont systemFontOfSize:13];
    label_bg.textColor = [UIColor lightGrayColor];
    label_bg.hidden = YES;
    label_bg.text = @"亲，没有找到匹配内容哟";
    [self.view addSubview:label_bg];
}


-(void)PressBtn:(UIButton *)sender{
    selected_mark=sender.tag-kButton_topbtn+1;
    for(int i=0;i<3;i++){
        UIButton *btn=(UIButton *)[self.view viewWithTag:kButton_topbtn+i];
        if(sender==btn) [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        else [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if([dataArray count]) {
        [dataArray removeAllObjects];
        [mtableview reloadData];
    }
    [mtableview launchRefreshing];
}

-(void)requestshopslist{
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
        
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0001\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"searchContent\":\"%@\",\"requestArea\":\"-1\",\"businessID\":\"-1\",\"requestRow\":\"15\",\"currentPage\":\"%d\",\"sortType\":\"%d\",\"userLongitude\":\"%@\",\"userLatitude\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],self.currentPage+1,selected_mark,lng_,lat_];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"材料商列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10011) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *arr_=[jsonDict objectForKey:@"shopList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                [dataArray addObject:[GoodslistObj objWithDict:dict]];
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
                else if (code==10012) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mtableview tableViewDidFinishedLoading];
                        if(![dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [mtableview reloadData];
                    });
                }
                else if (code==10019) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
                        if(![dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
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
                                  [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
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
-(void)requestRecordCallinfo:(GoodslistObj *)obj{
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
        if([obj.shopMobileNum length]>2) str_called=obj.shopMobileNum;
        else str_called=@"";
        //获取被叫号码编号
        NSString *str_called_id;
        if([obj.shopID integerValue] >=0) str_called_id=[NSString stringWithFormat:@"%@",obj.shopID];
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
        [postDict02 setObject:@"2" forKey:@"calledIdenttityType"];
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
    searchBar.delegate=self;
    searchBar.placeholder=@"请输入搜索内容";
    searchBar.returnKeyType=UIReturnKeySearch;
    searchBar.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    searchBar.font=[UIFont systemFontOfSize:15];
    searchBar.tintColor=[UIColor redColor];
    searchBar.clearsOnBeginEditing=YES;
    searchBar.clearButtonMode=UITextFieldViewModeWhileEditing;
    searchBar.leftView=view_left_ss;
    searchBar.leftViewMode=UITextFieldViewModeAlways;
    self.navigationItem.titleView=searchBar;
}

#pragma mark -
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
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
    
    if(textField.text.length){
        [dataArray_history insertObject:textField.text atIndex:0];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:KHISTORY_SS_BUSINESS];
        [dataArray_history writeToFile:_filename atomically:NO];
    }
    
    return YES;
}

#pragma mark -UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 20)];
    view_.backgroundColor=[UIColor clearColor];
    
    return view_;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==mtableview)return 250;
    else return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     if(tableView==mtableview) return [dataArray count];
     else return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==mtableview) return 1;
    else {
        if([dataArray_history count]<=15) return [dataArray_history count];
        else return 15;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==mtableview){
        static NSString *cellid=@"mycellid";
        GoodsListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"GoodsListCell" owner:nil options:nil]lastObject];
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if([self.dataArray count]){
            GoodslistObj *obj=[self.dataArray objectAtIndex:indexPath.section];
             CGSize size_name=[util calHeightForLabel:obj.shopName width:167 font:[UIFont systemFontOfSize:17]];
            cell.shop_name.text=obj.shopName;
            cell.image_big.clipsToBounds=YES;
            cell.image_big.contentMode=UIViewContentModeScaleAspectFill;
            [cell.image_big sd_setImageWithURL:[NSURL URLWithString:obj.shopLitimgPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
            
            if(![obj.distance isEqual:[NSNull null]] && ![obj.distance isEqualToString:@"(null)"]){
                if(![obj.distance isEqualToString:@"-1"])
                    cell.lab_distance.text=[NSString stringWithFormat:@"%0.1fkm",[obj.distance floatValue]];
                else
                    cell.lab_distance.text=@"无法定位";
            }
            else
                cell.lab_distance.text=@"";
            
            if([obj.arr_rztype count]){
                for(int i=0;i<[obj.arr_rztype count];i++){
                    NSDictionary *dict=[obj.arr_rztype objectAtIndex:i];
                    UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(20+size_name.width+i*25, 195, 20, 20)];
                    image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_s_%@.png",[dict objectForKey:@"authzId"]]];
                    [cell addSubview:image_rz];
                }
            }
            
            if(selected_mark!=3){
                NSInteger srat_full=0;
                NSInteger srat_half=0;
                if([obj.shopLevel integerValue]<[obj.shopLevel floatValue]){
                    srat_full=[obj.shopLevel integerValue];
                    srat_half=1;
                }
                else if([obj.shopLevel integerValue]==[obj.shopLevel floatValue]){
                    srat_full=[obj.shopLevel integerValue];
                    srat_half=0;
                }
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, 220, 100, 20)];
                view.backgroundColor=[UIColor clearColor];
                for(int i=0;i<5;i++){
                    if (i <srat_full) {
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
                        [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
                        [view addSubview:imageView];
                        
                    }
                    else if (i==srat_full && srat_half!=0) {
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
                        [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
                        [view addSubview:imageView];
                        
                    }
                    else {
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
                        [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
                        [view addSubview:imageView];
                        
                    }
                }
                [cell addSubview:view];
                cell.image_brower.hidden=YES;
                cell.image_collect.hidden=YES;
            }
            else{
                if([obj.shopCollectPoints integerValue]>=100000000) cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f亿",[obj.shopCollectPoints floatValue]/100000000];
                else if([obj.shopCollectPoints integerValue]>=10000) cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f万",[obj.shopCollectPoints floatValue]/10000];
                else cell.lab_collect.text=obj.shopCollectPoints;
                
                if([obj.shopBrowsePoints integerValue]>=100000000) cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f亿",[obj.shopBrowsePoints floatValue]/100000000];
                else if([obj.shopBrowsePoints integerValue]>=10000) cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f万",[obj.shopBrowsePoints floatValue]/10000];
                else cell.lab_brower.text=obj.shopBrowsePoints;
            }
            
        }
        
        return cell;
    }
    else{
        static NSString *cellid=@"mycellid_";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=[dataArray_history objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==mtableview) {
        GoodslistObj *obj_=[dataArray objectAtIndex:indexPath.section];
        BusinessInfoVC *desvc=[[BusinessInfoVC alloc]init];
        desvc.obj=obj_;
        [self.navigationController pushViewController:desvc animated:YES];
    }
    else{
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
        
        [dataArray_history insertObject:searchBar.text atIndex:0];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:KHISTORY_SS_BUSINESS];
        [dataArray_history writeToFile:_filename atomically:NO];
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
        [self requestshopslist];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestshopslist];
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
    
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    GoodslistObj *obj=[dataArray objectAtIndex:btn.tag-kButton_phone];
    [self requestRecordCallinfo:obj];
    if ([osVersion floatValue] >= 3.1) {
        UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[obj.shopMobileNum stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]]];
        webview.hidden = YES;
        // Assume we are in a view controller and have access to self.view
        [self.view addSubview:webview];
        
    }else {
        // On 3.0 and below, dial as usual
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[obj.shopMobileNum stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    }
}

#pragma mark -
#pragma mark - UIButton

-(void)pressClear_btn{
    if([dataArray_history count]){
        [dataArray_history removeAllObjects];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:KHISTORY_SS_BUSINESS];
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
