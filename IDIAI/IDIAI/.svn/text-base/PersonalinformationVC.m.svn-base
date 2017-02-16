//
//  PersonalinformationVC.m
//  IDIAI
//
//  Created by iMac on 14-7-3.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PersonalinformationVC.h"
#import "Persionalcell.h"
#import "HexColor.h"
#import "MessageListVC.h"
#import "PersonaldataVC.h"
#import "RetroactionVC.h"
#import "MyhouseTypeVC.h"
#import "MybudgetVC.h"
#import "MycollectVC.h"
#import "IDIAIAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@interface PersonalinformationVC ()<ASIHTTPRequestDelegate>
{
    UIButton *photoButton;
}
@end

@implementation PersonalinformationVC
@synthesize lab_address,lab_name,photo;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"resgister_succeed" object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registersucceed:) name:@"resgister_succeed" object:nil];
    }
    return self;
}

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:YES];
    
    UIImageView *nav_bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"导航条.png"]];
    nav_bg.frame=CGRectMake(0, 20, 320, 44);
    nav_bg.userInteractionEnabled=YES;
    [self.view addSubview:nav_bg];
    
    CGRect frame = CGRectMake(100, 29, 120, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"6d2907" alpha:1.0];
    label.text = @"个人信息";
    [self.view addSubview:label];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(10, 25, 50, 28)];
    rightButton.tag=1;
    [rightButton setBackgroundImage:[UIImage imageNamed:@"返回键.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(backTouched:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
}

-(void)viewWillAppear:(BOOL)animated{
    [[[self navigationController] navigationBar] setHidden:YES];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]isEqual:[NSNull null]]||[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]]isEqualToString:@"(null)"])
        lab_name.text=@"";
    else
        lab_name.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]isEqual:[NSNull null]]||[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]]isEqualToString:@"(null)"])
        lab_address.text=@"";
    else
        lab_address.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]];
    
    
    if([self ReadPhoto])
        [photoButton setImage:[self circleImage:[self ReadPhoto] withParam:1.0] forState:UIControlStateNormal];
    else
        [photoButton setImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
    
    [mtableview reloadData];
}

-(void)backTouched:(UIButton *)btn{
    if(btn.tag==1){
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag==2) {
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]){
            PersonaldataVC *personal=[[PersonaldataVC alloc]init];
            [self.navigationController pushViewController:personal animated:YES];
        }
        else{
//            LoginVC *loginvc=[[LoginVC alloc] init];
//            loginvc.delegate=self;
//            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:loginvc];
//            [self presentViewController:nav animated:YES completion:nil];
            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
            login.delegate=self;
            [login show];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(IS_iOS7_8)
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
    [self customizeNavigationBar];
    
    mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mtableview];
    
    [self createTableviewheader];
    
}

-(void)createTableviewheader{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    view.backgroundColor=[UIColor clearColor];
    mtableview.tableHeaderView=view;
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 147, 320, 3)];
    line.image=[UIImage imageNamed:@"粗分割线.png"];
    [view addSubview:line];
    
    photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setFrame:CGRectMake(120, 10,80, 80)];
    photoButton.tag=2;
    if([self ReadPhoto])
        [photoButton setImage:[self circleImage:[self ReadPhoto] withParam:1.0] forState:UIControlStateNormal];
    else
        [photoButton setImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(backTouched:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:photoButton];
    
    lab_name = [[UILabel alloc] initWithFrame: CGRectMake(50, 90, 220, 30)];
    lab_name.backgroundColor = [UIColor clearColor];
    lab_name.font = [UIFont systemFontOfSize:20.0];
    lab_name.textAlignment = NSTextAlignmentCenter;
    lab_name.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]isEqual:[NSNull null]]|[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]]isEqualToString:@"(null)"])
    lab_name.text=@"";
    else
    lab_name.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]];
    [view addSubview:lab_name];
   
    lab_address = [[UILabel alloc] initWithFrame: CGRectMake(30, 120, 260, 20)];
    lab_address.backgroundColor = [UIColor clearColor];
    lab_address.font = [UIFont systemFontOfSize:13.0];
    lab_address.textAlignment = NSTextAlignmentCenter;
    lab_address.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]isEqual:[NSNull null]]|[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]]isEqualToString:@"(null)"])
        lab_address.text=@"";
    else
        lab_address.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]];
    [view addSubview:lab_address];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid";
    Persionalcell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"Persionalcell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
     if([[[NSUserDefaults standardUserDefaults]objectForKey:Is_NewMessage]isEqualToString:@"yes"]&&indexPath.row==0){
         UIImageView *image_message=[[UIImageView alloc]initWithFrame:CGRectMake(130, 23, 10, 10)];
         image_message.image=[UIImage imageNamed:@"消息提醒图标.png"];
         [cell addSubview:image_message];
     }
    
    NSArray *array_icon=[NSArray arrayWithObjects:@"消息.png",@"户型.png",@"预算.png",@"收藏夹.png",@"反馈.png", nil];
     NSArray *array_title=[NSArray arrayWithObjects:@"消息",@"我的房型",@"装修预算",@"收藏夹",@"反馈", nil];
    cell.icon_image.image=[UIImage imageNamed:[array_icon objectAtIndex:indexPath.row]];
    cell.title_lab.text=[array_title objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:Is_NewMessage];
        [[NSUserDefaults standardUserDefaults]synchronize];
        MessageListVC *mess=[[MessageListVC alloc]init];
        [self.navigationController pushViewController:mess animated:YES];
    }
    if (indexPath.row==1) {
        MyhouseTypeVC *myhousevc=[[MyhouseTypeVC alloc]init];
       [self.navigationController pushViewController:myhousevc animated:YES];
    }
    if (indexPath.row==2) {
        MybudgetVC *budgetvc=[[MybudgetVC alloc]init];
        [self.navigationController pushViewController:budgetvc animated:YES];
    }
    if (indexPath.row==3) {
//        //删除缓存
//        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate*)[[UIApplication sharedApplication] delegate];
//        [appDelegate.myCache clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
//        [ASIHTTPRequest clearSession];   //将会删除任何使用ASICacheForSessionDurationCacheStoragePolicy策略的缓存数据
        
        MycollectVC *collectvc=[[MycollectVC alloc]init];
        [self.navigationController pushViewController:collectvc animated:YES];
    }
    if (indexPath.row==4) {
        RetroactionVC *revc=[[RetroactionVC alloc]initWithNibName:@"RetroactionVC" bundle:nil];
        [self.navigationController pushViewController:revc animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]isEqual:[NSNull null]]||[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]]isEqualToString:@"(null)"])
