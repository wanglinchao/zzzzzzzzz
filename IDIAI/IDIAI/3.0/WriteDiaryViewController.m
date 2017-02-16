//
//  WriteDiaryViewController.m
//  IDIAI
//
//  Created by PM on 16/7/13.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "WriteDiaryViewController.h"
#import "SWAddPhotoView.h"//1
#import "TLToast.h"
#import "QBImagePickerController.h"//2
#import "SWShareImageDetailViewController.h"//3
#import "ChooseDecorateMarkViewController.h"
#import "IDIAI3AddDiaryViewController.h"
#import "Emoji.h"
#import "LoginView.h"
#import "AFNetworking.h"
#define ImageRowHeight 82*kMainScreenWidth/375
#define TextViewHeight 150

#define NormalCellHeght 44
#define  MAX_STARWORDS_LENGTH 25 //标题最大长度


@interface WriteDiaryViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,SWAddPhotoViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>


@property(nonatomic,strong)UILabel * placeholderLab;
@property(nonatomic,strong)UIView * lineView;
@property(nonatomic,strong)SWAddPhotoView * addPhotoView;
@property(nonatomic,assign)NSInteger photocount;//剩余可添加图片数量
@property(nonatomic,strong)NSMutableArray *addImages;
@property(nonatomic,strong)NSMutableArray *deleteImages;
@property(nonatomic,strong)NSArray * chooseMarksArr;
@property(nonatomic,strong)NSMutableArray * selectedMarkArr;
@property(nonatomic,strong)NSString *diaryTitle;
@property(nonatomic,strong)NSString *diaryContext;
@property(nonatomic,strong)NSString *lablestr;
@property(nonatomic,strong)UIToolbar  * topView; //键盘上的完成按钮父视图
@property(nonatomic,strong)UILabel * marksChooseLab;//标签选择
@property(nonatomic,strong) UILabel * marksLab;//标签显示label
@end

@implementation WriteDiaryViewController


-(void)viewWillAppear:(BOOL)animated{
    //传送的是标签的在数组中的位置
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.diaryContext = self.textView.text;
    self.diaryTitle = self.textfield.text;

}

- (void)viewDidLoad{
    NSLog(@"=========+++++++++%ld",(long)self.diaryType1);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMarks:) name:@"chooseDecorateMarks"object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goBackCheck:) name:@"goBackCheck" object:nil];

    if (self.diaryId>0) {//编辑发过的贴
        
        self.navigationController.navigationBar.hidden = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.theRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        if (self.useType==2) {
            [self.theRightBtn setTitleColor:[UIColor colorWithHexString:@"#35BB9D" alpha:1.0] forState:UIControlStateNormal];
        }else{
            [self.theRightBtn setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateNormal];
        }
        
        [self.theRightBtn setTitle:@"发布" forState:UIControlStateNormal];
        self.theRightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.theRightBtn addTarget:self action:@selector(releaseNewDiary:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.theRightBtn];
        self.navigationItem.rightBarButtonItem = rightBarBtn;
        
    }else{//新发帖
        
        self.navigationController.navigationBar.hidden = YES;
    }
    [super viewDidLoad];
    self.chooseMarksArr = [[NSArray alloc]initWithObjects:@"装前准备",@"前期设计",@"主体拆改",@"水电改造",@"泥木施工",@"墙面地板",@"成品安装",@"软饰搭配",@"经验总结", nil];
    self.selectedMarkArr = [NSMutableArray array];
    if (self.diaryId<=0) {//新发帖
        [self creatUI];
    }else{//编辑发过的贴
        [self requstEditDiary];
    }

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textOFTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.textfield];
}

- (void)creatUI{
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-40)];
    
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    _tableView.tableHeaderView =backView;
//    _tableView.tableHeaderView.backgroundColor= [UIColor redColor];
    
    _tableView.backgroundColor = [UIColor clearColor];;

    [self.view addSubview:_tableView];
     self.addImages =[NSMutableArray array];
     self.deleteImages =[NSMutableArray array];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGesture];
    if (self.diaryTitle.length>0) {
        self.textfield.text = self.diaryTitle;
        NSLog(@"=======*******%@",self.diaryTitle);
    }
    if (self.diaryContext.length>0) {
        self.textView.text  = self.diaryContext;
        self.placeholderLab.text = @"";
    }
    self.topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-40-64, kMainScreenWidth, 40)];
    [self.topView setBarStyle:UIBarStyleDefault];
    [self.view addSubview:self.topView];
    self.topView.hidden  = YES;
    
}

