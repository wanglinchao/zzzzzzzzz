//
//  CustomPickerView.m
//  IDIAI
//
//  Created by iMac on 14-10-31.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CustomPickerView.h"
#import <QuartzCore/QuartzCore.h>
#import "HexColor.h"


@implementation CustomPickerView
@synthesize titlesForComponenets = _titlesForComponenets;
@synthesize widthsForComponents = _widthsForComponents;
@synthesize isRangePickerView = _isRangePickerView;
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor whiteColor];
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
    imv.frame=CGRectMake(0, 0, kMainScreenWidth, 58);
    imv.userInteractionEnabled=YES;
    [self addSubview:imv];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, imv.bounds.size.height - 10, kMainScreenWidth, 1)];
    lineView.backgroundColor = kFontPlacehoderColor;
//    [imv addSubview:lineView];
    
    UIButton *btn_left=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_left.frame = CGRectMake(20, 13, 35, 28);
    [btn_left setBackgroundImage:[UIImage imageNamed:@"ic_jiantou_down@2x"] forState:UIControlStateNormal];
    [btn_left addTarget:self action:@selector(pickerCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [imv addSubview:btn_left];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-100)/2, 8, 100, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    label.textColor = [UIColor darkGrayColor];
    label.text = title;
    [imv addSubview:label];
    
    UIButton *btn_tight=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_tight.frame = CGRectMake(kMainScreenWidth-60, 8, 60, 40);
    btn_tight.titleLabel.font=[UIFont systemFontOfSize:16];
//    [btn_tight setTitleColor:[UIColor colorWithHexString:@"#6d2907" alpha:1.0] forState:UIControlStateNormal];
    [btn_tight setTitle:@"完成" forState:UIControlStateNormal];
    [btn_tight setTitleColor:kThemeColor forState:UIControlStateNormal];
    [btn_tight addTarget:self action:@selector(pickerDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imv addSubview:btn_tight];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40 , kMainScreenWidth, 210)];
    [_pickerView sizeToFit];
    [_pickerView setShowsSelectionIndicator:YES];
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
//    _pickerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    
}

-(void)pickerCancelClicked:(UIBarButtonItem*)barButton
{
     [self dismiss];
}

-(void)pickerDoneClicked:(UIBarButtonItem*)barButton
{
    if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didSelectTitles:)])
    {
        NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
        
            for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
            {
                NSInteger row = [_pickerView selectedRowInComponent:component];
                
                if (row!= -1)
                {
                    [selectedTitles addObject:[[_titlesForComponenets objectAtIndex:component] objectAtIndex:row]];
                }
                else
                {
                    [selectedTitles addObject:[NSNull null]];
                }
            }
            
            [self setSelectedTitles:selectedTitles];

        
        [self.delegate actionSheetPickerView:self didSelectTitles:selectedTitles];
        
    }
    [self dismiss];
}

-(void)setSelectedTitles:(NSArray *)selectedTitles
{
    [self setSelectedTitles:selectedTitles animated:NO];
}

-(void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated
{
    
        NSUInteger totalComponent = MIN(selectedTitles.count, _pickerView.numberOfComponents);
        
        for (NSInteger component = 0; component<totalComponent; component++)
        {
            NSArray *items = [_titlesForComponenets objectAtIndex:component];
            id selectTitle = [selectedTitles objectAtIndex:component];
            
            if ([items containsObject:selectTitle])
            {
                NSUInteger rowIndex = [items indexOfObject:selectTitle];
                [_pickerView selectRow:rowIndex inComponent:component animated:animated];
            }
        }
}

-(void)selectIndexes:(NSArray *)indexes animated:(BOOL)animated
{
   
        NSUInteger totalComponent = MIN(indexes.count, _pickerView.numberOfComponents);
        
        for (NSInteger component = 0; component<totalComponent; component++)
        {
            NSArray *items = [_titlesForComponenets objectAtIndex:component];
            NSUInteger selectIndex = [[indexes objectAtIndex:component] intValue];
            
            if (items.count < selectIndex)
            {
                [_pickerView selectRow:selectIndex inComponent:component animated:animated];
            }
        }
}




- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    //If having widths
    if (_widthsForComponents)
    {
        //If object isKind of NSNumber class
        if ([[_widthsForComponents objectAtIndex:component] isKindOfClass:[NSNumber class]])
        {
            CGFloat width = [[_widthsForComponents objectAtIndex:component] floatValue];
            
            //If width is 0, then calculating it's size.
            if (width == 0)
                return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
            //Else returning it's width.
            else
                return width;
        }
        //Else calculating it's size.
        else
            return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
    }
    //Else calculating it's size.
    else
    {
        return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_titlesForComponenets count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[_titlesForComponenets objectAtIndex:component] count];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    pickerLabel.text= [[_titlesForComponenets objectAtIndex:component] objectAtIndex:row];
    
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isRangePickerView && pickerView.numberOfComponents == 3)
    {
        if (component == 0)
        {
            [pickerView selectRow:MAX([pickerView selectedRowInComponent:2], row) inComponent:2 animated:YES];
        }
        else if (component == 2)
        {
            [pickerView selectRow:MIN([pickerView selectedRowInComponent:0], row) inComponent:0 animated:YES];
        }
    }
}


-(void)dismiss{
    [control removeFromSuperview];
    control=nil;
    self.alpha=1.0;
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha=0.2;
        [self setFrame:CGRectMake(self.frame.origin.x, kMainScreenHeight, self.frame.size.width, self.frame.size.height)];
    }completion:^(BOOL finished){
        [self removeFromSuperview];

    }];
}

-(void)show {
    [_pickerView reloadAllComponents];
    self.alpha=0.0;
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:control];
    [UIView animateWithDuration:.35 animations:^{
        self.alpha=1.0;
        [keywindow addSubview:self];
        self.frame=CGRectMake(0, kMainScreenHeight-self.frame.size.height, kMainScreenWidth, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
