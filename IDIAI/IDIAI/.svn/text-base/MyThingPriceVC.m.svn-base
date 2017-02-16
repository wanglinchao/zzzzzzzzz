//
//  MyThingPriceVC.m
//  IDIAI
//
//  Created by iMac on 14-7-22.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyThingPriceVC.h"
#import "HexColor.h"
#import "util.h"
#import "MyhudgetInfoObj.h"
#import "NSStringAdditions.h"

#define kButton_tag 100
#define kImageview_tag 200
#define kUIView_tag 300
@interface MyThingPriceVC ()

@end

@implementation MyThingPriceVC
@synthesize data_Array,title_string;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:YES];
    
    UIImageView *nav_bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"导航条.png"]];
    nav_bg.frame=CGRectMake(0, 20, 320, 44);
    nav_bg.userInteractionEnabled=YES;
    [self.view addSubview:nav_bg];
    
    CGRect frame = CGRectMake(60, 29, 200, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    
    label.text =[NSString stringWithFormat:@"我的%@报价",title_string];
    if ([title_string isEqualToString:@"主材报价"]) {
        label.text =[NSString stringWithFormat:@"我的%@",title_string];
    }
    [self.view addSubview:label];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(10, 25, 50, 28)];
    rightButton.tag=1;
    [rightButton setBackgroundImage:[UIImage imageNamed:@"返回键.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(backTouched:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
}
-(void)backTouched:(UIButton *)btn{
    if(btn.tag==1)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =[NSString stringWithFormat:@"我的%@报价",title_string];
    if ([title_string isEqualToString:@"主材报价"]) {
        self.title =[NSString stringWithFormat:@"我的%@",title_string];
    }

    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
//    [self customizeNavigationBar];
    
    mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
//    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mtableview];
    
//    [self createTableHeader];
    
    self.openOrCloseArray=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<[data_Array count]; i++) {
        [self.openOrCloseArray addObject:@"0"];
    }
}

