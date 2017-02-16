//
//  ChooseDecorateMarkViewController.m
//  IDIAI
//
//  Created by PM on 16/7/14.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ChooseDecorateMarkViewController.h"

@interface ChooseDecorateMarkViewController ()

@end

@implementation ChooseDecorateMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0,0, kMainScreenWidth, kMainScreenHeight-20);
    UIView * customStatusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenHeight, 20)];
    [self.view addSubview:customStatusBar];
    customStatusBar.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    UIView * customNavigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 44)];
    customNavigationBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:customNavigationBar];
    UILabel * customTitleLab  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,80,40)];
    CGPoint center = {customNavigationBar.center.x,22};
    customTitleLab.center = center;
    [customNavigationBar addSubview:customTitleLab];
     customTitleLab.text = @"选择分类";
     customTitleLab.font  = [UIFont systemFontOfSize:19];
    
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createMarks];
    self.theBackButton = [[UIButton alloc]initWithFrame:CGRectMake(7,7,30,30)];
    [customNavigationBar addSubview:self.theBackButton];
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
    [self.theBackButton addTarget:self action:@selector(goBackToLastVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createMarks{
    
    self.titleArray =@[@"装前准备",@"前期设计",@"主体拆改",@"水电改造",@"泥木施工",@"墙面地板",@"成品安装",@"软饰搭配",@"经验总结"];
    int count =0;
    int countx =0;
    int county =0;
    for (NSString *title in self.titleArray) {
        UIButton *titlebtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [titlebtn setTitle:title forState:UIControlStateNormal];
        [titlebtn setTitle:title forState:UIControlStateSelected];
        [titlebtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:UIControlStateNormal];
        [titlebtn setTitleColor:[UIColor colorWithHexString:@"#ef6562"] forState:UIControlStateSelected];
        titlebtn.layer.masksToBounds = YES;
        titlebtn.layer.cornerRadius = 10;
        titlebtn.layer.borderColor =[UIColor colorWithHexString:@"#a0a0a0"].CGColor;
        titlebtn.layer.borderWidth = 1;
        titlebtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        titlebtn.frame =CGRectMake(16+((kMainScreenWidth-32-216)/2+72)*countx, 25+33*county+64, 72, 22);
        [titlebtn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.selecttitles containsObject:[NSString stringWithFormat:@"%d",count]]) {
            titlebtn.selected =YES;
        }
        titlebtn.tag =1000+count;
        count++;
        countx++;
        if (countx%3==0) {
            countx=0;
            county++;
        }
        [self.view addSubview:titlebtn];
    }

}

-(void)titleAction:(UIButton *)sender{
    sender.selected =!sender.selected;
    if (sender.selected ==YES) {
        [self.selecttitles addObject:[NSString stringWithFormat:@"%d",(int)sender.tag-1000]];
    }else{
        [self.selecttitles removeObject:[NSString stringWithFormat:@"%d",(int)sender.tag-1000]];
    }
 
}

- (void)goBackToLastVC:(UIButton*)sender{
    sender.enabled = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseDecorateMarks" object:nil userInfo:@{@"Marks":self.selecttitles,@"diaryType":[NSString stringWithFormat:@"%ld",(long)self.diaryType]}];
    CATransition *animation = [CATransition animation];
    animation.duration = .3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];

}



@end
