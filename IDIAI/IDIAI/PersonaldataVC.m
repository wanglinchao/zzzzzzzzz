//
//  PersonaldataVC.m
//  IDIAI
//
//  Created by iMac on 14-7-14.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PersonaldataVC.h"
#import "HexColor.h"
#import "PersonalDatacell.h"
#import "UIAlertviewCustom.h"
#import "WritePersonalDataVC.h"
#import "CameraAndPhotosView.h"
#import "TLToast.h"
#import "ASIFormDataRequest.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "PersonalInfoObj.h"
#import "savelogObj.h"
#import "TextUILable.h"
#import "UIImage+fixOrientation.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f

@interface PersonaldataVC ()<UIAlertviewCustomDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate,VPImageCropperDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIImage *image;

@end

@implementation PersonaldataVC
@synthesize lab_address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    label.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    label.text = @"个人信息";
    [self.view addSubview:label];

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(10, 25, 50, 28)];
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
    [mtableview reloadData];
}
-(void)backTouched:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"用户查看了个人信息" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:6];
    
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
    [self createTableviewfooter];
    
    self.dataArray_first=[[NSMutableArray alloc]initWithObjects:@"昵称",@"性别",@"手机号",@"地址", nil];
    self.dataArray_second=[[NSMutableArray alloc]initWithObjects:@"填写你的昵称",@"选择你的性别",@"填写手机号码",@"填写地址", nil];
    self.Array_personal=[[NSMutableArray alloc]initWithCapacity:0];
    
}

-(void)createTableviewheader{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    view.backgroundColor=[UIColor clearColor];
    mtableview.tableHeaderView=view;
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 147, 320, 3)];
    line.image=[UIImage imageNamed:@"粗分割线.png"];
    [view addSubview:line];
    
    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.photoButton  setFrame:CGRectMake(120, 10,80, 80)];
    self.photoButton .tag=2;
    if([self ReadPhoto]){
        
        [self.photoButton  setImage:[self circleImage:[self ReadPhoto] withParam:1.0] forState:UIControlStateNormal];
    }
    else
        [self.photoButton  setImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
    [self.photoButton  addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.photoButton ];
    
    lab_address = [[UILabel alloc] initWithFrame: CGRectMake(110, 100, 100, 20)];
    lab_address.backgroundColor = [UIColor clearColor];
    lab_address.font = [UIFont systemFontOfSize:14.0];
    lab_address.textAlignment = NSTextAlignmentCenter;
    lab_address.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    lab_address.text=@"点击更换头像";
    [view addSubview:lab_address];
    
}

-(void)createTableviewfooter{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    view.backgroundColor=[UIColor clearColor];
    mtableview.tableFooterView=view;
    
    UIButton *Exit_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [Exit_Button setFrame:CGRectMake(20, 50,280, 60)];
    Exit_Button.tag=3;
    [Exit_Button setTitle:@"注销账号" forState:UIControlStateNormal];
    [Exit_Button setTitleColor:[UIColor colorWithHexString:@"#6d2907" alpha:1.0] forState:UIControlStateNormal];
    [Exit_Button setBackgroundImage:[UIImage imageNamed:@"下一步及登录按钮.png"] forState:UIControlStateNormal];
    [Exit_Button setBackgroundImage:[UIImage imageNamed:@"下一步及登录按钮点击效果.png"] forState:UIControlStateHighlighted];
    [Exit_Button addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:Exit_Button];
    
}

-(void)pressbtn:(UIButton *)btn{
    if (btn.tag==2) {
        CameraAndPhotosView *cam=[[CameraAndPhotosView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, 320, 170) title:nil];
        cam.delegate=self;
        [UIView animateWithDuration:.25 animations:^{
            cam.frame=CGRectMake(0, kMainScreenHeight-170, 320, 170);
        } completion:^(BOOL finished) {
            if (finished) {
              
            }
        }];
        [cam show];
        
    }
    else if(btn.tag==3){
        UIAlertviewCustom *al=[[UIAlertviewCustom alloc]initWithFrame:CGRectMake(30, 200, 260, 200) title:@"温馨提示" contentText:@"是否确认退出" leftButtonTitle:@"取消" rightButtonTitle:@"确认" display:1 dismiss:1];
        al.delegate=self;
        [al show];
    }
}

-(void)alertviewCustom:(UIView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
    }
    if (buttonIndex==2) {
        NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
        [[NSFileManager defaultManager] removeItemAtPath:aPath3 error:nil];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Name];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Password];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Token];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_ID];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Addrss];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Mobile];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_sex];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_nickName];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)CameraAndPhotoCustom:(UIView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self LocalPhoto];
    }
    if (buttonIndex==2) {
        [self takePhoto];
    }
    
}

