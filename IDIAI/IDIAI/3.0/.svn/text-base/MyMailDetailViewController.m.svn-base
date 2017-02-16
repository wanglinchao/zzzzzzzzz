//
//  MyMailDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 16/5/11.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyMailDetailViewController.h"
#import "DiaryPhotosCell.h"
#import "LoginView.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "MailDetailObject.h"
#import "TLToast.h"
#import "UIImageView+OnlineImage.h"
#import "IDIAIAppDelegate.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+WebCache.h"
@interface MyMailDetailViewController ()<UITableViewDataSource,UITableViewDelegate,DiaryPhotosCellDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)MailDetailObject *mailDetail;
@end

@implementation MyMailDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"详情";
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
//    self.mailDetail =[[MailDetailObject alloc] init];
    self.view.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.table =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    self.table.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
    self.table.dataSource=self;
    self.table.delegate=self;
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 27)];
    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    UILabel *datelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 6.5, kMainScreenWidth-30, 14)];
    datelbl.textColor =[UIColor colorWithHexString:@"#575757"];
    datelbl.font =[UIFont systemFontOfSize:14];
    datelbl.text =@"2016.04.05 14:00";
    [backView addSubview:datelbl];
    self.table.tableHeaderView =backView;
    [self.view addSubview:self.table];
    [self requestMaillDetail];
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
    [appDelegate.nav setNavigationBarHidden:YES animated:NO];
}
-(void)requestMaillDetail{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0366\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"roleId\":7,\"actionType\":%d,\"mailId\":%d}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(int)self.actionType,self.mailid];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"信息详情返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                //token为空或验证未通过处理 huangrun
                if (code == 10002 || code == 10003) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                    });
                }
                else if (code==103661) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSDictionary *arr_=[jsonDict objectForKey:@"mailInfo"];
//                        if ([arr_ count]) {
//                            for(NSDictionary *dict in arr_){
                                DCParserConfiguration *config = [DCParserConfiguration configuration];
                                DCArrayMapping *arrayMapping = [DCArrayMapping mapperForClassElements:[MailUserInfoObject class] forAttribute:@"recvUserInfos" onClass:[MailDetailObject class]];
                                [config addArrayMapper:arrayMapping];
                                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[MailDetailObject class] andConfiguration:config];
                                MailDetailObject *mailDetail =[parser parseDictionary:arr_];
                                self.mailDetail =mailDetail;
