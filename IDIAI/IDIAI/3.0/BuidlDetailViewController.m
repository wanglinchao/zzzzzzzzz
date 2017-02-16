//
//  BuidlDetailViewController.m
//  UTopGD
//
//  Created by Ricky on 15/9/19.
//  Copyright (c) 2015年 yangfan. All rights reserved.
//

#import "BuidlDetailViewController.h"
#import "ForemanSiteObject.h"
#import "UIImageView+WebCache.h"
#import "HexColor.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "GongzhangDetailViewController.h"
#import "CommonFreeViewController.h"
#import "ForemanSiteObject.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "IDIAIAppDelegate.h"
#import "IDIAI4NewHomePageViewController.h"
@interface BuidlDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)ForemanSiteObject *foremanObject;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int piccount;
@end

@implementation BuidlDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    self.piccount =0;
    self.view.backgroundColor =[UIColor whiteColor];
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
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
        [postDict setObject:@"ID0263" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"foremanSitesId":self.foremanSitesId};
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
                 NSLog(@"工地详情：%@",jsonDict);
                DCParserConfiguration *config = [DCParserConfiguration configuration];
                DCArrayMapping *arrayMapping = [DCArrayMapping mapperForClassElements:[ForemanSitesPic class] forAttribute:@"foremanSitesPics" onClass:[ForemanSiteObject class]];
                [config addArrayMapper:arrayMapping];
                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[ForemanSiteObject class] andConfiguration:config];
                self.foremanObject =[parser parseDictionary:[jsonDict objectForKey:@"foremanSites"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (kResCode == 102601) {
                        [self stopRequest];
                        self.tableView.tableHeaderView =[self getTableHeaderView];
                        [self.tableView reloadData];
                    } else {
                        [self stopRequest];
                        self.tableView.tableHeaderView =[self getTableHeaderView];
                        [self.tableView reloadData];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                              });
                          }
                               method:url postDict:post];
    });
//    [HomePageParser postBuildDetail:@"ID0263" foremanSitesId:self.foremanSitesId theBlock:^(id user, NSError *error) {
//        if (!error) {
//            self.foremanObject =(ForemanSiteObject *)user;
//            self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-55)];
//            self.tableView.delegate =self;
//            self.tableView.dataSource =self;
//            self.tableView.tableHeaderView =[self getTableHeaderView];
//            self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
//            [self.view addSubview:self.tableView];
//            [self.tableView reloadData];
//            [self initFooter];
//        }
//    }];
    // Do any additional setup after loading the view.
}






- (void)PressBarItemLeft {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//    if ([delegate.nav.viewControllers[delegate.nav.viewControllers.count-2] isKindOfClass:[IDIAI4NewHomePageViewController class]]) {
////        [delegate.nav setNavigationBarHidden:NO animated:NO];
//    }
    
}
- (UIView *)getTableHeaderView{
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 108)];
//    backView.backgroundColor =[UIColor redColor];
//    UIImageView *headerimage =[[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth-22)/2-7, 20, 36, 36)];
//    headerimage.contentMode=UIViewContentModeScaleAspectFill;
//    headerimage.clipsToBounds=YES;
//    [headerimage sd_setImageWithURL:[NSURL URLWithString:self.foremanObject.foremanIconPath] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//        if (image) {
//            headerimage.image =[self circleImage:image withParam:1.0];
//        }
//    }];
//    headerimage.userInteractionEnabled =YES;
//    [backView addSubview:headerimage];
    
//    UILabel *namelbl =[[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-70)/2, headerimage.frame.size.height+headerimage.frame.origin.y+13, self.foremanObject.foremanName.length*15, 15)];
//    namelbl.text =self.foremanObject.foremanName;
//    namelbl.font =[UIFont systemFontOfSize:15];
//    namelbl.textColor =[UIColor blackColor];
//    namelbl.textAlignment =NSTextAlignmentLeft;
//    [backView addSubview:namelbl];
    