//编辑已发帖子时请求帖子数据
-(void)requstEditDiary{
    [self startRequestWithString:@"加载中..."];

          NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
    NSMutableDictionary * bodyDict = [NSMutableDictionary dictionary];
   
    [bodyDict setObject:[NSNumber numberWithInt:self.diaryId] forKey:@"diaryId"];
    [bodyDict setObject:[NSNumber numberWithInteger:self.roleId]forKey:@"roleId"];
          __weak  typeof(self) weakself =self;
        [self sendRequestToServerUrl:^(id responseObject){
            [weakself stopMBProgressHUD];
            if([[responseObject objectForKey:@"resCode"] integerValue]==10002){
                [weakself loginViewShow];
                
            }
            else if ([[responseObject objectForKey:@"resCode"] integerValue]==103451){
                weakself.diaryTitle =[[responseObject objectForKey:@"decorDiary"] objectForKey:@"diaryTitle"];
                    weakself.diaryContext =[[responseObject objectForKey:@"decorDiary"] objectForKey:@"diaryContext"];
                    weakself.photoURL =[[responseObject objectForKey:@"decorDiary"] objectForKey:@"picPaths"];
                    weakself.lablestr =[[responseObject objectForKey:@"decorDiary"] objectForKey:@"diaryLableIds"];
                    NSArray *labelArray =[self.lablestr componentsSeparatedByString:@","];
                    if (labelArray.count>0) {
                        for (NSString *labelcount in labelArray) {
                            [weakself.selectedMarkArr addObject:[NSString stringWithFormat:@"%d",[labelcount intValue]-1]];
                        }
                    }
                    
                    [weakself creatUI];
            }
            else{
               dispatch_async(dispatch_get_main_queue(), ^{
                   [TLToast showWithText:@"获取日记信息错误"];
               });
            }
            
        } failedBlock:^(id responseObject){
            [weakself stopMBProgressHUD];
            [util showError:responseObject];
        }
                          RequestUrl:url CmdID:@"ID0345" PostDict:bodyDict RequestType:@"GET"];

}

#pragma mark -Notification

