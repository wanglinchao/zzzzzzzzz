//
//  IWantDecoViewController.m
//  IDIAI
//
//  Created by iMac on 15-7-2.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IWantDecoViewController.h"
#import "util.h"
#import "DecorateViewController.h"
#import "MyhouseTypeVC.h"
#import "KnowledgeViewController.h"
#import "WorkerListViewController.h"
#import "MyeffectypictureVC.h"
#import "LearnDecorViewController.h"
#import "IDIAIAppDelegate.h"

@interface IWantDecoViewController ()
{
    UIScrollView *scr;
    
    NSTimer *timer;
    NSInteger j;
    UITapGestureRecognizer *tap;
}

@property (nonatomic,strong) UIButton *btn_Decor;

@end

@implementation IWantDecoViewController

- (void)customizeNavigationBar {
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:[UIColor colorWithHexString:@"#E0E0E0" alpha:1.0]];
    self.navigationController.navigationBar.translucent = YES;

    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);//修复点击其余选项卡导致关于cell不能点击的问题 huangrun
    [self customizeNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title = @"我要装";
    
    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"ic_fh.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    if(!scr) scr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    if(kMainScreenHeight>568) scr.contentSize=CGSizeMake(kMainScreenWidth, kMainScreenHeight-40);
    else scr.contentSize=CGSizeMake(kMainScreenWidth, kMainScreenHeight+30);
    scr.showsHorizontalScrollIndicator=NO;
    scr.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scr];
    
    j=0;
    timer=[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(LoadMenu) userInfo:nil repeats:YES];
    
    //防止透明提示层未显示完成，就切换tabbar按钮
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:kXueZhuangXiu_End] isEqualToString:@"YES"]){
        tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired=1;
        tap.numberOfTouchesRequired=1;
        [self.tabBarController.tabBar addGestureRecognizer:tap];
    }
}

-(void)tap:(UIGestureRecognizer *)gesture{
    
}

