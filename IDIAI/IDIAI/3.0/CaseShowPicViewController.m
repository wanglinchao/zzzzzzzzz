//
//  CaseShowPicViewController.m
//  IDIAI
//
//  Created by iMac on 16/4/7.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CaseShowPicViewController.h"
#import "MRZoomScrollView.h"
#import "util.h"

#define KUIButton_TAG 100
@interface CaseShowPicViewController ()

@property (nonatomic,strong) UILabel *lab_count;
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation CaseShowPicViewController
@synthesize data_array,pic_id,obj_effect;

-(void)dealloc{
    self.queue=nil;
}

- (NSOperationQueue *)queue {
    if (!_queue) _queue = [[NSOperationQueue alloc] init];
    //[_queue setMaxConcurrentOperationCount:5];
    return _queue;
}

-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if(self.queue.operationCount) [self.queue cancelAllOperations];
    for(MRZoomScrollView *mrscr in _scrollView.subviews) {
        [mrscr removeFromSuperview];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_scrollView setContentOffset:CGPointMake(kMainScreenWidth * pic_id, 0) animated:NO];
    for (int i = 0; i < [data_array count]; i++) {
        @autoreleasepool {
            [self downloadImg:[data_array objectAtIndex:i] index:i];
        }
    }
}

-(void)loadImageView:(UIImage *)img image:(NSInteger )i{
    MRZoomScrollView *_zoomScrollView = [[MRZoomScrollView alloc]init];
    CGRect frame = CGRectMake(0, 150, kMainScreenWidth, kMainScreenHeight);
    frame.origin.x = frame.size.width * i;
    frame.origin.y = 0;
    _zoomScrollView.frame = frame;
    [_scrollView addSubview:_zoomScrollView];
    
    float height=0.01;
    if(img){
        height=(img.size.height*kMainScreenWidth)/img.size.width;
        _zoomScrollView.imageView.frame=CGRectMake(0,(kMainScreenHeight-height)/2, kMainScreenWidth, height);
        _zoomScrollView.imageView.image=img;
    }
}

-(void)downloadImg:(NSString *)url index:(NSInteger)index {
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center=CGPointMake(kMainScreenWidth*index+kMainScreenWidth/2, kMainScreenHeight/2);
    activityView.hidesWhenStopped=YES;
    [_scrollView addSubview:activityView];
    [activityView startAnimating];
    
    //if ([[NSOperationQueue mainQueue] operationCount]>6) [[NSOperationQueue mainQueue] cancelAllOperations];
    [self.queue addOperationWithBlock: ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]]; //得到图像数据
        //MJLog(@"图片的大小：%dKB", (unsigned)imgData.length/1000);
        UIImage *image = [UIImage imageWithData:imgData];
        if(image){
            if(activityView){
                [activityView stopAnimating];
                [activityView removeFromSuperview];
            }
        }
        else{
            if(activityView){
                [activityView stopAnimating];
                [activityView removeFromSuperview];
            }
        }
        //在主线程中更新UI
        if([NSOperationQueue currentQueue]){
            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                if([self respondsToSelector:@selector(loadImageView: image:)]){
                    [self loadImageView:image image:index];
                }
            }];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(kMainScreenWidth * [self.data_array count], kMainScreenHeight)];
    
    self.lab_count= [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-30, 29, 30, 20)];
    self.lab_count.backgroundColor = [UIColor clearColor];
    self.lab_count.font = [UIFont systemFontOfSize:20.0];
    self.lab_count.textAlignment = NSTextAlignmentRight;
    self.lab_count.textColor = [UIColor whiteColor];
    self.lab_count.text =[NSString stringWithFormat:@"%ld",(long)pic_id+1];
    [self.view addSubview:self.lab_count];
    
    UILabel *lab_right= [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2, 30, 30, 20)];
    lab_right.backgroundColor = [UIColor clearColor];
    lab_right.font = [UIFont systemFontOfSize:17.0];
    lab_right.textAlignment = NSTextAlignmentLeft;
    lab_right.textColor = [UIColor whiteColor];
    lab_right.text =[NSString stringWithFormat:@"/%ld",(long)[data_array count]];
    [self.view addSubview:lab_right];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(15, 15, 80, 50)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui_b.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 50);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index_=_scrollView.contentOffset.x/kMainScreenWidth;
    self.lab_count.text=[NSString stringWithFormat:@"%ld",(long)index_+1];
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
