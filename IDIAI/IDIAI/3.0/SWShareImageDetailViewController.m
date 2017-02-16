//
//  SWShareImageDetailViewController.m
//  SubWayWifi
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SWShareImageDetailViewController.h"
#import "KL_ImagesZoomController.h"
@interface SWShareImageDetailViewController ()<KL_ImagesZoomControllerDelegate>
@property(nonatomic,strong)KL_ImagesZoomController *imgDetail;
@property(nonatomic,assign)BOOL ishide;
@end

@implementation SWShareImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.title =[NSString stringWithFormat:@"%d/%d",self.index+1,(int)self.photos.count];
    self.imgDetail = [[KL_ImagesZoomController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)imgViewSize:CGSizeZero];
    self.imgDetail.delegate =self;
    [self.view addSubview:self.imgDetail];
    [self.imgDetail updateImageDate:self.photos selectIndex:self.index];
    self.ishide =YES;
    self.navigationController.navigationBarHidden =NO;
    self.navigationController.navigationBar.barTintColor =[UIColor blackColor];
    self.navigationController.navigationBar.backgroundColor =[UIColor blackColor];
     UIColor * color = [UIColor whiteColor];
     NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
     self.navigationController.navigationBar.titleTextAttributes = dict;
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"<", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    self.navigationItem.leftBarButtonItem.tintColor =[UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = backButton;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    leftButton.tag=1;
    [leftButton setImage:[UIImage imageNamed:@"ic_fh.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 50);
    
    [leftButton addTarget:self
                   action:@selector(doneButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(5, 5, 40, 40)];
    [rightButton setImage:[UIImage imageNamed:@"ic_sjanchu.png"] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rightButton addTarget:self
                    action:@selector(deleteImage:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    [self.navigationItem setRightBarButtonItem:rightItem];
//    UIBarButtonItem *deteleButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"删除", nil) style:UIBarButtonItemStylePlain target:self action:@selector(deleteImage:)];
//    self.navigationItem.rightBarButtonItem = deteleButton;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - KL_ImagesZoomControllerDelegate
-(void)tapImage{
//    self.ishide =!self.ishide;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.35];
//    if (self.ishide) {
//        self.navigationController.navigationBarHidden =YES;
//        //        [self.navigationController.navigationBar setAlpha:0];
//    }else{
//        self.navigationController.navigationBarHidden =NO;
//        //        [self.navigationController.navigationBar setAlpha:1];
//    }
//    [UIView commitAnimations];
}
-(void)deleteImage:(NSInteger)imagecount{
    [self.photos removeObjectAtIndex:self.imgDetail.imagecount];
    self.selectDone(self.photos);
 
    [self dismissViewControllerAnimated:YES completion:^{
     
    }];


}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.imgDetail removeFromSuperview];
}
- (void)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)changeImageRow:(NSInteger)imagecount{
    self.title =[NSString stringWithFormat:@"%d/%d",(int)imagecount+1,(int)self.photos.count];
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
