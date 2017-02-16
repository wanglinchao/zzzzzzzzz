//
//  AddMailViewController.m
//  IDIAI
//
//  Created by Ricky on 16/5/13.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "AddMailViewController.h"
#import "CLTokenInputView.h"
#import "SWAddPhotoView.h"
#import "TLToast.h"
#import "SWShareImageDetailViewController.h"
#import "ContactViewController.h"
#import "MailContactObject.h"
#import "LoginView.h"
@interface AddMailViewController ()<CLTokenInputViewDelegate,UITextViewDelegate,SWAddPhotoViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)CLTokenInputView *tokenInputView;
@property(nonatomic,strong)UIButton *releasebtn;
@property(nonatomic,strong)UIButton *addcontact;
@property(nonatomic,strong)UILabel *contactlbl;
@property(nonatomic,strong)UITextView *contenttxt;
@property(nonatomic,strong)UILabel *placeholder;
@property(nonatomic,strong)SWAddPhotoView *addPhotoView;
@property(nonatomic,assign)NSInteger photocount;
@property(nonatomic,strong)NSMutableArray *contactlist;
@property(nonatomic,strong)NSMutableArray *addImages;
@property(nonatomic,strong)UIView *hiddenView;

@end

@implementation AddMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.title =@"写信";
    self.contactlist =[NSMutableArray array];
    self.view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.addImages =[NSMutableArray array];
    self.releasebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.releasebtn.frame = CGRectMake(0, 0, 42, 42);
    [self.releasebtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.releasebtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateNormal];
    //右移
    [self.releasebtn addTarget:self action:@selector(releaseAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.releasebtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.addcontact =[UIButton buttonWithType:UIButtonTypeCustom];
    self.addcontact.frame =CGRectMake(11, 11, kMainScreenWidth-22, 38);
    self.addcontact.backgroundColor =[UIColor whiteColor];
    self.addcontact.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
    self.addcontact.layer.borderWidth = 1;
    self.addcontact.layer.masksToBounds = YES;
    self.addcontact.layer.cornerRadius = 5;
    [self.addcontact addTarget:self action:@selector(addContactAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addcontact];
    
    self.contactlbl =[[UILabel alloc] initWithFrame:CGRectMake(8, 8, kMainScreenWidth-22-30, 22)];
    self.contactlbl.textColor =kColorWithRGB(217, 217, 221);
    self.contactlbl.text =@"请添加收信人";
    self.contactlbl.font =[UIFont systemFontOfSize:16];
    [self.addcontact addSubview:self.contactlbl];
    
    UIImageView *addimage =[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-22-30, 6.5, 25, 25)];
    addimage.image =[UIImage imageNamed:@"ic_tianjiashouxinren"];
    [self.addcontact addSubview:addimage];
    
    self.contenttxt=[[UITextView alloc] initWithFrame:CGRectMake(10, self.addcontact.frame.origin.y+self.addcontact.frame.size.height+10, kMainScreenWidth-20, 100)];
    self.contenttxt.backgroundColor =[UIColor whiteColor];
    self.contenttxt.font =[UIFont systemFontOfSize:14];
    self.contenttxt.layer.cornerRadius=5;
    self.contenttxt.clipsToBounds=YES;
    self.contenttxt.delegate =self;
    self.contenttxt.layer.borderColor =[UIColor colorWithHexString:@"#cccccc"].CGColor;
    self.contenttxt.layer.borderWidth = 1;
    self.contenttxt.returnKeyType =UIReturnKeyDefault;
    [self.view addSubview:self.contenttxt];
    
    self.placeholder =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contenttxt.frame.size.width-20, 14)];
    self.placeholder.textColor =kColorWithRGB(217, 217, 221);
    NSString *placeholderstr =@"请输入内容";
    UIFont *font1= [UIFont fontWithName:@"Arial" size:14];
    self.placeholder.text =placeholderstr;
    self.placeholder.font =font1;
    self.placeholder.numberOfLines =0;
//    self.placeholder.lineBreakMode = UILineBreakModeWordWrap;
    [self.contenttxt addSubview:self.placeholder];
    
    self.addPhotoView =[[SWAddPhotoView alloc] initWithFrame: CGRectMake(10, self.contenttxt.frame.origin.y+self.contenttxt.frame.size.height+14, kMainScreenWidth-20, 0)];
    self.addPhotoView.delegate =self;
    self.addPhotoView.photocount =3;
    self.addPhotoView.photos =[NSMutableArray array];
//    [self.addPhotoView addImages:self.photoURL];
    [self.view addSubview:self.addPhotoView];
