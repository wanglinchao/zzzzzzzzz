//
//  IDIAI3DiaryViewController.m
//  IDIAI
//
//  Created by Ricky on 15/11/16.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//
#import "IDIAI3DiaryViewController.h"//=
#import "DiaryObject.h"//=
#import "DCArrayMapping.h"//-
#import "DCParserConfiguration.h"//-
#import "KVCObject.h"//-
#import "DCObjectMapping.h"//-
#import "DCKeyValueObjectMapping.h"//-
#import "UIImageView+OnlineImage.h"//-
#import "MJPhotoBrowser.h"//=
#import "MJPhoto.h"//=
#import "UIImageView+WebCache.h"
#import "IDIAI3DiaryDetaileViewController.h"//=
#import "IDIAIAppDelegate.h"//!=
#import "LoginView.h"//!=
#import "TLToast.h"//==
#import "IDIAI3ReplayViewController.h"//！= 消息列表 2
#import "IDIAI3AddDiaryViewController.h"//！＝ 写帖子 2
#import "WriteDiaryViewController.h"//！＝ 2
#import "Emoji.h"//＝
#import "IDIAI3AboutDiaryViewController.h"//= 名字不等
#define kCellViewTag 10000

@interface IDIAI3DiaryViewController ()<LoginViewDelegate,UIAlertViewDelegate>{

    NSString *_bookIdStr;
}
@property(nonatomic,strong)UIView *tableCellBack;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isrequst;
@property(nonatomic,strong)UIButton *unreadbtn;
@property(nonatomic,assign)int deletacount;
@property(nonatomic,strong)UIButton *backtop;
@property(nonatomic,assign)int newInfoNumber;

@end

@implementation IDIAI3DiaryViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.ismyDiary ==NO) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (self.ismyDiary ==NO) {
        
        [self requestDiarylist];
    }else{
        [self requestMyDiary];
    }
    [self.mtableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }

    self.currentPage=0;
    self.type =7;
    self.newInfoNumber =0;
    self.dataArray =[NSMutableArray array];
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    if (self.ismyDiary ==NO) {
        self.mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-93-64) pullingDelegate:self];
    }else{
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
        [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
        leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
        [leftButton addTarget:self
                       action:@selector(PressBarItemLeft)
             forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        [self.navigationItem setLeftBarButtonItem:leftItem];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(5, 5, 40, 40)];
        [rightButton setImage:[UIImage imageNamed:@"ic_xieriji.png"] forState:UIControlStateNormal];
        rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
        [rightButton addTarget:self
                        action:@selector(PressBarItemRight)
              forControlEvents:UIControlEventTouchUpInside];
//        rightButton.backgroundColor =[UIColor redColor];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        
        UIButton *rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton1 setFrame:CGRectMake(5, 5, 40, 40)];
        [rightButton1 setImage:[UIImage imageNamed:@"ic_xiaoxilibiao.png"] forState:UIControlStateNormal];
        rightButton1.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
        [rightButton1 addTarget:self
                        action:@selector(showMyAboutAction:)
              forControlEvents:UIControlEventTouchUpInside];
//        rightButton1.backgroundColor =[UIColor orangeColor];
        UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];
        
        NSMutableArray *items =[NSMutableArray array];
        
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -20;
        [items addObject:negativeSeperator];
        if (self.ismyDiary==YES) {
            [items addObject:rightItem1];
        }
        [items addObject:rightItem];
        