//    UIButton *showMaster =[UIButton buttonWithType:UIButtonTypeCustom];
//    showMaster.frame =CGRectMake(headerimage.frame.size.width+headerimage.frame.origin.x+5, namelbl.frame.origin.y-7, 30, 30);
//    [showMaster setImage:[UIImage imageNamed:@"ic_jiantou_tz.png"] forState:UIControlStateNormal];
//    [showMaster setImage:[UIImage imageNamed:@"ic_jiantou_tz.png"] forState:UIControlStateHighlighted];
//    [showMaster addTarget:self action:@selector(showMaster:) forControlEvents:UIControlEventTouchUpInside];
//    showMaster.imageEdgeInsets =UIEdgeInsetsMake(0, -30, 0, 0);
//    [backView addSubview:showMaster];
    
    NSString *str = self.foremanObject.villageName;
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kMainScreenWidth-20,60)lineBreakMode:UILineBreakModeWordWrap];
    if (size.height>14) {
        backView.frame =CGRectMake(0, 0, kMainScreenWidth, 108+size.height-14);
    }
    
    

    
    UILabel *villageNamelbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 28, size.width, size.height)];
    villageNamelbl.textAlignment =NSTextAlignmentCenter;
    villageNamelbl.text =str;
    villageNamelbl.textColor =[UIColor blackColor];
    villageNamelbl.font =[UIFont systemFontOfSize:14];
    villageNamelbl.numberOfLines =0;
    [backView addSubview:villageNamelbl];
    
    UILabel *arealbl =[[UILabel alloc] initWithFrame:CGRectMake(10, villageNamelbl.frame.origin.y+villageNamelbl.frame.size.height+16, 44, 11)];
    arealbl.textColor =[UIColor colorWithHexString:@"#a7a7a7"];
    arealbl.text =[NSString stringWithFormat:@"%.1f㎡|",[self.foremanObject.acreage floatValue]];
    arealbl.font =[UIFont systemFontOfSize:12];
//    arealbl.backgroundColor =[UIColor redColor];
    arealbl.numberOfLines =2;
    arealbl.textAlignment =NSTextAlignmentLeft;
//    [backView addSubview:arealbl];
    
    UILabel *costlbl =[[UILabel alloc] initWithFrame:CGRectMake(11+(kMainScreenWidth-22)/4, villageNamelbl.frame.origin.y+villageNamelbl.frame.size.height+6, (kMainScreenWidth-22)/4, 11)];
    costlbl.textColor =[UIColor colorWithHexString:@"#a7a7a7"];
    costlbl.text =[NSString stringWithFormat:@"造价:%.1f万",[self.foremanObject.buildingCost floatValue]];
    costlbl.font =[UIFont systemFontOfSize:11];
    costlbl.numberOfLines =1;
    [costlbl sizeToFit];
//    costlbl.backgroundColor =[UIColor orangeColor];
    costlbl.textAlignment =NSTextAlignmentCenter;
//    [backView addSubview:costlbl];
    
    UILabel *limitlbl =[[UILabel alloc] initWithFrame:CGRectMake(11+(kMainScreenWidth-22)/2, villageNamelbl.frame.origin.y+villageNamelbl.frame.size.height+6, (kMainScreenWidth-22)/4, 11)];
    limitlbl.textColor =[UIColor colorWithHexString:@"#a7a7a7"];
    limitlbl.text =[NSString stringWithFormat:@"工期:%@天",self.foremanObject.projectLimit];
    limitlbl.font =[UIFont systemFontOfSize:11];
//    limitlbl.backgroundColor =[UIColor blueColor];
    limitlbl.textAlignment =NSTextAlignmentCenter;
    limitlbl.numberOfLines =1;
//    [backView addSubview:limitlbl];
    
    UILabel *distancelbl =[[UILabel alloc] initWithFrame:CGRectMake(11+(kMainScreenWidth-22)/4*3, villageNamelbl.frame.origin.y+villageNamelbl.frame.size.height+6, (kMainScreenWidth-22)/4, 11)];
    distancelbl.textColor =[UIColor colorWithHexString:@"#a7a7a7"];
//    CGFloat distance =[self getdistance:self.userlocation home:CLLocationCoordinate2DMake([self.foremanObject.latitude doubleValue], [self.foremanObject.longitude doubleValue])];
//    distancelbl.text =[NSString stringWithFormat:@"距离:%.2fkm",distance/1000];
    distancelbl.font =[UIFont systemFontOfSize:11];
