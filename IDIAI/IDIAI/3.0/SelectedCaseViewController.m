//
//  SelectedCaseViewController.m
//  IDIAI
//
//  Created by iMac on 16/4/5.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SelectedCaseViewController.h"
#import "IDIAIAppDelegate.h"
#import "UIImageView+OnlineImage.h"
#import "util.h"
#import "CityListObj.h"
#import "MyeffectPictureObj.h"
#import "CasePicInfoViewController.h"

#define SECTION_BTN_TAG_BEGIN 100
#define SECTION_IV_TAG_BEGIN 200
#define KAreaOrGongzType_TAG 10000
@interface SelectedCaseViewController (){

    
    UIControl *_control;
    UIView *_dv;
    UIScrollView *_scr;
    NSArray *_dataArr;//弹出层数据源
    NSInteger currentExtendSection;
}

@end

@implementation SelectedCaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;//zl
    [appDelegate.nav setNavigationBarHidden:YES animated:NO];
//    self.tabBarController.title = @"案例";
    self.navigationItem.title = @"精选案例";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[util imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(249, 249, 250)];
    self.navigationController.view.frame =CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.backgroundColor=[UIColor clearColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self createHeafer];
    
    self.picture_style = -1;
    self.picture_doorModel = -1;
    self.picture_price = -1;
    self.picture_city=0;
    /*存储城市code码*/
    _arr_cityCode=[NSMutableArray arrayWithCapacity:0];
    [_arr_cityCode addObject:@"-1"];
    self.currentPage=0;
    self.refreshing=YES;
    dataArray=[NSMutableArray array];
    mtableview = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-64-40-49) style:UITableViewStyleGrouped];
    mtableview.pullingDelegate = self;
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.backgroundColor=[UIColor colorWithHexString:@"#f1f0f6" alpha:1.0];
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    [mtableview setHeaderOnly:YES];          //只有下拉刷新
    //    [mtableview setFooterOnly:YES];         //只有上拉加载
    [mtableview launchRefreshing];
    [self.view addSubview:mtableview];
    
    [self loadImageviewBG];
}


-(void)ShowImageBG{
    if([dataArray count]){
        imageview_bg.hidden=YES;
        label_bg.hidden=YES;
    }
    else{
        imageview_bg.hidden=NO;
        label_bg.hidden=NO;
    }
}

#pragma mark - 请求图片列表
-(void)requestSelectedCaseList{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSInteger cityCodeInteger = [kCityCode integerValue];
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        
        NSInteger cityCode =[_arr_cityCode[self.picture_city] integerValue];
        
        NSString *requestUrl=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0351\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":%ld}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\",\"renderingsId\":\"%ld\",\"doorModelId\":\"%ld\",\"offerId\":\"%ld\",\"classificationId\":\"%ld\",\"cityCode\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,(long)cityCodeInteger,(long)self.currentPage+1,(long)self.picture_style,(long)self.picture_doorModel,(long)self.picture_price,(long)3,(long)cityCode];

         NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonDict = [[request responseString] objectFromJSONString];
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                NSLog(@"%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (code==13511) {
                        self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];        //得到总的页数
                        self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];      //当前的页数
                        self.shareUrl=[jsonDict objectForKey:@"shareUrl"];     //分享的Url
                        if(self.refreshing==YES && [dataArray count]) [dataArray removeAllObjects];
                        
                        for (NSDictionary *dict in [jsonDict objectForKey:@"rendreingsList"]){
                            [dataArray addObject:[MyeffectPictureObj objWithDict:dict]];
                        }
                        [mtableview tableViewDidFinishedLoading];
                        [mtableview reloadData];
                    }
                    else [mtableview tableViewDidFinishedLoading];
                    
                    [self ShowImageBG];
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [mtableview tableViewDidFinishedLoading];
                                  [self ShowImageBG];
                              });
                          }
                               method:requestUrl postDict:nil];
    });
}

