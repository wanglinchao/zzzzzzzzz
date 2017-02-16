//
//  IDIAI3Diary\DetaileViewController.m
//  IDIAI
//
//  Created by Ricky on 15/11/23.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3DiaryDetaileViewController.h"
#import "DiaryDetailObject.h"
#import "DiaryCommentObject.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "DiaryMessageCell.h"
#import "DiaryPhotosCell.h"
#import "DiaryCommentCell.h"
#import "LoginView.h"
#import "TLToast.h"
#import "SharePcitureView.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "FacialView.h"
#import "IDIAI3AboutDiaryViewController.h"
#import "UITextField+ExtentRange.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "IDIAIAppDelegate.h"
#import "IDIAI4NewHomePageViewController.h"
@interface IDIAI3DiaryDetaileViewController ()<UITableViewDelegate,UITableViewDataSource,DiaryCommentCellDelegate,UITextViewDelegate,LoginViewDelegate,DiaryMessageCellDelegate,SharePicViewDelegate,facialViewDelegate,DiaryPhotosCellDelegate>{
    UIScrollView *scrollView_emoji;
    UIPageControl *pageControl;
}
@property(nonatomic,strong)DiaryDetailObject *detail;
@property(nonatomic,strong)NSMutableArray *diaryCommentlist;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UIView *commentview;
@property(nonatomic,strong)UITextView *commenttxf;
@property(nonatomic,strong)UIButton *expressionimage;
@property(nonatomic,assign)BOOL isshow;
@property(nonatomic,assign)BOOL isreplay;
@property(nonatomic,strong)DiaryReplyCommentObject *selectreply;
@property(nonatomic,assign)NSInteger selectComment;
@property(nonatomic,assign)CGFloat commentHeight;
@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,assign)NSInteger cursorPosition;
@property(nonatomic,strong)UIButton *backtop;
@property(nonatomic,strong)UIView *keyboardView;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)UIView *tapView;
@property(nonatomic,strong)UILabel *placeholder;
@property(nonatomic,assign)CGFloat commentY;
@end

@implementation IDIAI3DiaryDetaileViewController
-(void)viewWillAppear:(BOOL)animated{
//    
//    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//    if ([delegate.nav.viewControllers[delegate.nav.viewControllers.count-2] isKindOfClass:[IDIAI4NewHomePageViewController class]]) {
//        [delegate.nav setNavigationBarHidden:NO animated:NO];
//    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.type=7;
    self.title =@"帖子详情";
    self.isshow =NO;
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
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
    [rightButton setImage:[UIImage imageNamed:@"ic_fenxiang_2.png"] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    self.table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-42)];
    self.table.backgroundColor=[UIColor whiteColor];
    self.table.dataSource=self;
    self.table.delegate=self;
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    
    UIView *footerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    footerView.backgroundColor =[UIColor whiteColor];
    UILabel *footlbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    footlbl.font =[UIFont systemFontOfSize:15];
    footlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    footlbl.text =@"没有更多了";
    footlbl.textAlignment =NSTextAlignmentCenter;
    [footerView addSubview:footlbl];
    self.table.tableFooterView =footerView;
    
    self.commentview =[[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-64-42, kMainScreenWidth, 42)];
    self.commentview.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:self.commentview];
    
    
    
    self.commenttxf =[[UITextView alloc] init];
    self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, 32);
    self.placeholder =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.commenttxf.frame.size.width-20, self.self.commenttxf.frame.size.height-20)];
    self.commenttxf.font =[UIFont systemFontOfSize:14];
    UIFont *font1= [UIFont fontWithName:@"Arial" size:14];
    self.placeholder.font =font1;
    self.placeholder.textColor =kColorWithRGB(217, 217, 221);
    self.placeholder.text =@"请输入评论内容";
    [self.commenttxf addSubview:self.placeholder];
