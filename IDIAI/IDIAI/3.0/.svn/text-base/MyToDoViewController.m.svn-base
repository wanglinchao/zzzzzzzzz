//
//  MyToDoViewController.m
//  IDIAI
//
//  Created by Ricky on 16/5/10.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyToDoViewController.h"
#import "LoginView.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "MyToDoObject.h"
#import "UIImageView+OnlineImage.h"
#import "TLToast.h"
@interface MyToDoViewController (){
    UIImageView *imageview_bg;
    UILabel *label_bg;
}
//@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MyToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"我的待办";
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.dataArray =[NSMutableArray array];
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) pullingDelegate:self];
    self.mtableview.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
    self.mtableview.dataSource=self;
    self.mtableview.delegate=self;
    self.mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.mtableview.tableHeaderView =backView;
//    self.isRefresh =YES;
    [self.mtableview launchRefreshing];
    [self.view addSubview:self.mtableview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 44;
    }
    return 84;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MyToDoObject *todoobject =[self.dataArray objectAtIndex:section];
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 84)];
    backView.backgroundColor =kColorWithRGB(229, 228, 233);
    if (section ==0) {
        backView.frame =CGRectMake(0, 0, kMainScreenWidth, 44);
    }
    UIView *topView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    topView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    if (section ==0) {
        topView.frame =CGRectMake(0, 0, kMainScreenWidth, 0);
    }
    [backView addSubview:topView];
    
    
//    backView.backgroundColor =[UIColor redColor];
    
    UIImageView *photo=[[UIImageView alloc]initWithFrame:CGRectMake(15, 47, 30, 30)];
//    photo.tag=KButtonTag_phone*2+indexPath.section;
    if (section ==0) {
        photo.frame =CGRectMake(15, 7, 30, 30);
    }
    photo.layer.cornerRadius=12;
    photo.clipsToBounds=YES;
    photo.image =[UIImage imageNamed:@"ic_touxiang_tk"];
    if (todoobject.roleId==7) {
        photo.image =[UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[todoobject.userLogo stringByReplacingOccurrencesOfString:@"\n" withString:@""]  options:NSDataBase64DecodingIgnoreUnknownCharacters]];
    }else{
        [photo setOnlineImage:todoobject.userLogo placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
    }
    [backView addSubview:photo];
    
    
    CGSize size_name=[util calHeightForLabel:todoobject.userName width:80 font:[UIFont systemFontOfSize:18]];
    UILabel *namelbl =[[UILabel alloc] initWithFrame:CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, 45, 80, 18)];
    if (section ==0) {
        namelbl.frame =CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, 5, 80, 18);
    }
    namelbl.text =todoobject.userName;
    namelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    namelbl.font =[UIFont systemFontOfSize:18];
//    namelbl.backgroundColor =[UIColor redColor];
    [backView addSubview:namelbl];
    
    UIImageView *typeimage =[[UIImageView alloc] initWithFrame:CGRectMake(namelbl.frame.origin.x+size_name.width+5, namelbl.frame.origin.y+2, 33, 14)];
    [backView addSubview:typeimage];
    if (todoobject.roleId ==1) {
        typeimage.frame =CGRectMake(typeimage.frame.origin.x, typeimage.frame.origin.y, 43, 14);
        typeimage.image =[UIImage imageNamed:@"ic_shejishi.png"];
    }else if (todoobject.roleId ==4){
        typeimage.image =[UIImage imageNamed:@"ic_gongzhang_diary.png"];
    }else if (todoobject.roleId ==6){
        typeimage.image =[UIImage imageNamed:@"ic_jianli_diary.png"];
    }else if (todoobject.roleId ==7){
        typeimage.image =[UIImage imageNamed:@"ic_yezhu.png"];
    }
        
    CGSize phase_size_name=[util calHeightForLabel:todoobject.phaseName width:kMainScreenWidth-15-phase_size_name.width-33 font:[UIFont systemFontOfSize:18]];
    UILabel *phaselbl =[[UILabel alloc] initWithFrame:CGRectMake(typeimage.frame.origin.x+typeimage.frame.size.width+10, 45, kMainScreenWidth-40-typeimage.frame.origin.x-typeimage.frame.size.width, 18)];
    if (section ==0) {
        phaselbl.frame =CGRectMake(typeimage.frame.origin.x+typeimage.frame.size.width+10, 5, kMainScreenWidth-40-typeimage.frame.origin.x-typeimage.frame.size.width, 18);
    }
    phaselbl.text =todoobject.phaseName;
    phaselbl.textColor =[UIColor colorWithHexString:@"#575757"];
    phaselbl.font =[UIFont systemFontOfSize:18];
    phaselbl.textAlignment =NSTextAlignmentRight;
