//
//  CustomProvinceCApicker.m
//  UTopSP
//
//  Created by iMac on 15-1-20.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CustomProvinceCApicker.h"
#import <QuartzCore/QuartzCore.h>
#import "HexColor.h"
#import "Macros.h"

@implementation CustomProvinceCApicker
@synthesize delegate,province_index,city_index,area_index;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor whiteColor];
        
        NSString *path=[[NSBundle mainBundle] pathForResource:@"ProvinceCA" ofType:@"plist"];
        dict=[NSDictionary dictionaryWithContentsOfFile:path];
        
        province_index=0;
        city_index=0;
        area_index=0;
 
        array_city=[NSArray arrayWithArray:[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:province_index] objectForKey:@"city"]];
        array_area=[NSArray arrayWithArray:[[[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:province_index] objectForKey:@"city"] objectAtIndex:city_index] objectForKey:@"district"]];
        self.selectcomponent =-1;
        [self createView:title];
    }
    return self;
}

-(void)createView:(NSString *)title{
    
    control = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
    [control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    imv.backgroundColor = [UIColor whiteColor];
    imv.frame=CGRectMake(0, 10, kMainScreenWidth, 40);
    imv.userInteractionEnabled=YES;
    imv.tag =101;
    [self addSubview:imv];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, imv.bounds.size.height - 10, kMainScreenWidth, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    //    [imv addSubview:lineView];
    
    UIButton *btn_left=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_left.frame = CGRectMake(20, 13, 35, 28);
    [btn_left setBackgroundImage:[UIImage imageNamed:@"ic_jiantou_down@2x"] forState:UIControlStateNormal];
    [btn_left addTarget:self action:@selector(pickerCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [imv addSubview:btn_left];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-100)/2, 0, 100, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    //    label.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    label.textColor = [UIColor darkGrayColor];
    label.text = title;
    [imv addSubview:label];
    
    UIButton *btn_tight=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_tight.frame = CGRectMake(kMainScreenWidth-70, 0, 60, 40);
    btn_tight.titleLabel.font=[UIFont systemFontOfSize:16];
    btn_tight.tag =100;
    //    [btn_tight setTitleColor:[UIColor colorWithHexString:@"#6d2907" alpha:1.0] forState:UIControlStateNormal];
    [btn_tight setTitle:@"完成" forState:UIControlStateNormal];
    [btn_tight setTitleColor:kThemeColor forState:UIControlStateNormal];
    [btn_tight addTarget:self action:@selector(pickerDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imv addSubview:btn_tight];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 250)];
    [_pickerView setShowsSelectionIndicator:YES];
    [_pickerView setDataSource:self];
    [_pickerView setDelegate:self];
    //    _pickerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    for (NSInteger component = 0; component<3; component++){
        if(component==0)[_pickerView selectRow:province_index inComponent:component animated:YES];
        else if(component==1)[_pickerView selectRow:city_index inComponent:component animated:YES];
        else [_pickerView selectRow:area_index inComponent:component animated:YES];
    }
    
}

-(void)pickerCancelClicked:(UIBarButtonItem*)barButton
{
    [self dismiss];
}

-(void)pickerDoneClicked:(UIBarButtonItem*)barButton
{
    if ([self.delegate respondsToSelector:@selector(actionSheetProvinceCAPickerView:didSelectTitles:)])
    {
        NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
        
        for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
        {
            NSInteger row = [_pickerView selectedRowInComponent:component];
            
            if (row!= -1)
            {
                if(component==0) [selectedTitles addObject:@[[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:row] objectForKey:@"name"],[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:row] objectForKey:@"code"]]];
                else if(component==1) {
                   if([array_city count]) [selectedTitles addObject:@[[[array_city objectAtIndex:row] objectForKey:@"name"],[[array_city objectAtIndex:row] objectForKey:@"code"]]];
                }
                else {
                   if([array_area count]) [selectedTitles addObject:@[[[array_area objectAtIndex:row] objectForKey:@"name"],[[array_area objectAtIndex:row] objectForKey:@"code"]]];
                }
            }
            else
            {
                [selectedTitles addObject:[NSNull null]];
            }
        }
        
        [self setSelectedTitles:selectedTitles];
        
        
        [self.delegate actionSheetProvinceCAPickerView:self didSelectTitles:selectedTitles];
        
    }
    [self dismiss];
}

-(void)setSelectedTitles:(NSArray *)selectedTitles
{
    [self setSelectedTitles:selectedTitles animated:NO];
}