//            lab_name.text=@"";
//        else
//            lab_name.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]];
//        
//        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]isEqual:[NSNull null]]||[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]]isEqualToString:@"(null)"])
//            lab_address.text=@"";
//        else
//            lab_address.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]];
//        
//        if([self ReadPhoto])
//            [photoButton setImage:[self circleImage:[self ReadPhoto] withParam:1.0] forState:UIControlStateNormal];
//        else
//            [photoButton setImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
//    }];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    [self dismissViewControllerAnimated:YES completion:^{
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]isEqual:[NSNull null]]||[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]]isEqualToString:@"(null)"])
            lab_name.text=@"";
        else
            lab_name.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]];
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]isEqual:[NSNull null]]||[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]]isEqualToString:@"(null)"])
            lab_address.text=@"";
        else
            lab_address.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]];
        
        if([self ReadPhoto])
            [photoButton setImage:[self circleImage:[self ReadPhoto] withParam:1.0] forState:UIControlStateNormal];
        else
            [photoButton setImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
    }];
}

-(void)cancel{
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)registersucceed:(NSNotification *)notif{
    [self login];
}

//裁剪为圆形图片
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

//登录
-(void)login{
    NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:@"ID0011" forKey:@"cmdID"];
    [postDict setObject:@"" forKey:@"token"];
    [postDict setObject:@"" forKey:@"userID"];
    [postDict setObject:@"iOS" forKey:@"deviceType"];
    NSString *string=[postDict JSONString];
    
    NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
    [postDict02 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Name] forKey:@"loginName"];
    [postDict02 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Password] forKey:@"password"];
    NSString *string02=[postDict02 JSONString];
    
    NSURL* url_string = [NSURL URLWithString:url];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url_string];
    request.delegate = self;
    [request setPostValue:string forKey:@"header"];
    [request setPostValue:string02 forKey:@"body"];
    [request startAsynchronous];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
//    LoginVC *loginvc=[[LoginVC alloc] init];
//    loginvc.delegate=self;
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:loginvc];
//    [self presentViewController:nav animated:YES completion:nil];
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    [login show];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [request setResponseEncoding:NSUTF8StringEncoding];
    NSString *respString = [request responseString];
    NSDictionary *jsonDict = [respString objectFromJSONString];
    
    if ([[jsonDict objectForKey:@"resCode"] integerValue]==10121) {
        
        [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Token] forKey:User_Token];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[jsonDict objectForKey:User_ID]] forKey:User_ID];
        if(![[jsonDict objectForKey:User_nickName] isEqual:[NSNull null]])
            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_nickName] forKey:User_nickName];
        if(![[jsonDict objectForKey:User_Mobile] isEqual:[NSNull null]])
            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Mobile] forKey:User_Mobile];
        if(![[jsonDict objectForKey:User_sex] isEqual:[NSNull null]]){
            if([[jsonDict objectForKey:User_sex] integerValue]==1)
                [[NSUserDefaults standardUserDefaults]setObject:@"男" forKey:User_sex];
            else
                [[NSUserDefaults standardUserDefaults]setObject:@"女" forKey:User_sex];
        }
        if([[jsonDict objectForKey:User_logo]length]>10){
            UIImage *image=[UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[[jsonDict objectForKey:User_logo] stringByReplacingOccurrencesOfString:@"\n" withString:@""]  options:NSDataBase64DecodingIgnoreUnknownCharacters]];
            NSData *photo_data = UIImageJPEGRepresentation(image, 0.5);
            NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
            [photo_data writeToFile:aPath atomically:YES];
        }
        if(![[jsonDict objectForKey:User_Addrss] isEqual:[NSNull null]])
            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Addrss] forKey:User_Addrss];
        [[NSUserDefaults standardUserDefaults] synchronize];
       
    }
    else {
//       LoginVC *loginvc=[[LoginVC alloc] init];
//        loginvc.delegate=self;
//        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:loginvc];
//        [self presentViewController:nav animated:YES completion:nil];
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
    

    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]isEqual:[NSNull null]]||[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]]isEqualToString:@"(null)"])
        lab_name.text=@"";
    else
        lab_name.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]isEqual:[NSNull null]]||[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]]isEqualToString:@"(null)"])
        lab_address.text=@"";
    else
        lab_address.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]];
    
    if([self ReadPhoto])
        [photoButton setImage:[self circleImage:[self ReadPhoto] withParam:1.0] forState:UIControlStateNormal];
    else
        [photoButton setImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
}

//手机读取头像
-(UIImage *)ReadPhoto{
    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
    return imgFromUrl3;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
