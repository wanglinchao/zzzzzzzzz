//
//  IDIAI3AboutDiaryViewController.m
//  IDIAI
//
//  Created by Ricky on 15/12/2.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3AboutDiaryViewController.h"
#import "DiaryObject.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "UIImageView+OnlineImage.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+WebCache.h"
#import "IDIAI3DiaryDetaileViewController.h"
#import "IDIAIAppDelegate.h"
#import "LoginView.h"
#import "TLToast.h"
#import "IDIAI3ReplayViewController.h"
#import "IDIAI3AddDiaryViewController.h"
#import "Emoji.h"
@interface IDIAI3AboutDiaryViewController ()<LoginViewDelegate,UIAlertViewDelegate>{

    NSString *_bookIdStr;
}
@property(nonatomic,strong)UIView *tableCellBack;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isrequst;
@property(nonatomic,strong)UIButton *unreadbtn;
@property(nonatomic,assign)int deletacount;
@property(nonatomic,strong)UIButton *backtop;
@end

@implementation IDIAI3AboutDiaryViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    if (self.ismyDiary ==NO) {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    if (self.ismyDiary ==NO) {
//        [self requestDiarylist];
//    }else{
//        [self requestMyDiary];
//    }
    [self requestAboutlist];
    [self.mtableview reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title =@"相关用户列表";
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.currentPage=0;
    self.type =7;
    self.dataArray =[NSMutableArray array];
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    [leftButton addTarget:self
                    action:@selector(PressBarItemLeft)
            forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
        
    self.mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) pullingDelegate:self];
    self.mtableview.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
    self.mtableview.dataSource=self;
    self.mtableview.delegate=self;
    self.mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [self.mtableview launchRefreshing];
    [self.view addSubview:self.mtableview];
    
    self.backtop =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.backtop setImage:[UIImage imageNamed:@"ic_huidaodingbu.png"] forState:UIControlStateNormal];
    [self.backtop setImage:[UIImage imageNamed:@"ic_huidaodingbu.png"] forState:UIControlStateHighlighted];
    self.backtop.frame =CGRectMake(kMainScreenWidth-7-35, kMainScreenHeight-64-42-7-35, 35, 35);
    [self.backtop addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
    self.backtop.hidden =YES;
    [self.view addSubview:self.backtop];
    // Do any additional setup after loading the view.
}
-(void)PressBarItemRight{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:User_Token]) {
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
    IDIAI3AddDiaryViewController *adddiary =[[IDIAI3AddDiaryViewController alloc] init];
    adddiary.title =@"写帖子";
    adddiary.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:adddiary animated:YES];
    
}
-(void)topAction:(id)sender{
    self.mtableview.contentOffset =CGPointMake(0, 0);
    self.backtop.hidden =YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiaryObject *diary =[self.dataArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    NSString *context=[Emoji replaceUicodeBecomeEmojiWith:diary.diaryContext];
    CGSize size = CGSizeMake(kMainScreenWidth-69,90);
    CGSize labelsize = [context sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    int count =(int)[diary.picPaths count]/3+1;
    if ([diary.picPaths count]%3==0) {
        count =(int)[diary.picPaths count]/3;
    }
    float photowidth =kMainScreenWidth-90;
    
    if (diary.picPaths.count ==1) {
        return 48+labelsize.height+photowidth/8*5+49+11;
    }else if (diary.picPaths.count ==2){
        return 48+labelsize.height+(photowidth-5)/2+49+11;
    }else if (diary.picPaths.count ==4){
        return 48+labelsize.height+photowidth+49+11;
    }else{
        return 48+labelsize.height+count*(photowidth-5)/3+49+11;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (self.dataArray.count==0) {
    //        return 1;
    //    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier1 = @"designerDetailCell1";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    
    if (!cell1) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        UIImageView *headback =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 11)];
        headback.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        headback.tag =100000;
        [cell1 addSubview:headback];
        UIView *tableCellBack =[[UIView alloc] initWithFrame:CGRectMake(0, 11, kMainScreenWidth, 100)];
        tableCellBack.tag =100001;
        [cell1 addSubview:tableCellBack];
        
        
//        UIImageView *headimage =[[UIImageView alloc] initWithFrame:CGRectMake(6, 12, 33, 33)];
//        headimage.layer.cornerRadius=17;
//        headimage.clipsToBounds=YES;
//        headimage.tag =100002;
//        [tableCellBack addSubview:headimage];
        
//        UILabel *namelbl =[[UILabel alloc] init];
//        namelbl.textColor =[UIColor blackColor];
//        namelbl.tag =100003;
//        namelbl.font =[UIFont systemFontOfSize:15];
//        [tableCellBack addSubview:namelbl];
        
//        UIImageView *styleimage =[[UIImageView alloc] init];
//        styleimage.tag =100004;
//        [tableCellBack addSubview:styleimage];
        UILabel *homelbl =[[UILabel alloc] init];
        homelbl.tag =100005;
        homelbl.textColor =[UIColor blackColor];
        homelbl.font =[UIFont systemFontOfSize:15];
        [tableCellBack addSubview:homelbl];
        
        
        UILabel *contentlbl =[[UILabel alloc] init];
        contentlbl.tag =100006;
        [tableCellBack addSubview:contentlbl];
        
        UILabel *datelbl =[[UILabel alloc] init];
        datelbl.tag =100007;
        [tableCellBack addSubview:datelbl];
        
        UIButton *praisebtn =[UIButton buttonWithType:UIButtonTypeCustom];
        praisebtn.tag =100008;
        [tableCellBack addSubview:praisebtn];
        
        UIImageView *zanimage =[[UIImageView alloc] init];
        zanimage.tag =100009;
        [praisebtn addSubview:zanimage];
        
        UILabel *zancount =[[UILabel alloc] init];
        zancount.tag =100010;
        [praisebtn addSubview:zancount];
        
        UIButton *commentbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        commentbtn.tag =100011;
        [tableCellBack addSubview:commentbtn];
        
        UIImageView *commentimage =[[UIImageView alloc] init];
        commentimage.tag =100012;
        [commentbtn addSubview:commentimage];
        
        UILabel *commentcount =[[UILabel alloc] init];
        commentcount.tag =100013;
        [commentbtn addSubview:commentcount];
    
    }
    
    UIView *tableCellBack =(UIView *)[cell1 viewWithTag:100001];
    
//    UIImageView *headimage =(UIImageView *)[tableCellBack viewWithTag:100002];
    DiaryObject *diary =[self.dataArray objectAtIndex:indexPath.row];
    
//    [headimage setOnlineImage:diary.logo placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
    
//    UILabel *namelbl =(UILabel *)[tableCellBack viewWithTag:100003];
//    if (diary.nickName.length>0) {
//        namelbl.frame =CGRectMake(6, 12, diary.nickName.length*15, 15);
//        namelbl.text =diary.nickName;
//    }else{
//        NSString *str =[NSString stringWithFormat:@"用户%@",diary.userId];
//        namelbl.frame =CGRectMake(6, 12, str.length*11, 15);
//        namelbl.text =str;
//    }
    
    
//    UIImageView *styleimage =(UIImageView *)[tableCellBack viewWithTag:100004];
//    styleimage.frame=CGRectMake(namelbl.frame.origin.x+namelbl.frame.size.width+12, namelbl.frame.origin.y+0.5, 33, 14);
//    if ([diary.roleId integerValue]==1) {
//        styleimage.frame =CGRectMake(styleimage.frame.origin.x, styleimage.frame.origin.y, 43, 14);
//        styleimage.image =[UIImage imageNamed:@"ic_shejishi.png"];
//    }else if ([diary.roleId integerValue]==4){
//        styleimage.image =[UIImage imageNamed:@"ic_gongzhang_diary.png"];
//    }else if ([diary.roleId integerValue]==6){
//        styleimage.image =[UIImage imageNamed:@"ic_jianli_diary.png"];
//    }else if ([diary.roleId integerValue]==7){
//        styleimage.image =[UIImage imageNamed:@"ic_yezhu.png"];
//    }else if ([diary.roleId integerValue]==2){
//       self.typeimage.image =[UIImage imageNamed:@"ic_shangjia.png"];
//    }

    UILabel *homelbl =(UILabel *)[tableCellBack viewWithTag:100005];
    homelbl.frame =CGRectMake(12, 20, kMainScreenWidth-69, 15);
    homelbl.text =diary.diaryTitle;
    
    NSString *context=[Emoji replaceUicodeBecomeEmojiWith:diary.diaryContext];
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    CGSize size = CGSizeMake(kMainScreenWidth-24,70);
    CGSize labelsize = [context sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *contentlbl =(UILabel *)[tableCellBack viewWithTag:100006];
    contentlbl.frame =CGRectMake(homelbl.frame.origin.x, homelbl.frame.size.height+homelbl.frame.origin.y+8, labelsize.width, labelsize.height);
    contentlbl.lineBreakMode = UILineBreakModeWordWrap;
    contentlbl.numberOfLines =5;
    contentlbl.font =font;
    contentlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    contentlbl.text =context;
    float photowidth =kMainScreenWidth-90;
    float photoheight =kMainScreenWidth-90;
    for (int i=0; i<9; i++) {
        UIImageView *picimage =(UIImageView *)[tableCellBack viewWithTag:1000+i];
        if (picimage) {
            [picimage removeFromSuperview];
            picimage =nil;
        }
    }
    int countx =0;
    int county =0;
    int count=0;
    for (NSString *pic in diary.picPaths) {
        UIImageView *picimage =[[UIImageView alloc] initWithFrame:CGRectMake(45+countx*((photowidth-5)/3+2.5), contentlbl.frame.origin.y+contentlbl.frame.size.height+12+county*((photowidth-5)/3+2.5), (photowidth-5)/3, (photowidth-5)/3)];
        if (diary.picPaths.count ==1) {
            picimage.frame =CGRectMake(45, contentlbl.frame.origin.y+contentlbl.frame.size.height+12, photowidth, photoheight/8*5);
        }else if (diary.picPaths.count ==2){
            picimage.frame =CGRectMake(45+((kMainScreenWidth-90-5)/2+2.5)*countx, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+county*((photowidth-5)/2+2.5), (photowidth-5)/2, (photowidth-5)/2);
        }else if (diary.picPaths.count ==4){
            picimage.frame =CGRectMake(45+((kMainScreenWidth-90-5)/2+2.5)*countx, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+county*((photowidth-5)/2+2.5), (photowidth-5)/2, (photowidth-5)/2);
        }
        [picimage sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
        picimage.clipsToBounds=YES;
        picimage.contentMode=UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        picimage.userInteractionEnabled =YES;
        [picimage addGestureRecognizer:tap];
        picimage.tag =1000+count;
        if (diary.picPaths.count!=4) {
            count++;
            countx++;
            if (count%3==0) {
                countx=0;
                county++;
            }
        }else{
            count++;
            countx++;
            if (count%2==0) {
                countx=0;
                county++;
            }
        }
        
        [tableCellBack addSubview:picimage];
    }
    UILabel *datelbl = (UILabel *)[tableCellBack viewWithTag:100007];
    int height =0;
    if (diary.picPaths.count%3==0) {
        height =county;
    }else{
        height =county+1;
    }
    datelbl.frame =CGRectMake(contentlbl.frame.origin.x, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+height*(photowidth-5)/3+17, 100, 12);
    if (diary.picPaths.count ==1) {
        datelbl.frame =CGRectMake(contentlbl.frame.origin.x, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+photowidth/8*5+17, 100, 12);
    }else if (diary.picPaths.count ==2){
        datelbl.frame =CGRectMake(contentlbl.frame.origin.x, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+(photowidth-5)/2+17, 100, 12);
    }else if (diary.picPaths.count ==4){
        datelbl.frame =CGRectMake(contentlbl.frame.origin.x, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+photowidth+17, 100, 12);
    }
    datelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    datelbl.font =[UIFont systemFontOfSize:12];
    //    [cell1 addSubview:datelbl];
    NSDate *releasedate = [NSDate dateWithTimeIntervalSince1970:[diary.releaseDate doubleValue]/1000.0];
    NSDate *nowdate =[NSDate date];
    int second =0;
    second =[nowdate timeIntervalSinceDate:releasedate];
    NSLog(@"%d",(int)second/(60*60*24));
    if (second/(60*60*24*30*12)>0) {
        datelbl.text =[NSString stringWithFormat:@"%d年前",(int)second/(60*60*24*30*12)];
    }else{
        if (second/(60*60*24*30)>0) {
            datelbl.text =[NSString stringWithFormat:@"%d个月前",(int)second/(60*60*24*30)];
        }else{
            if (second/(60*60*24)>0) {
                datelbl.text =[NSString stringWithFormat:@"%d天前",(int)second/(60*60*24)];
            }else{
                if (second/(60*60)>0) {
                    datelbl.text =[NSString stringWithFormat:@"%d小时前",(int)second/(60*60)];
                }else{
                    if (second/60>0) {
                        datelbl.text =[NSString stringWithFormat:@"%d分钟前",(int)second/60];
                    }else{
                        datelbl.text =[NSString stringWithFormat:@"刚刚"];
                    }
                }
            }
        }
    }
    UIButton *praisebtn =(UIButton *)[tableCellBack viewWithTag:100008];
    praisebtn.frame =CGRectMake(kMainScreenWidth-12-140-15, datelbl.frame.origin.y-5, 70, 22);
    if (self.ismyDiary ==NO) {
        praisebtn.layer.cornerRadius=10;
        praisebtn.clipsToBounds=YES;
        praisebtn.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
        praisebtn.layer.borderWidth = 1;
    }else{
        praisebtn.userInteractionEnabled =NO;
    }
    
    [praisebtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *zanimage =(UIImageView *)[praisebtn viewWithTag:100009];
    zanimage.frame =CGRectMake(11, 5, 11, 12);
    zanimage.image =[UIImage imageNamed:@"ic_zan.png"];
    
    
    UILabel *zancount =(UILabel *)[praisebtn viewWithTag:100010];
    zancount.frame =CGRectMake(28, 5.5, 70-22-16,11);
    zancount.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    zancount.font =[UIFont systemFontOfSize:11];
    zancount.text =[NSString stringWithFormat:@"%d",[diary.pointNumber intValue]];
    zancount.textAlignment =NSTextAlignmentCenter;
    if ([diary.pointNumber intValue]>10000) {
        zancount.text =[NSString stringWithFormat:@"%.1f万",[diary.pointNumber floatValue]/10000];
    }
    if ([diary.pointNumber intValue]>100000000) {
        zancount.text =[NSString stringWithFormat:@"%.1f亿",[diary.pointNumber floatValue]/100000000];
    }
    
    UIButton *commentbtn =(UIButton *)[tableCellBack viewWithTag:100011];
    commentbtn.frame =CGRectMake(kMainScreenWidth-12-70, datelbl.frame.origin.y-5, 70, 22);
    if (self.ismyDiary ==NO) {
        commentbtn.layer.cornerRadius=10;
        commentbtn.clipsToBounds=YES;
        commentbtn.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
        commentbtn.layer.borderWidth = 1;
    }else{
        commentbtn.userInteractionEnabled =NO;
    }
    [commentbtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *commentimage =(UIImageView *)[commentbtn viewWithTag:100012];
    commentimage.frame =CGRectMake(11, 5, 10, 10.5);
    commentimage.image =[UIImage imageNamed:@"ic_pinglun.png"];
    
    
    UILabel *commentcount =(UILabel *)[commentbtn viewWithTag:100013];
    commentcount.frame =CGRectMake(27,5.5,70-22-16,11);
    commentcount.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    commentcount.font =[UIFont systemFontOfSize:11];
    commentcount.text =[NSString stringWithFormat:@"%d",[diary.commentNumber intValue]];
    commentcount.textAlignment =NSTextAlignmentCenter;
    if ([diary.commentNumber intValue]>10000) {
        commentcount.text =[NSString stringWithFormat:@"%.1f万",[diary.commentNumber floatValue]/10000];
    }
    if ([diary.commentNumber intValue]>100000000) {
        commentcount.text =[NSString stringWithFormat:@"%.1f亿",[diary.commentNumber floatValue]/100000000];
    }
    
    tableCellBack.frame =CGRectMake(0, 0, kMainScreenWidth, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+height*(photowidth-5)/3+49+11);
    if (diary.picPaths.count ==1) {
        tableCellBack.frame =CGRectMake(0, 0, kMainScreenWidth, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+photowidth/8*5+49+11);
    }else if (diary.picPaths.count ==2){
        tableCellBack.frame =CGRectMake(0, 0, kMainScreenWidth, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+(photowidth-5)/2+49+11);
    }else if (diary.picPaths.count ==4){
        tableCellBack.frame =CGRectMake(0, 0, kMainScreenWidth, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+photowidth+49+11);
    }
    
    cell1.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell1;
}
-(void)commentAction:(id)sender{
    UITableViewCell *cell =(UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.mtableview indexPathForCell:cell];
    DiaryObject *diary =[self.dataArray objectAtIndex:indexPath.row];
    IDIAI3DiaryDetaileViewController *detail =[[IDIAI3DiaryDetaileViewController alloc] init];
    detail.title =@"帖子详情";
    
    detail.iscomment =YES;
    if ([diary.userId integerValue]==[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]) {
        detail.iscomment =NO;
    }
    detail.diaryId =diary.diaryId;
    detail.type =7;
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.nav pushViewController:detail animated:YES];
//    [self.navigationController pushViewController:detail animated:YES];
    
}
-(void)praiseAction:(UIButton *)sender{
    [self startRequestWithString:@"加载中..."];
    NSLog(@"%@",[[sender superview] superview]);
    UITableViewCell *cell =(UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.mtableview indexPathForCell:cell];
    DiaryObject *diary =[self.dataArray objectAtIndex:indexPath.row];
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
        [postDict setObject:@"ID0300" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"diaryId":diary.diaryId,@"roleId":[NSNumber numberWithInt:7],@"toUserId":diary.userId,@"toRoleId":diary.roleId};
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
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 103001) {
                        [self stopRequest];
                        UIView *tableCellBack =(UIView *)[cell viewWithTag:100001];
                        UIButton *praisebtn =(UIButton *)[tableCellBack viewWithTag:100008];
                        UILabel *zancount =(UILabel *)[praisebtn viewWithTag:100010];
                        diary.pointNumber =[NSString stringWithFormat:@"%d",[diary.pointNumber intValue]+1];
                        zancount.text =[NSString stringWithFormat:@"%d",[diary.pointNumber intValue]];
                        if ([diary.pointNumber intValue]>10000) {
                            zancount.text =[NSString stringWithFormat:@"%.1f万",[diary.pointNumber floatValue]/10000];
                        }
                        if ([diary.pointNumber intValue]>100000000) {
                            zancount.text =[NSString stringWithFormat:@"%.1f亿",[diary.pointNumber floatValue]/100000000];
                        }
                    } else if (kResCode == 103002) {
                        [self stopRequest];
                        [TLToast showWithText:@"你已点过赞了"];
                    }else{
                        [self stopRequest];
                        [TLToast showWithText:@"点赞失败"];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IDIAI3DiaryDetaileViewController *detail =[[IDIAI3DiaryDetaileViewController alloc] init];
    detail.title =@"帖子详情";
    DiaryObject*diary =[self.dataArray objectAtIndex:indexPath.row];
    detail.diaryId =diary.diaryId;
    detail.type =7;
    detail.ismyDiary =YES;
    if (self.ismyDiary ==YES) {
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
        [appDelegate.nav pushViewController:detail animated:YES];
//        [self.navigationController pushViewController:detail animated:YES];
    }
    
}
-(void)tapAction:(UIGestureRecognizer *)sender{
    UIImageView *image =(UIImageView  *)sender.view;
    NSLog(@"%@",[[image superview] superview]);
    UITableViewCell *cell =(UITableViewCell *)[[image superview] superview];
    NSIndexPath *indexPath = [self.mtableview indexPathForCell:cell];
    DiaryObject *diary =[self.dataArray objectAtIndex:indexPath.row];
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:diary.picPaths.count];
    for (int i = 0; i<diary.picPaths.count; i++) {
        // 替换为中等尺寸图片
        NSString *pic =[diary.picPaths objectAtIndex:i];
        NSString *url = pic;
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = (UIImageView *)sender.view; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = sender.view.tag-1000; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    //    browser.describe =selectpic.phasePicDescription;
    [browser show];
}

-(void)requestAboutlist{
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

        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0285\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"toUserId\":%ld,\"requestRow\":\"10\",\"currentPage\":\"%ld\",\"roleId\":\%ld,\"toRoleId\":\%ld}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.toUserId,(long)self.currentPage,(long)self.type,(long)self.toRoleId];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"相关用户列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==102851) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if(self.refreshing==YES && [self.dataArray count]) [self.dataArray removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"decorDiarys"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                DCParserConfiguration *config = [DCParserConfiguration configuration];
                                DCArrayMapping *arrayMapping = [DCArrayMapping mapperForClassElements:[NSString class] forAttribute:@"picPaths" onClass:[DiaryObject class]];
                                [config addArrayMapper:arrayMapping];
                                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[DiaryObject class] andConfiguration:config];
                                DiaryObject *diary =[parser parseDictionary:dict];
                                [self.dataArray addObject:diary];
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
                        self.isrequst =YES;
                        [self.mtableview reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==102809) {
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

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=1;
        [self requestAboutlist];
    }
    else {
        if(self.totalPages>self.currentPage){
            self.currentPage +=1;
            [self requestAboutlist];
        }
        else{
            
            [self.mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            self.mtableview.reachedTheEnd = YES;  //是否加载到底了
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
    //手指开始拖动方法
    [self.mtableview tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y>2*kMainScreenHeight) {
        self.backtop.hidden =NO;
    }else{
        self.backtop.hidden =YES;
    }
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
