//
//  CustomProvinceCApicker.h
//  UTopSP
//
//  Created by iMac on 15-1-20.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomProvinceCApickerDelegate;
@interface CustomProvinceCApicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

{
    UIPickerView    *_pickerView;
    UIControl *control;
    
    NSDictionary *dict;
    
    NSArray *array_city;
    NSArray *array_area;
}

@property(nonatomic,assign) id<CustomProvinceCApickerDelegate> delegate; // weak reference
@property(nonatomic, strong) NSArray *selectedTitles;
@property(nonatomic, assign) NSInteger province_index;
@property(nonatomic, assign) NSInteger city_index;
@property(nonatomic, assign) NSInteger area_index;
@property(nonatomic, assign) NSInteger selectcomponent;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;
-(void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated;
-(void)dismiss;
-(void)show;

@end

@protocol CustomProvinceCApickerDelegate <NSObject>

- (void)actionSheetProvinceCAPickerView:(CustomProvinceCApicker *)pickerView didSelectTitles:(NSArray*)titles;

@end