#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0) return 0.1;
    else return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMainScreenWidth*3/4+90;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"MyCellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIImageView *coverImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*3/4)];
        coverImage.tag=1000;
        coverImage.contentMode=UIViewContentModeScaleAspectFill;
        coverImage.clipsToBounds=YES;
        coverImage.userInteractionEnabled=YES;
        [cell addSubview:coverImage];
        
        UILabel *houseModel=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(coverImage.frame)+20, kMainScreenWidth-30, 20)];
        houseModel.tag=1001;
        houseModel.backgroundColor=[UIColor clearColor];
        houseModel.textAlignment=NSTextAlignmentLeft;
        houseModel.textColor=[UIColor colorWithHexString:@"#575757" alpha:1.0];
        houseModel.font=[UIFont systemFontOfSize:15];
        [cell addSubview:houseModel];
        
        UILabel *styleArea=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(houseModel.frame)+10, kMainScreenWidth-30, 20)];
        styleArea.tag=1002;
        styleArea.backgroundColor=[UIColor clearColor];
        styleArea.textAlignment=NSTextAlignmentLeft;
        styleArea.textColor=[UIColor lightGrayColor];
        styleArea.font=[UIFont systemFontOfSize:15];
        [cell addSubview:styleArea];
        
    }
    MyeffectPictureObj *obj=dataArray[indexPath.section];
    
    UIImageView *coverImage=(UIImageView *)[cell viewWithTag:1000];
    [coverImage setOnlineImage:obj.rendreingsPath placeholderImage:[UIImage imageNamed:@"ic_morentu"]];
    
    UILabel *houseModel=(UILabel *)[cell viewWithTag:1001];
    houseModel.text=obj.doorModel;
    
    UILabel *styleArea=(UILabel *)[cell viewWithTag:1002];
    styleArea.text=[NSString stringWithFormat:@"%@      %@m²      ¥ %@/m²",obj.frameName,obj.buildingArea,obj.price];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CasePicInfoViewController *picVC=[[CasePicInfoViewController alloc]init];
    picVC.hidesBottomBarWhenPushed=YES;
    picVC.dataArr=dataArray;
    picVC.indexSort=indexPath.section;
    picVC.shareUrl=self.shareUrl;
    picVC.currentPage=self.currentPage;
    picVC.totalPages=self.totalPages;
    picVC.picture_style=_picture_style;
    picVC.picture_price=_picture_price;
    picVC.picture_doorModel=_picture_doorModel;
    picVC.picture_cityCode=[_arr_cityCode[self.picture_city] integerValue];
    picVC.selectDoneCaseInfo=^(NSInteger currentPage, NSInteger totalPages, NSMutableArray *Array){
        self.currentPage=currentPage;
        self.totalPages=totalPages;
        dataArray=Array;
        [mtableview reloadData];
    };
    [self.navigationController pushViewController:picVC animated:YES];
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        self.currentPage=0;
        [self requestSelectedCaseList];
    }
    else {
        if(self.totalPages>self.currentPage){
           [self requestSelectedCaseList];
        }
        else{
            [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            mtableview.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    //MJLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    //MJLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

//上拉加载  Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    // MJLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    if(isFirstInt==YES){
        self.refreshing=NO;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
    }
    else {
        [mtableview tableViewDidFinishedLoading];
        isFirstInt=!isFirstInt;
    }
}

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (mtableview.contentOffset.y<-30) {
        mtableview.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [mtableview tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [mtableview tableViewDidEndDragging:scrollView];
    
//    static float newY = 0;
//    static float oldY = 0;
//    newY= scrollView.contentOffset.y;
//    if (newY != oldY ) {
//        if (newY > oldY) {
//            self.tabBarController.tabBar.hidden=YES;
//            mtableview.frame = CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-64-40);
//        }else if(newY < oldY){
//            self.tabBarController.tabBar.hidden=NO;
//            mtableview.frame = CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-64-40-49);
//        }
//        oldY = newY;
//    }
}

#pragma mark -
#pragma mark - 创建弹出框

-(void)createHeafer{
    for (int i=0; i<4; i++) {
        UIButton *sectionBtn=(UIButton *)[self.view viewWithTag:SECTION_BTN_TAG_BEGIN+i];
        if(!sectionBtn) sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake((kMainScreenWidth/4)*i, 1, kMainScreenWidth/4, 40)];
        //if(!sectionBtn) sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake((kMainScreenWidth-240)/2+80*i-10, 1, 80, 40)];
        sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
        [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [sectionBtn  setTitle:@[@"风格",@"户型",@"报价",@"城市"][i] forState:UIControlStateNormal];
        [sectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        sectionBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [sectionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 22)];
        //sectionBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        sectionBtn.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:sectionBtn];
        
        UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sectionBtn.frame)-25, CGRectGetMidY(sectionBtn.frame)-2.5, 10, 5)];
        [sectionBtnIv setImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
        [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
        sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
        [self.view addSubview: sectionBtnIv];
    }
    
    UIView *line_bottom=[[UIView alloc]initWithFrame:CGRectMake(0, 39.5, kMainScreenWidth, 0.5)];
    line_bottom.backgroundColor=[UIColor colorWithHexString:@"#E0E0E0" alpha:0.5];
    [self.view addSubview:line_bottom];
    
    currentExtendSection = -1;
}

-(void)sectionBtnTouch:(UIButton *)btn{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    
    UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:(SECTION_IV_TAG_BEGIN +currentExtendSection)];
    [currentIV setImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    if (currentExtendSection == section) {
        [self dismiss];
    }else{
        [_control removeFromSuperview];
        _control=nil;
        [_dv removeFromSuperview];
        _dv=nil;
        for(int i=0;i<4;i++){
            UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:(SECTION_IV_TAG_BEGIN +i)];
            [currentIV setImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
            UIButton *sectionBtn=(UIButton *)[self.view viewWithTag:SECTION_BTN_TAG_BEGIN+i];
            [sectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        currentExtendSection = section;
        currentIV = (UIImageView *)[self.view viewWithTag:SECTION_IV_TAG_BEGIN + currentExtendSection];
        [currentIV setImage:[UIImage imageNamed:@"ic_jiantoushaixuan_s"]];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateNormal];
        [self show];
    }
}

- (void)show {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if(!_control)_control = [[UIControl alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight+40, kMainScreenHeight - 80, kMainScreenHeight - kNavigationBarHeight -40)];
    _control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
    [_control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:_control];
    
    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+40, kMainScreenWidth , 0)];
    _dv.tag=101;
    _dv.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    [keywindow addSubview:_dv];
    
    // [HRCoreAnimationEffect animationCubeFromRight:_dv];
    
    //动画设置位置
    _control.alpha=0.3;
    [UIView animateWithDuration:0.3 animations:^{
        _control.alpha=1.0;
        _dv.frame =  CGRectMake(0, kNavigationBarHeight+40, kMainScreenWidth , 250);
        [self createChioces];
    }];
}

