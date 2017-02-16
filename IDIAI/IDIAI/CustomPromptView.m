//
//  CustomPromptView.m
//  IDIAI
//
//  Created by Ricky on 16/1/26.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CustomPromptView.h"
#import "util.h"
@implementation CustomPromptView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor =[UIColor blackColor];
        self.alpha =0.5;
    }
    return self;
}
-(void)setContenttxt:(NSString *)contenttxt{
    _contenttxt =contenttxt;
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    CGSize textSize = [util calHeightForLabel:contenttxt width:270 font:font];
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-textSize.width-24)/2, (kMainScreenHeight-textSize.height-24)/2, textSize.width + 24, textSize.height + 24)];
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.textColor = [UIColor colorWithHexString:@"#575757"];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = font;
    textLabel.text = contenttxt;
    textLabel.layer.cornerRadius = 8.0f;
    //        textLabel.layer.borderWidth = 1.0f;
    //        textLabel.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    textLabel.numberOfLines = 0;
    textLabel.layer.masksToBounds=YES;
    textLabel.clipsToBounds=YES;
}
-(void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window  addSubview:self];
    [window addSubview:textLabel];
}
-(void)dismiss{
    [textLabel removeFromSuperview];
    [self removeFromSuperview];
}
@end