-(void)LoadMenu{
    NSArray *icon_arr=[NSArray arrayWithObjects:@"ic_fangan_",@"ic_fengge_",@"ic_zhaobiao_",@"ic_yusuan_",@"ic_zhishi_",@"ic_xiaogong_", nil];
    NSArray *title_arr=[NSArray arrayWithObjects:@"装修方案",@"选风格",@"装修招标",@"做预算",@"装修知识",@"找小工", nil];
    if(j<6){
        UIImageView *icon=(UIImageView *)[scr viewWithTag:1000+j];
        if(!icon) icon=[[UIImageView alloc]init];
        icon.tag=1000+j;
        if(kMainScreenWidth>375)
            icon.frame=CGRectMake(80*(j%2)+((j%2)*2+1)*(kMainScreenWidth-160)/4,50+j/2*200, 80, 80);
        else if(kMainScreenWidth>320 && kMainScreenWidth<=375)
            icon.frame=CGRectMake(75*(j%2)+((j%2)*2+1)*(kMainScreenWidth-150)/4,45+j/2*180, 75, 75);
        else
            icon.frame=CGRectMake(70*(j%2)+((j%2)*2+1)*(kMainScreenWidth-140)/4,40+j/2*150, 70, 70);
        icon.image=[UIImage imageNamed:[icon_arr objectAtIndex:j]];
        [scr addSubview:icon];
    
        UILabel *title_lab=(UILabel *)[scr viewWithTag:2000+j];
        if(!title_lab) title_lab=[[UILabel alloc]init];
        title_lab.tag=2000+j;
        if(kMainScreenWidth>375)
            title_lab.frame=CGRectMake(80*(j%2)+((j%2)*2+1)*(kMainScreenWidth-160)/4, 50+j/2*200+90, 80, 20);
        else if(kMainScreenWidth>320 && kMainScreenWidth<=375)
            title_lab.frame=CGRectMake(75*(j%2)+((j%2)*2+1)*(kMainScreenWidth-150)/4, 45+j/2*180+85, 75, 20);
        else
            title_lab.frame=CGRectMake(70*(j%2)+((j%2)*2+1)*(kMainScreenWidth-140)/4, 40+j/2*150+80, 70, 20);
        title_lab.backgroundColor=[UIColor clearColor];
        title_lab.textColor=[UIColor blackColor];
        title_lab.font=[UIFont systemFontOfSize:15];
        title_lab.textAlignment=NSTextAlignmentCenter;
        title_lab.text=[title_arr objectAtIndex:j];
        [scr addSubview:title_lab];
        
        UIButton *btn=(UIButton *)[scr viewWithTag:101+j];
        if(!btn)btn=[[UIButton alloc]init];
        if(kMainScreenWidth>375)
            btn.frame=CGRectMake(80*(j%2)+((j%2)*2+1)*(kMainScreenWidth-140)/4, 50+j/2*200, 80, 110);
        else if(kMainScreenWidth>320 && kMainScreenWidth<=375)
            btn.frame=CGRectMake(75*(j%2)+((j%2)*2+1)*(kMainScreenWidth-150)/4, 45+j/2*180, 75, 110);
        else
            btn.frame=CGRectMake(70*(j%2)+((j%2)*2+1)*(kMainScreenWidth-140)/4, 40+j/2*150, 70, 110);
        btn.tag=101+j;
        [btn addTarget:self action:@selector(PressMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [scr addSubview:btn];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        // 动画选项设定
        animation.duration = 0.5; // 动画持续时间
        animation.repeatCount = 1; // 重复次数
        animation.autoreverses = YES; // 动画结束时执行逆动画
        
        // 缩放倍数
        animation.fromValue = [NSNumber numberWithFloat:1.4]; // 开始时的倍率
        animation.toValue = [NSNumber numberWithFloat:0.6]; // 结束时的倍率
        
        // 添加动画
        [icon.layer addAnimation:animation forKey:@"scale-layer"];
        [title_lab.layer addAnimation:animation forKey:@"scale-layer"];
        
        [self performSelector:@selector(dis:) withObject:[NSString stringWithFormat:@"%ld",(long)j] afterDelay:0.05];
    
//       icon.transform = CGAffineTransformMakeScale(1.2, 1.2);

    }
    else{
        [timer invalidate];
        
        [self createDecor];
        
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:kXueZhuangXiu_End] isEqualToString:@"YES"]){
            UIView *view_yd=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
            view_yd.tag=1;
            view_yd.backgroundColor=[UIColor blackColor];
            view_yd.alpha=0.1;
            [self.tabBarController.navigationController.view addSubview:view_yd];
            
            [UIView animateWithDuration:0.35 animations:^{
                view_yd.alpha=0.5;
            }completion:^(BOOL finished){
                
                UIImageView *image_tishi=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-kMainScreenWidth/2)/2, kMainScreenHeight-49-45-65, kMainScreenWidth/2, 60)];
                image_tishi.contentMode=UIViewContentModeScaleAspectFill;
                image_tishi.image=[UIImage imageNamed:@"xuezhuangxiu_yd"];
                image_tishi.alpha=0.1;
                [view_yd addSubview:image_tishi];
                
                UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth-100)/2, kMainScreenHeight-49-45, 100, 44)];
                [btn setBackgroundImage:[UIImage imageNamed:@"ic_xuezhuangxiu_normal"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"ic_xuezhuangxiu_pressed"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
                btn.alpha=0.1;
                [view_yd addSubview:btn];
                
                [UIView animateWithDuration:0.8 animations:^{
                    image_tishi.alpha=1.0;
                    btn.alpha=1.0;
                }completion:^(BOOL finished){
                    
                }];
            }];
        }
    }
    
    j++;
}
- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"动画开始");
}


