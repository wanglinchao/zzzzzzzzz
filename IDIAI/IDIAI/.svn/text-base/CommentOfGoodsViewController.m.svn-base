//
//  CommentOfGoodsViewController.m
//  IDIAI
//
//  Created by Ricky on 15/5/27.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CommentOfGoodsViewController.h"
#import "TLToast.h"
#import "NSStringAdditions.h"
#import "LoginView.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "CustomPromptView.h"
#import "SWShareImageDetailViewController.h"
@interface CommentOfGoodsViewController () <UITextViewDelegate,LoginViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    CustomPromptView *customPromp;
}
@property(nonatomic,assign)NSInteger photocount;
@end

@implementation CommentOfGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"评论";
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    
    //加载星级（0-10,0表示无星级）
    self.numberStart = 0;
    self.startView = [[UIView alloc] init];
    self.startView.frame=CGRectMake(75, 100, 160, 20);
    [self.startView setBackgroundColor:[UIColor clearColor]];
    [self.theScrollView addSubview:self.startView];
    _imageViewArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*20, 3,15, 15)];
            [self.imageViewArray addObject:imageView];
            [self.startView addSubview:imageView];
        }
    }
    [self numberStartReLoad:self.numberStart];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.startView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoGesture:)];
    [self.startView addGestureRecognizer:tapGesture];
    
    self.commentComtentTV.delegate = self;
    self.commentComtentTV.layer.masksToBounds = YES;
    self.commentComtentTV.layer.cornerRadius = 5;
    self.commentComtentTV.layer.borderColor = kFontPlacehoderCGColor;
    self.commentComtentTV.layer.borderWidth = 1;
    
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 3;
    
    NSString *imgUrlStr = [self.goodsInfoDic objectForKey:@"goodsUrl"];
    [self.goodsIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
    
    self.goodsNameLabel.text = [self.goodsInfoDic objectForKey:@"goodsName"];
    if([[self.goodsInfoDic objectForKey:@"goodsColor"] length]>=1)
        self.guigeLabel.text = [NSString stringWithFormat:@"颜色：%@           规格：%@",[self.goodsInfoDic objectForKey:@"goodsColor"],[self.goodsInfoDic objectForKey:@"goodsModel"]];
    else
        self.guigeLabel.text = [NSString stringWithFormat:@"%@",[self.goodsInfoDic objectForKey:@"goodsModel"]];
    
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[self.goodsInfoDic objectForKey:@"goodsPrice"]floatValue]];
    
    self.addPhotoView =[[SWAddPhotoView alloc] initWithFrame: CGRectMake(15, self.commentComtentTV.frame.origin.y+self.commentComtentTV.frame.size.height+14, kMainScreenWidth-30, 0)];
    self.addPhotoView.delegate =self;
    self.addPhotoView.photocount =3;
    self.addPhotoView.photos =[NSMutableArray array];
    [self.theScrollView addSubview:self.addPhotoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - gestrue

- (void)handlePanGesture:(UIGestureRecognizer *)sender {
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart = 0;
        }
        else if (translation.x >10 &&translation.x <25) {
            self.numberStart = 1;
        }
        else if (translation.x >= 25 &&translation.x <40) {
            self.numberStart = 2;
        }
        else if(translation.x >= 40 &&translation.x < 55){
            self.numberStart = 3;
        }
        else if (translation.x >= 55 &&translation.x < 70) {
            self.numberStart = 4;
        }
        else if(translation.x >=70 &&translation.x < 85)
        {
            self.numberStart = 5;
        }
        else if (translation.x >=85 &&translation.x <100) {
            self.numberStart = 6;
        }
        else if (translation.x >= 100 &&translation.x <115) {
            self.numberStart = 7;
        }
        else if(translation.x >= 115 &&translation.x < 130){
            self.numberStart = 8;
        }
        else if (translation.x >= 130 &&translation.x < 145) {
            self.numberStart = 9;
        }
        else if(translation.x >= 145 &&translation.x < 160)
        {
            self.numberStart = 10;
        }
        else if(translation.x >=160)
        {
            self.numberStart = 10;
        }
        [self numberStartReLoad:self.numberStart];
    }
}
-(void)handleTwoGesture:(UIGestureRecognizer *)sender{
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart = 0;
        }
        else if (translation.x >10 &&translation.x <20) {
            self.numberStart = 1;
        }
        else if (translation.x >= 20 &&translation.x <30) {
            self.numberStart = 2;
        }
        else if(translation.x >= 30 &&translation.x < 40){
            self.numberStart = 3;
        }
        else if (translation.x >= 40 &&translation.x < 50) {
            self.numberStart = 4;
        }
        else if(translation.x >=50 &&translation.x < 60)
        {
            self.numberStart = 5;
        }
        else if (translation.x >=60 &&translation.x <70) {
            self.numberStart = 6;
        }
        else if (translation.x >= 70 &&translation.x <80) {
            self.numberStart = 7;
        }
        else if(translation.x >= 80 &&translation.x < 90){
            self.numberStart = 8;
        }
        else if (translation.x >= 90 &&translation.x < 100) {
            self.numberStart = 9;
        }
        else if(translation.x >= 100 &&translation.x < 110)
        {
            self.numberStart = 10;
        }
        else if(translation.x >=110)
        {
            self.numberStart = 10;
        }
        [self numberStartReLoad:self.numberStart];
    }
    
}
- (void)numberStartReLoad:(NSInteger)number {
    int fullNum = number/2;
    int halfNum = number%2;
    int emptyNum = 5 - fullNum -halfNum;
    NSMutableArray *starArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            if (fullNum != 0 ) {
                fullNum --;
                [starArray addObject:@"0"];
            }else if(fullNum == 0 &&halfNum != 0)
            {
                halfNum --;
                [starArray addObject:@"1"];
            }
            else if(fullNum == 0 &&halfNum == 0 &&emptyNum!= 0)
            {
                emptyNum --;
                [starArray addObject:@"2"];
            }
            UIImageView *imageView = [self.imageViewArray objectAtIndex:i];
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_xing_%@",[starArray objectAtIndex:i]]]];
        }
    }
}