#pragma mark -
#pragma mark -UITableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row!=3)
    return 60.0;
    else
    return 90;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row!=3){
    static NSString *cellid=@"mycellid";
    PersonalDatacell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PersonalDatacell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.Lab_first.text=[self.dataArray_first objectAtIndex:indexPath.row];
    
    if(indexPath.row==0){
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName] length]>=1)
        cell.Lab_second.text=[[NSUserDefaults standardUserDefaults]objectForKey:User_nickName];
    else
        cell.Lab_second.text=[self.dataArray_second objectAtIndex:indexPath.row];
    }
    if(indexPath.row==1){
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_sex] length]>=1)
            cell.Lab_second.text=[[NSUserDefaults standardUserDefaults]objectForKey:User_sex];
        else
            cell.Lab_second.text=[self.dataArray_second objectAtIndex:indexPath.row];
    }
    if(indexPath.row==2){
        cell.image_dj.hidden=YES;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile] length]>=1)
            cell.Lab_second.text=[[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile];
        else
            cell.Lab_second.text=[self.dataArray_second objectAtIndex:indexPath.row];
    }
//    if(indexPath.row==3){
//        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss] length]>=1)
//            cell.Lab_second.text=[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss];
//        else
//            cell.Lab_second.text=[self.dataArray_second objectAtIndex:indexPath.row];
//    }
    
    return cell;
    }
    else{
        static NSString *cellid=@"mycell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        UILabel *first_lab=(UILabel *)[cell viewWithTag:1001];
        if(!first_lab)
        first_lab = [[UILabel alloc] initWithFrame:CGRectMake(22, 10, 60, 30)];
        first_lab.tag=1001;
        first_lab.backgroundColor = [UIColor clearColor];
        first_lab.font = [UIFont systemFontOfSize:18.0];
        first_lab.textAlignment = NSTextAlignmentLeft;
        first_lab.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
        first_lab.text =@"地址";
        [cell addSubview:first_lab];
        
         TextUILable *second_lab=(TextUILable *)[cell viewWithTag:1002];
        if (!second_lab)
        second_lab = [[TextUILable alloc] initWithFrame:CGRectMake(115, 15, 160, 70)];
        second_lab.backgroundColor = [UIColor clearColor];
        second_lab.tag=1002;
        second_lab.font = [UIFont systemFontOfSize:17.0];
        second_lab.textAlignment = NSTextAlignmentLeft;
        [second_lab setVerticalAlignment:VerticalAlignmentTop];
        second_lab.numberOfLines=3;
        second_lab.textColor = [UIColor colorWithHexString:@"#6d2900" alpha:0.58];
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss] length]>=1)
            second_lab.text =[[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss];
        else
            second_lab.text =[self.dataArray_second objectAtIndex:indexPath.row];
        [cell addSubview:second_lab];
        
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 88, 320, 2)];
        line.image=[UIImage imageNamed:@"细分割线.png"];
        [cell addSubview:line];
        UIImageView *next=[[UIImageView alloc]initWithFrame:CGRectMake(278, 30, 18, 26)];
        next.image=[UIImage imageNamed:@"展开图标.png"];
        [cell addSubview:next];
 
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        PersonalDatacell *cell=(PersonalDatacell *)[mtableview cellForRowAtIndexPath:indexPath];
        WritePersonalDataVC *writvc=[[WritePersonalDataVC alloc]init];
        writvc.title_main=[self.dataArray_first objectAtIndex:indexPath.row];
        writvc.select_index=indexPath.row;
        writvc.title_diplay=cell.Lab_second.text;
        [self.navigationController pushViewController:writvc animated:YES];
    }
    if (indexPath.row==1) {
        UIActionSheet *act=[[UIActionSheet alloc]initWithTitle:@"性别选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [act showInView:self.view];
    }
    if(indexPath.row==3){
        UITableViewCell *cell=(UITableViewCell *)[mtableview cellForRowAtIndexPath:indexPath];
        UILabel *lab=(UILabel *)[cell viewWithTag:1002];
        WritePersonalDataVC *writvc=[[WritePersonalDataVC alloc]init];
        writvc.title_main=[self.dataArray_first objectAtIndex:indexPath.row];
        writvc.select_index=indexPath.row;
        writvc.title_diplay=lab.text;
        [self.navigationController pushViewController:writvc animated:YES];
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
      self.sex_selected=@"1";
     [self SendpersonalSexInfo];
    }
    if (buttonIndex==1) {
      self.sex_selected=@"2";
     [self SendpersonalSexInfo];
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

//发送性别修改
-(void)SendpersonalSexInfo{
    NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:@"ID0017" forKey:@"cmdID"];
    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] forKey:@"token"];
    [postDict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
    [postDict setObject:@"iOS" forKey:@"deviceType"];
    NSString *string=[postDict JSONString];
    
    NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
    [postDict02 setObject:@"" forKey:@"nickName"];
    [postDict02 setObject:self.sex_selected forKey:@"sex"];
    [postDict02 setObject:@"" forKey:@"userAddress"];
    [postDict02 setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
    [postDict02 setObject:@"" forKey:@"userLogo"];
    NSString *string02=[postDict02 JSONString];
   
    NSURL* url_string = [NSURL URLWithString:url];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url_string];
    request.delegate = self;
    [request setPostValue:string forKey:@"header"];
    [request setPostValue:string02 forKey:@"body"];
    [request setUserInfo:[NSDictionary  dictionaryWithObject:@"sex" forKey:@"key"]];
    [request startAsynchronous];
    
}