-(void)createTableHeader{
    UIView *top_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
//    top_view.backgroundColor=[UIColor clearColor];
    mtableview.tableHeaderView=top_view;
    
//    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
//    [bgImageView setImage:[UIImage imageNamed:@"弹出框标题栏.png"]];
//    [top_view addSubview:bgImageView];
    
    NSArray *arr_header=[NSArray arrayWithObjects:@"类型",@"单价",@"工程量",@"总价", nil];
    for (int i=0; i<[arr_header count]; i++) {
    UILabel *titleLabel_first = [[UILabel alloc] initWithFrame:CGRectMake(80*i, 10, 80, 40)];
    titleLabel_first.backgroundColor = [UIColor clearColor];
    [titleLabel_first setFont:[UIFont systemFontOfSize:19.0f]];
//    titleLabel_first.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    titleLabel_first.textAlignment=NSTextAlignmentCenter;
    titleLabel_first.text=[arr_header objectAtIndex:i];
    [top_view addSubview:titleLabel_first];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyhudgetInfoObj *obj=[data_Array objectAtIndex:indexPath.section];
    
    CGSize size=[util calHeightForLabel:obj.TheDesc width:kMainScreenWidth font:[UIFont systemFontOfSize:18]];
    
    return size.height + 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 77.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view_footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 54)];
    view_footer.tag=kUIView_tag+section;
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 77);
    headerBtn.tag = kButton_tag + section;
    [headerBtn addTarget:self
                  action:@selector(tapHeader:)
        forControlEvents:UIControlEventTouchUpInside];
    [view_footer addSubview:headerBtn];
    
        MyhudgetInfoObj *obj=[data_Array objectAtIndex:section];
        UILabel *titleLabel_first = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 120, 40)];
        titleLabel_first.backgroundColor = [UIColor clearColor];
        [titleLabel_first setFont:[UIFont systemFontOfSize:17.0f]];
        titleLabel_first.text=obj.ProjectName;
        [view_footer addSubview:titleLabel_first];
    
    UILabel *titleLabel_two = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 140, 40)];
    titleLabel_two.backgroundColor = [UIColor clearColor];
    [titleLabel_two setFont:[UIFont systemFontOfSize:15.0f]];
    titleLabel_two.textColor=kFontPlacehoderColor;
    titleLabel_two.text=[NSString stringWithFormat:@"单价 %@",obj.ThePrice];
    [view_footer addSubview:titleLabel_two];
    
    UILabel *titleLabel_three = [[UILabel alloc] initWithFrame:CGRectMake(150, 40, 120, 40)];
    titleLabel_three.backgroundColor = [UIColor clearColor];
    [titleLabel_three setFont:[UIFont systemFontOfSize:15.0f]];
    titleLabel_three.textColor = kFontPlacehoderColor;
    titleLabel_three.text=[NSString stringWithFormat:@"工程量 %.0f",[obj.TheFormula floatValue]];;
    [view_footer addSubview:titleLabel_three];
    
    UILabel *titleLabel_four = [[UILabel alloc] initWithFrame:CGRectMake(130, 7, 178, 40)];
    titleLabel_four.backgroundColor = [UIColor clearColor];
    [titleLabel_four setFont:[UIFont systemFontOfSize:15.0f]];
    titleLabel_four.textColor = kThemeColor;
    titleLabel_four.textAlignment=NSTextAlignmentRight;
    titleLabel_four.text=[NSString stringWithFormat:@"总价 %.0f元",[obj.totalprice floatValue]];
    [view_footer addSubview:titleLabel_four];
    
    UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_gengduo_ys"]];
    imv.frame = CGRectMake(kMainScreenWidth - 30, 57, 15, 3.5);
    if (![NSString isEmptyOrWhitespace:obj.TheDesc])
    [view_footer addSubview:imv];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 3, kMainScreenWidth, .6)];
    lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.25];
    [view_footer addSubview:lineView];
    
    view_footer.backgroundColor = [UIColor whiteColor];
    return view_footer;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [data_Array count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger retval = 0;
    
    if ([[self.openOrCloseArray objectAtIndex:section] intValue]) retval =1;
    return retval;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *cellid_top=[NSString stringWithFormat:@"mycellid_second_%ld_%ld",(long)indexPath.row,(long)indexPath.section];;
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid_top];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid_top];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
     MyhudgetInfoObj *obj=[data_Array objectAtIndex:indexPath.section];
    
    CGSize size=[util calHeightForLabel:obj.TheDesc width:kMainScreenWidth font:[UIFont systemFontOfSize:15]];
    UILabel *read_lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth - 20, size.height)];
    read_lab.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.8];
    read_lab.font=[UIFont systemFontOfSize:15];
    read_lab.textColor = kFontPlacehoderColor;
    read_lab.textAlignment=NSTextAlignmentLeft;
    read_lab.numberOfLines=0;
    
    //以下调整行间距 huangrun
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:obj.TheDesc];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [obj.TheDesc length])];
    read_lab.attributedText = attributedString;
    [cell addSubview:read_lab];
    [read_lab sizeToFit];//必须
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (void)tapHeader:(UIButton *)sender {
     NSInteger section = [sender tag] - 100;
     MyhudgetInfoObj *obj=[data_Array objectAtIndex:section];
    
    if([obj.TheDesc length]>=1){
    
        UITableViewCell *cell_bottom=[mtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        UIView *view_header=(UIView *)[cell_bottom viewWithTag:kUIView_tag+section];
        UIImageView *imv_=(UIImageView *)[view_header viewWithTag:kImageview_tag+section];
        CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
        [spinAnimation setToValue:[NSNumber numberWithDouble:M_PI]];
        [spinAnimation setDelegate:self];
        [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [spinAnimation setDuration:0.3];
        [imv_.layer addAnimation:spinAnimation forKey:@"spin"];
        [imv_.layer setTransform:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
    
    if (![[self.openOrCloseArray objectAtIndex:section] intValue]) {
        [self.openOrCloseArray replaceObjectAtIndex:section withObject:@"1"];
        
        NSMutableArray *insertArray = [NSMutableArray array];
        
        NSMutableArray *addContentArray =[NSMutableArray arrayWithObjects:obj.TheDesc,nil];
        
        for (NSInteger ix = 0; ix < addContentArray.count; ++ix) {
            @autoreleasepool {
                
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:ix inSection:section];
                
                [insertArray addObject:tmpIndexPath];
            }
        }
        
        [mtableview beginUpdates];
        [mtableview insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationFade];
        [mtableview endUpdates];
        
    }else {
        [self.openOrCloseArray replaceObjectAtIndex:section withObject:@"0"];
        
        NSMutableArray *deleteArray = [NSMutableArray array];
        NSMutableArray *deleteContentArray = [NSMutableArray arrayWithObjects:[data_Array objectAtIndex:section],nil];
        
        for (NSInteger ix = 0; ix < deleteContentArray.count; ++ix) {
            @autoreleasepool {
                
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:ix inSection:section];
                [deleteArray addObject:tmpIndexPath];
            }
        }
        
        [mtableview beginUpdates];
        [mtableview deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
        [mtableview endUpdates];
    }
    
    for (NSInteger ix = 0; ix <[data_Array count]; ++ix) {
        @autoreleasepool {
            if (ix == section) continue;
            
            if ([[self.openOrCloseArray objectAtIndex:ix] intValue]) {
                [self.openOrCloseArray replaceObjectAtIndex:ix withObject:@"0"];
                
                NSMutableArray *deleteArray = [NSMutableArray array];
                NSMutableArray *deleteContentArray = [NSMutableArray arrayWithObjects:obj.TheDesc,nil];
                
                for (NSInteger jx = 0; jx < deleteContentArray.count; ++jx) {
                    @autoreleasepool {
                        
                        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:jx inSection:ix];
                        [deleteArray addObject:tmpIndexPath];
                    }
                }
                
                [mtableview beginUpdates];
                [mtableview deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
                [mtableview endUpdates];
            }
        }
    }

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