-(void)dismiss{
    if (currentExtendSection != -1) {
        currentExtendSection = -1;
        
        [UIView animateWithDuration:0.3 animations:^{
            _control.alpha=0.3;
            _scr.frame=CGRectMake(0, 0, kMainScreenWidth , 0);
            _dv.frame=CGRectMake(0, kNavigationBarHeight+40, kMainScreenWidth , 0);
        } completion:^(BOOL finished) {
            if (finished) {
                [_control removeFromSuperview];
                _control=nil;
                [_scr removeFromSuperview];
                _scr=nil;
                [_dv removeFromSuperview];
                _dv=nil;
            }
        }];
    }
    
    for(int i=0;i<4;i++){
        UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:(SECTION_IV_TAG_BEGIN +i)];
        [currentIV setImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
        UIButton *sectionBtn=(UIButton *)[self.view viewWithTag:SECTION_BTN_TAG_BEGIN+i];
        [sectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

-(void)createChioces{
    _scr=[[UIScrollView alloc] init];
    _scr.backgroundColor=[UIColor clearColor];
    [_dv addSubview:_scr];
    
    /*存储城市名字*/
    NSMutableArray *arr_city=[NSMutableArray arrayWithCapacity:0];
    [arr_city addObject:@"全国"];
    if([_arr_cityCode count]) [_arr_cityCode removeAllObjects];
    [_arr_cityCode addObject:@"-1"];
    IDIAIAppDelegate *appDelegate=(IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    if([appDelegate.array_city_list count]){
        for(CityListObj *obj in appDelegate.array_city_list){
            if(![obj.cityName isEqualToString:@"全国"]){
                [arr_city addObject:obj.cityName];
                [_arr_cityCode addObject:[NSString stringWithFormat:@"%@",obj.cityCode]];
            }
        }
    }
    
    if(currentExtendSection==0) _dataArr=@[@"不限",@"现代简约",@"田园",@"欧式",@"中式",@"美式",@"地中海",@"东南亚",@"混搭",@"新古典",@"日式"];
    else if (currentExtendSection==1) _dataArr=@[@"不限",@"小户型(<70㎡)",@"普通户型(70-120㎡)",@"大户型(>120㎡)"];
    else if (currentExtendSection==2) _dataArr=@[@"不限",@"经济方案(<100元/㎡)",@"品质方案(100-200元/㎡)",@"奢华方案(>200元/㎡)"];
    else _dataArr=arr_city;
    
    NSInteger countX=3;
    if(currentExtendSection==1 || currentExtendSection==2) countX=2;
    float width_=(kMainScreenWidth-40-(countX-1)*30)/countX;
    float heigth_=32;
    float space=0;
    for (int i=0; i<[_dataArr count]; i++) {
        UIButton *btn_style=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%countX), 20+10+(i/countX)*(heigth_+15), width_, heigth_)];
        btn_style.tag=KAreaOrGongzType_TAG+i;
        [btn_style setTitle:[_dataArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn_style setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
        [btn_style setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
        btn_style.titleLabel.font=[UIFont systemFontOfSize:14.0];
        if(kMainScreenWidth==320) btn_style.titleLabel.font=[UIFont systemFontOfSize:12.0];
        else if (kMainScreenWidth==375) btn_style.titleLabel.font=[UIFont systemFontOfSize:13.5];
        if(currentExtendSection==0) {  //风格
            if(i==0 && self.picture_style==-1) btn_style.selected=YES;
            else if(i==self.picture_style && i!=0) btn_style.selected=YES;
        }
        else if(currentExtendSection==1) {   //户型
            if(i==0 && self.picture_doorModel==-1) btn_style.selected=YES;
            else if(i==self.picture_doorModel-11 && i!=0) btn_style.selected=YES;
        }
        else if(currentExtendSection==2) {   //报价
            if(i==0 && self.picture_price==-1) btn_style.selected=YES;
            else if(i==self.picture_price-14 && i!=0) btn_style.selected=YES;
        }
        else if(currentExtendSection==3) {   //城市
            if(i==self.picture_city) btn_style.selected=YES;
        }
        //给按钮加一个红色的板框
        if(btn_style.selected==YES) btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
        else btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
        btn_style.layer.borderWidth = 1.0f;
        //给按钮设置弧度,这里将按钮变成了圆形
        btn_style.layer.cornerRadius = 5.0f;
        btn_style.layer.masksToBounds = YES;
        [btn_style addTarget:self action:@selector(ChoiceStyle:) forControlEvents:UIControlEventTouchUpInside];
        [_scr addSubview:btn_style];
        
        if(i==[_dataArr count]-1) space=CGRectGetMaxY(btn_style.frame);
    }
    
    _scr.frame=CGRectMake(0, 0, CGRectGetWidth(_dv.frame), CGRectGetHeight(_dv.frame));
    _scr.contentSize=CGSizeMake(CGRectGetWidth(_scr.frame), space+30);
}

-(void)ChoiceStyle:(UIButton *)sender{
    for (int i=0; i<[_dataArr count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KAreaOrGongzType_TAG+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
            
            //改变选择卡得颜色和文字
            for (int j=0; j<4; j++) {
                UIButton *sectionBtn=(UIButton *)[self.view viewWithTag:SECTION_BTN_TAG_BEGIN+j];
                UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:SECTION_IV_TAG_BEGIN +j];
                [currentIV setImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
                
//                if(currentExtendSection==j) {
//                    [sectionBtn setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateNormal];
//                    [sectionBtn setTitle:_dataArr[i] forState:UIControlStateNormal];
//                }
//                else [sectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                
                [sectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            
            //获取选中的id发送服务器
            if(currentExtendSection==0) {
                if(i==0) self.picture_style=-1;
                else self.picture_style=i;
            }
            if(currentExtendSection==1) {
                if(i==0) self.picture_doorModel=-1;
                else self.picture_doorModel=11+i;
            }
            if(currentExtendSection==2) {
                if(i==0) self.picture_price=-1;
                else self.picture_price=14+i;
            }
            if(currentExtendSection==3) {
                self.picture_city=i;
            }
            
            [self dismiss];
            if([dataArray count]) [dataArray removeAllObjects];
            [mtableview reloadData];
            [mtableview launchRefreshing];
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
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