//    phaselbl.backgroundColor =[UIColor purpleColor];
    [backView addSubview:phaselbl];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:todoobject.beginDate/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    UILabel *startdate =[[UILabel alloc] initWithFrame:CGRectMake(namelbl.frame.origin.x, namelbl.frame.origin.y+namelbl.frame.size.height+5, kMainScreenWidth, 14)];
    startdate.text=confromTimespStr;
    startdate.font =[UIFont systemFontOfSize:14];
    startdate.textColor =[UIColor colorWithHexString:@"#575757"];
    [backView addSubview:startdate];
    
    UIView *footview =[[UIView alloc] initWithFrame:CGRectMake(0, startdate.frame.origin.y+startdate.frame.size.height+4, kMainScreenWidth, 4)];
    footview.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [backView addSubview:footview];
    return backView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString *CellIdentifier1 = [NSString stringWithFormat:@"MyCellIdentifier%d%d",(int)indexPath.section,(int)indexPath.row];
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    MyToDoObject *todoobject =[self.dataArray objectAtIndex:indexPath.section];
    if (!cell1) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
//        if (indexPath.row <todoobject.unfinised.count) {
            UIView *tableCellBack =[[UIView alloc] initWithFrame:CGRectMake(10, 4, kMainScreenWidth-20, 40)];
            tableCellBack.tag =100001;
            tableCellBack.backgroundColor =[UIColor whiteColor];
            [cell1 addSubview:tableCellBack];
            
            UIImageView *selectimage =[[UIImageView alloc] initWithFrame:CGRectMake(14, 7, 25, 25)];
            selectimage.tag =1000;
            [tableCellBack addSubview:selectimage];
            
            UILabel *contentlbl =[[UILabel alloc] initWithFrame:CGRectMake(selectimage.frame.origin.x+selectimage.frame.size.width+15, selectimage.frame.origin.y+3.5, (kMainScreenWidth-53-30)/2, 18)];
            contentlbl.font =[UIFont systemFontOfSize:18];
            contentlbl.textColor =[UIColor  colorWithHexString:@"#575757"];
            contentlbl.tag =1001;
            [tableCellBack addSubview:contentlbl];
            
            UILabel *datelbl =[[UILabel alloc] initWithFrame:CGRectMake(contentlbl.frame.origin.x+contentlbl.frame.size.width, selectimage.frame.origin.y+3.5, (kMainScreenWidth-53-30)/2, 18)];
            datelbl.font =[UIFont systemFontOfSize:18];
            datelbl.tag =1002;
            datelbl.textColor =[UIColor  colorWithHexString:@"#575757"];
            datelbl.textAlignment =NSTextAlignmentRight;
            [tableCellBack addSubview:datelbl];
//        }
//        if (indexPath.row ==todoobject.unfinised.count&&todoobject.finised.count>0) {
            UIButton *hidebtn =[UIButton buttonWithType:UIButtonTypeCustom];
            hidebtn.frame =CGRectMake((kMainScreenWidth-95)/2, 7, 95, 30);
            [hidebtn setBackgroundColor:kColorWithRGB(229, 228, 233)];
            [hidebtn setTitle:@"隐藏已完成任务" forState:UIControlStateNormal];
            [hidebtn setTitle:@"显示已完成任务" forState:UIControlStateSelected];
            [hidebtn setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateNormal];
            [hidebtn setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateSelected];
            hidebtn.titleLabel.font =[UIFont systemFontOfSize:13.0];
            hidebtn.tag =10000+indexPath.section;
            hidebtn.hidden =YES;
            [hidebtn addTarget:self action:@selector(hideMyToDo:) forControlEvents:UIControlEventTouchUpInside];
            [cell1 addSubview:hidebtn];