//        [self.navigationItem setRightBarButtonItem:rightItem];
        [self.navigationItem setRightBarButtonItems:items];
        
        self.mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) pullingDelegate:self];
    }
    self.mtableview.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
    self.mtableview.dataSource=self;
    self.mtableview.delegate=self;
    self.mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [self.mtableview launchRefreshing];//?
    [self.view addSubview:self.mtableview];

    self.backtop =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.backtop setImage:[UIImage imageNamed:@"ic_huidaodingbu.png"] forState:UIControlStateNormal];
    [self.backtop setImage:[UIImage imageNamed:@"ic_huidaodingbu.png"] forState:UIControlStateHighlighted];
    self.backtop.frame =CGRectMake(kMainScreenWidth-7-35, kMainScreenHeight-64-42-7-35-49, 35, 35);
    [self.backtop addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
    self.backtop.hidden =YES;
    [self.view addSubview:self.backtop];
    [self loadImageviewBG];
    

}
-(void)showMyAboutAction:(id)sender{
    IDIAI3ReplayViewController *replay =[[IDIAI3ReplayViewController alloc] init];
    replay.title =@"消息列表";

    replay.ismyDiary =self.ismyDiary;
    [self.navigationController pushViewController:replay animated:YES];
}
-(void)topAction:(id)sender{
    self.mtableview.contentOffset =CGPointMake(0, 0);
    self.backtop.hidden =YES;
}
-(void)PressBarItemRight{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:User_Token]) {
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
    IDIAI3AddDiaryViewController *adddiary =[[IDIAI3AddDiaryViewController alloc] init];
    adddiary.fromStr =@"IDIAI3DiaryViewController";
    adddiary.title =@"写帖子";
    adddiary.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:adddiary animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"self=========%@",self);
    // Dispose of any resources that can be recreated.
}
-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiaryObject *diary =[self.dataArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    NSString *context=[Emoji replaceUicodeBecomeEmojiWith:diary.diaryContext];
    CGSize labelsize = [util calHeightForLabel:context width:kMainScreenWidth-69 font:font];
    if (labelsize.height>84) {
        labelsize.height =84;
    }
    int count =(int)[diary.picPaths count]/3+1;
    if ([diary.picPaths count]%3==0) {
        count =(int)[diary.picPaths count]/3;
    }
    float photowidth =kMainScreenWidth-90;
    
    int y =10;
    if (indexPath.row ==0) {
        y=0;
    }
    float originy =0;
    if (self.ismyDiary==YES) {
        originy =20+y;
    }
    float diaryTypeY=0;
    if (diary.diaryType==2) {
        diaryTypeY=-20;
    }
    if (diary.picPaths.count ==1) {
        return 88+labelsize.height+photowidth/8*5+49+11-originy+y+diaryTypeY+labelsize.height/14*5;
    }else if (diary.picPaths.count ==2){
        return 88+labelsize.height+(photowidth-5)/2+49+11-originy+y+diaryTypeY+labelsize.height/14*5;
    }else if (diary.picPaths.count ==4){
        return 88+labelsize.height+photowidth+49+11-originy+y-11+diaryTypeY+labelsize.height/14*5;
    }else{
       return 88+labelsize.height+count*(photowidth-5)/3+49+11-originy+y+diaryTypeY+labelsize.height/14*5;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

         
     static NSString *CellIdentifier1 = @"MyCellIdentifier";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        int y =10;
        DiaryObject *diary =[self.dataArray objectAtIndex:indexPath.row];
        if (!cell1) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            
            UIView *tableCellBack =[[UIView alloc] initWithFrame:CGRectMake(0, 11, kMainScreenWidth, 100)];
            tableCellBack.tag =100001;
            [cell1 addSubview:tableCellBack];
            
            UIImageView *headimage =[[UIImageView alloc] initWithFrame:CGRectMake(6, 12+y, 33, 33)];
            headimage.layer.cornerRadius=17;
            headimage.clipsToBounds=YES;
            headimage.tag =100002;
            headimage.userInteractionEnabled =YES;
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAboutAction:)];
            [headimage addGestureRecognizer:tap];
            if (self.ismyDiary ==NO) {
                [tableCellBack addSubview:headimage];
            }
            
            UILabel *namelbl =[[UILabel alloc] init];
            namelbl.textColor =[UIColor blackColor];
            namelbl.tag =100003;
            namelbl.font =[UIFont systemFontOfSize:15];
            if (self.ismyDiary ==NO) {
                [tableCellBack addSubview:namelbl];
            }
            
            
            UIImageView *styleimage =[[UIImageView alloc] init];
            styleimage.tag =100004;
            [tableCellBack addSubview:styleimage];
            //        if (diary.diaryType==1) {
            UILabel *homelbl =[[UILabel alloc] initWithFrame:CGRectMake(namelbl.frame.origin.x, headimage.frame.size.height+headimage.frame.origin.y+8, kMainScreenWidth-69, 15)];
            homelbl.tag =100005;
            homelbl.textColor =[UIColor blackColor];
            homelbl.font =[UIFont systemFontOfSize:15];
            [tableCellBack addSubview:homelbl];
            //        }
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
            
            UIButton *deletabtn =[UIButton buttonWithType:UIButtonTypeCustom];
            deletabtn.tag =100014;
            [tableCellBack addSubview:deletabtn];
            
            UIButton *editorbtn =[UIButton buttonWithType:UIButtonTypeCustom];
            editorbtn.tag =100016;
            [tableCellBack addSubview:editorbtn];
            
            UIImageView *questionimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
            questionimage.tag =100017;
            questionimage.image =[UIImage imageNamed:@"ic_zhangxiuwenda.png"];
            
            [tableCellBack addSubview:questionimage];
            
            UIImageView *footimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 11)];
            footimage.tag =100015;
            [cell1 addSubview:footimage];
        }
        
        UIView *tableCellBack =(UIView *)[cell1 viewWithTag:100001];
        float orginx =0;
        float orginy =0;
        if (self.ismyDiary ==NO) {
            UIImageView *headimage =(UIImageView *)[tableCellBack viewWithTag:100002];
            
            if ([diary.roleId integerValue]!=7) {
                if (diary.diaryType==2) {
                    headimage.image =[UIImage imageNamed:@"ic_tiwen_u.png"];;
                    
                }else{
//                    headimage.image = nil;
                    [headimage sd_setImageWithURL:[NSURL URLWithString:diary.logo] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
//                                   [headimage setOnlineImage:diary.logo placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
                }
            }else{
                if (diary.logo.length>0) {
                    if (diary.diaryType==2) {
                        headimage.image = [UIImage imageNamed:@"ic_tiwen_u.png"];
                        
                    }else{
                         [headimage sd_setImageWithURL:[NSURL URLWithString:diary.logo] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
                        
                    }
                }else{
                    if (diary.diaryType==2) {
                        headimage.image =  [UIImage imageNamed:@"ic_tiwen_u.png"];

                        
                    }else{
                        headimage.image =  [UIImage imageNamed:@"ic_touxiang_tk"];
                        //
                    }
                }
                
            }
            
            
            UILabel *namelbl =(UILabel *)[tableCellBack viewWithTag:100003];
            if (diary.nickName.length>0) {
                namelbl.text =diary.nickName;
                namelbl.frame =CGRectMake(headimage.frame.origin.x+headimage.frame.size.width+6, headimage.frame.origin.y+9, diary.nickName.length*15, 15);
                if (diary.diaryType==2) {
                    namelbl.text =[NSString stringWithFormat:@"【%@】提问",diary.nickName];
                }
            }else{
                NSString *str =[NSString stringWithFormat:@"用户%@",diary.userId];
                if (diary.diaryType==2) {
                    str =[NSString stringWithFormat:@"【%@】提问",str];
                }
                namelbl.frame =CGRectMake(headimage.frame.origin.x+headimage.frame.size.width+6, headimage.frame.origin.y+9, str.length*11, 15);
                namelbl.text =str;
            }
            UIFont *font1= [UIFont fontWithName:@"Arial" size:15];
            CGSize labelsize1 = [util calHeightForLabel:namelbl.text width:kMainScreenWidth-67 font:font1];
            namelbl.font =font1;
            namelbl.frame =CGRectMake(namelbl.frame.origin.x, namelbl.frame.origin.y, labelsize1.width, namelbl.frame.size.height);
            
            UIImageView *styleimage =(UIImageView *)[tableCellBack viewWithTag:100004];
            styleimage.frame=CGRectMake(namelbl.frame.origin.x+namelbl.frame.size.width+12, namelbl.frame.origin.y+0.5, 33, 14);
            if ([diary.roleId integerValue]==1) {
                styleimage.frame =CGRectMake(styleimage.frame.origin.x, styleimage.frame.origin.y, 43, 14);
                styleimage.image =  [UIImage imageNamed:@"ic_shejishi.png"];
                
            }else if ([diary.roleId integerValue]==4){
                styleimage.image = [UIImage imageNamed:@"ic_gongzhang_diary.png"];

            }else if ([diary.roleId integerValue]==6){
                styleimage.image =  [UIImage imageNamed:@"ic_jianli_diary.png"];
                
            }else if ([diary.roleId integerValue]==7){
                styleimage.image =  [UIImage imageNamed:@"ic_yezhu.png"];
               
            }else if ([diary.roleId integerValue]==2){
                styleimage.image = [UIImage imageNamed:@"ic_shangjia.png"];
                
            }else if ([diary.roleId integerValue]==9){
                styleimage.image = [UIImage imageNamed:@"ic_jianli_diary.png"];
                
            }
            if (diary.diaryType==2) {
                styleimage.hidden =YES;
            }else{
                styleimage.hidden =NO;
            }
            orginx =namelbl.frame.origin.x;
            orginy =headimage.frame.size.height+headimage.frame.origin.y+8;
        }else{
            orginx =12;
            orginy =20+y;
        }
        
        
        UILabel *homelbl =(UILabel *)[tableCellBack viewWithTag:100005];
        if (diary.diaryType==1) {
            homelbl.frame =CGRectMake(orginx, orginy, kMainScreenWidth-69, 16);
            homelbl.text =diary.diaryTitle;
            homelbl.textColor =[UIColor blackColor];
            UIImageView *questionimage =(UIImageView *)[tableCellBack viewWithTag:100017];
            questionimage.hidden =YES;
        }else{
            if (self.ismyDiary==YES) {
                UIImageView *questionimage =(UIImageView *)[tableCellBack viewWithTag:100017];
                questionimage.frame=CGRectMake(orginx, orginy+3, 13, 13);
                questionimage.hidden =NO;
                homelbl.text =@"提问";
                homelbl.frame =CGRectMake(orginx+19, orginy, kMainScreenWidth-69, 16);
                homelbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
                
            }else{
                UIImageView *questionimage =(UIImageView *)[tableCellBack viewWithTag:100017];
                questionimage.hidden =YES;
                homelbl.frame =CGRectMake(orginx, orginy, kMainScreenWidth-69, 16);
                homelbl.text =@"";
                homelbl.textColor =[UIColor blackColor];
            }
        }
        
        NSString *context=[Emoji replaceUicodeBecomeEmojiWith:diary.diaryContext];
        UIFont *font = [UIFont fontWithName:@"Arial" size:14];
        
        CGSize size = CGSizeMake(kMainScreenWidth-69,200);
        if (self.ismyDiary ==YES) {
            size =CGSizeMake(kMainScreenWidth-24, 200);
        }
        CGSize labelsize = [util calHeightForLabel:context width:size.width font:font];
        UILabel *contentlbl =(UILabel *)[tableCellBack viewWithTag:100006];
        if (labelsize.height>84) {
            labelsize.height =84;
        }
        contentlbl.frame =CGRectMake(homelbl.frame.origin.x, homelbl.frame.size.height+homelbl.frame.origin.y+8, labelsize.width, labelsize.height);
        if (diary.diaryType==2) {
            if (self.ismyDiary ==NO) {
                contentlbl.frame =CGRectMake(orginx, orginy, labelsize.width, labelsize.height);
            }else{
                contentlbl.frame =CGRectMake(orginx, homelbl.frame.size.height+homelbl.frame.origin.y+8, labelsize.width, labelsize.height);
            }
            
        }
        contentlbl.numberOfLines =6;
        contentlbl.font =font;
        contentlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:context];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [context length])];
        contentlbl.attributedText = attributedString;
        [contentlbl sizeToFit];
        
        //    contentlbl.text =context;
        float photowidth =kMainScreenWidth-90;
        float photoheight =kMainScreenWidth-90;
        for (int i=0; i<9; i++) {
            UIImageView *picimage =(UIImageView *)[tableCellBack viewWithTag:1000+i];
            if (picimage) {
                [picimage removeFromSuperview];
                picimage =nil;
//                [picimage removeFromSuperview];
            }
        }
        int countx =0;
        int county =0;
        int count=0;
        NSLog(@"diarypicPath===========%@",diary.picPaths);
        for (NSString *pic in diary.picPaths) {
           
            UIImageView *picimage =[[UIImageView alloc] initWithFrame:CGRectMake(contentlbl.frame.origin.x+countx*((photowidth-5)/3+2.5), contentlbl.frame.origin.y+contentlbl.frame.size.height+12+county*((photowidth-5)/3+2.5), (photowidth-5)/3, (photowidth-5)/3)];
            if (self.ismyDiary ==YES) {
                picimage.frame =CGRectMake(45+countx*((photowidth-5)/3+2.5), contentlbl.frame.origin.y+contentlbl.frame.size.height+12+county*((photowidth-5)/3+2.5), (photowidth-5)/3, (photowidth-5)/3);
            }
            if (diary.picPaths.count ==1) {
                picimage.frame =CGRectMake(45, contentlbl.frame.origin.y+contentlbl.frame.size.height+12, photowidth, photoheight/8*5);
            }else if (diary.picPaths.count ==2){
                picimage.frame =CGRectMake(45+((kMainScreenWidth-90-5)/2+2.5)*countx, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+county*((photowidth-5)/2+2.5), (photowidth-5)/2, (photowidth-5)/2);
            }else if (diary.picPaths.count ==4){
                picimage.frame =CGRectMake(45+((kMainScreenWidth-90-5)/2+2.5)*countx, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+county*((photowidth-5)/2+2.5), (photowidth-5)/2, (photowidth-5)/2);
            }
//                    picimage.image =[UIImage imageNamed:@"bg_taotubeijing.png"];
//                    [picimage sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                        picimage.image =image;
//                    }];
            [picimage sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                picimage.image =image;
            }];
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
        NSDate *releasedate = [NSDate dateWithTimeIntervalSince1970:[diary.releaseDate doubleValue]/1000];
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
            praisebtn.layer.cornerRadius=10;
            praisebtn.clipsToBounds=YES;
            praisebtn.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
            praisebtn.layer.borderWidth = 1;
            praisebtn.frame =CGRectMake(praisebtn.frame.origin.x-20, praisebtn.frame.origin.y, praisebtn.frame.size.width, praisebtn.frame.size.height);
            if (diary.diaryType==1) {
                praisebtn.layer.cornerRadius=10;
                praisebtn.clipsToBounds=YES;
                praisebtn.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
                praisebtn.layer.borderWidth = 1;
                praisebtn.frame =CGRectMake(praisebtn.frame.origin.x-55, praisebtn.frame.origin.y, praisebtn.frame.size.width, praisebtn.frame.size.height);
            }
        }
        
        [praisebtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView *zanimage =(UIImageView *)[praisebtn viewWithTag:100009];
        zanimage.frame =CGRectMake(11, 5, 11, 12);
        zanimage.image =  [UIImage imageNamed:@"ic_zan.png"];
     
        if (diary.isPoint>0) {
            zanimage.image = [UIImage imageNamed:@"ic_zan_up_sp.png"];
            
        }
        
        
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
            [commentbtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            commentbtn.userInteractionEnabled =NO;
            commentbtn.frame =CGRectMake(commentbtn.frame.origin.x-30, commentbtn.frame.origin.y, commentbtn.frame.size.width, commentbtn.frame.size.height);
            if (diary.diaryType==1) {
                commentbtn.frame =CGRectMake(commentbtn.frame.origin.x-45, commentbtn.frame.origin.y, commentbtn.frame.size.width, commentbtn.frame.size.height);
            }
            commentbtn.layer.cornerRadius=10;
            commentbtn.clipsToBounds=YES;
            commentbtn.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
            commentbtn.layer.borderWidth = 1;
        }
        
        UIButton *deletabtn =(UIButton *)[tableCellBack viewWithTag:100014];
        
        deletabtn.frame =CGRectMake(kMainScreenWidth-11-25, commentbtn.frame.origin.y-3, 25, 25);
            [deletabtn setImage:[UIImage imageNamed:@"ic_shanchu_wo_u.png"] forState:UIControlStateNormal];
            [deletabtn setImage:[UIImage imageNamed:@"ic_shanchu_wo_u.png"] forState:UIControlStateHighlighted];
        [deletabtn addTarget:self action:@selector(deletaAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.ismyDiary ==NO) {
            deletabtn.hidden =YES;
        }else{
            deletabtn.hidden =NO;
        }
        
        UIButton *editorbtn =(UIButton *)[tableCellBack viewWithTag:100016];
        editorbtn.frame =CGRectMake(kMainScreenWidth-11-60, commentbtn.frame.origin.y-3, 25, 25);
            [editorbtn setImage:[UIImage imageNamed:@"ic_bianji.png"] forState:UIControlStateNormal];
            [editorbtn setImage:[UIImage imageNamed:@"ic_bianji.png"] forState:UIControlStateHighlighted];
        [editorbtn addTarget:self action:@selector(editorAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.ismyDiary==YES) {
            if (diary.diaryType==1) {
                editorbtn.hidden =NO;
            }else{
                editorbtn.hidden =YES;
            }
        }else{
            editorbtn.hidden =YES;
        }
        
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
        tableCellBack.frame =CGRectMake(0, 0, kMainScreenWidth, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+height*(photowidth-5)/3+49+11+y);
        if (diary.picPaths.count ==1) {
            tableCellBack.frame =CGRectMake(0, 0, kMainScreenWidth, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+photowidth/8*5+49+11+y);
        }else if (diary.picPaths.count ==2){
            tableCellBack.frame =CGRectMake(0, 0, kMainScreenWidth, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+(photowidth-5)/2+49+11+y);
        }else if (diary.picPaths.count ==4){
            tableCellBack.frame =CGRectMake(0, 0, kMainScreenWidth, contentlbl.frame.origin.y+contentlbl.frame.size.height+12+photowidth+49+11+y);
        }
        UIImageView *footview =(UIImageView *)[cell1 viewWithTag:100015];
        //    if (footview ==nil) {
        //        UIImageView *footview =[[UIImageView alloc] initWithFrame:CGRectMake(0, tableCellBack.frame.size.height-11, kMainScreenWidth, 11)];
        //    }
        //    if (indexPath.row ==0) {
        //        tableCellBack.backgroundColor =[UIColor redColor];
        //    }else if (indexPath.row ==1){
        //        tableCellBack.backgroundColor =[UIColor orangeColor];
        //    }else if (indexPath.row ==2){
        //        tableCellBack.backgroundColor =[UIColor blueColor];
        //    }else if (indexPath.row ==3){
        //        tableCellBack.backgroundColor =[UIColor greenColor];
        //    }else if (indexPath.row ==4){
        //        tableCellBack.backgroundColor =[UIColor darkGrayColor];
        //    }
        footview.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        //    footview.frame =CGRectMake(0, tableCellBack.frame.size.height-11, kMainScreenWidth, 11);
        //    [tableCellBack addSubview:footview];
        //    NSLog(@"%@",cell1.subviews);
     if (self.unreadbtn!=nil&&indexPath.row ==0) {
            footview.hidden =YES;
        }else{
            footview.hidden =NO;
        }
        cell1.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell1;
    
 }

-(void)editorAction:(id)sender{
    UITableViewCell *cell =(UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.mtableview indexPathForCell:cell];
    DiaryObject *diary =[self.dataArray objectAtIndex:indexPath.row];
    WriteDiaryViewController * writeDiary = [[WriteDiaryViewController alloc]init];
    writeDiary.title =@"写帖子";
    writeDiary.roleId = 7;
    writeDiary.hidesBottomBarWhenPushed =YES;
    writeDiary.photoURL =diary.picPaths;
    writeDiary.diaryId =[diary.diaryId intValue];
    writeDiary.diaryType1 =diary.diaryType;
    writeDiary.useType = 1;//1 utop
    [self.navigationController pushViewController:writeDiary animated:YES];
}
-(void)commentAction:(id)sender{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
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
    detail.ismyDiary =self.ismyDiary;
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    detail.hidesBottomBarWhenPushed =YES;
    [appDelegate.nav setNavigationBarHidden:NO animated:YES];
    [appDelegate.nav pushViewController:detail animated:YES];

}
-(void)deletaAction:(UIButton *)sender{
    UITableViewCell *cell =(UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.mtableview indexPathForCell:cell];
    self.deletacount =(int)indexPath.row;
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"" message:@"确定删除该帖子吗？" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
    [alert dismissWithClickedButtonIndex:1 animated:YES];
    [alert show];
}
-(void)praiseAction:(UIButton *)sender{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
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
                        [TLToast showWithText:@"点赞成功"];
                        UIView *tableCellBack =(UIView *)[cell.contentView viewWithTag:100001];
                        UIButton *praisebtn =(UIButton *)[tableCellBack viewWithTag:100008];
                        UIImageView *zanimage =(UIImageView *)[praisebtn viewWithTag:100009];
                        zanimage.image =[UIImage imageNamed:@"ic_zan_up_sp.png"];
                        UILabel *zancount =(UILabel *)[praisebtn viewWithTag:100010];
                        diary.pointNumber =[NSString stringWithFormat:@"%d",[diary.pointNumber intValue]+1];
                        zancount.text =[NSString stringWithFormat:@"%d",[diary.pointNumber intValue]];
                        diary.isPoint =1;
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
    detail.ismyDiary =self.ismyDiary;
    if (self.ismyDiary ==YES) {
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        detail.hidesBottomBarWhenPushed =YES;
        [appDelegate.nav setNavigationBarHidden:NO animated:YES];
        [appDelegate.nav pushViewController:detail animated:YES];
    }
    
}
-(void)tapAction:(UIGestureRecognizer *)sender{
    

    
    UIImageView *image =(UIImageView  *)sender.view;
    NSLog(@"%@",[[image superview] superview]);
    UITableViewCell *cell =(UITableViewCell *)[[image superview] superview];
    NSIndexPath *indexPath = [self.mtableview indexPathForCell:cell];
    NSLog(@"indexPath===================%@",indexPath);
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
    browser.describe =@"";
    [browser show];
}
-(void)requestMyDiary{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }

        NSString *url =[NSString string];
        if (self.labelId==0) {
            self.labelId =-1;
        }
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0288\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\",\"roleId\":7,\"siteDiaryType\":1}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"日记我的列表返回信息：%@",jsonDict);
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
                if (code==102881) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(self.refreshing==YES && [self.dataArray count]) [self.dataArray removeAllObjects];
                        if (self.currentPage ==1) {
                            [self.dataArray removeAllObjects];
                        }
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
                            
                            if (![[jsonDict objectForKey:@"newInfoNumber"] isEqual:[NSNull null]]) {
                                self.newInfoNumber =(int)[[jsonDict objectForKey:@"newInfoNumber"] integerValue];
                                UIView *headback =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 38)];
                                headback.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                                if ([[jsonDict objectForKey:@"newInfoNumber"] integerValue]>0) {
                                    UIView *unreadback =[[UIView alloc] initWithFrame:CGRectMake(0, 11, kMainScreenWidth, 27)];
                                    unreadback.backgroundColor =[UIColor whiteColor];
                                    [headback addSubview:unreadback];
                                    if (!self.unreadbtn) {
                                        self.unreadbtn =[UIButton buttonWithType:UIButtonTypeCustom];
                                        
                                    }
                                    [unreadback addSubview:self.unreadbtn];
                                    self.unreadbtn.backgroundColor =[UIColor colorWithHexString:@"#e6e6e6"];
                                    [self.unreadbtn setTitleColor:[UIColor colorWithHexString:@"a0a0a0"] forState:UIControlStateNormal];
                                    [self.unreadbtn setTitleColor:[UIColor colorWithHexString:@"a0a0a0"] forState:UIControlStateHighlighted];
                                    [self.unreadbtn setTitle:[NSString stringWithFormat:@"你有%@条未读",[jsonDict objectForKey:@"newInfoNumber"]] forState:UIControlStateNormal];
                                    [self.unreadbtn setTitle:[NSString stringWithFormat:@"你有%@条未读",[jsonDict objectForKey:@"newInfoNumber"]] forState:UIControlStateHighlighted];
                                    self.unreadbtn.frame =CGRectMake((kMainScreenWidth-73)/2, 10, 93, 17);
                                    self.unreadbtn.titleLabel.font =[UIFont systemFontOfSize:11];
                                    self.unreadbtn.layer.cornerRadius=9;
                                    self.unreadbtn.clipsToBounds=YES;
                                    [self.unreadbtn addTarget:self action:@selector(showMessageList:) forControlEvents:UIControlEventTouchUpInside];
                                    self.mtableview.tableHeaderView =headback;
                                }else if ([[jsonDict objectForKey:@"newInfoNumber"] integerValue]==0){
                                    headback.frame =CGRectMake(0, 0, kMainScreenWidth, 11);
                                    if (self.unreadbtn) {
                                        [self.unreadbtn removeFromSuperview];
                                        self.unreadbtn =nil;
                                    }
                                    self.mtableview.tableHeaderView =nil;
                                }
                                
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
//                                                self.isrequst =NO;
                    });
                }
                else if (code==102809) {
                    dispatch_async(dispatch_get_main_queue(), ^{
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
-(void)showAboutAction:(UIGestureRecognizer *)sender{
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:User_Token]) {
//        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
//        login.delegate=self;
//        [login show];
//        return;
//    }
    UITableViewCell *cell =(UITableViewCell *)[[sender.view superview] superview];
    NSIndexPath *indexPath = [self.mtableview indexPathForCell:cell];
    DiaryObject *diary =[self.dataArray objectAtIndex:indexPath.row];
    IDIAI3AboutDiaryViewController *about =[[IDIAI3AboutDiaryViewController alloc] init];
    about.toRoleId =[diary.roleId integerValue];
    about.toUserId =[diary.userId integerValue];
    NSString *style =[NSString string];
    if ([diary.roleId integerValue]==1) {
        style =@"设计师";
    }else if ([diary.roleId integerValue]==2){
        style =@"商家";
    }else if ([diary.roleId integerValue]==4){
        style =@"工长";
    }else if ([diary.roleId integerValue]==6){
        style =@"监理";
    }else if ([diary.roleId integerValue]==7){
        style =@"业主";
    }
    NSString *nickName =[NSString string];
    if (diary.nickName.length ==0) {
        nickName =[NSString stringWithFormat:@"用户%@",diary.userId];
    }else{
        nickName =diary.nickName;
    }
    about.title =[NSString stringWithFormat:@"%@[%@]",nickName,style];
    about.ismyDiary =self.ismyDiary;
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.nav setNavigationBarHidden:NO animated:YES];
    [appDelegate.nav pushViewController:about animated:YES];
}
-(void)requestDiarylist{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }

        NSString *url =[NSString string];
        if (self.labelId==0) {
            self.labelId =-1;
        }
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0280\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"lableId\":\"%ld\",\"requestRow\":\"10\",\"currentPage\":\"%ld\",\"roleId\":\%ld}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.labelId,(long)self.currentPage,(long)self.type];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"日记列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==102801) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(![[jsonDict objectForKey:@"timeTemp"] isEqual:[NSNull null]]){
                            [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:@"timeTemp"] forKey:DiaryTimeStamp];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        
                        if(self.refreshing==YES && [self.dataArray count]) [self.dataArray removeAllObjects];
                        if (self.currentPage ==1) {
                            [self.dataArray removeAllObjects];
                        }
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
                            if (![[jsonDict objectForKey:@"newInfoNumber"] isEqual:[NSNull null]]) {
                                self.newInfoNumber =(int)[[jsonDict objectForKey:@"newInfoNumber"] integerValue];
                                UIView *headback =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 38)];
                                headback.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
                                if ([[jsonDict objectForKey:@"newInfoNumber"] integerValue]>0) {
                                    UIView *unreadback =[[UIView alloc] initWithFrame:CGRectMake(0, 11, kMainScreenWidth, 27)];
                                    unreadback.backgroundColor =[UIColor whiteColor];
                                    [headback addSubview:unreadback];
                                    if (!self.unreadbtn) {
                                         self.unreadbtn =[UIButton buttonWithType:UIButtonTypeCustom];
                                    }
                                    [unreadback addSubview:self.unreadbtn];
                                    self.unreadbtn.backgroundColor =[UIColor colorWithHexString:@"#e6e6e6"];
                                    [self.unreadbtn setTitleColor:[UIColor colorWithHexString:@"a0a0a0"] forState:UIControlStateNormal];
                                    [self.unreadbtn setTitleColor:[UIColor colorWithHexString:@"a0a0a0"] forState:UIControlStateHighlighted];
                                    [self.unreadbtn setTitle:[NSString stringWithFormat:@"你有%@条未读",[jsonDict objectForKey:@"newInfoNumber"]] forState:UIControlStateNormal];
                                    [self.unreadbtn setTitle:[NSString stringWithFormat:@"你有%@条未读",[jsonDict objectForKey:@"newInfoNumber"]] forState:UIControlStateHighlighted];
                                    self.unreadbtn.frame =CGRectMake((kMainScreenWidth-73)/2, 10, 93, 17);
                                    self.unreadbtn.titleLabel.font =[UIFont systemFontOfSize:11];
                                    self.unreadbtn.layer.cornerRadius=9;
                                    self.unreadbtn.clipsToBounds=YES;
                                    [self.unreadbtn addTarget:self action:@selector(showMessageList:) forControlEvents:UIControlEventTouchUpInside];
                                    self.mtableview.tableHeaderView =headback;
                                }else if ([[jsonDict objectForKey:@"newInfoNumber"] integerValue]==0){
                                    headback.frame =CGRectMake(0, 0, kMainScreenWidth, 11);
                                    if (self.unreadbtn) {
                                        [self.unreadbtn removeFromSuperview];
                                         self.unreadbtn =nil;
                                    }
                                    self.mtableview.tableHeaderView =nil;
                                }
                                
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
-(void)showMessageList:(UIButton *)sender{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:User_Token]) {
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
    IDIAI3ReplayViewController *replay =[[IDIAI3ReplayViewController alloc] init];
    replay.title =@"消息列表";
    replay.ismyDiary =self.ismyDiary;
    if (self.ismyDiary ==YES) {
        [self.navigationController pushViewController:replay animated:YES];
    }else{
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        replay.hidesBottomBarWhenPushed =YES;
        [appDelegate.nav setNavigationBarHidden:NO animated:YES];
        [appDelegate.nav pushViewController:replay animated:YES];
    }
    self.mtableview.tableHeaderView =nil;
}
#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=1;
        if (self.ismyDiary ==NO) {
            [self requestDiarylist];
        }else{
            [self requestMyDiary];
        }
    }
    else {
        if(self.totalPages>self.currentPage){
            self.currentPage +=1;
            if (self.ismyDiary ==NO) {
                [self requestDiarylist];
            }else{
                [self requestMyDiary];
            }
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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>2*kMainScreenHeight) {
        self.backtop.hidden =NO;
    }else{
        self.backtop.hidden =YES;
    }
}
#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        DiaryObject *diary =[self.dataArray objectAtIndex:self.deletacount];
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
            [postDict setObject:@"ID0278" forKey:@"cmdID"];
            [postDict setObject:string_token forKey:@"token"];
            [postDict setObject:string_userid forKey:@"userID"];
            [postDict setObject:@"ios" forKey:@"deviceType"];
            [postDict setObject:kCityCode forKey:@"cityCode"];
            
            NSString *string=[postDict JSONString];
            NSDictionary *bodyDic = @{@"diaryId":[NSNumber numberWithInteger:[diary.diaryId integerValue]],@"roleId":[NSNumber numberWithInt:7]};
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
                        
                        if (kResCode == 102781) {
                            [self stopRequest];
                            [TLToast showWithText:@"删除帖子成功"];
                            [self requestMyDiary];
                        } else {
                            [self stopRequest];
                            [TLToast showWithText:@"删除帖子失败"];
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