-(void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated
{
    if([selectedTitles count]){
        //获取省位置
        NSInteger selected_province=0;
        for (NSInteger i=0; i<[[[dict objectForKey:@"root"] objectForKey:@"province"] count]; i++) {
            if([[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:i] objectForKey:@"code"] isEqualToString:[NSString stringWithFormat:@"%@",[[selectedTitles objectAtIndex:0] objectAtIndex:1]]]){
                selected_province=i;
                break;
            }
            else continue;
        }
        
        //获取市位置
        NSInteger selected_city=0;
        for (NSInteger j=0; j<[[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:selected_province] objectForKey:@"city"] count]; j++) {
            if([[[[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:selected_province] objectForKey:@"city"] objectAtIndex:j] objectForKey:@"code"] isEqualToString:[NSString stringWithFormat:@"%@",[[selectedTitles objectAtIndex:1] objectAtIndex:1]]]){
                selected_city=j;
                break;
            }
            else continue;
        }
        //获取区县位置
        NSInteger selected_area=0;
        for (NSInteger k=0; k<[[[[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:selected_province] objectForKey:@"city"] objectAtIndex:selected_city] objectForKey:@"district"] count]; k++) {
            if([[[[[[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:selected_province] objectForKey:@"city"] objectAtIndex:selected_city] objectForKey:@"district"] objectAtIndex:k] objectForKey:@"code"] isEqualToString: [NSString stringWithFormat:@"%@",[[selectedTitles objectAtIndex:2] objectAtIndex:1]]]){
                selected_area=k;
                break;
            }
            else continue;
        }
        
        province_index=selected_province;
        city_index=selected_city;
        area_index=selected_area;
        
        array_city=[NSArray arrayWithArray:[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:selected_province] objectForKey:@"city"]];
        array_area=[NSArray arrayWithArray:[[[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:selected_province] objectForKey:@"city"] objectAtIndex:selected_city] objectForKey:@"district"]];
    
        [_pickerView reloadAllComponents];
        for (NSInteger component = 0; component<3; component++){
            if(component==0)[_pickerView selectRow:selected_province inComponent:component animated:YES];
            else if(component==1) [_pickerView selectRow:selected_city inComponent:component animated:YES];
            else [_pickerView selectRow:selected_area inComponent:component animated:YES];
        }
        
    }
}

-(void)selectIndexes:(NSArray *)indexes animated:(BOOL)animated
{
    
//    NSUInteger totalComponent = MIN(indexes.count, _pickerView.numberOfComponents);
//    
//    for (NSInteger component = 0; component<totalComponent; component++)
//    {
//        NSArray *items = [_titlesForComponenets objectAtIndex:component];
//        NSUInteger selectIndex = [[indexes objectAtIndex:component] intValue];
//        
//        if (items.count < selectIndex)
//        {
//            [_pickerView selectRow:selectIndex inComponent:component animated:animated];
//        }
//    }
}


#pragma mark -UIPickerDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return ((pickerView.bounds.size.width-20)-2*(3-1))/3;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0) return [[[dict objectForKey:@"root"] objectForKey:@"province"] count];
    else if(component==1) return [array_city count] ;
    else return [array_area count];
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIImageView *imv =(UIImageView *)[self viewWithTag:101];
    UIButton *btn =(UIButton *)[imv viewWithTag:100];
    btn.userInteractionEnabled =NO;
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    if(component==0) {
        pickerLabel.text=[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:row] objectForKey:@"name"];
    }
    else if(component==1) {
        if(row<[array_city count])pickerLabel.text= [[array_city objectAtIndex:row] objectForKey:@"name"];
    }
    else {
        if(row<[array_area count])pickerLabel.text= [[array_area objectAtIndex:row]  objectForKey:@"name"];
    }
    [self performSelector:@selector(performDeply) withObject:nil afterDelay:1.0];

    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(component==0){
        province_index=row;
        city_index=0;
        area_index=0;
        
        array_city=[NSArray arrayWithArray:[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:province_index] objectForKey:@"city"]];
        array_area=[NSArray arrayWithArray:[[[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:province_index] objectForKey:@"city"] objectAtIndex:0] objectForKey:@"district"]];
        
        [pickerView reloadComponent:0];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:province_index inComponent:0 animated:NO];
        [pickerView selectRow:city_index inComponent:1 animated:NO];
        [pickerView selectRow:area_index inComponent:2 animated:NO];
        
    }
    else if(component==1){
        city_index=row;
        area_index=0;
        

        array_area=[NSArray arrayWithArray:[[[[[[dict objectForKey:@"root"] objectForKey:@"province"] objectAtIndex:province_index] objectForKey:@"city"] objectAtIndex:city_index] objectForKey:@"district"]];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:city_index inComponent:2 animated:NO];
        [pickerView selectRow:area_index inComponent:2 animated:NO];
    }
    else{
        area_index=row;
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:area_index inComponent:2 animated:NO];
    }
    


}


-(void)dismiss{
    [control removeFromSuperview];
    control=nil;
    [UIView animateWithDuration:0.35 animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x, kMainScreenHeight, self.frame.size.width, self.frame.size.height)];
    }completion:^(BOOL finished){
        [self removeFromSuperview];
        
    }];
}

-(void)show {
    
   // [_pickerView reloadAllComponents];
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:control];
    [UIView animateWithDuration:.35 animations:^{
        [keywindow addSubview:self];
        self.frame=CGRectMake(self.frame.origin.x, kMainScreenHeight-self.frame.size.height, kMainScreenWidth, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)performDeply{
    UIImageView *imv =(UIImageView *)[self viewWithTag:101];
    UIButton *btn =(UIButton *)[imv viewWithTag:100];
    btn.userInteractionEnabled =YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
