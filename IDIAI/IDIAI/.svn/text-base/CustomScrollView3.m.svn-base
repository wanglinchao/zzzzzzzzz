//
//  CustomScrollView3.m
//  IDIAI
//
//  Created by Ricky on 15/10/23.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CustomScrollView3.h"
#import "UIImageView+WebCache.h"
@implementation CustomScrollView3
- (id)initWithFrame:(CGRect)frame imageURL:(NSMutableArray *)urls{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageUrls = [NSMutableArray arrayWithCapacity:0];
        imageUrls =urls;
        scroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroll.contentSize =CGSizeMake((scroll.frame.size.height*4/3+2)*imageUrls.count, scroll.frame.size.height);
        scroll.autoresizingMask = 0xFF;
        scroll.contentMode = UIViewContentModeCenter;
        scroll.showsHorizontalScrollIndicator=NO;
        scroll.showsVerticalScrollIndicator=NO;
        scroll.bounces=NO;
        [self addSubview:scroll];
        [self creaImages];
    }
    return self;
}
-(void)creaImages{
    int count =0;
    for (NSString *url in imageUrls) {
        UIImageView *image =[[UIImageView alloc] initWithFrame:CGRectMake((scroll.frame.size.height*4/3+3)*count, 0, scroll.frame.size.height*4/3, scroll.frame.size.height)];
        [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"]];
        image.clipsToBounds=YES;
        image.contentMode=UIViewContentModeScaleAspectFill;
        image.userInteractionEnabled =YES;
        [scroll addSubview:image];
        if (count ==0) {
            image.backgroundColor =[UIColor grayColor];
        }else if (count ==1){
            image.backgroundColor =[UIColor purpleColor];
        }else if(count ==2){
            image.backgroundColor =[UIColor greenColor];
        }
        image.tag =100+count;
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImagePage:)];
        [image addGestureRecognizer:tap];
        count++;
    }
}
-(void)selectImagePage:(UIGestureRecognizer *)sender{
    self.TapActionBlock((int)sender.view.tag-100);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