//    self.tokenInputView =[[CLTokenInputView alloc] initWithFrame:CGRectMake(11, 11, kMainScreenWidth-22, 38)];
//    self.tokenInputView.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
//    self.tokenInputView.layer.borderWidth = 1;
//    self.tokenInputView.layer.masksToBounds = YES;
//    self.tokenInputView.layer.cornerRadius = 5;
//    self.tokenInputView.backgroundColor =[UIColor whiteColor];
//    self.tokenInputView.delegate =self;
//    self.tokenInputView.placeholderText = @"请添加收信人";
//    UIButton *contactAddButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    [contactAddButton addTarget:self action:@selector(onAccessoryContactAddButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    self.tokenInputView.accessoryView = contactAddButton;
//    [self.view addSubview:self.tokenInputView];
    // Do any additional setup after loading the view.
    self.hiddenView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.hiddenView.backgroundColor =[UIColor clearColor];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.hiddenView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)hideKeyboard:(UIGestureRecognizer *)sender{
    [self.contenttxt resignFirstResponder];
    [self.hiddenView removeFromSuperview];
}
-(void)releaseAction:(id)sender{
    if (self.contactlist.count==0) {
        [TLToast showWithText:@"请选择收信人"];
        return;
    }
    if (self.contenttxt.text.length<1||self.contenttxt.text.length>500) {
        [TLToast showWithText:@"信件内容1-500字"];
        return;
    }
    self.releasebtn.userInteractionEnabled =NO;
    //    self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled=NO;
    
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
    [postDict setObject:@"ID0364" forKey:@"cmdID"];
    [postDict setObject:string_token forKey:@"token"];
    [postDict setObject:string_userid forKey:@"userID"];
    [postDict setObject:@"ios" forKey:@"deviceType"];
    [postDict setObject:kCityCode forKey:@"cityCode"];
    
    NSString *string=[postDict JSONString];
    NSMutableDictionary *bodyDic =[NSMutableDictionary dictionary];
    [bodyDic setObject:@"7" forKey:@"sendRoleId"];
    [bodyDic setObject:self.contenttxt.text forKey:@"mailContext"];
    [bodyDic setObject:self.contactlist forKey:@"recvUserInfo"];
    
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: url]];
    
    NSString *string02=[bodyDic JSONString];
    [request setPostValue:string forKey:@"header"];
    [request setPostValue:string02 forKey:@"body"];
    request.showAccurateProgress=YES;
    
  
    int count=0;
    [self.addImages removeAllObjects];
    for (id photo in self.addPhotoView.photos) {
        if ([photo isKindOfClass:[UIImage class]]) {
            NSData *data1 = UIImageJPEGRepresentation(photo,1.0);
            NSLog(@"%d",(int)data1.length);
            [self.addImages addObject:photo];
        }
    }
    for (UIImage *image in self.addImages) {
        BOOL success;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSLog(@"found an image");
        
        NSString *_imageFile1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"temp%d.jpg",count]];
        
        NSLog(@"%@",_imageFile1);
        
        success = [fileManager fileExistsAtPath:_imageFile1];
        
        if(success) {
            
            success = [fileManager removeItemAtPath:_imageFile1 error:&error];
            
        }
        
        [UIImageJPEGRepresentation(image, 0.1f) writeToFile:_imageFile1 atomically:YES];
        
        [request addFile:_imageFile1 forKey:@"filedata"];
        count++;
    }
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setUploadProgressDelegate:self];
    [request startAsynchronous];
}

#pragma mark -ASIHTTPRequestDelegate

- (void)requestFailed:(ASIHTTPRequest *)request {
    [self stopRequest];
    [TLToast showWithText:@"操作失败"];
    self.releasebtn.userInteractionEnabled=YES;
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self stopRequest];
    NSString *respString = [request responseString];
    NSDictionary *jsonDict = [respString objectFromJSONString];
    if ([[jsonDict objectForKey:@"resCode"]integerValue] == 103641) {
        [TLToast showWithText:@"发信成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([[jsonDict objectForKey:@"resCode"]integerValue] == 10002){
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        self.releasebtn.userInteractionEnabled=YES;
        return;
    }else {
        [TLToast showWithText:@"发信失败"];
        self.releasebtn.userInteractionEnabled=YES;
    }
    
}
-(void)addContactAction:(id)sender{
    ContactViewController *contact =[[ContactViewController alloc] init];
    contact.selectlist =self.contactlist;
    contact.selectDone =^(NSMutableArray *selectContactArray){
        [self.contactlist removeAllObjects];
        self.contactlbl.text =@"请添加收信人";
        self.contactlbl.textColor =kColorWithRGB(217, 217, 221);
        if (selectContactArray.count>0) {
            int count =0;
            for (MailContactObject *mailobject in selectContactArray) {
                if (mailobject.isselct ==YES) {
                    if (count>0) {
                        self.contactlbl.text =[NSString stringWithFormat:@"%@,%@",self.contactlbl.text,mailobject.userName];
                    }else{
                        self.contactlbl.text =[NSString stringWithFormat:@"%@",mailobject.userName];
                    }
                    self.contactlbl.textColor =[UIColor colorWithHexString:@"#575757"];
                    count++;
                    NSMutableDictionary *contact =[NSMutableDictionary dictionary];
                    [contact setObject:mailobject.userName forKey:@"userName"];
                    [contact setObject:[NSNumber numberWithInt:mailobject.roleId] forKey:@"roleId"];
                    [contact setObject:[NSNumber numberWithInt:mailobject.userId] forKey:@"userId"];
                    [self.contactlist addObject:contact];
                }
            }
        }
        
    };
    [self.navigationController pushViewController:contact animated:YES];
}
#pragma mark addPhotoViewDelegate