- (IBAction)clickSubmitBtn:(id)sender {
    [self requestCommentGoods];
}

//给UITextView添加placeholder
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (range.location>0 || text.length!=0) {
        _placeholderLabel.hidden = YES;
    }else{
        _placeholderLabel.hidden = NO;
    }
    return YES;
}

#pragma mark - 评论商品
-(void)requestCommentGoods {
   
    if (self.numberStart<=0.0) {
        [TLToast showWithText:@"请评价星级"];
        return;
    } else if ([NSString isEmptyOrWhitespace:self.commentComtentTV.text]) {
        [TLToast showWithText:@"请输入评价内容"];
        return;
    }
    if (self.commentComtentTV.text.length>100) {
        [TLToast showWithText:@"评价内容1-100字"];
        return;
    }
    [self startRequestWithString:@"加载中..."];
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
    [postDict setObject:@"ID0207" forKey:@"cmdID"];
    [postDict setObject:string_token forKey:@"token"];
    [postDict setObject:string_userid forKey:@"userID"];
    [postDict setObject:@"ios" forKey:@"deviceType"];
    [postDict setObject:kCityCode forKey:@"cityCode"];
    NSString *string=[postDict JSONString];
    
    NSString *levelStr;
    if(self.numberStart%2==1) levelStr=[NSString stringWithFormat:@"%.1f",self.numberStart/2+0.5];
    else levelStr=[NSString stringWithFormat:@"%ld",(long)self.numberStart/2];
    NSDictionary *bodyDic = @{@"commentLevel":levelStr,@"content":self.commentComtentTV.text,@"shopId":self.shopIdStr,@"shopOrderDetailId":self.shopOrderDetailStr,@"shopGoodsDetailId":self.shopGoodsDetailIdStr};
    NSString *string02=[bodyDic JSONString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: url]];
    
    [request setPostValue:string forKey:@"header"];
    [request setPostValue:string02 forKey:@"body"];
    request.showAccurateProgress=YES;
    int count=0;
    
    for (UIImage *image in self.addPhotoView.photos) {
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
    
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
//        
//        NSString *string_token;
//        NSString *string_userid;
//        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
//            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
//            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
//        }
//        else{
//            string_token=@"";
//            string_userid=@"";
//        }
//        
//        
//        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//        [postDict setObject:@"ID0207" forKey:@"cmdID"];
//        [postDict setObject:string_token forKey:@"token"];
//        [postDict setObject:string_userid forKey:@"userID"];
//        [postDict setObject:@"ios" forKey:@"deviceType"];
//        [postDict setObject:kCityCode forKey:@"cityCode"];
//        NSString *string=[postDict JSONString];
//    
//        NSString *levelStr;
//        if(self.numberStart%2==1) levelStr=[NSString stringWithFormat:@"%.1f",self.numberStart/2+0.5];
//        else levelStr=[NSString stringWithFormat:@"%ld",(long)self.numberStart/2];
//        NSDictionary *bodyDic = @{@"commentLevel":levelStr,@"content":self.commentComtentTV.text,@"shopId":self.shopIdStr,@"shopOrderDetailId":self.shopOrderDetailStr,@"shopGoodsDetailId":self.shopGoodsDetailIdStr};
//        NSString *string02=[bodyDic JSONString];
//        
//        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
//        [post setObject:string forKey:@"header"];
//        [post setObject:string02 forKey:@"body"];
//        
//        NetworkRequest *req = [[NetworkRequest alloc] init];
//        [req setHttpMethod:PostMethod];
//        
//        [req sendToServerInBackground:^{
//            dispatch_async(parsingQueue, ^{
//                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
//                [request setTimeOutSeconds:15];
//                [request setResponseEncoding:NSUTF8StringEncoding];
//                NSString *respString = [request responseString];
//                NSDictionary *jsonDict = [respString objectFromJSONString];
//                 NSLog(@"评论商品返回信息：%@",jsonDict);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    //token为空或验证未通过处理 huangrun
//                    if (kResCode == 10002 || kResCode == 10003) {
//                        [self stopRequest];
//                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
//                        login.delegate=self;
//                        [login show];
//                        return;
//                    }
//                    
//                    if (kResCode == 102071) {
//                        [self stopRequest];
//                        [TLToast showWithText:@"评论成功"];
//                        [self.navigationController popViewControllerAnimated:YES];
//                    } else {
//                        [self stopRequest];
//                        [TLToast showWithText:@"评论失败"];
//                    }
//                });
//            });
//        }
//                          failedBlock:^{
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [self stopRequest];
//                                  [TLToast showWithText:@"操作失败"];
//                              });
//                          }
//                               method:url postDict:post];
//    });
    
}
-(void)hideAction:(id)sender{
    [customPromp dismiss];
}
#pragma mark -
#pragma mark -ASIHTTPRequestDelegate