-(void)dis:(NSString *) value{
    NSInteger i=[value integerValue];
    UILabel *title_lab=(UILabel *)[scr viewWithTag:2000+i];
    UIImageView *icon=(UIImageView *)[scr viewWithTag:1000+i];
    
    CABasicAnimation *animation_ = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation_.duration = 0.15; // 动画持续时间
    animation_.repeatCount = 1; // 重复次数
    animation_.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation_.fromValue = [NSNumber numberWithFloat:1.25]; // 开始时的倍率
    animation_.toValue = [NSNumber numberWithFloat:0.75]; // 结束时的倍率
    
    // 添加动画
    [title_lab.layer addAnimation:animation_ forKey:@"scale-layer"];
    [icon.layer addAnimation:animation_ forKey:@"scale-layer"];
}

- (void)PressMenuBtn:(UIButton *)sender {
    UIButton *btn = sender;
    
    MyeffectypictureVC *effectVC=[[MyeffectypictureVC alloc]init];
    DecorateViewController *decorateVC = [[DecorateViewController alloc]init];
    MyhouseTypeVC *myHouseTypeVC = [[MyhouseTypeVC alloc]init];
    KnowledgeViewController *knowledgeVC = [[KnowledgeViewController alloc]init];
    WorkerListViewController *workListVC = [[WorkerListViewController alloc]init];
    switch (btn.tag) {
        case 101:
            effectVC.picture_type=@"taotu";
            effectVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:effectVC animated:YES];
            break;
        case 102:
            effectVC.picture_type=@"dantu";
            effectVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:effectVC animated:YES];
            break;
        case 103:
            decorateVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:decorateVC animated:YES];
            break;
        case 104:
            myHouseTypeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myHouseTypeVC animated:YES];
            break;
        case 105:
            knowledgeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:knowledgeVC animated:YES];
            break;
        case 106:
            {
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            workListVC.hidesBottomBarWhenPushed = YES;
            [delegate.nav pushViewController:workListVC animated:YES];
            }
            break;
        default:
            break;
    }
}

-(void)createDecor{
    if(!self.btn_Decor) self.btn_Decor = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_Decor.frame=CGRectMake((kMainScreenWidth-100)/2, kMainScreenHeight-49-44, 100, 44);
    [self.btn_Decor setBackgroundImage:[UIImage imageNamed:@"ic_xuezhuangxiu_normal"] forState:UIControlStateNormal];
    [self.btn_Decor setBackgroundImage:[UIImage imageNamed:@"ic_xuezhuangxiu_pressed"] forState:UIControlStateHighlighted];
    [self.btn_Decor addTarget:self action:@selector(pressbtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn_Decor ];
    UIPanGestureRecognizer *pan_search = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragToSearch:)];
    [pan_search setMinimumNumberOfTouches:1];
    [pan_search setMaximumNumberOfTouches:1];
    [self.btn_Decor addGestureRecognizer:pan_search];
}

- (void)dragToSearch:(UIPanGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gr locationInView:self.view];
        if(point.x<=50) point.x=50;
        else if(point.x>=kMainScreenWidth-50) point.x=kMainScreenWidth-50;

        self.btn_Decor.center = CGPointMake(point.x, kMainScreenHeight-49-22);

        if (gr.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.18 animations:^{
                // self.btn_Decor.frame=CGRectMake(kMainScreenWidth-50,kMainScreenHeight-64-49-60, 120, 60);
            }];
        }
    }
}

-(void)pressbtn{
    LearnDecorViewController *learnVC=[[LearnDecorViewController alloc]init];
    learnVC.hidesBottomBarWhenPushed = YES;
    learnVC.fromType=@"IWantDecor";
    [self.navigationController pushViewController:learnVC animated:YES];
}

-(void)removeView{
    UIView *view=[self.tabBarController.navigationController.view viewWithTag:1];
    
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha=0.1;
    }completion:^(BOOL finished){
        [view removeFromSuperview];
        
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:kXueZhuangXiu_End] isEqualToString:@"YES"])
            [self.tabBarController.tabBar removeGestureRecognizer:tap];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kXueZhuangXiu_End];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
