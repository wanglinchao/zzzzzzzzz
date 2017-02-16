//
//  SettingViewController.m
//  IDIAI
//
//  Created by PM on 16/6/12.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SettingViewController.h"
#import "EmptyClearTableViewCell.h"
#import "UIImageView+LBBlurredImage.h"
#import "ModifyPsdViewController.h"
#import "InputLoginPsdViewController.h"
#import "RMTickerView.h"
#import "TLToast.h"
#import "RetroactionVC.h"
#import "AboutSelfViewController.h"
#import "IMMessageSoundSettingViewController.h"
#import "util.h"

@interface SettingViewController ()<UIAlertViewDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIActivityIndicatorView * activityIndicatorView ;
@property(nonatomic,assign)NSInteger numberOfSection;
@property(nonatomic,strong)UIImageView * barView;
@property(nonatomic,strong)UILabel * nav_title;
@property(nonatomic,strong)UIView * line_bar;

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    
    //获取缓存大小
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat catchSizeFloat = [self folderSizeAtPath:cachePath];
    UITableViewCell *cell = (UITableViewCell *)[self.view viewWithTag:101];
    UILabel *lab_ = (UILabel *)[cell viewWithTag:1000];
    lab_.text = [NSString stringWithFormat:@"%.2fM",catchSizeFloat];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavgationBar];
    //检测用户是否登陆了
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:User_Token]length]) {
      // 用户未登录
        self.numberOfSection = 2;
    }else{
    //用户已登录
        self.numberOfSection = 4 ;
    
    }
    self.title = @"设置";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.frame = CGRectMake(kMainScreenWidth - 50, 12, _activityIndicatorView.bounds.size.width, _activityIndicatorView.bounds.size.height);
    


}


-(void)createNavgationBar{
    self.barView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    
    [self.barView setImageToBlur:[util imageWithColor:[UIColor whiteColor]]
                 blurRadius:kLBBlurredImageDefaultBlurRadius
            completionBlock:^(NSError *error){
            }];
    self.barView.alpha=0;
    [self.view addSubview:self.barView];
    
    self.nav_title = [[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-80)/2, 30, 80, 20)];
    self.nav_title.textColor = mainHeadingColor;
    self.nav_title.font = [UIFont systemFontOfSize:20];
    self.nav_title.textAlignment=NSTextAlignmentCenter;
    self.nav_title.text = @"设置";
    [self.barView addSubview:self.nav_title];
    
    self.line_bar=[[UIView alloc]initWithFrame:CGRectMake(0, 63.5, kMainScreenWidth, 0.5)];
    self.line_bar.backgroundColor=[UIColor clearColor];
    [self.barView addSubview:self.line_bar];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }

-(void)showCacheWithCell:(EmptyClearTableViewCell*)cell{
    cell.tag=101;
    //获取缓存大小
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat catchSizeFloat = [self folderSizeAtPath:cachePath];
    
    UILabel *huanc_lab = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth- 110, 15, 80, 20)];
    huanc_lab.tag=1000;
    huanc_lab.textColor = kThemeColor;
    huanc_lab.font = [UIFont systemFontOfSize:16];
    huanc_lab.textAlignment=NSTextAlignmentRight;
    huanc_lab.text = [NSString stringWithFormat:@"%.2fM",catchSizeFloat];
    [cell addSubview:huanc_lab];


}

#pragma mark - 获取缓存大小 清理缓存

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

//  带动画的清理缓存
-(void)clearCacheWithAnimationAndWithTableView:(UITableView*)tableView AndIndexPath:(NSIndexPath*)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"indexPath=========================%@",indexPath);
    cell.tag = 101;
    //            [self showActivityIndicatorView];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fromValue=[NSNumber numberWithFloat:0.0];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [cell.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self resumeLayer:cell.imageView.layer];
    [self performSelector:@selector(clearCache) withObject:nil afterDelay:3.0];



}


//清理缓存
- (void)clearCache {
    NSLog(@"la啦啦啦啦啦啊啦啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊");
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%ld",(long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [[NSURLCache sharedURLCache] removeAllCachedResponses];//清除h5缓存
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}

