//
//  CustomPickerView.h
//  IDIAI
//
//  Created by iMac on 14-10-31.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPickerViewDelegate;
@interface CustomPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView    *_pickerView;
    UIControl *control;
}

@property(nonatomic,assign) id<CustomPickerViewDelegate> delegate; // weak reference
@property(nonatomic, assign) BOOL isRangePickerView;
@property(nonatomic, strong) NSArray *titlesForComponenets;
@property(nonatomic, strong) NSArray *widthsForComponents;
@property(nonatomic, strong) NSArray *selectedTitles;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;
-(void)selectIndexes:(NSArray *)indexes animated:(BOOL)animated;
-(void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated;
-(void)dismiss;
-(void)show;

@end

@protocol CustomPickerViewDelegate <NSObject>

- (void)actionSheetPickerView:(CustomPickerView *)pickerView didSelectTitles:(NSArray*)titles;

@end