//    distancelbl.backgroundColor =[UIColor purpleColor];
    distancelbl.textAlignment =NSTextAlignmentRight;
    distancelbl.numberOfLines =1;
//    [backView addSubview:distancelbl];
    
    UILabel *topmessagelbl =[[UILabel alloc] initWithFrame:CGRectMake(10, villageNamelbl.frame.origin.y+villageNamelbl.frame.size.height+16, kMainScreenWidth-20, 11)];
    topmessagelbl.textColor =[UIColor colorWithHexString:@"#a7a7a7"];
    topmessagelbl.text =[NSString stringWithFormat:@"%.1f㎡ | %@室%@厅 | %@",[self.foremanObject.acreage floatValue],self.foremanObject.bedRoom,self.foremanObject.livingRoom,self.foremanObject.frameName];
    topmessagelbl.font =[UIFont systemFontOfSize:11];
//        topmessagelbl.backgroundColor =[UIColor purpleColor];
    topmessagelbl.textAlignment =NSTextAlignmentLeft;
    topmessagelbl.numberOfLines =1;
    [backView addSubview:topmessagelbl];
    
    UILabel *footmessagelbl =[[UILabel alloc] initWithFrame:CGRectMake(10, topmessagelbl.frame.origin.y+topmessagelbl.frame.size.height+15, kMainScreenWidth-22, 11)];
    footmessagelbl.textColor =[UIColor colorWithHexString:@"#a7a7a7"];
    footmessagelbl.text =[NSString stringWithFormat:@"造价:%.1f万   工期:%@天",[self.foremanObject.buildingCost floatValue],self.foremanObject.projectLimit];
    footmessagelbl.font =[UIFont systemFontOfSize:12];
    //    distancelbl.backgroundColor =[UIColor purpleColor];
    footmessagelbl.textAlignment =NSTextAlignmentLeft;
    footmessagelbl.numberOfLines =1;
    [backView addSubview:footmessagelbl];
    return backView;
}
-(void)initFooter{
    
    UIView *footer =[[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-55, kMainScreenWidth, 55)];
    footer.backgroundColor =kColorWithRGB(255, 253, 254);
    [self.view addSubview:footer];
    
    
    UIButton *homeAccbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    homeAccbtn.frame =CGRectMake(0, 0, (footer.frame.size.width-12)/3, 55);
    [homeAccbtn  addTarget:self action:@selector(homeAccAction:) forControlEvents:UIControlEventTouchUpInside];
//    homeAccbtn.backgroundColor =[UIColor redColor];
    [footer addSubview:homeAccbtn];
    
    UIImageView *homeAccimg =[[UIImageView alloc] initWithFrame:CGRectMake(15*kMainScreenWidth/320, 18, 21, 18)];
    homeAccimg.image =[UIImage imageNamed:@"ic_liangfang.png"];
    [homeAccbtn addSubview:homeAccimg];
    
    if (kMainScreenWidth==320) {
        homeAccimg.frame =CGRectMake(10*kMainScreenWidth/320, 18, 21, 18);
    }
    
    UILabel *homeAcclbl =[[UILabel alloc] initWithFrame:CGRectMake(homeAccimg.frame.origin.x+homeAccimg.frame.size.width+5, homeAccimg.frame.origin.y+1, 60, 15)];
    homeAcclbl.font =[UIFont systemFontOfSize:15.0];
    homeAcclbl.text =@"免费验房";
    homeAcclbl.textColor =kColorWithRGB(125, 125, 132);
    [homeAccbtn addSubview:homeAcclbl];
    
    UIButton *offerbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    offerbtn.frame =CGRectMake(footer.frame.size.width/3, 0, (footer.frame.size.width-12)/3, 55);
    [offerbtn  addTarget:self action:@selector(offerAction:) forControlEvents:UIControlEventTouchUpInside];
//    offerbtn.backgroundColor =[UIColor blueColor];
    [footer addSubview:offerbtn];
    
    UIImageView *offerimg =[[UIImageView alloc] initWithFrame:CGRectMake(15*kMainScreenWidth/320, 18, 21, 18)];
    offerimg.image =[UIImage imageNamed:@"ic_baojia.png"];
    [offerbtn addSubview:offerimg];
    if (kMainScreenWidth==320) {
        offerimg.frame =CGRectMake(10*kMainScreenWidth/320, 18, 21, 18);
    }
    
    UILabel *offerlbl =[[UILabel alloc] initWithFrame:CGRectMake(offerimg.frame.origin.x+offerimg.frame.size.width+5, offerimg.frame.origin.y+1, 60, 15)];
    offerlbl.font =[UIFont systemFontOfSize:15.0];
    offerlbl.text =@"免费报价";
    offerlbl.textColor =kColorWithRGB(125, 125, 132);
    [offerbtn addSubview:offerlbl];
    
    UIButton *loanbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loanbtn.frame =CGRectMake(footer.frame.size.width/3*2, 0, (footer.frame.size.width-12)/3, 55);
    [loanbtn  addTarget:self action:@selector(loanAction:) forControlEvents:UIControlEventTouchUpInside];
//    loanbtn.backgroundColor =[UIColor orangeColor];
    [footer addSubview:loanbtn];
    
    UIImageView *loanimg =[[UIImageView alloc] initWithFrame:CGRectMake(15*kMainScreenWidth/320, 18, 21, 18)];
    loanimg.image =[UIImage imageNamed:@"ic_canguan.png"];
    [loanbtn addSubview:loanimg];
    if (kMainScreenWidth==320) {
        loanimg.frame =CGRectMake(10*kMainScreenWidth/320, 18, 21, 18);
    }
    
    UILabel *loanlbl =[[UILabel alloc] initWithFrame:CGRectMake(loanimg.frame.origin.x+loanimg.frame.size.width+5, loanimg.frame.origin.y+1, 60, 15)];
    loanlbl.font =[UIFont systemFontOfSize:15.0];
    loanlbl.text =@"申请参观";
    loanlbl.textColor =kColorWithRGB(125, 125, 132);
    [loanbtn addSubview:loanlbl];
}
-(void)homeAccAction:(id)sender{
    NSLog(@"免费验房");
    CommonFreeViewController *common =[[CommonFreeViewController alloc] init];
    common.type =0;
    [self.navigationController pushViewController:common animated:YES];
}