//    self.commenttxf.borderStyle=UITextBorderStyleRoundedRect;
//    self.commenttxf.placeholder =@"请输入评论内容";
    if (self.commentId>0) {
        self.placeholder.text =[NSString stringWithFormat:@"回复%@",self.tonickName];
//        self.commenttxf.placeholder =[NSString stringWithFormat:@"回复%@",self.tonickName];
    }
    self.commenttxf.returnKeyType =UIReturnKeyDone;
    self.commenttxf.delegate =self;
    [self.commentview addSubview:self.commenttxf];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeAction:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.expressionimage =[UIButton buttonWithType:UIButtonTypeCustom];
    self.expressionimage.frame =CGRectMake(self.commenttxf.frame.origin.x+self.commenttxf.frame.size.width+10, 0, 35, 42);
    [self.expressionimage setImage:[UIImage imageNamed:@"ic_baoqing_comment"] forState:UIControlStateNormal];
    [self.expressionimage setImage:[UIImage imageNamed:@"ic_jianpan_comment"] forState:UIControlStateSelected];
    [self.expressionimage addTarget:self action:@selector(showExpression:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentview addSubview:self.expressionimage];
    
    self.backtop =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.backtop setImage:[UIImage imageNamed:@"ic_huidaodingbu.png"] forState:UIControlStateNormal];
    [self.backtop setImage:[UIImage imageNamed:@"ic_huidaodingbu.png"] forState:UIControlStateHighlighted];
    self.backtop.frame =CGRectMake(kMainScreenWidth-7-35, kMainScreenHeight-64-42-7-35, 35, 35);
    [self.backtop addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
    self.backtop.hidden =YES;
    [self.view addSubview:self.backtop];
    [self requestDiaryDetail];
    // Do any additional setup after loading the view.
}
-(void)topAction:(id)sender{
    self.table.contentOffset =CGPointMake(0, 0);
    self.backtop.hidden =YES;
}
-(void)showExpression:(UIButton *)sender{
    if (self.tapView==nil) {
        self.tapView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, self.table.frame.size.height)];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        self.tapView.backgroundColor =[UIColor clearColor];
        [self.tapView addGestureRecognizer:tap];
        [self.view addSubview:self.tapView];
    }
    [self.commenttxf resignFirstResponder];
    UIButton *button =(UIButton *)sender;
    button.selected =!button.selected;
    if (button.selected ==NO) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.keyboardView.frame =CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 205);
        [UIView commitAnimations];
        [self.commenttxf becomeFirstResponder];
        [self.view bringSubviewToFront:self.commentview];
    }else{
        if (self.keyboardView==nil) {
            self.keyboardView =[[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 205)];
            [self.view addSubview:self.keyboardView];
        }
        self.keyboardView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        if (scrollView_emoji==nil) {
            scrollView_emoji=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 145)];
            float width=(kMainScreenWidth-30)/7;
            float height=145/3;
            for (int i=0; i<4; i++) {
                FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(15+kMainScreenWidth*i, 0, kMainScreenWidth-30, 145)];
                [fview loadFacialView:i size:CGSizeMake(width, height)];
                fview.delegate=self;
                [scrollView_emoji addSubview:fview];
            }
        }
        [scrollView_emoji setShowsVerticalScrollIndicator:NO];
        [scrollView_emoji setShowsHorizontalScrollIndicator:NO];
        scrollView_emoji.contentSize=CGSizeMake(kMainScreenWidth*4, 145);
        scrollView_emoji.pagingEnabled=YES;
        scrollView_emoji.delegate=self;
        [self.keyboardView addSubview:scrollView_emoji];
        
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((kMainScreenWidth-150)/2, 145, 150, 20)];
        [pageControl setCurrentPage:0];
        pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
        pageControl.currentPageIndicatorTintColor=[UIColor darkGrayColor];
        pageControl.numberOfPages = 4;//指定页面个数
        [pageControl setBackgroundColor:[UIColor clearColor]];
        [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        [self.keyboardView addSubview:pageControl];
        
        self.footView =[[UIView alloc] initWithFrame:CGRectMake(0, pageControl.frame.origin.y+pageControl.frame.size.height, kMainScreenWidth, 40)];
        self.footView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        UIImageView *headimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
        headimage.backgroundColor =[UIColor colorWithHexString:@"#a0a0a0"];
        UIButton *finishbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        finishbtn.frame =CGRectMake(kMainScreenWidth-60, 0, 60, 40);
        [finishbtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishbtn setTitle:@"完成" forState:UIControlStateHighlighted];
        [finishbtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:UIControlStateNormal];
        [finishbtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:UIControlStateHighlighted];
        [finishbtn addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.footView addSubview:finishbtn];
        [self.footView addSubview:headimage];
        [self.keyboardView addSubview:self.footView];
        [self.view bringSubviewToFront:self.keyboardView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.commentY =kMainScreenHeight-64-42-self.keyboardView.frame.size.height;
        self.keyboardView.frame =CGRectMake(0, kMainScreenHeight-205-64 , kMainScreenWidth, 205);
        CGSize labelsize1 = [util calHeightForLabel:self.commenttxf.text width:kMainScreenWidth-70 font:[UIFont systemFontOfSize:14]];
        if (labelsize1.height-14>32) {
            self.commentview.frame =CGRectMake(0, self.commentY-labelsize1.height+14, kMainScreenWidth, 42+labelsize1.height-32);
            self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, labelsize1.height);
        }else{
            //            commentViewY =self.commentview.frame.origin.y;
            self.commentview.frame =CGRectMake(0, self.commentY, kMainScreenWidth, 42);
            self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, 32);
        }
//        self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42-self.keyboardView.frame.size.height, kMainScreenWidth, 42);
        
        self.table.frame =CGRectMake(0, -self.keyboardView.frame.size.height, self.table.frame.size.width, self.table.frame.size.height);
        [UIView commitAnimations];
//        self.commenttxf.inputView =keyboardView;
    }
    
//    [self.commenttxf becomeFirstResponder];
    
}
-(void)keyboardHide:(NSNotification *)notification{
    if ([self.commenttxf isFirstResponder]) {
        [self.commenttxf resignFirstResponder];
    }
    if (self.expressionimage.selected==YES) {
        self.expressionimage.selected =NO;
    }
    self.placeholder.text =@"请输入评论内容";
    if (self.tapView) {
        [self.tapView removeFromSuperview];
        self.tapView =nil;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.commentY =kMainScreenHeight-64-42;
    self.keyboardView.frame =CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 205);
    CGSize labelsize1 = [util calHeightForLabel:self.commenttxf.text width:kMainScreenWidth-70 font:[UIFont systemFontOfSize:14]];
    if (labelsize1.height-14>32) {
        self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42-labelsize1.height+14, kMainScreenWidth, 42+labelsize1.height-32);
        self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, labelsize1.height);
    }else{
        //            commentViewY =self.commentview.frame.origin.y;
        self.commentview.frame =CGRectMake(0, self.commentY, kMainScreenWidth, 42);
        self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, 32);
    }
//    self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42, kMainScreenWidth, 42);
    
    self.table.frame =CGRectMake(0, 0, self.table.frame.size.width, self.table.frame.size.height);
    [UIView commitAnimations];
}
-(void)keyboardShow:(NSNotification *)notification{
    if (self.tapView ==nil) {
        self.tapView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, self.table.frame.size.height)];
        self.tapView.backgroundColor =[UIColor clearColor];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [self.tapView addGestureRecognizer:tap];
        [self.view addSubview:self.tapView];
        [self.view bringSubviewToFront:self.commentview];
    }
}
-(void)hideAction:(id)sender{
    if ([self.commenttxf isFirstResponder]) {
        [self.commenttxf resignFirstResponder];
    }
    if (self.expressionimage.selected==YES) {
        self.expressionimage.selected =NO;
    }
    self.placeholder.text =@"请输入评论内容";
    [self.tapView removeFromSuperview];
    self.tapView =nil;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.commentY =kMainScreenHeight-64-42;
    self.keyboardView.frame =CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 205);
    CGSize labelsize1 = [util calHeightForLabel:self.commenttxf.text width:kMainScreenWidth-70 font:[UIFont systemFontOfSize:14]];
    if (labelsize1.height-14>32) {
        self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42-labelsize1.height+14, kMainScreenWidth, 42+labelsize1.height-32);
        self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, labelsize1.height);
    }else{
        //            commentViewY =self.commentview.frame.origin.y;
        self.commentview.frame =CGRectMake(0, self.commentY, kMainScreenWidth, 42);
        self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, 32);
    }