//        }

    }
    UIView *tableCellBack =(UIView *)[cell1 viewWithTag:100001];
    UIButton *hidebtn =[cell1 viewWithTag:10000+indexPath.section];
    if (tableCellBack) {
        if (indexPath.row <todoobject.unfinised.count) {
            hidebtn.hidden =YES;
            MyToDoInfoObject *mytoinfo =[todoobject.unfinised objectAtIndex:indexPath.row];
            UIImageView *selectimage =(UIImageView *)[tableCellBack viewWithTag:1000];
            selectimage.image =[UIImage imageNamed:@"ic_gouxian"];
            
            UILabel *contentlbl =(UILabel *)[tableCellBack viewWithTag:1001];
            contentlbl.text =mytoinfo.todoDesc;
            
            UILabel *datelbl =(UILabel *)[tableCellBack viewWithTag:1002];
            datelbl.text =[NSString stringWithFormat:@"请%d天完成",mytoinfo.finished];
        }else if (indexPath.row>todoobject.unfinised.count){
            hidebtn.hidden =YES;
            MyToDoInfoObject *mytoinfo =[todoobject.finised objectAtIndex:indexPath.row-todoobject.unfinised.count-1];
            UIImageView *selectimage =(UIImageView *)[tableCellBack viewWithTag:1000];
            selectimage.image =[UIImage imageNamed:@"ic_gouxuan_press"];
            
            UILabel *contentlbl =(UILabel *)[tableCellBack viewWithTag:1001];
//            contentlbl.text =;
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:mytoinfo.todoDesc];
            NSUInteger length = [mytoinfo.todoDesc length];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0, length)];
            [contentlbl setAttributedText:attri];
            
            UILabel *datelbl =(UILabel *)[tableCellBack viewWithTag:1002];