-(void)offerAction:(id)sender{
    NSLog(@"免费报价");
    CommonFreeViewController *common =[[CommonFreeViewController alloc] init];
    common.type =1;
    [self.navigationController pushViewController:common animated:YES];
}
- (IBAction)loanAction:(id)sender {
    if (self.calNum) {
        NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",self.calNum];
        UIWebView *callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
        [self.view addSubview:callWebview];
    } else {
        [self requestCallNum];
    }
}
#pragma mark - 获取电话号码
- (void)requestCallNum {
    
}
//-(void)loanAction:(id)sender{
//    NSLog(@"装修贷款");
//    CommonFreeViewController *common =[[CommonFreeViewController alloc] init];
//    common.type =2;
//    [self.navigationController pushViewController:common animated:YES];
//    
//}
-(CGFloat)getdistance:(CLLocationCoordinate2D)userlocation home:(CLLocationCoordinate2D)homelocation{
    CLLocation *current=[[CLLocation alloc] initWithLatitude:userlocation.latitude longitude:userlocation.longitude];
    //第二个坐标
    CLLocation *before=[[CLLocation alloc] initWithLatitude:homelocation.latitude longitude:homelocation.longitude];
    // 计算距离
    CLLocationDistance meters=[current distanceFromLocation:before];
    return meters;
}