-(void)addPhotoCount:(NSInteger)count
{
    self.photocount =count;
    UIActionSheet *action =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    action.actionSheetStyle =UIActionSheetStyleBlackTranslucent;
    [action showInView:self.view];
    
    
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            if (self.photocount ==0) {
                [TLToast showWithText:@"最多允许上传9张图片"];
                return;
            }
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            //指定源类型前，检查图片源是否可用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                //指定源的类型
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
                imagePicker.allowsEditing = YES;
                
                //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
                imagePicker.delegate = self;
                
                //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
                imagePicker.allowsEditing = YES;
                
                //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
                imagePicker.delegate = self;
                
                //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
            break;
        case 1:
        {
            if (self.photocount ==0) {
                [TLToast showWithText:@"最多允许上传9张图片"];
                return;
            }
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            
            imagePickerController.limitsMaximumNumberOfSelection = YES;
            imagePickerController.maximumNumberOfSelection = self.photocount;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
            [self presentViewController:navigationController animated:YES completion:NULL];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 删除图片
-(void)detelePhotoCount:(NSInteger)count
{
    SWShareImageDetailViewController *sharedetail =[[SWShareImageDetailViewController alloc] init];
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:sharedetail];
    NSMutableArray *photosArray =[[NSMutableArray alloc] init];
    [photosArray addObjectsFromArray:[self.addPhotoView.photos copy]];
    sharedetail.photos =photosArray;
    sharedetail.index =(int)count-100;
    sharedetail.selectDone =^(NSMutableArray *photosArray){
//        for (NSString *photo in self.photoURL) {
//            if (![photosArray containsObject:photo]) {
//                [self.deleteImages addObject:photo];
//            }
//        }
        [self.addPhotoView setPhotos:photosArray];
    };
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark - 选择照片数量
-(void)pickPhotoCount:(NSInteger)count
{
    if (count ==0) {
        [TLToast showWithText:@"最多允许上传9张图片"];
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    //指定源类型前，检查图片源是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //指定源的类型
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
        imagePicker.allowsEditing = YES;
        
        //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
        imagePicker.delegate = self;
        
        //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
        imagePicker.allowsEditing = YES;
        
        //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
        imagePicker.delegate = self;
        
        //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if ([imagePickerController isKindOfClass:[QBImagePickerController class]]) {
        if(imagePickerController.allowsMultipleSelection) {
            NSMutableArray *images =[NSMutableArray array];
            for (NSDictionary *dic in info) {
                UIImage *image =[dic objectForKey:@"UIImagePickerControllerOriginalImage"];
                NSData *origImageData = UIImageJPEGRepresentation(image, 1.0);
                for (int i=0; i<1; i++) {
                    if ([origImageData length] <= 4*1024*1024) {
                        image =[UIImage imageWithData:origImageData];
                        [images addObject:image];
                    }else {
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                        origImageData =imageData;
                        i--;
                    }
                }
            }
            [self.addPhotoView addImages:images];
        }
    }else{
        NSMutableArray *images =[NSMutableArray array];
        UIImage *image =[info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *origImageData = UIImageJPEGRepresentation(image, 1.0);
        for (int i=0; i<1; i++) {
            if ([origImageData length] <= 4*1024*1024) {
                image =[UIImage imageWithData:origImageData];
                [images addObject:image];
            }else {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                origImageData =imageData;
                i--;
            }
        }
        [self.addPhotoView addImages:images];
    }
    //    CGRect rect =CGRectMake(0, self.addPhotoView.frame.origin.y+self.addPhotoView.frame.size.height+26, 0, 0);
    //    self.isselectbtn.frame =CGRectMake(self.isselectbtn.frame.origin.x, rect.origin.y, self.isselectbtn.frame.size.width, self.isselectbtn.frame.size.height);
    //    self.selectlbl.frame =CGRectMake(self.isselectbtn.frame.origin.x+25, rect.origin.y+3, self.selectlbl.frame.size.width, self.selectlbl.frame.size.height);
    [self dismissViewControllerAnimated:YES completion:^{
        UISegmentedControl *segment =(UISegmentedControl *)[self.navigationController.navigationBar viewWithTag:100];
        segment.hidden =YES;
        //        [segment removeFromSuperview];
    }];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:^{
        UISegmentedControl *segment =(UISegmentedControl *)[self.navigationController.navigationBar viewWithTag:100];
        segment.hidden =YES;
        //        [segment removeFromSuperview];
    }];
    
}
- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"";
}

- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"";
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"图片%d张", numberOfPhotos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"视频%d", numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"图片%d 视频%d", numberOfPhotos, numberOfVideos];
}
#pragma mark -UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view addSubview:self.hiddenView];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.hiddenView removeFromSuperview];
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    //    self.contenttxt.text =  textView.text;
    if (textView.text.length == 0) {
        NSString *placeholderstr =@"请输入内容";
        self.placeholder.text =placeholderstr;
    }else{
        self.placeholder.text = @"";
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
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
