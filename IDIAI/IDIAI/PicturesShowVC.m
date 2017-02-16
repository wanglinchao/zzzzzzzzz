//
//  PicturesShowVC.m
//  IDIAI
//
//  Created by iMac on 14-8-5.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PicturesShowVC.h"
#import "HexColor.h"
#import "util.h"
#import "UIImageView+OnlineImage.h"
#import "MRZoomScrollView.h"

#define KUIButton_TAG 100

@interface PicturesShowVC (){
    UITapGestureRecognizer *doubleTapGesture;
        UIView *bottom_bg;
}

@property (nonatomic,strong) UILabel *lab_count;
@property (nonatomic,strong) UIImageView *imv;
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation PicturesShowVC
@synthesize data_array,type_pic,imv,pic_id,obj_effect;

-(void)dealloc{
    [self.view removeGestureRecognizer:doubleTapGesture];
    self.queue=nil;
}

- (NSOperationQueue *)queue {
    if (!_queue) _queue = [[NSOperationQueue alloc] init];
     //[_queue setMaxConcurrentOperationCount:5];
    return _queue;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if(self.queue.operationCount) [self.queue cancelAllOperations];
    for(MRZoomScrollView *mrscr in _scrollView.subviews) {
        [mrscr removeFromSuperview];
    }
}

-(void)viewDidAppear:(BOOL)animated{
     [_scrollView setContentOffset:CGPointMake(kMainScreenWidth * pic_id, 0) animated:NO];
    for (int i = 0; i < [data_array count]; i++) {
        @autoreleasepool {
        if([type_pic isEqualToString:@"designer"])
            [self downloadImg:[[data_array objectAtIndex:i] objectForKey:@"rendreingsPath"] index:i];
        if ([type_pic isEqualToString:@"business"])
            [self downloadImg:[[data_array objectAtIndex:i] objectForKey:@"imgsPath"] index:i];
        }
    }
}

-(void)loadImageView:(UIImage *)img image:(NSInteger )i{
    
    MRZoomScrollView *_zoomScrollView = [[MRZoomScrollView alloc]init];
    CGRect frame = CGRectMake(0, 150, kMainScreenWidth, kMainScreenHeight);
    frame.origin.x = frame.size.width * i;
    frame.origin.y = 0;
    _zoomScrollView.frame = frame;
    
    if([type_pic isEqualToString:@"designer"]){
        [_scrollView addSubview:_zoomScrollView];
        float height=0.01;
        if(img){
            height=(img.size.height*kMainScreenWidth)/img.size.width;
            _zoomScrollView.imageView.frame=CGRectMake(0,(kMainScreenHeight-height)/2, kMainScreenWidth, height);
            _zoomScrollView.imageView.image=img;
        }
    }
    if ([type_pic isEqualToString:@"business"]){
        [_scrollView addSubview:_zoomScrollView];
        float height=0.01;
        if(img){
            height=(img.size.height*kMainScreenWidth)/img.size.width;
            _zoomScrollView.imageView.frame=CGRectMake(0,(kMainScreenHeight-height)/2, kMainScreenWidth, height);
            _zoomScrollView.imageView.image=img;
        }
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
        UIImage *image = [UIImage imageWithData:imgData];
        if(image){
            [activityView stopAnimating];
            [activityView removeFromSuperview];
        }
        else{
            [activityView stopAnimating];
            [activityView removeFromSuperview];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor blackColor];
    
//    doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [doubleTapGesture setNumberOfTouchesRequired:1];
//    [doubleTapGesture setNumberOfTapsRequired:1];
//    [self.view addGestureRecognizer:doubleTapGesture];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(kMainScreenWidth * [self.data_array count], kMainScreenHeight)];
    
    self.lab_count= [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-50, kMainScreenHeight - 40, 100, 30)];
    self.lab_count.backgroundColor = [UIColor clearColor];
    self.lab_count.font = [UIFont systemFontOfSize:22.0];
    self.lab_count.textAlignment = NSTextAlignmentCenter;
    self.lab_count.textColor = [UIColor whiteColor];
    self.lab_count.text =[NSString stringWithFormat:@"%d/%d",pic_id+1,[data_array count]];
    [self.view addSubview:self.lab_count];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 20, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui_b"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 30);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
}

#pragma mark - Zoom methods

- (void)handleTap:(UIGestureRecognizer *)gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index_=_scrollView.contentOffset.x/kMainScreenWidth;
    self.lab_count.text=[NSString stringWithFormat:@"%d/%d",index_+1,[data_array count]];
}

@end