//    self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42, kMainScreenWidth, 42);
    
    self.table.frame =CGRectMake(0, 0, self.table.frame.size.width, self.table.frame.size.height);
    [UIView commitAnimations];
}

-(void)finishAction:(id)sender{
    [self.tapView removeFromSuperview];
    self.tapView =nil;
    self.expressionimage.selected =NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.commentY =kMainScreenHeight-64-42;
    self.keyboardView.frame =CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 205);
    CGSize labelsize1 = [util calHeightForLabel:self.commenttxf.text width:kMainScreenWidth-70 font:[UIFont systemFontOfSize:14]];
    if (labelsize1.height-14>32) {
        self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42-labelsize1.height+14, kMainScreenWidth, 42+labelsize1.height-32);
        self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, labelsize1.height);
    }else{
        //            commentViewY =self.commentview.frame.origin.y;
        self.commentview.frame =CGRectMake(0, self.commentY, kMainScreenWidth, 42);
        self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, 32);
    }
//    self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42, kMainScreenWidth, 42);
    
    self.table.frame =CGRectMake(0, 0, self.table.frame.size.width, self.table.frame.size.height);
    [UIView commitAnimations];
    if (self.isreplay ==NO) {
        [self commentDiary];
    }else{
        [self replayComment];
    }
    self.iscomment =NO;
    self.isreplay =NO;
    self.placeholder.text =@"请输入评论内容";
}
-(void)keyboardChangeAction:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    if (self.isshow ==YES) {
        [UIView beginAnimations:@"commentmove" context:NULL];
        [UIView setAnimationDuration:0.25];
        self.commentY =kMainScreenHeight-64-42-keyboardRect.size.height;
        CGSize labelsize1 = [util calHeightForLabel:self.commenttxf.text width:kMainScreenWidth-70 font:[UIFont systemFontOfSize:14]];
        if (labelsize1.height-14>32) {
            self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42-labelsize1.height+14-keyboardRect.size.height, kMainScreenWidth, 42+labelsize1.height-32);
            self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, labelsize1.height);
        }else{
            //            commentViewY =self.commentview.frame.origin.y;
            self.commentview.frame =CGRectMake(0, self.commentY, kMainScreenWidth, 42);
            self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, 32);
        }
