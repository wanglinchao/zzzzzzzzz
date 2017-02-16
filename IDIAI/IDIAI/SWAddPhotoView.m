//
//  SWAddPhotoView.m
//  SubWayWifi
//
//  Created by apple on 15-1-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SWAddPhotoView.h"
#import "UIImageView+WebCache.h"
@implementation SWAddPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor =[UIColor clearColor];

    }
    return self;
}
-(void)setPhotos:(NSMutableArray *)photos{
    _photos =photos;
    for (int i =0; i<photos.count+1; i++) {
        UIButton *button =(UIButton*)[self viewWithTag:i+100];
        if (button) {
            [button removeFromSuperview];
        }
    }
    int count =0;
    int x =0;
    int y =0;
    if (photos.count ==0) {
        if (self.addPhotobtn ==nil) {
            self.addPhotobtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 82*kMainScreenWidth/375, 82*kMainScreenWidth/375)];
            [self.addPhotobtn setBackgroundImage:[UIImage imageNamed:@"ic_tupian"] forState:UIControlStateNormal];
            [self.addPhotobtn addTarget:self action:@selector(addPhotosAction:) forControlEvents:UIControlEventTouchUpInside];
            //            [self.addPhotobtn setBackgroundColor: [UIColor redColor]];
            [self addSubview:self.addPhotobtn];
            _maxOrMinPicNumLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_addPhotobtn.frame), CGRectGetWidth(_addPhotobtn.frame),20)];
            [self addSubview:_maxOrMinPicNumLab];
            if (_minPicNum) {
                _maxOrMinPicNumLab.text =[NSString stringWithFormat:@"最少%ld张",(long)_minPicNum];
            }else{
                _maxOrMinPicNumLab.text =[NSString stringWithFormat:@"最多%ld张",(long)_photocount];
            }
            
            _maxOrMinPicNumLab.font = [UIFont systemFontOfSize:15];
            _maxOrMinPicNumLab.textColor = [UIColor lightGrayColor];
            _maxOrMinPicNumLab.textAlignment = NSTextAlignmentCenter;
        }else{
            self.addPhotobtn.frame  =CGRectMake(0, 0, 82*kMainScreenWidth/375, 82*kMainScreenWidth/375);
            _maxOrMinPicNumLab.hidden = NO;
        }
        //        if (self.pickPhoto ==nil) {
        //            self.pickPhoto =[[UIButton alloc] initWithFrame:CGRectMake(60, 10, 82, 82)];
        //            [self.pickPhoto setImage:[UIImage imageNamed:@"take_picture.png"] forState:UIControlStateNormal];
        //            [self.pickPhoto addTarget:self action:@selector(pickPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        //            [self addSubview:self.pickPhoto];
        //        }else{
        //            self.pickPhoto.frame =CGRectMake(60, 10, 38, 38);
        //        }
        
    }
    if (photos.count!=0) {
        _maxOrMinPicNumLab.hidden =YES;
    }
    
    for (id backimage in photos) {
        if (count<self.photocount) {
            UIButton *photobtn =[UIButton buttonWithType:UIButtonTypeCustom];
            if ([backimage isKindOfClass:[UIImage class]]) {
                [photobtn setImage:backimage forState:UIControlStateNormal];
            }else{
                [photobtn setImage:[UIImage imageNamed:@"bg_morentu_tuku_1"] forState:UIControlStateNormal];
                [photobtn.imageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)backimage] placeholderImage:[UIImage imageNamed:@"bg_morentu_tuku_1"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [photobtn setImage:image forState:UIControlStateNormal];
                }];
            }
            
            [photobtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
            photobtn.tag =count+100;
            y=count/3;
            if (count%3 ==0) {
                x =0;
            }
            photobtn.frame =CGRectMake(128*kMainScreenWidth/375*x, 98*kMainScreenWidth/375*y, 82*kMainScreenWidth/375, 82*kMainScreenWidth/375);
            [self addSubview:photobtn];
            if (count  ==photos.count -1) {
                if ((count+1)%3==0) {
                    self.addPhotobtn.frame =CGRectMake(0, 98*kMainScreenWidth/375*(y+1), 82*kMainScreenWidth/375, 82*kMainScreenWidth/375);
                }else{
                    self.addPhotobtn.frame =CGRectMake(128*kMainScreenWidth/375*(x+1), 98*kMainScreenWidth/375*y, 82*kMainScreenWidth/375, 82*kMainScreenWidth/375);
                }
                
                //                self.pickPhoto.frame =CGRectMake(10+50*(x+2), 10+50*y, 38, 38);
            }
            if (photos.count==self.photocount) {
                self.addPhotobtn.hidden =YES;
                
            }else{
                self.addPhotobtn.hidden =NO;
            }
            //            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
            //            longPress.minimumPressDuration = 0.8; //定义按的时间
            //            [photobtn addGestureRecognizer:longPress];
        }
        x++;
        count++;
    }
    [self getPhotoFrame:self.frame.origin.y];
}
-(void)addImages:(NSMutableArray *)images{
    [self.photos addObjectsFromArray:images];
    [self setPhotos:self.photos];
}
-(void)getPhotoFrame:(CGFloat)y{
    //    CGRect frame =[self CGRectMake1:CGRectMake(15, 0, 290, 0) ];
    CGFloat buttomSpace =10;
    if (_photos.count==0) {
        buttomSpace = 30;
    }
    CGRect rect =CGRectMake(15,y,kMainScreenWidth-30,buttomSpace+98*kMainScreenWidth/375*(self.photos.count/3+1));
    if (self.photos.count%3 ==0 &&self.photos.count !=0) {
        rect =CGRectMake(15,y,kMainScreenWidth-30,buttomSpace+98*kMainScreenWidth/375*(self.photos.count/3+1));
    }
    if (self.photos.count==self.photocount &&self.photocount%3==0) {
        rect = CGRectMake(15,y,kMainScreenWidth-30,buttomSpace+98*kMainScreenWidth/375*(self.photos.count/3));    }
    self.frame =rect;
}
-(void)addPhotosAction:(UIButton *)sender{
    [self.delegate addPhotoCount:self.photocount-self.photos.count];
}
-(void)pickPhotoAction:(UIButton *)sender{
    [self.delegate pickPhotoCount:self.photocount -self.photos.count];
}
-(void)deletePhoto:(UIButton *)sender{
    [self.delegate detelePhotoCount:sender.tag];
    for (int i =0; i<self.photos.count+1; i++) {
        UIButton *button =(UIButton*)[self viewWithTag:i+100];
        [button removeFromSuperview];
    }
    [self setPhotos:self.photos];
}
//-(void)btnLong:(UILongPressGestureRecognizer *)sender{
//    if(sender.state == UIGestureRecognizerStateBegan){
//        UIButton *btn =(UIButton *)sender.view;
//        [self.delegate longTouchPhotoCount:btn.tag];
//    }
//}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(CGRect)CGRectMake1:(CGRect)frame{
    float autoSizeScaleX;
    float autoSizeScaleY;
    if( [[UIScreen mainScreen] bounds].size.height > 480){
        autoSizeScaleX = [[UIScreen mainScreen] bounds].size.width/320;
        autoSizeScaleY = [[UIScreen mainScreen] bounds].size.height/568;
    }else{
        autoSizeScaleX = [[UIScreen mainScreen] bounds].size.width/320;
        autoSizeScaleY = [[UIScreen mainScreen] bounds].size.height/568;
        
    }
    CGRect rect;
    rect.origin.x = frame.origin.x * autoSizeScaleX; rect.origin.y = frame.origin.y * autoSizeScaleY;
    rect.size.width = frame.size.width * autoSizeScaleX; rect.size.height = frame.size.height * autoSizeScaleY;
    return rect;
}

@end