//                            }
//                        }
                        
                        [self.table reloadData];
                        
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"获取失败"];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                              });
                          }
                               method:url postDict:nil];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mailDetail) {
        return 3;
    }else{
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        return 53;
    }else if (indexPath.row ==1){
        CGSize labelsize1 = [util calHeightForLabel:self.mailDetail.mailContent width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:18]];
        return 30+self.mailDetail.recvUserInfos.count*29+labelsize1.height+25;
    }else{
        NSString *const cellidentifier = [NSString stringWithFormat:@"diaryphoto%d",(int)indexPath.row];
        DiaryPhotosCell *cell = (DiaryPhotosCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (!cell) {
            cell = [[DiaryPhotosCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
        }
        cell.pics =self.mailDetail.maillAttchments;
        return [cell getCellHeight]+10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        static NSString *CellIdentifier1 = @"MessageCell";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell1) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            
            UIImageView *logoimage =[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 36, 36)];
            //    photo.tag=KButtonTag_phone*2+indexPath.section;
            logoimage.layer.cornerRadius=18;
            logoimage.clipsToBounds=YES;
            logoimage.image =[UIImage imageNamed:@"ic_touxiang_tk"];
            logoimage.tag =1000;
            [cell1.contentView addSubview:logoimage];
            
            UILabel *namelbl =[[UILabel alloc] initWithFrame:CGRectMake(logoimage.frame.origin.x+logoimage.frame.size.width+11, 19, kMainScreenWidth-36-30, 18)];
            //        namelbl.text =@"张三[工长]";
            namelbl.textColor =[UIColor colorWithHexString:@"#575757"];
            namelbl.font =[UIFont systemFontOfSize:18];
            namelbl.tag =1001;
            [cell1.contentView addSubview:namelbl];
            
            UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(10, 52, kMainScreenWidth-20, 1)];
            lineView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
            [cell1.contentView addSubview:lineView];
            
            UILabel *statuslbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-100, 17, 80, 14)];
            statuslbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
            statuslbl.font =[UIFont systemFontOfSize:14];
            statuslbl.tag =1002;
            statuslbl.textAlignment =NSTextAlignmentRight;
            [cell1.contentView addSubview:statuslbl];
        }
        UILabel *namelbl =[cell1.contentView viewWithTag:1001];
        if (self.mailDetail.sendRoleId ==1) {
            namelbl.text =[NSString stringWithFormat:@"%@[设计师]",self.mailDetail.sendUserName];
        }else if (self.mailDetail.sendRoleId ==4){
            namelbl.text =[NSString stringWithFormat:@"%@[工长]",self.mailDetail.sendUserName];
        }else if (self.mailDetail.sendRoleId ==6){
            namelbl.text =[NSString stringWithFormat:@"%@[第三方监理]",self.mailDetail.sendUserName];
        }else if (self.mailDetail.sendRoleId ==7){
            namelbl.text =[NSString stringWithFormat:@"%@[业主]",self.mailDetail.sendUserName];
        }if (self.mailDetail.sendRoleId ==9){
            namelbl.text =[NSString stringWithFormat:@"%@[平台监理]",self.mailDetail.sendUserName];
        }else{
            namelbl.text =[NSString stringWithFormat:@"%@",self.mailDetail.sendUserName];
        }
        UIImageView *logoimage =[cell1.contentView viewWithTag:1000];
        if (self.actionType ==1) {
            if (self.mailDetail.sendRoleId==7) {
                logoimage.image =[UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[self.mailDetail.userLogo stringByReplacingOccurrencesOfString:@"\n" withString:@""]  options:NSDataBase64DecodingIgnoreUnknownCharacters]];
            }else{
                [logoimage setOnlineImage:self.mailDetail.userLogo placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
            }
        }else{
//            NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
//            UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
//            logoimage.image =imgFromUrl3;            
            [logoimage sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:User_logo]] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
        }
        
        cell1.selectionStyle =UITableViewCellSelectionStyleNone;
        if (self.actionType ==1) {
            UILabel *statuslbl =[cell1.contentView viewWithTag:1002];
            statuslbl.text =self.mailDetail.stateName;
        }else{
            UILabel *statuslbl =[cell1.contentView viewWithTag:1002];
            statuslbl.text=@"";
        }
        return cell1;
    }else if (indexPath.row==1){
        static NSString *CellIdentifier1 = @"ContentCell";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell1) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            UILabel *headerlbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 18)];
            headerlbl.textColor =[UIColor colorWithHexString:@"#575757"];
            headerlbl.font =[UIFont systemFontOfSize:18];
            headerlbl.text =@"收件人:";
            [cell1.contentView addSubview:headerlbl];
            int tagCount =0;
            for (int i=0; i<self.mailDetail.recvUserInfos.count; i++) {
                UILabel *recipientlbl =[[UILabel alloc] initWithFrame:CGRectMake(80, 15+29*i, kMainScreenWidth-180, 18)];
                recipientlbl.textColor =[UIColor colorWithHexString:@"#575757"];
                recipientlbl.font =[UIFont systemFontOfSize:16];
                recipientlbl.tag =1000+tagCount;
                tagCount++;
                [cell1.contentView addSubview:recipientlbl];
                
                UILabel *statuslbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-100, 17+27*i, 80, 14)];
                statuslbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
                statuslbl.font =[UIFont systemFontOfSize:14];
                statuslbl.tag =1000+tagCount;
                statuslbl.textAlignment =NSTextAlignmentRight;
                tagCount++;
                [cell1.contentView addSubview:statuslbl];
            }
            CGSize labelsize1 = [util calHeightForLabel:self.mailDetail.mailContent width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:18]];
            UILabel *contentlbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 15+self.mailDetail.recvUserInfos.count*29, labelsize1.width, labelsize1.height)];
            contentlbl.numberOfLines =0;
            contentlbl.tag =900;
            contentlbl.textColor =[UIColor colorWithHexString:@"#575757"];
            contentlbl.font =[UIFont systemFontOfSize:18];
            [cell1.contentView addSubview:contentlbl];
            
        }

        int tagCount =0;
        NSString *namecontentstr =@"";
        for (MailUserInfoObject *userinfo in self.mailDetail.recvUserInfos) {
            UILabel *recipientlbl =[cell1.contentView viewWithTag:1000+tagCount];
            tagCount++;
            if (userinfo.roleId ==1) {
                namecontentstr =[NSString stringWithFormat:@"%@[设计师]",userinfo.userName];
            }else if (userinfo.roleId ==4){
                namecontentstr =[NSString stringWithFormat:@"%@[工长]",userinfo.userName];
            }else if (userinfo.roleId ==6){
                namecontentstr =[NSString stringWithFormat:@"%@[第三方监理]",userinfo.userName];
            }else if (userinfo.roleId ==7){
                namecontentstr =[NSString stringWithFormat:@"%@[业主]",userinfo.userName];
            }else if (userinfo.roleId ==9){
                namecontentstr =[NSString stringWithFormat:@"%@[平台监理]",userinfo.userName];
            }else{
                namecontentstr =[NSString stringWithFormat:@"%@",userinfo.userName];
            }
            recipientlbl.text =namecontentstr;
//            if (i ==0) {
//                recipientlbl.text =@"李四[业主]";
//            }else{
//                recipientlbl.text =@"张忠龙[业主]";
//            }
            if (self.actionType ==1) {
//                if (tagCount ==1) {
//                    UILabel *statuslbl =[cell1.contentView viewWithTag:1000+tagCount];
//                    tagCount++;
//                    statuslbl.text =self.mailDetail.stateName;
//                }else{
                    tagCount++;
//                }
            }else{
                UILabel *statuslbl =[cell1.contentView viewWithTag:1000+tagCount];
                tagCount++;
                statuslbl.text =userinfo.stateName;
            }
            
        }
        UILabel *contentlbl =[cell1.contentView viewWithTag:900];
        contentlbl.text =self.mailDetail.mailContent;
        cell1.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell1;
    }else{
        NSString *const cellidentifier = [NSString stringWithFormat:@"diaryphoto%d",(int)indexPath.row];
        DiaryPhotosCell *cell = (DiaryPhotosCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (!cell) {
            cell = [[DiaryPhotosCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellidentifier];
        }
        cell.delegate =self;
        cell.pics =self.mailDetail.maillAttchments;
        [cell getCellHeight];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)reloadCell{
    [self.table reloadData];
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