//        self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42-keyboardRect.size.height, kMainScreenWidth, 42);
        
        self.table.frame =CGRectMake(0, -keyboardRect.size.height, self.table.frame.size.width, self.table.frame.size.height);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:@"commentmove" context:NULL];
        [UIView setAnimationDuration:0.25];
        self.table.frame =CGRectMake(0, 0, self.table.frame.size.width, self.table.frame.size.height);
        [UIView commitAnimations];
    }
    
    NSLog(@"%@",notification);
}
- (void)PressBarItemLeft {
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
- (void)PressBarItemRight:(UIButton *)sender{
    SharePcitureView *shareView=[[SharePcitureView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 100)];
    shareView.delegate=self;
    shareView.isdiary =YES;
    [UIView animateWithDuration:.25 animations:^{
        shareView.frame=CGRectMake(0, kMainScreenHeight-100, kMainScreenWidth, 100);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
    [shareView show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)moveComment{
    int count =0;
    count =self.commentHeight/kMainScreenHeight;
    CGFloat height =0;
    //    NSLog(@"%f",kMainScreenHeight);
    height =self.commentHeight-(kMainScreenHeight-(self.commentHeight-count*kMainScreenHeight));
    self.table.contentOffset =CGPointMake(0, self.table.contentSize.height-kMainScreenHeight+42);
    [self.commenttxf becomeFirstResponder];
}
-(void)replayComment{
    if (self.commenttxf.text.length >300||self.commenttxf.text.length <1) {
        [TLToast showWithText:@"评论内容长度为1～300字"];
        return;
    }
    DiaryCommentObject *commentObject =[self.diaryCommentlist objectAtIndex:self.selectComment];
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
        [postDict setObject:@"ID0283" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        int toUserId =0;
        int toRoleId =0;
        NSString *toNickName =[NSString string];
        if (self.selectreply) {
            toUserId =self.selectreply.userId;
            toRoleId =self.selectreply.roleId;
            if (self.selectreply.nickName.length ==0) {
                toNickName =[NSString stringWithFormat:@"用户%d",self.selectreply.userId];
            }else{
                toNickName =self.selectreply.nickName;
            }
            
        }else{
            toUserId =commentObject.userId;
            toRoleId =commentObject.roleId;
            if (commentObject.nickName.length==0) {
                toNickName =[NSString stringWithFormat:@"用户%d",commentObject.userId];
            }else{
                toNickName =commentObject.nickName;
            }
            
        }
        if (self.commentId>0) {
            toUserId =(int)self.commentId;
            toNickName =self.tonickName;
            toRoleId =self.roleId;
        }
        NSString *nickName =[[NSUserDefaults standardUserDefaults] objectForKey:User_nickName];
        if (nickName.length==0) {
            nickName =[NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:User_ID]];
        }
        
        NSMutableString *sendString = [NSMutableString string];
        for(int i=0;i<self.commenttxf.text.length;i++){
            if(self.commenttxf.text.length>=2 && i<=self.commenttxf.text.length-2){
                if ([[Emoji allEmoji] containsObject:[self.commenttxf.text substringWithRange:NSMakeRange(i, 2)]]) {
                    [sendString appendString:[Emoji GetToEmojiUnicode:[self.commenttxf.text substringWithRange:NSMakeRange(i, 2)]]];
                    i+=1;
                }
                else{
                    [sendString appendString:[self.commenttxf.text substringWithRange:NSMakeRange(i, 1)]];
                }
            }
            else{
                [sendString appendString:[self.commenttxf.text substringWithRange:NSMakeRange(i, 1)]];
            }
        }
        
        NSDictionary *bodyDic = @{@"commentId":[NSNumber numberWithInt:commentObject.commentId],@"replyContext":sendString,@"roleId":[NSNumber numberWithInt:7],@"toUserId":[NSNumber numberWithInt:toUserId],@"toRoleId":[NSNumber numberWithInt:toRoleId],@"toNickName":toNickName,@"nickName":nickName,@"diaryId":[NSNumber numberWithInt:self.detail.diaryId]};
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
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 102831) {
                        [self stopRequest];
                        self.selectreply =nil;
                        self.commenttxf.text=@"";
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DiaryReplyCommentObject *diaryComment =[[DiaryReplyCommentObject alloc] init];
                            diaryComment.userId =[[[jsonDict objectForKey:@"diaryCommentReply"] objectForKey:@"userId"] intValue];
                            diaryComment.nickName =[[jsonDict objectForKey:@"diaryCommentReply"] objectForKey:@"nickName"];
                            diaryComment.roleId =[[[jsonDict objectForKey:@"diaryCommentReply"] objectForKey:@"roleId"] intValue];
                            diaryComment.replyContext =[[jsonDict objectForKey:@"diaryCommentReply"] objectForKey:@"replyContext"];
                            diaryComment.toUserId =[[[jsonDict objectForKey:@"diaryCommentReply"] objectForKey:@"toUserId"] intValue];
                            diaryComment.toNickName =[[jsonDict objectForKey:@"diaryCommentReply"] objectForKey:@"toNickName"];
                            diaryComment.ToRoleId =[[[jsonDict objectForKey:@"diaryCommentReply"] objectForKey:@"toRoleId"] intValue];
                            if (self.commentId>0) {
                                for (int i=0; i<[self.diaryCommentlist count]; i++) {
                                    DiaryCommentObject *comment =[self.diaryCommentlist objectAtIndex:i];
                                    if (comment.commentId ==(int)self.commentId) {
                                        [comment.replyComments addObject:diaryComment];
                                    }
                                }
                            }else{
                               [commentObject.replyComments addObject:diaryComment];
                            }
                            
                            
                            NSLog(@"hahahahahha");
                            self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42, kMainScreenWidth, 42);
                            self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, 32);
                            self.commenttxf.text =@"";
                            self.commentHeight =0;
                            [self.table reloadData];
                            
                            if (self.iscomment) {
                                [self performSelector:@selector(moveComment) withObject:nil afterDelay:0.5f];
//                                [self.commenttxf becomeFirstResponder];
                            }
                            self.placeholder.hidden =NO;
                        });
                    } else {
                        [self stopRequest];
                        self.selectreply =nil;
                        [TLToast showWithText:@"评论失败"];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"评价失败"];
                              });
                          }
                               method:url postDict:post];
    });
}
-(void)commentDiary{

    if (self.commenttxf.text.length >300||self.commenttxf.text.length <1) {
        [TLToast showWithText:@"评论内容长度为1～300字"];
        return;
    }
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
        [postDict setObject:@"ID0282" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSMutableString *sendString = [NSMutableString string];
        for(int i=0;i<self.commenttxf.text.length;i++){
            if(self.commenttxf.text.length>=2 && i<=self.commenttxf.text.length-2){
                if ([[Emoji allEmoji] containsObject:[self.commenttxf.text substringWithRange:NSMakeRange(i, 2)]]) {
                    [sendString appendString:[Emoji GetToEmojiUnicode:[self.commenttxf.text substringWithRange:NSMakeRange(i, 2)]]];
                    i+=1;
                }
                else{
                    [sendString appendString:[self.commenttxf.text substringWithRange:NSMakeRange(i, 1)]];
                }
            }
            else{
                [sendString appendString:[self.commenttxf.text substringWithRange:NSMakeRange(i, 1)]];
            }
        }
        NSDictionary *bodyDic = @{@"diaryId":[NSNumber numberWithInt:self.detail.diaryId],@"commentContext":sendString,@"roleId":[NSNumber numberWithInt:7],@"toUserId":[NSNumber numberWithInt:self.detail.userId],@"toRoleId":[NSNumber numberWithInt:self.detail.roleId]};
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
                    
                    if (kResCode == 102821) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            DCParserConfiguration *config = [DCParserConfiguration configuration];
                            DCKeyValueObjectMapping *parser1 = [DCKeyValueObjectMapping mapperForClass:[DiaryCommentObject class] andConfiguration:config];
                            DiaryCommentObject *diaryComment =[parser1 parseDictionary:[jsonDict objectForKey:@"diaryComment"]];
                            [self.diaryCommentlist addObject:diaryComment];

                            NSLog(@"hahahahahha");
                            self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42, kMainScreenWidth, 42);
                            self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, 32);
                            self.commenttxf.text =@"";
                            self.commentHeight =0;
                            self.placeholder.hidden =NO;
                            [self.table reloadData];
                            
                            if (self.iscomment) {
                                [self performSelector:@selector(moveComment) withObject:nil afterDelay:0.5f];
//                                [self.commenttxf becomeFirstResponder];
                            }
                        });
                    } else {
                        [self stopRequest];
                        [TLToast showWithText:@"评论失败"];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"评价失败"];
                              });
                          }
                               method:url postDict:post];
    });
}
-(void)requestDiaryDetail{
    self.diaryCommentlist =[NSMutableArray array];
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
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0281\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"diaryId\":\%ld,\"roleId\":\%ld}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)[self.diaryId integerValue],(long)self.type];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"日记详情返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==102811) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        DCParserConfiguration *config = [DCParserConfiguration configuration];
                        DCArrayMapping *arrayMapping = [DCArrayMapping mapperForClassElements:[NSString class] forAttribute:@"picPaths" onClass:[DiaryDetailObject class]];
                        [config addArrayMapper:arrayMapping];
                        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[DiaryDetailObject class] andConfiguration:config];
                        self.detail =[parser parseDictionary:[jsonDict objectForKey:@"decorDiary"]];
                        
                        DCParserConfiguration *config1 = [DCParserConfiguration configuration];
                        DCArrayMapping *arrayMapping1 = [DCArrayMapping mapperForClassElements:[DiaryReplyCommentObject class] forAttribute:@"replyComments" onClass:[DiaryCommentObject class]];
                        [config1 addArrayMapper:arrayMapping1];
                        DCKeyValueObjectMapping *parser1 = [DCKeyValueObjectMapping mapperForClass:[DiaryCommentObject class] andConfiguration:config];
                        for (NSDictionary *dic in [jsonDict objectForKey:@"diaryComments"]) {
                            DiaryCommentObject *diaryComment =[parser1 parseDictionary:dic];
                            [self.diaryCommentlist addObject:diaryComment];
                        }
                        self.shareUrl =[jsonDict objectForKey:@"shareUrl"];
                        NSLog(@"hahahahahha");
                        self.commenttxf.text =@"";
                        self.commentHeight =0;
                        [self.table reloadData];
                        
                        if (self.iscomment) {
                           [self performSelector:@selector(moveComment) withObject:nil afterDelay:0.5f];
                            if (self.commentId>0) {
                                self.isreplay =YES;
                            }
//                            [self.commenttxf becomeFirstResponder];
                        }
                    });
                }
                else if (code==102819) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"获取详情失败"];