-(void)clearCacheSuccess
{
    //获取缓存大小
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat catchSizeFloat = [self folderSizeAtPath:cachePath];
    UITableViewCell *cell = (UITableViewCell *)[self.view viewWithTag:101];
    UILabel *lab_ = (UILabel *)[cell viewWithTag:1000];
    lab_.text = [NSString stringWithFormat:@"%.2fM",catchSizeFloat];
    lab_.textColor = kThemeColor;
    
    //    [_activityIndicatorView stopAnimating];
    [self pauseLayer:cell.imageView.layer];
    [TLToast showWithText:@"清理缓存成功" duration:1];
}
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 0.0 ];
    rotationAnimation.duration = 0.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    
    [layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark - 退出登录
- (void)clickLogoutBtn:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定退出当前账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.delegate=self;
    [alertView show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        
    }
    if (buttonIndex==1) {
        [util utopLoginOut];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



#pragma - mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  self.numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.numberOfSection==4) {
        if (section==3) {
            return 1;
        }
  
    }
    if (self.numberOfSection == 2) {
        if (section == 0) {
            return 2;
        }
    }
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellid=@"mycellid";
    EmptyClearTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"EmptyClearTableViewCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
   
    // 未登录
    if (self.numberOfSection==2) {
        NSArray *cellImageArr = @[@[@"ic_xiaoxi_u",@"ic_hc"],@[@"ic_fk",@"ic_gy"]];
        NSArray *cellNameArr = @[@[@"新消息通知",@"清理缓存"],@[@"投诉反馈",@"关于我们"]];
        cell.imageView.image = [UIImage imageNamed:[[cellImageArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
        cell.textLabel.text = [[cellNameArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section==0&&indexPath.row==1) {
        [self showCacheWithCell:cell];
        }
    }
    //登录了
    if (self.numberOfSection == 4) {
        if (indexPath.section<3) {
            NSArray *cellImageArr = @[@[@"ic_mm.png",@"ic_zhifumima.png"],@[@"ic_xiaoxi_u",@"ic_hc"],@[@"ic_fk",@"ic_gy"]];
            NSArray *cellNameArr = @[@[@"修改登录密码",@"修改支付密码"],@[@"新消息通知",@"清理缓存"],@[@"投诉反馈",@"关于我们"]];
            cell.imageView.image = [UIImage imageNamed:[[cellImageArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
            cell.textLabel.text = [[cellNameArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.section==1&&indexPath.row==1) {
                [self showCacheWithCell:cell];
            }
        }
        else{
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,kMainScreenWidth, CGRectGetHeight(cell.frame))];
            NSLog(@"============%f,%f",label.frame.size.width,label.frame.size.height);
            label.textColor = emphasizeTextColor;
            label.text = @"退出登录";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
        
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   //未登录
    if (self.numberOfSection==2) {
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                IMMessageSoundSettingViewController *  IMMessageSoundSettingVC =[[IMMessageSoundSettingViewController alloc]init];
                [self.navigationController pushViewController:IMMessageSoundSettingVC animated:YES];
            } else {
              [self clearCacheWithAnimationAndWithTableView:tableView AndIndexPath:indexPath];
            }
          
        }
        else if(indexPath.section==1){
            if (indexPath.row==0) {
                UIStoryboard * mainSB  = [UIStoryboard storyboardWithName:@"ZL" bundle:nil];
                RetroactionVC *retroactionVC = [mainSB instantiateViewControllerWithIdentifier:@"RetroactionVC"];
                retroactionVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:retroactionVC animated:YES];
            }else{
                AboutSelfViewController *aboutUsVC = [[AboutSelfViewController alloc]init];
                aboutUsVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutUsVC animated:YES];
            }
        }
        else {
            [self clickLogoutBtn:nil];
        }
    }

    //已经登录
    if (self.numberOfSection==4) {
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                ModifyPsdViewController *modifyPsdVC = [[ModifyPsdViewController alloc]init];
                [self.navigationController pushViewController:modifyPsdVC animated:YES];
            }
            else{
                InputLoginPsdViewController *inputLoginPsdVC = [[InputLoginPsdViewController alloc]init];
                [self.navigationController pushViewController:inputLoginPsdVC animated:YES];
            }
        }else if(indexPath.section == 1){
            if (indexPath.row==0) {
                IMMessageSoundSettingViewController *  IMMessageSoundSettingVC =[[IMMessageSoundSettingViewController alloc]init];
                [self.navigationController pushViewController:IMMessageSoundSettingVC animated:YES];
            } else {
                [self clearCacheWithAnimationAndWithTableView:tableView AndIndexPath:indexPath];
            }
         
        } else if (indexPath.section == 2){
            if (indexPath.row==0) {
                UIStoryboard * mainSB  = [UIStoryboard storyboardWithName:@"ZL" bundle:nil];
                RetroactionVC *retroactionVC = [mainSB instantiateViewControllerWithIdentifier:@"RetroactionVC"];                [self.navigationController pushViewController:retroactionVC animated:YES];
            }else{
                AboutSelfViewController *aboutUsVC = [[AboutSelfViewController alloc]init];
                aboutUsVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutUsVC animated:YES];
            }
        
        }else {
            [self clickLogoutBtn:nil];
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 1;
}



#pragma - mark UITableViewDelegate





@end