//发送头像信息
-(void)SendpersonalInfo:(UIImage *)image_upload{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0017" forKey:@"cmdID"];
        [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] forKey:@"token"];
        [postDict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        NSString *string=[postDict JSONString];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:@"" forKey:@"nickName"];
        [postDict02 setObject:@"" forKey:@"sex"];
        [postDict02 setObject:@"" forKey:@"userAddress"];
        [postDict02 setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
        [postDict02 setObject:[NSString stringWithFormat:@"%@",[UIImageJPEGRepresentation([self imageWithImage:image_upload scaledToSize:CGSizeMake(100, 100)], 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]] forKey:@"userLogo"];
        NSString *string02=[postDict02 JSONString];
    
    NSURL* url_string = [NSURL URLWithString:url];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url_string];
    request.delegate = self;
    [request setPostValue:string forKey:@"header"];
    [request setPostValue:string02 forKey:@"body"];
    [request setUserInfo:[NSDictionary  dictionaryWithObject:@"photo" forKey:@"key"]];
    [request startAsynchronous];
        
}

#pragma mark -
#pragma mark -ASIHTTPRequestDelegate

- (void)requestFailed:(ASIHTTPRequest *)request {
    if([[request.userInfo objectForKey:@"key"] isEqualToString:@"photo"]){
    [TLToast showWithText:@"上传头像失败" bottomOffset:200.0f duration:1.0];
    if([self ReadPhoto])
        [self.photoButton  setImage:[self circleImage:[self imageWithImage:[self ReadPhoto] scaledToSize:CGSizeMake(100, 100)] withParam:1.0] forState:UIControlStateNormal];
    else
        [self.photoButton  setImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
    }
    if ([[request.userInfo objectForKey:@"key"] isEqualToString:@"sex"]) {
        [TLToast showWithText:@"设置性别失败" bottomOffset:200.0f duration:1.5];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if([[request.userInfo objectForKey:@"key"] isEqualToString:@"photo"]){
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *respString = [request responseString];
        NSDictionary *jsonDict = [respString objectFromJSONString];
    
        if ([[jsonDict objectForKey:@"resCode"] integerValue]==10191) {
            [TLToast showWithText:@"上传头像成功" bottomOffset:200.0f duration:1.0];
            [self savePhotoTOdisk:UIImagePNGRepresentation([self.image fixOrientation])];
        }
        else{
            [TLToast showWithText:@"上传头像失败" bottomOffset:200.0f duration:1.0];
            if([self ReadPhoto])
                [self.photoButton  setImage:[self circleImage:[self imageWithImage:[self ReadPhoto] scaledToSize:CGSizeMake(100, 100)] withParam:0.0] forState:UIControlStateNormal];
            else
                [self.photoButton  setImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
        }
    }
    if ([[request.userInfo objectForKey:@"key"] isEqualToString:@"sex"]) {
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *respString = [request responseString];
        NSDictionary *jsonDict = [respString objectFromJSONString];
        if ([[jsonDict objectForKey:@"resCode"] integerValue]==10191) {
            [TLToast showWithText:@"设置性别成功" bottomOffset:200.0f duration:1.5];
            if([self.sex_selected isEqualToString:@"1"])
                [[NSUserDefaults standardUserDefaults]setObject:@"男" forKey:User_sex];
            if([self.sex_selected isEqualToString:@"2"])
                [[NSUserDefaults standardUserDefaults]setObject:@"女" forKey:User_sex];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            UITableViewCell *cell=[mtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            UILabel *lab=(UILabel *)[[cell.contentView subviews] objectAtIndex:2];
            lab.text=[[NSUserDefaults standardUserDefaults]objectForKey:User_sex];
        }
        else{
           [TLToast showWithText:@"设置性别失败" bottomOffset:200.0f duration:1.5];
        }
    }
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
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

//头像存在本地
-(void)savePhotoTOdisk:(NSData *)photo_data{
    NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
    [photo_data writeToFile:aPath atomically:YES];
}
//手机读取头像
-(UIImage *)ReadPhoto{
    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
    return imgFromUrl3;
}

#pragma mark -
#pragma mark - UIImagePickerDelegate
//开始拍照
-(void)takePhoto
{
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                    
                         }];
    }
    else
    {
        [TLToast showWithText:@"该设备不支持摄像头拍照" bottomOffset:200.0f duration:1.0];
    }
}

//打开本地相册
-(void)LocalPhoto
{
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                            
                         }];
    }
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
    [picker pushViewController:imgEditorVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //NSLog(@"您取消了选择图片");
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{

            self.image = editedImage;
            [self.photoButton  setImage:[self circleImage:[self imageWithImage:self.image scaledToSize:CGSizeMake(100, 100)] withParam:1.0] forState:UIControlStateNormal];
            [self SendpersonalInfo:self.image];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
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