//                        [self.mtableview tableViewDidFinishedLoading];
//                        if(![self.dataArray count]) {
//                            imageview_bg.hidden=NO;
//                            label_bg.hidden = NO;
//                        }
//                        [self.mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"获取详情失败"];
//                        [self.mtableview tableViewDidFinishedLoading];
//                        if(![self.dataArray count]) {
//                            imageview_bg.hidden=NO;
//                            label_bg.hidden = NO;
//                        }
//                        [self.mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"获取详情失败"];
//                                  [self.mtableview tableViewDidFinishedLoading];
//                                  if(![self.dataArray count]) {
//                                      imageview_bg.hidden=NO;
//                                      label_bg.hidden = NO;
//                                  }
//                                  [self.mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}
//#pragma mark -UITextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self.tapView removeFromSuperview];
//    self.tapView =nil;
//    [self.commenttxf resignFirstResponder];
//    if (self.isreplay ==NO) {
//        [self commentDiary];
//    }else{
//        [self replayComment];
//    }
//    self.iscomment =NO;
//    self.isreplay =NO;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42, kMainScreenWidth, 42);
//    [UIView commitAnimations];
//    self.placeholder.text =@"请输入评论内容";
//    return YES;
//}
#pragma mark -UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        NSString *const cellidentifier = [NSString stringWithFormat:@"tvcRemindItem%d",(int)indexPath.row];
        DiaryMessageCell *cell = (DiaryMessageCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (!cell) {
            cell = [[DiaryMessageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
        }
        cell.detail =self.detail;
        return [cell getCellHeight];
    }else if (indexPath.section ==1){
        if (self.detail.picPaths.count>0) {
            NSString *const cellidentifier = [NSString stringWithFormat:@"diaryphoto%d",(int)indexPath.row];
            DiaryPhotosCell *cell = (DiaryPhotosCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
            if (!cell) {
                cell = [[DiaryPhotosCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
            }
            cell.pics =self.detail.picPaths;
            return [cell getCellHeight];
        }else{
            NSString *const cellidentifier = [NSString stringWithFormat:@"diarycomment%d",(int)indexPath.row];
            DiaryCommentCell *cell = (DiaryCommentCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
            if (!cell) {
                cell = [[DiaryCommentCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
            }
            cell.commentobject =[self.diaryCommentlist objectAtIndex:indexPath.row];
            return [cell getCellHeight];
        }
    }else{
        NSString *const cellidentifier = [NSString stringWithFormat:@"diarycomment%d",(int)indexPath.row];
        DiaryCommentCell *cell = (DiaryCommentCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (!cell) {
            cell = [[DiaryCommentCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
        }
        cell.commentobject =[self.diaryCommentlist objectAtIndex:indexPath.row];
        return [cell getCellHeight];
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.detail==nil||self.diaryCommentlist==nil) {
        return 0;
    }
    int section=3;
    if (self.detail.picPaths.count==0) {
        section--;
    }
    if (self.diaryCommentlist.count==0) {
        section--;
    }
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.detail.picPaths.count>0) {
        if (self.diaryCommentlist.count>0) {
            if (section==1) {
                return 1;
            }
            if (section ==2) {
                return self.diaryCommentlist.count;
            }
        }else{
            if (section ==1) {
                return 1;
            }
        }
    }else{
        if (section==1) {
            return self.diaryCommentlist.count;
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        NSString *const cellidentifier = [NSString stringWithFormat:@"tvcRemindItem%d",(int)indexPath.row];
        DiaryMessageCell *cell = (DiaryMessageCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (!cell) {
            cell = [[DiaryMessageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
            cell.delegate =self;
            cell.detail =self.detail;
            self.commentHeight +=[cell getCellHeight];
        }else{
            cell.delegate =self;
//            cell.detail =self.detail;
            [cell getCellHeight];
        }
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section ==1){
        if (self.detail.picPaths.count>0) {
            NSString *const cellidentifier = [NSString stringWithFormat:@"diaryphoto%d",(int)indexPath.row];
            DiaryPhotosCell *cell = (DiaryPhotosCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
            if (!cell) {
                cell = [[DiaryPhotosCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
                cell.pics =self.detail.picPaths;
                cell.delegate =self;
                self.commentHeight +=[cell getCellHeight];
            }else{
                cell.pics =self.detail.picPaths;
                [cell getCellHeight];
            }
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            NSString *const cellidentifier = [NSString stringWithFormat:@"diaryComment%d",(int)indexPath.row];
            DiaryCommentCell *cell = (DiaryCommentCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
            if (!cell) {
                cell = [[DiaryCommentCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
            }
            cell.delegate =self;
            cell.commentobject =[self.diaryCommentlist objectAtIndex:indexPath.row];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            cell.row =indexPath.row;
            [cell getCellHeight];
            return cell;
        }
        
    }else{
        NSString *const cellidentifier = [NSString stringWithFormat:@"diaryComment%d",(int)indexPath.row];
        DiaryCommentCell *cell = (DiaryCommentCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (!cell) {
            cell = [[DiaryCommentCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
        }
        cell.delegate =self;
        cell.commentobject =[self.diaryCommentlist objectAtIndex:indexPath.row];
        cell.row =indexPath.row;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        [cell getCellHeight];
        return cell;
    }
}
#pragma mark -DiaryCommentCellDelegate
-(void)touchComment:(DiaryCommentObject *)object Row:(NSInteger)row{
    self.isreplay =YES;
    self.placeholder.text =[NSString stringWithFormat:@"回复%@",object.nickName];
    self.selectComment =row;
    [self.commenttxf becomeFirstResponder];
}
-(void)touchReplay:(DiaryReplyCommentObject *)object Row:(NSInteger)row{
    self.isreplay =YES;
    self.selectreply =[[DiaryReplyCommentObject alloc] init];
    self.selectreply =object;
    self.placeholder.text =[NSString stringWithFormat:@"回复%@",object.nickName];
    self.selectComment =row;
    [self.commenttxf becomeFirstResponder];
}
-(void)touchnickName:(DiaryReplyCommentObject *)object{
    IDIAI3AboutDiaryViewController *about =[[IDIAI3AboutDiaryViewController alloc] init];
    about.toRoleId =object.roleId;
    about.toUserId =object.userId ;
    NSString *style =[NSString string];
    if (object.roleId==1) {
        style =@"设计师";
    }else if (object.roleId==2){
        style =@"商家";
    }else if (object.roleId==4){
        style =@"工长";
    }else if (object.roleId==6){
        style =@"监理";
    }else if (object.roleId==7){
        style =@"业主";
    }
    NSString *nickName =[NSString string];
    if (object.nickName.length ==0) {
        nickName =[NSString stringWithFormat:@"用户%d",object.userId];
    }else{
        nickName =object.nickName;
    }
    about.ismyDiary =self.ismyDiary;
    about.title =[NSString stringWithFormat:@"%@[%@]",nickName,style];
    [self.navigationController pushViewController:about animated:YES];
}
-(void)touchtonickName:(DiaryReplyCommentObject *)object{
    IDIAI3AboutDiaryViewController *about =[[IDIAI3AboutDiaryViewController alloc] init];
    about.toRoleId =object.ToRoleId;
    about.toUserId =object.toUserId ;
    NSString *style =[NSString string];
    if (object.roleId==1) {
        style =@"设计师";
    }else if (object.roleId==2){
        style =@"商家";
    }else if (object.roleId==4){
        style =@"工长";
    }else if (object.roleId==6){
        style =@"监理";
    }else if (object.roleId==7){
        style =@"业主";
    }
    NSString *nickName =[NSString string];
    if (object.toNickName.length ==0) {
        nickName =[NSString stringWithFormat:@"用户%d",object.toUserId];
    }else{
        nickName =object.toNickName;
    }
    about.ismyDiary =self.ismyDiary;
    about.title =[NSString stringWithFormat:@"%@[%@]",nickName,style];
    [self.navigationController pushViewController:about animated:YES];
}
-(void)touchCommentHead:(DiaryCommentObject *)object{
    IDIAI3AboutDiaryViewController *about =[[IDIAI3AboutDiaryViewController alloc] init];
    about.toRoleId =object.roleId;
    about.toUserId =object.userId ;
    NSString *style =[NSString string];
    if (object.roleId==1) {
        style =@"设计师";
    }else if (object.roleId==2){
        style =@"商家";
    }else if (object.roleId==4){
        style =@"工长";
    }else if (object.roleId==6){
        style =@"监理";
    }else if (object.roleId==7){
        style =@"业主";
    }
    NSString *nickName =[NSString string];
    if (object.nickName.length ==0) {
        nickName =[NSString stringWithFormat:@"用户%d",object.userId];
    }else{
        nickName =object.nickName;
    }
    about.ismyDiary =self.ismyDiary;
    about.title =[NSString stringWithFormat:@"%@[%@]",nickName,style];
    [self.navigationController pushViewController:about animated:YES];
}
-(void)touchPhotos:(NSMutableArray *)photos index:(NSInteger)index view:(UIImageView *)imageView{
    NSMutableArray *photosArray = [NSMutableArray arrayWithCapacity:photos.count];
    for (int i = 0; i<photos.count; i++) {
        // 替换为中等尺寸图片
        NSString *pic =[photos objectAtIndex:i];
        NSString *url = pic;
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        [photosArray addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photosArray; // 设置所有的图片
    //    browser.describe =selectpic.phasePicDescription;
    [browser show];
    [self hideAction:nil];
    [self.commenttxf resignFirstResponder];
}
-(void)reloadCell{
    [self.table reloadData];
}
#pragma mark -DiaryMessageCellDelegate
-(void)touchMessageComment{
    [self moveComment];
}
-(void)touchHead:(DiaryDetailObject *)detail{
    IDIAI3AboutDiaryViewController *about =[[IDIAI3AboutDiaryViewController alloc] init];
    about.toRoleId =detail.roleId;
    about.toUserId =detail.userId ;
    NSString *style =[NSString string];
    if (detail.roleId==1) {
        style =@"设计师";
    }else if (detail.roleId==2){
        style =@"商家";
    }else if (detail.roleId==4){
        style =@"工长";
    }else if (detail.roleId==6){
        style =@"监理";
    }else if (detail.roleId==7){
        style =@"业主";
    }
    NSString *nickName =[NSString string];
    if (detail.nickName.length ==0) {
        nickName =[NSString stringWithFormat:@"用户%d",detail.userId];
    }else{
        nickName =detail.nickName;
    }
    about.ismyDiary =self.ismyDiary;
    about.title =[NSString stringWithFormat:@"%@[%@]",nickName,style];
    [self.navigationController pushViewController:about animated:YES];
}
-(void)touchPraise{
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
        [postDict setObject:@"ID0300" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"diaryId":[NSNumber numberWithInt:self.detail.diaryId],@"roleId":[NSNumber numberWithInt:7],@"toUserId":[NSNumber numberWithInt:self.detail.userId],@"toRoleId":[NSNumber numberWithInt:self.detail.roleId]};
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
                        self.detail.pointNumber++;
                        self.detail.isPoint =1;
                        self.commentHeight =0;
                        [self.table reloadData];
                        [TLToast showWithText:@"点赞成功"];
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
-(void)SharePicCustomclickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){
        if([WXApi isWXAppInstalled])
            [self sendTextContentToWX:1];
        else
            [TLToast showWithText:@"请先安装微信客户端" topOffset:220.0 duration:1.5];
    }
    else if (buttonIndex==1){
        if([WXApi isWXAppInstalled])
            [self sendTextContentToWX:2];
        else
            [TLToast showWithText:@"请先安装微信客户端" topOffset:220.0 duration:1.5];
    }
    else if (buttonIndex==2){
        if([WeiboSDK isWeiboAppInstalled])
            [self sendTextContentToWB];
        else
            [TLToast showWithText:@"请先安装新浪微博客户端" topOffset:220.0 duration:1.5];
    }
    else{
        if([QQApiInterface isQQInstalled])
            [self sendTextContentToQQorZone];
        else
            [TLToast showWithText:@"请先安装手机QQ客户端" topOffset:220.0 duration:1.5];
    }
}
#pragma mark -
#pragma mark - Weixin related
- (void)sendTextContentToWX:(NSInteger)type {
    //分享图片
    if(self.shareUrl==nil) self.shareUrl=@" ";
    WXMediaMessage *message = [WXMediaMessage message];
    if (self.detail.diaryType==1) {
        message.title =[NSString stringWithFormat:@"[屋托邦]%@",self.detail.diaryTitle];
        message.description =@"内容来源-屋托邦装修论坛";
    }else{
        NSString *contentstr =[NSString string];
        if (self.detail.diaryContext.length>20) {
            contentstr =[self.detail.diaryContext substringToIndex:20];
        }else{
            contentstr =self.detail.diaryContext;
        }
        message.title =[NSString stringWithFormat:@"[屋托邦]%@",contentstr];
        message.description =@"内容来源-屋托邦装修问答";
    }
    
    if (self.detail.picPaths.count>0) {
        message.thumbData = UIImageJPEGRepresentation([self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.detail.picPaths objectAtIndex:0]]]]scaleToSize:CGSizeMake(100, 100)],0.06);
    }else{
        message.thumbData =UIImageJPEGRepresentation([self OriginImage:[UIImage imageNamed:@"bg_morentu_naobu"]scaleToSize:CGSizeMake(100, 100)],0.06);
    }
    
    
    //    WXImageObject *obj=[WXImageObject object];
    //    obj.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url_pic]];
    //    message.mediaObject=obj;
    
    WXWebpageObject *obj=[WXWebpageObject object];
    obj.webpageUrl=self.shareUrl;
    message.mediaObject=obj;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if(type==1) req.scene = WXSceneSession;
    else req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

#pragma mark -
#pragma mark - QQorZone related
-(void)sendTextContentToQQorZone{
    //分享图片
    if(self.shareUrl==nil) self.shareUrl=@" ";
    NSString *title =[NSString string];
    NSString *description =[NSString string];
    if (self.detail.diaryType==1) {
        title =[NSString stringWithFormat:@"[屋托邦]%@",self.detail.diaryTitle];
        description =@"内容来源-屋托邦装修论坛";
    }else{
        NSString *contentstr =[NSString string];
        if (self.detail.diaryContext.length>20) {
            contentstr =[self.detail.diaryContext substringToIndex:20];
        }else{
            contentstr =self.detail.diaryContext;
        }
        title =[NSString stringWithFormat:@"[屋托邦]%@",contentstr];
        description =@"内容来源-屋托邦装修问答";
    }
    QQApiNewsObject *txtObj;
    if (self.detail.picPaths.count>0) {
        txtObj =[QQApiNewsObject objectWithURL:[NSURL URLWithString:self.shareUrl] title:title description:description previewImageURL:[NSURL URLWithString:[self.detail.picPaths objectAtIndex:0]]];
    }else{
        txtObj =[QQApiNewsObject objectWithURL:[NSURL URLWithString:self.shareUrl] title:title description:description previewImageURL:nil];
    }
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    
    [QQApiInterface SendReqToQZone:req];
}

#pragma mark -
#pragma mark - Sinawb related
- (void)sendTextContentToWB {
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = @{@"picture": @"share",};
    //request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
    
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"屋托邦帖子";
    
    //    WBImageObject *image = [WBImageObject object];
    //    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj_effect.imagePath]];
    //    message.imageObject = image;
    
    //分享图片
    NSString *title =[NSString string];
    NSString *description =[NSString string];
    if (self.detail.diaryType==1) {
        title =[NSString stringWithFormat:@"[屋托邦]%@",self.detail.diaryTitle];
        description =@"内容来源-屋托邦装修论坛";
    }else{
        NSString *contentstr =[NSString string];
        if (self.detail.diaryContext.length>20) {
            contentstr =[self.detail.diaryContext substringToIndex:20];
        }else{
            contentstr =self.detail.diaryContext;
        }
        title =[NSString stringWithFormat:@"[屋托邦]%@",contentstr];
        description =@"内容来源-屋托邦装修问答";
    }
    if(self.shareUrl==nil) self.shareUrl=@" ";
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = [NSString stringWithFormat:@"%@",@"11111"];
    webpage.title = title;
    webpage.description = description;
    if (self.detail.picPaths.count>0) {
        webpage.thumbnailData = UIImageJPEGRepresentation([self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.detail.picPaths objectAtIndex:0]]]]scaleToSize:CGSizeMake(100, 100)],0.06);
    }else{
        webpage.thumbnailData =UIImageJPEGRepresentation([self OriginImage:[UIImage imageNamed:@"bg_morentu_naobu"]scaleToSize:CGSizeMake(100, 100)],0.06);
    }
    webpage.webpageUrl =self.shareUrl;
    message.mediaObject = webpage;
    
    return message;
}
#pragma mark - facialViewDelegate
-(void)selectedFacialView:(NSString *)str{
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (self.commenttxf.text.length>0) {
            if(self.commenttxf.text.length>=2){
                if ([[Emoji allEmoji] containsObject:[self.commenttxf.text substringFromIndex:self.commenttxf.text.length-2]]) {
                    NSLog(@"删除emoji %@",[self.commenttxf.text substringFromIndex:self.commenttxf.text.length-2]);
                    newStr=[self.commenttxf.text substringToIndex:self.commenttxf.text.length-2];
                }else{
                    NSLog(@"删除文字%@",[self.commenttxf.text substringFromIndex:self.commenttxf.text.length-1]);
                    newStr=[self.commenttxf.text substringToIndex:self.commenttxf.text.length-1];
                }
            }
            else{
                NSLog(@"删除文字%@",[self.commenttxf.text substringFromIndex:self.commenttxf.text.length-1]);
                newStr=[self.commenttxf.text substringToIndex:self.commenttxf.text.length-1];
            }
            self.commenttxf.text=newStr;
            if (self.commenttxf.text.length>0) {
                self.placeholder.hidden =YES;
            }else{
                self.placeholder.hidden =NO;
            }
        }
    }
    else{
        NSMutableString *content = [[NSMutableString alloc] initWithString:self.commenttxf.text];
        if(self.cursorPosition>content.length) self.cursorPosition=content.length;
        [content insertString:str atIndex:self.cursorPosition];
        self.commenttxf.text = content;
        if (self.commenttxf.text.length>0) {
            self.placeholder.hidden =YES;
        }else{
            self.placeholder.hidden =NO;
        }
        self.cursorPosition+=2;
    }
//    NSString *newStr;
//    if ([str isEqualToString:@"删除"]) {
//        if (self.commenttxf.text.length>0) {
//            if(self.commenttxf.text.length>=2){
//                if ([[Emoji allEmoji] containsObject:[self.commenttxf.text substringFromIndex:self.commenttxf.text.length-2]]) {
//                    NSLog(@"删除emoji %@",[self.commenttxf.text substringFromIndex:self.commenttxf.text.length-2]);
//                    newStr=[self.commenttxf.text substringToIndex:self.commenttxf.text.length-2];
//                }else{
//                    NSLog(@"删除文字%@",[self.commenttxf.text substringFromIndex:self.commenttxf.text.length-1]);
//                    newStr=[self.commenttxf.text substringToIndex:self.commenttxf.text.length-1];
//                }
//            }
//            else{
//                NSLog(@"删除文字%@",[self.commenttxf.text substringFromIndex:self.commenttxf.text.length-1]);
//                newStr=[self.commenttxf.text substringToIndex:self.commenttxf.text.length-1];
//            }
//            self.commenttxf.text=newStr;
//        }
//    }
//    else{
//        NSMutableString *content = [[NSMutableString alloc] initWithString:self.commenttxf.text];
//        if(self.cursorPosition>content.length) self.cursorPosition=content.length;
//        [content insertString:str atIndex:self.cursorPosition];
//        self.commenttxf.text = content;
//        self.cursorPosition+=2;
//    }
}

- (void)changePage:(id) sender {
    NSInteger page = pageControl.currentPage;//获取当前pagecontroll的值
    [scrollView_emoji setContentOffset:CGPointMake(kMainScreenWidth * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (self.commenttxf ==textField) {
//        self.isshow =YES;
//    }
//    self.expressionimage.selected =NO;
//    return YES;
//}
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    if (self.commenttxf ==textField) {
//        self.isshow =NO;
//    }
//    NSRange cursorPosition = [textField selectedRange];
//    NSInteger index = cursorPosition.location;
//    self.cursorPosition=index;
//    return YES;
//}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y>2*kMainScreenHeight) {
        self.backtop.hidden =NO;
    }else{
        self.backtop.hidden =YES;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView==scrollView_emoji) {
        int page = scrollView.contentOffset.x / kMainScreenWidth;//通过滚动的偏移量来判断目前页面所对应的小白点
        pageControl.currentPage = page;//pagecontroll响应值的变化
        return;
    }
}
#pragma mark -UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    self.expressionbtn.selected =NO;
    if (self.commenttxf ==textView) {
        self.isshow =YES;
    }
    
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]) {
        
            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
            login.delegate=self;
            [login show];
        [self.commenttxf resignFirstResponder];
        [login.textf_mobile becomeFirstResponder];

    }
    self.expressionimage.selected =NO;
    return YES;
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
//    [self.view addSubview:self.hiddenView];
//    [self.view bringSubviewToFront:self.topView];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.commenttxf ==textView) {
        self.isshow =NO;
    }
    NSRange cursorPosition = [textView selectedRange];
    NSInteger index = cursorPosition.location;
    self.cursorPosition=index;
    return YES;
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    //    self.contenttxt.text =  textView.text;
    if (textView.text.length == 0) {
        self.placeholder.hidden =NO;
    }else{
        CGSize labelsize1 = [util calHeightForLabel:textView.text width:kMainScreenWidth-70 font:[UIFont systemFontOfSize:14]];
        if (labelsize1.height-14>32) {
            self.commentview.frame =CGRectMake(0, self.commentY-labelsize1.height+14, kMainScreenWidth, 42+labelsize1.height-32);
            self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, labelsize1.height);
        }else{
//            commentViewY =self.commentview.frame.origin.y;
            self.commentview.frame =CGRectMake(0, self.commentY, kMainScreenWidth, 42);
            self.commenttxf.frame =CGRectMake(15, 5, kMainScreenWidth-70, 32);
        }

        self.placeholder.hidden =YES;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [self.tapView removeFromSuperview];
        self.tapView =nil;
        [self.commenttxf resignFirstResponder];
        if (self.isreplay ==NO) {
            [self commentDiary];
        }else{
            [self replayComment];
        }
        self.iscomment =NO;
        self.isreplay =NO;
        self.commentY =kMainScreenHeight-64-42;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.commentview.frame =CGRectMake(0, kMainScreenHeight-64-42, kMainScreenWidth, 42);
        [UIView commitAnimations];
        self.placeholder.text =@"请输入评论内容";
        return YES;
    }
    
    return YES;
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