//选择标签后
- (void)getMarks:(NSNotification*)notif{
  
    NSDictionary * dict = notif.userInfo;
    NSString * diaryTypeStr = dict[@"diaryType"];
    NSInteger diaryType = [diaryTypeStr integerValue];
    if (diaryType==self.diaryType1) {
        
        NSArray * arry = dict[@"Marks"];
        NSLog(@"%@",arry);
        [self.selectedMarkArr removeAllObjects];
        for (id markNum in arry) {
            [self.selectedMarkArr  addObject:markNum];
        }
         //选择标签后去掉 @“请选择其他板块”
        self.marksChooseLab.text =@"";
        self.marksLab.frame= CGRectMake(15, 0, kMainScreenWidth-80,NormalCellHeght);
       
        if (diaryType==1) {
           [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }else if(diaryType==2){
            
           [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }else{
        
        }
    }
    
   
 
}

-(void)goBackCheck:(NSNotification*)notiy{
     NSDictionary * dict = notiy.userInfo;
     NSArray * arr =dict[@"sender"];
     UIButton * button =[arr firstObject];
    BOOL  weatherAlert = [self checkWeatherAlertUser:button];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"alertNotification" object:nil userInfo:@{@"weatherAlert":[NSNumber numberWithBool:weatherAlert]}];
        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你的帖子尚在编辑，是否确定返回？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.tag =50;
//        [alert show];
//    }
    
}
//确认返回前是否有必要提醒用户帖子还在编辑中
-(BOOL)checkWeatherAlertUser:(UIButton*)sender{
    
    if (self.diaryType1==1) {
        if (self.textfield.text.length==0&&self.textView.text.length==0&&self.addPhotoView.photos.count==0&&[self.marksLab.text isEqualToString:@"经验总结"]==YES) {
            return NO;
        }else{

            return YES;
        }
        
    }else {
        if (self.textView.text.length==0&&self.addPhotoView.photos.count==0&&[self.marksLab.text isEqualToString:@"经验总结"]==YES) {
            return NO;
        }else{
            return YES;
        }

    }
}


// 发布前检查是否能发布
-(BOOL)checkWeatherCanRelease:(UIButton*)sender{
    NSLog(@"diaryType1============%ld",(long)self.diaryType1);
    sender.enabled = NO;
    BOOL isOK = YES;
    [self hideKeyBoard];
    self.textfield.text =[self.textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//?
    //    if (self.releaseType==0) {//写帖子
    if (self.diaryType1==1) {
        if (self.textfield.text.length<5||self.textfield.text.length>25) {
            NSLog(@"text==========%@",self.textfield.text);
            [TLToast showWithText:@"请输入5 ～ 25字的标题"];
            sender.enabled = YES;
            isOK = NO;
            return isOK;
        }
        
        if (self.textView.text.length<5||self.textView.text.length>500) {
            [TLToast showWithText:@"请输入5 ～ 500字的帖子内容"];
            sender.enabled = YES;
            isOK = NO;
            return isOK;
        }
        
        if (self.addPhotoView.photos.count==0) {
            [TLToast showWithText:@"请选择上传图片"];
            sender.enabled = YES;
            isOK = NO;
            return isOK;
        }
        
    }else {
        if (self.textView.text.length<5||self.textView.text.length>500) {
            [TLToast showWithText:@"请输入5 ～ 500字的帖子内容"];
            sender.enabled = YES;
            isOK = NO;
            return isOK;
        }
    }
    return isOK;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionNumber ;
    if (self.diaryType1==1) {
        sectionNumber =3;
        //写帖子
    }else if(self.diaryType1==2){
        sectionNumber =2;
        //提问
    }
    NSLog(@"sectionNumner=========%ld",sectionNumber);
    return sectionNumber;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    static int section=0;
    if (self.diaryType1==1) {
        section=0;//写帖子
    }else{
        section=-1;//提问
    }

        if (indexPath.section==section) {
            return NormalCellHeght;
        }else if(indexPath.section==section+1)
        {
            NSLog(@"self.addPhotoView.frame.size.height===========++++++++++++++++++++++++++%f",self.addPhotoView.frame.size.height);
            if (self.addPhotoView.photos.count==9) {
                return 150+0.5+25+self.addPhotoView.frame.size.height;
            }
            return 150+0.5+25+self.addPhotoView.frame.size.height;
            
        }else{
            return NormalCellHeght;
        }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    static int section = 0 ;
    if (self.diaryType1==1) {
        section=0;
    }else {
        section = -1;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section==section) {
        if (!self.textfield) {
            self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kMainScreenWidth-20,NormalCellHeght)];
            self.textfield.placeholder=@"请输入日记标题";
            self.textfield.returnKeyType = UIReturnKeyDone;
             self.textfield.textColor=[UIColor darkGrayColor];
            self.textfield.font = [UIFont systemFontOfSize:15];
            [self.textfield addTarget:self action:@selector(textfielddDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
            self.textfield.text = self.diaryTitle;
       
        [cell.contentView addSubview:self.textfield];
    } else if(indexPath.section==section+1){
//        cell.contentView.backgroundColor = [UIColor whiteColor];
        if (!self.textView) {
            self.textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 20, kMainScreenWidth-40, TextViewHeight )];
            self.textView.textColor=[UIColor darkGrayColor];
            self.textView.font =[UIFont systemFontOfSize:15];
            self.textView.delegate =self;
            
        }
            self.textView.text = self.diaryContext;
     
       [cell.contentView  addSubview:self.textView];
        
        if (!self.placeholderLab) {
            self.placeholderLab = [[UILabel alloc]initWithFrame:CGRectMake(5,0,CGRectGetWidth(self.textView.frame)-20,40)];
            if (self.diaryType1==1) {
            self.placeholderLab.text=@"分享一下你的装修经验吧";
            }else{
            self.placeholderLab.text =@"请输入你的问题";
            }
            self.placeholderLab.font =[UIFont systemFontOfSize:17];
            self.placeholderLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
            [self.textView addSubview:self.placeholderLab];
        }
        if (self.diaryContext.length!=0) {
            self.placeholderLab.text =@"";
        }

        if (!self.lineView) {
            self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(self.textView.frame),kMainScreenWidth-30,0.5)];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        }
        
      [cell.contentView  addSubview:_lineView];
        if (!self.addPhotoView) {
            self.addPhotoView =[[SWAddPhotoView alloc] initWithFrame: CGRectMake(15,CGRectGetMaxY(self.textView.frame)+15, kMainScreenWidth-30, 0)];
            self.addPhotoView.delegate =self;
            self.addPhotoView.photocount =9;
            self.addPhotoView.photos =[NSMutableArray array];
           [self.addPhotoView addImages:self.photoURL];
        }   cell.clipsToBounds =YES;
            [cell.contentView addSubview:self.addPhotoView];
            NSLog(@"cell=================%@",cell.contentView);
        
    }else {
        //使用手势present VC 因为父视图self.View 添加了隐藏键盘的手势，若用didSelectRowAtIndexPath 则不会响应，因为父视图先响应。
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToChooseDecorateMarkVC:)];
        [cell.contentView addGestureRecognizer:tapGesture];
        if (!_marksLab) {
             _marksLab  = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kMainScreenWidth-155,NormalCellHeght)];
             _marksLab.font = [UIFont systemFontOfSize:17];
             _marksLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
        }
        
        [cell.contentView addSubview:_marksLab];
      
        if (!_marksChooseLab) {
            _marksChooseLab  = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-140,0, 110,NormalCellHeght)];
            _marksChooseLab.text =@"选择其他板块";
            _marksChooseLab.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        }
        [cell.contentView addSubview:_marksChooseLab];
       
        if (self.selectedMarkArr.count == 0) {
            _marksLab.text = @"经验总结";
        [self.selectedMarkArr addObject:@"8"];
        }else{
           NSMutableString *str =[NSMutableString stringWithString:@""];
            for (int i=0; i<self.selectedMarkArr.count; i++) {
                NSInteger index = [self.selectedMarkArr[i] integerValue];
        [str appendString:[NSString stringWithFormat:@" %@",self.chooseMarksArr[index]]];
            }
            _marksLab.text = str;    
        }
        
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section==0) {
         NSLog(@"kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    }else if(indexPath.section==1){
     NSLog(@"kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    }else if(indexPath.section==2){
        NSLog(@"kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
     
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{

     view.tintColor =[UIColor colorWithHexString:@"#efeff4"];
    
}



-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
//    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];//使用这个不变色
    view.tintColor = [UIColor colorWithHexString:@"#efeff4"];
    
}


//使用手势present VC 因为父视图self.View 添加了隐藏键盘的手势，若用didSelectRowAtIndexPath 则不会响应，因为父视图先响应。
-(void)pushToChooseDecorateMarkVC:(UITapGestureRecognizer*)Sender{
    
    ChooseDecorateMarkViewController * chooseVC = [[ChooseDecorateMarkViewController alloc]init];
    chooseVC.selecttitles =[NSMutableArray arrayWithArray:self.selectedMarkArr];
    chooseVC.diaryType = self.diaryType1;
//    UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:chooseVC];
    CATransition *animation = [CATransition animation];
    animation.duration = .3;
 
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
  
    [self presentViewController:chooseVC animated:NO completion:nil];
    
}


- (void)releaseNewDiary:(UIButton *)sender{
    
    if ([self checkWeatherCanRelease:sender]==NO) {
        
        return ;
    }
    
     sender.tag = 200;
    
    NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
    
    NSMutableDictionary *bodyDic =[NSMutableDictionary dictionary];
    [bodyDic setObject:@"" forKey:@"siteDiaryId"];
    if (self.diaryType1==1) {
            [bodyDic setObject:self.textfield.text forKey:@"diaryTitle"];
    }else{
       
    }
    
    NSMutableString *sendString = [NSMutableString string];
    for(int i=0;i<self.textView.text.length;i++){
        if(self.textView.text.length>=2 && i<=self.textView.text.length-2){
            if ([[Emoji allEmoji] containsObject:[self.textView.text substringWithRange:NSMakeRange(i, 2)]]) {
                [sendString appendString:[Emoji GetToEmojiUnicode:[self.textView.text substringWithRange:NSMakeRange(i, 2)]]];
                i+=1;
            }
            else{
                [sendString appendString:[self.textView.text substringWithRange:NSMakeRange(i, 1)]];
            }
        }
        else{
            [sendString appendString:[self.textView.text substringWithRange:NSMakeRange(i, 1)]];
        }
    }
        [bodyDic setObject:sendString forKey:@"diaryContext"];
  
    NSString *diaryLableIds =[NSString string];
    if (self.selectedMarkArr.count>0) {
        for (NSString *str in self.selectedMarkArr) {
            if (diaryLableIds.length ==0) {
                diaryLableIds =[diaryLableIds stringByAppendingFormat:@"%d",[str intValue]+1];
            }else{
                diaryLableIds =[diaryLableIds stringByAppendingFormat:@",%d",[str intValue]+1];
            }
            
        }
    }
    [bodyDic setObject:diaryLableIds forKey:@"diaryLableIds"];
    [bodyDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:User_roleId]  forKey:@"roleId"];
    if (self.photoURL.count<=0) {//写新帖
        if (self.diaryType1==1){
            [bodyDic setObject:[NSNumber numberWithInt:1] forKey:@"diaryType"];
        }else{
            [bodyDic setObject:[NSNumber numberWithInt:2] forKey:@"diaryType"];
        }
    }else{//再次编辑帖子
        [bodyDic setObject:[NSNumber numberWithInt:1] forKey:@"diaryType"];
    }
    NSString *oldPicPath =[NSString string];
    if (self.deleteImages.count>0) {
        int count =0;
        for (NSString *photoURL in self.deleteImages) {
            if (count==0) {
                oldPicPath =[oldPicPath stringByAppendingFormat:@"%@",photoURL];
            }else{
                oldPicPath =[oldPicPath stringByAppendingFormat:@",%@",photoURL];
            }
        }
        count ++;
    }
    [bodyDic setObject:oldPicPath forKey:@"oldPicPath"];
    if (self.diaryId>0) {
        [bodyDic setObject:[NSNumber numberWithInt:self.diaryId] forKey:@"diaryId"];
    }

    [self.addImages removeAllObjects];
    
    if (self.addPhotoView.photos.count==0) {
        self.addImages =nil;
    }else{
        for (id photo in self.addPhotoView.photos)
            if ([photo isKindOfClass:[UIImage class]]) {
                NSData *data1 = UIImageJPEGRepresentation(photo,0.01);
                NSLog(@"%d",(int)data1.length);
//                UIImage  * photo1  = [UIImage imageWithData:data1];
                [self.addImages addObject:photo];
            }
    }
           [self startMBProgressHUDWithString:@"连接中..."];
        __weak  typeof(self) weakself =self;
        [self sendRequestImagesToServerUrl:^(id responseObject){
            [weakself stopMBProgressHUD];
            [weakself performSelector:@selector(PushViewController:) withObject:responseObject afterDelay:0.5];
            
        }failedBlock:^(id responseObject){
            [weakself stopMBProgressHUD];
            [util showError:responseObject];

            sender.enabled =YES;
        }
                                RequestUrl:url CmdID:@"ID0279" PostDict:bodyDic PostImages:self.addImages UploadImageKey:@"filedata" Progress:YES];
  }
   

    
-(void)PushViewController:(id)responseObject{
    if([[responseObject objectForKey:@"resCode"] integerValue]==10002){
        [self loginViewShow];
        UIButton * button = [self.view viewWithTag:200];
        button.enabled = YES;
    }
    else if ([[responseObject objectForKey:@"resCode"] integerValue]==102791) {
        [TLToast showWithText:@"发布帖子成功"];
        if (self.useType==1) {
            if (self.diaryId>0) {//编辑已发的帖子
            [self.navigationController popViewControllerAnimated:YES];
            }else{//添加新的
            [[NSNotificationCenter defaultCenter]postNotificationName:@"popToLastViewController" object:@"123"];
            }
      }
    }else {
        [TLToast showWithText:@"发布帖子失败"];
        UIButton * button = [self.view viewWithTag:200];
        button.enabled = YES;
    }

}



#pragma mark addPhotoViewDelegate

-(void)addPhotoCount:(NSInteger)count
{
     NSLog(@"diaryType110=========%ld",self.diaryType1);
    [self hideKeyBoard];
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
            if (self.photocount ==0) {//?
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
            if (self.photocount ==0) {//?
                [TLToast showWithText:@"最多允许上传9张图片"];
                return;
            }
               QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
               imagePickerController.delegate = self;
               imagePickerController.allowsMultipleSelection = YES;
            
               imagePickerController.limitsMaximumNumberOfSelection = YES;
               imagePickerController.maximumNumberOfSelection = self.photocount;
            
               UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
                      [self presentViewController:navigationController animated:YES completion:nil];
               NSLog(@"diaryType1=========%ld",self.diaryType1);
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
     __weak  typeof(self) weakself =self;
    sharedetail.selectDone =^(NSMutableArray *photosArray){
        for (NSString *photo in self.photoURL) {
            if (![photosArray containsObject:photo]) {
                [weakself.deleteImages addObject:photo];
            }
        }
        [weakself.addPhotoView setPhotos:photosArray];
        [weakself.tableView reloadData];
    };
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
   
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

    CATransition *animation = [CATransition animation];
    animation.duration = .3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    [imagePickerController.view.window.layer addAnimation:animation forKey:nil];
    __weak  typeof(self) weakself =self;
    [imagePickerController dismissViewControllerAnimated:NO completion:^{
                UISegmentedControl *segment =(UISegmentedControl *)[weakself.navigationController.navigationBar viewWithTag:100];
                segment.hidden =YES;
        
        [segment removeFromSuperview];
    }];
//    [imagePickerController dismissViewControllerAnimated:YES completion:^{
//        UISegmentedControl *segment =(UISegmentedControl *)[self.navigationController.navigationBar viewWithTag:100];
//        segment.hidden =YES;
//        
//        
//                [segment removeFromSuperview];
//    }];
     NSLog(@"diaryType2=========%ld",self.diaryType1);
    [self.tableView reloadData];
    
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    CATransition *animation = [CATransition animation];
    animation.duration = .3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [imagePickerController.view.window.layer addAnimation:animation forKey:nil];
     __weak  typeof(self) weakself =self;
    [imagePickerController dismissViewControllerAnimated:NO completion:^{
        UISegmentedControl *segment =(UISegmentedControl *)[weakself.navigationController.navigationBar viewWithTag:100];
        segment.hidden =YES;
        
        [segment removeFromSuperview];
    }];

//    [imagePickerController dismissViewControllerAnimated:YES completion:^{
//        UISegmentedControl *segment =(UISegmentedControl *)[self.navigationController.navigationBar viewWithTag:100];
//        segment.hidden =YES;
//        //        [segment removeFromSuperview];
//    }];
    
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
    return [NSString stringWithFormat:@"图片%lu张", (unsigned long)numberOfPhotos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"视频%lu", (unsigned long)numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"图片%lu 视频%lu", (unsigned long)numberOfPhotos, (unsigned long)numberOfVideos];
}
//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if (alertView.tag==50) {//返回提醒alert
//        if (buttonIndex==0) {
//            
//        }else{
//          [[NSNotificationCenter defaultCenter]postNotificationName:@"popToLastViewController" object:@"123"];
//        }
//    }
//    
//}
-(void)backpopView{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textViewDidBeginEditing:(UITextView *)textView;{}


-(void)textOFTextFieldDidChange:(NSNotification*)notiy{
    if (self.textfield.text.length>25) {
        [self.textfield endEditing:YES];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
 
    if (textView.text.length==0) {
        self.placeholderLab.hidden = NO;
    }else{
        self.placeholderLab.hidden = YES;
    
    }
    if (textView.text.length>500) {
        [self.textView endEditing:YES];
    }
}
//检测标题长度是否超出限制
-(void)textfielddDidChange:(UITextField*)textfield{
    if (textfield==self.textfield) {
        if (textfield.text.length > 25) {
            textfield.text =[textfield.text substringToIndex:25];
            [TLToast showWithText:@"输入标题长度已超出限制"];
        }
    }
}


-(void)hideKeyBoard{
    
    [self.textfield resignFirstResponder];
    [self.textView resignFirstResponder];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}




@end