-(NSString *)datestr:(NSString *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSLog(@"%f",[date doubleValue]);
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.foremanObject.foremanSitesPics.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 293.5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MyInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ForemanSitesPic *foremanpic =[self.foremanObject.foremanSitesPics objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    
    UIImageView *phaseimage =(UIImageView *)[cell.contentView viewWithTag:101];
    if (phaseimage==nil) {
        phaseimage =[[UIImageView alloc] initWithFrame:CGRectMake(11, 0, 45, 32)];
    }
    phaseimage.tag =101;
    
    [cell.contentView addSubview:phaseimage];
    UILabel *phaselbl =(UILabel *)[cell.contentView viewWithTag:103];
    if (phaselbl==nil) {
        phaselbl =[[UILabel alloc] initWithFrame:CGRectMake(phaseimage.frame.size.width+phaseimage.frame.origin.x+12, 20, kMainScreenWidth-22-118-45, 15)];
    }
    phaselbl.font =[UIFont systemFontOfSize:15];
    phaselbl.tag =103;
    phaselbl.textColor =[UIColor colorWithHexString:@"#636668"];
    [cell.contentView addSubview:phaselbl];
    UILabel *datelbl =(UILabel *)[cell.contentView viewWithTag:102];
    if (datelbl==nil) {
        datelbl =[[UILabel alloc] initWithFrame:CGRectMake(phaselbl.frame.origin.x+phaselbl.frame.size.width, 21, 100, 9)];
        datelbl.textAlignment =NSTextAlignmentRight;
    }
    datelbl.font =[UIFont systemFontOfSize:9];
    datelbl.textColor =[UIColor colorWithHexString:@"#a7a7a7"];
    datelbl.tag =102;
    [cell.contentView addSubview:datelbl];
    
    UIScrollView *phasescro =(UIScrollView *)[cell.contentView viewWithTag:104];
    if (phasescro==nil) {
        phasescro =[self getScenScro:foremanpic.picPathList];
    }
    phasescro.frame =CGRectMake(11, phaseimage.frame.size.height+phaseimage.frame.origin.y+8, phasescro.frame.size.width, phasescro.frame.size.height);
    phasescro.tag =104;
    [cell.contentView addSubview:phasescro];
    }
    UIImageView *phaseimage =(UIImageView *)[cell.contentView viewWithTag:101];
    if ([foremanpic.phaseId integerValue] ==1) {
        phaseimage.image =[UIImage imageNamed:@"ic_kaigong.png"];
    }else if ([foremanpic.phaseId integerValue] ==2){
        phaseimage.image =[UIImage imageNamed:@"ic_gongdi_shuidian.png"];
    }else if ([foremanpic.phaseId integerValue] ==3){
        phaseimage.image =[UIImage imageNamed:@"ic_nimu.png"];
    }else if ([foremanpic.phaseId integerValue] ==4){
        phaseimage.image =[UIImage imageNamed:@"ic_youqi.png"];
    }else if ([foremanpic.phaseId integerValue] ==5){
        phaseimage.image =[UIImage imageNamed:@"ic_chengpin.png"];
    }else if ([foremanpic.phaseId integerValue] ==6){
        phaseimage.image =[UIImage imageNamed:@"ic_shijing.png"];
    }
    UILabel *datelbl =(UILabel *)[cell.contentView viewWithTag:102];
    datelbl.text =[NSString stringWithFormat:@"%@更新",[self datestr:foremanpic.updateDate]];
     UILabel *phaselbl =(UILabel *)[cell.contentView viewWithTag:103];
    if ([foremanpic.phaseId integerValue] ==1) {
        phaselbl.text =@"开工阶段";
    }else if ([foremanpic.phaseId integerValue] ==2){
        phaselbl.text =@"水电阶段";
    }else if ([foremanpic.phaseId integerValue] ==3){
        phaselbl.text =@"泥木阶段";
    }else if ([foremanpic.phaseId integerValue] ==4){
        phaselbl.text =@"油漆阶段";
    }else if ([foremanpic.phaseId integerValue] ==5){
        phaselbl.text =@"成品安装阶段";
    }else if ([foremanpic.phaseId integerValue] ==6){
        phaselbl.text =@"实景阶段";
    }
    NSLog(@"%d",indexPath.row);
    UIScrollView *phasescro =(UIScrollView *)[cell viewWithTag:104];
    [self getscroimage:foremanpic.picPathList scro:phasescro indexrow:indexPath.row];
    return cell;
}
-(void)getscroimage:(NSMutableArray *)pics scro:(UIScrollView *)scro indexrow:(int)row{
    int count =0;
    for(NSString *url in pics) {
        for (UIImageView *image in scro.subviews) {
            if (image.frame.origin.x ==scro.frame.size.width*count) {
                if (image.frame.size.height ==2.5) {
                    [image removeFromSuperview];
                    break;
                }
                NSLog(@"%f",image.frame.size.height);
                if (image.frame.size.height!=223.500000) {
                    [image removeFromSuperview];
                    break;
                }
                [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"bg_morentu.png"]];
                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                image.userInteractionEnabled =YES;
                [image addGestureRecognizer:tap];
                image.tag =count;
                for (UIView *view in [image subviews]) {
                    if ([view isKindOfClass:[UILabel class]]) {
                        UILabel *countlbl =(UILabel *)view;
                        countlbl.text =[NSString stringWithFormat:@"%d张",pics.count];
                        countlbl.tag =row;
                    }
                }
            }
        }
        count++;
    }
}
-(UIScrollView *)getScenScro:(NSMutableArray *)pics{
    UIScrollView *scro =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth-22, 223.5)];
    scro.pagingEnabled =YES;
    scro.contentSize =CGSizeMake(scro.frame.size.width*pics.count, scro.frame.size.height);
    int count =0;
    for (NSString *url in pics) {
        UIImageView *picimage =[[UIImageView alloc] initWithFrame:CGRectMake(scro.frame.size.width*count, 0, scro.frame.size.width, scro.frame.size.height)];
        [picimage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"bg_morentu.png"]];
        picimage.tag =count+100000;
        picimage.contentMode=UIViewContentModeScaleAspectFill;
        picimage.clipsToBounds=YES;
        [scro addSubview:picimage];
        
        UILabel *countlbl =[[UILabel alloc] initWithFrame:CGRectMake(picimage.frame.size.width-50, 5, 45, 20)];
        countlbl.font =[UIFont systemFontOfSize:10];
        countlbl.text =[NSString stringWithFormat:@"%d张",pics.count];
        countlbl.backgroundColor =[UIColor blackColor];
        countlbl.alpha =0.3;
        countlbl.textColor =[UIColor whiteColor];
        countlbl.layer.cornerRadius = 9;
        countlbl.textAlignment =NSTextAlignmentCenter;
        countlbl.layer.masksToBounds = YES;
        [picimage addSubview:countlbl];
        