- (void)requestFailed:(ASIHTTPRequest *)request {
    [self stopRequest];
    [TLToast showWithText:@"操作失败"];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self stopRequest];
    NSString *respString = [request responseString];
    NSDictionary *jsonDict = [respString objectFromJSONString];
    if ([[jsonDict objectForKey:@"resCode"]integerValue] == 10002||[[jsonDict objectForKey:@"resCode"]integerValue]==10003) {
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }else if ([[jsonDict objectForKey:@"resCode"]integerValue] == 102071){
        [TLToast showWithText:@"评论成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"亲，评价失败哦";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
    }
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
            [self.addPhotoView setPhotos:photosArray];
        };
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    
    
//    NSMutableArray *photos =[NSMutableArray array];
//    MJPhoto *photo = [[MJPhoto alloc] init];
//    photo.image =[self.addPhotoView.photos objectAtIndex:count-100];
//    NSLog(@"%@",[self.addPhotoView viewWithTag:count]);
//    UIButton *contentbtn =(UIButton *)[self.addPhotoView viewWithTag:count];
//    photo.srcImageView = contentbtn.imageView; // 来源于哪个UIImageView
//    [photos addObject:photo];
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    //    browser.describe =selectpic.phasePicDescription;
//    [browser show];
}
//-(void)longTouchPhotoCount:(NSInteger)count{
//    NSMutableArray *photosArray =[[NSMutableArray alloc] init];
//    [photosArray addObjectsFromArray:[self.addPhotoView.photos copy]];
//    [photosArray removeObjectAtIndex:count-100];
//    [self.addPhotoView setPhotos:photosArray];
//}
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
    return [NSString stringWithFormat:@"图片%d张", (int)numberOfPhotos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"视频%d", (int)numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"图片%d 视频%d", (int)numberOfPhotos, (int)numberOfVideos];
}

@end