//            datelbl.text =;
            NSMutableAttributedString *dateattri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"请%d天完成",mytoinfo.finished]];
            NSUInteger datelength = [[NSString stringWithFormat:@"请%d天完成",mytoinfo.finished] length];
            [dateattri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, datelength)];
            [dateattri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0, datelength)];
            [datelbl setAttributedText:dateattri];
        }
        if (indexPath.row ==todoobject.unfinised.count&&todoobject.finised.count>0) {
            tableCellBack.hidden =YES;
            hidebtn.hidden =NO;
            hidebtn.selected =todoobject.ishide;
        }else{
            tableCellBack.hidden =NO;
            hidebtn.hidden =YES;
        }
    }
    cell1.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    cell1.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MyToDoObject *todoobject =[self.dataArray objectAtIndex:section];
    if (todoobject.ishide ==NO) {
        if (todoobject.finised.count>0) {
            return todoobject.unfinised.count+todoobject.finised.count+1;
        }else{
            return todoobject.unfinised.count;
        }
    }else{
        return todoobject.unfinised.count+1;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyToDoObject *todoobject =[self.dataArray objectAtIndex:indexPath.section];
    MyToDoInfoObject *todoinfo;
    int nationType =0;
    if (indexPath.row <todoobject.unfinised.count){
        nationType =2;
        todoinfo =[todoobject.unfinised objectAtIndex:indexPath.row];
    }else if (indexPath.row >todoobject.unfinised.count){
        nationType =1;
        todoinfo =[todoobject.finised objectAtIndex:indexPath.row-todoobject.unfinised.count-1];
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
        [postDict setObject:@"ID0362" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"nationType":[NSNumber numberWithInt:nationType],@"todoId":[NSNumber numberWithInt:todoinfo.todoId],@"roleId":@7};
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
                NSLog(@"代办管理返回信息：%@",jsonDict);
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
                    
                    if (kResCode == 103621) {
                        [self stopRequest];
                        if (indexPath.row <todoobject.unfinised.count){
                            [TLToast showWithText:@"完成代办成功"];
                            [todoobject.unfinised removeObject:todoinfo];
                            [todoobject.finised addObject:todoinfo];
                            
                        }else if (indexPath.row >todoobject.unfinised.count){
                            [TLToast showWithText:@"取消完成代办成功"];
                            [todoobject.finised removeObject:todoinfo];
                            [todoobject.unfinised addObject:todoinfo];
                        }
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                        [self.mtableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    } else if (kResCode == 103629) {
                        [self stopRequest];
                        if (indexPath.row <todoobject.unfinised.count){
                            [TLToast showWithText:@"完成代办失败"];
                        }else if (indexPath.row >todoobject.unfinised.count){
                            [TLToast showWithText:@"取消完成代办失败"];
                        }
                        //                        [TLToast showWithText:@"合同取消失败"];
                    } else  {
                        [self stopRequest];
                        if (indexPath.row <todoobject.unfinised.count){
                            [TLToast showWithText:@"完成代办失败"];
                        }else if (indexPath.row >todoobject.unfinised.count){
                            [TLToast showWithText:@"取消完成代办失败"];
                        }
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
                                  if (indexPath.row <todoobject.unfinised.count){
                                      [TLToast showWithText:@"完成代办失败"];
                                  }else if (indexPath.row >todoobject.unfinised.count){
                                      [TLToast showWithText:@"取消完成代办失败"];
                                  }
                                  //                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });
}
-(void)hideMyToDo:(id)sender{
    UIButton *hidebtn =(UIButton *)sender;
    hidebtn.selected =!hidebtn.selected;
    MyToDoObject *todoobject =[self.dataArray objectAtIndex:hidebtn.tag-10000];
    todoobject.ishide =hidebtn.selected;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:hidebtn.tag-10000];
    [self.mtableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=1;
        [self requestToDolist];
    }
    else {
        if(self.totalPages>self.currentPage){
            self.currentPage +=1;
            [self requestToDolist];
        }
        else{
            
            [self.mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            self.mtableview.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}
#pragma mark - 我的代办
-(void)requestToDolist{
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
        
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0361\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":10,\"currentPage\":%d,\"roleId\":7}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(int)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"我的代办列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (kResCode == 10002 || kResCode == 10003) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    });
                }
                if (code==103601) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if(self.refreshing==YES && [self.dataArray count]) [self.dataArray removeAllObjects];
                        if (self.currentPage ==1) {
                            [self.dataArray removeAllObjects];
                        }
                        NSArray *arr_=[jsonDict objectForKey:@"userPhaseTodoVo"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                DCParserConfiguration *config = [DCParserConfiguration configuration];
                                DCArrayMapping *arrayMapping = [DCArrayMapping mapperForClassElements:[MyToDoInfoObject class] forAttribute:@"phaseTodoInfos" onClass:[MyToDoObject class]];
                                [config addArrayMapper:arrayMapping];
                                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[MyToDoObject class] andConfiguration:config];
                                MyToDoObject *todoObject =[parser parseDictionary:dict];
                                todoObject.unfinised =[NSMutableArray array];
                                todoObject.finised =[NSMutableArray array];
                                for (MyToDoInfoObject *info in todoObject.phaseTodoInfos) {
                                    if (info.status==1) {
                                        [todoObject.unfinised addObject:info];
                                    }else{
                                        [todoObject.finised addObject:info];
                                    }
                                }
                                todoObject.ishide =NO;
                                [self.dataArray addObject:todoObject];
                            }
                        }
                        if([self.dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [self.mtableview tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [self.mtableview tableViewDidFinishedLoading];
                        }
                        [self.mtableview reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==103609) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [self.mtableview tableViewDidFinishedLoading];
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [self.mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [self.mtableview tableViewDidFinishedLoading];
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [self.mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [self.mtableview tableViewDidFinishedLoading];
                                  if(![self.dataArray count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [self.mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });

}
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=YES;
    
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
    if(isFirstInt==YES){
        self.refreshing=NO;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
    }
    else {
        [self.mtableview tableViewDidFinishedLoading];
        isFirstInt=!isFirstInt;
    }
}
#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.mtableview.contentOffset.y<-30) {
        self.mtableview.reachedTheEnd = NO;  //是否加载到底了
    }
    CGFloat sectionHeaderHeight = 84;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    //手指开始拖动方法
    [self.mtableview tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.mtableview tableViewDidEndDragging:scrollView];
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