//        UIImageView *watermarkimage =[[UIImageView alloc] initWithFrame:CGRectMake(scro.frame.size.width-56+scro.frame.size.width*count, scro.frame.size.height-42, 46, 32)];
//        watermarkimage.image =[UIImage imageNamed:@"ic_shuiyin.png"];
//        [scro addSubview:watermarkimage];
        count++;
        self.piccount++;
    }
    NSLog(@"%@",scro.subviews);
    return scro;
}
-(void)tapAction:(UIGestureRecognizer *)sender{
   
//    int selectcount =sender.view.tag-100000;
//    NSLog(@"%@",self.foremanObject.foremanSitesPics);
//    for (ForemanSitesPic*pic in self.foremanObject.foremanSitesPics) {
//        if (selectcount>=pic.picPathList.count) {
//            selectcount -=pic.picPathList.count;
//            selectpic =pic;
//        }else{
//            selectpic =pic;
//            break;
//        }
//    }
    ForemanSitesPic *selectpic =[[ForemanSitesPic alloc] init];
    UIImageView *image =(UIImageView  *)sender.view;
    for (UIView *view in [image subviews]) {
        if ([view isKindOfClass:[UILabel class]]){
            UILabel *label =(UILabel *)view;
            selectpic =[self.foremanObject.foremanSitesPics objectAtIndex:label.tag];
        }
    }
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:selectpic.picPathList.count];
    for (int i = 0; i<selectpic.picPathList.count; i++) {
        // 替换为中等尺寸图片
        NSString *url = selectpic.picPathList[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = (UIImageView *)sender.view; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = sender.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.describe =selectpic.phasePicDescription;
    [browser show];
}
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
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
