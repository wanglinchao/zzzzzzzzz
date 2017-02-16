//
//  PointsDetailsTableViewCell.m
//  IDIAI
//
//  Created by PM on 16/6/16.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PointsDetailsTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation PointsDetailsTableViewCell
{
    UIImageView *_goodImageView;
    UILabel * _goodNameLab;
    UILabel * _statusLab;
    UILabel * _pointStatus;
    UILabel * _timeLabel;
  
}




-(void)layoutSubviews{
      _goodImageView.frame =CGRectMake(12,12,79,79);
    
       _goodNameLab.frame =CGRectMake(CGRectGetMaxX(_goodImageView.frame)+12, CGRectGetMinY(_goodImageView.frame), kMainScreenWidth-42-CGRectGetWidth(_goodImageView.frame), 40);
    
       _statusLab.frame = CGRectMake(CGRectGetMinX(_goodNameLab.frame), CGRectGetMaxY(_goodNameLab.frame),50,14);
    
       _pointStatus.frame = CGRectMake(kMainScreenWidth-112, CGRectGetMinY(_statusLab.frame),100,14);
    
       _timeLabel.frame = CGRectMake(CGRectGetMinX(_goodNameLab.frame), CGRectGetMaxY(_pointStatus.frame)+10,80, 12);
    
    
       _checkCDKEYBtn.frame =CGRectMake(kMainScreenWidth-90, CGRectGetMaxY(_pointStatus.frame)+5,80,25);
 

}


- (void)setPointDetailsModel:(PointDetailsModel *)pointDetailsModel{
    
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_goodImageView];
        _goodImageView.contentMode = UIViewContentModeCenter;
    }

    
    if (!_goodNameLab) {
        _goodNameLab = [[UILabel alloc]init];
        [self.contentView  addSubview:_goodNameLab];
        _goodNameLab.numberOfLines = 0;
        _goodNameLab.textColor = subHeadingColor;
        _goodNameLab.font = [UIFont systemFontOfSize:15];
    }

    
    if (!_statusLab) {
        _statusLab = [[UILabel alloc]init];
        [self.contentView  addSubview:_statusLab];
        _statusLab.textColor =emphasizeTextColor;
        _statusLab.font = [UIFont systemFontOfSize:14];
        _statusLab.hidden = YES;
    }

    if (!_pointStatus) {
        _pointStatus = [[UILabel alloc]init];
        [self.contentView  addSubview:_pointStatus];
        _pointStatus.textColor = emphasizeTextColor;
        _pointStatus.font = [UIFont systemFontOfSize:13];
        _pointStatus.textAlignment = NSTextAlignmentRight;
    }

    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_timeLabel];
        _timeLabel.textColor = subHeadingColor;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        
    }

    
    if (!_checkCDKEYBtn) {
        _checkCDKEYBtn = [[UIButton alloc]init];
        _checkCDKEYBtn.layer.cornerRadius = 3;
        _checkCDKEYBtn.layer.masksToBounds = YES;
        [self.contentView  addSubview:_checkCDKEYBtn];
        _checkCDKEYBtn.backgroundColor = emphasizeTextColor;
       [_checkCDKEYBtn setTitle:@"查看兑换码"forState:UIControlStateNormal];
        _checkCDKEYBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        //            _checkCDKEYBtn.titleLabel.textColor = [UIColor whiteColor];
        [_checkCDKEYBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _checkCDKEYBtn.hidden = YES;
    }

    _pointDetailsModel = pointDetailsModel;
    _goodImageView.contentMode =UIViewContentModeScaleAspectFill;
    _goodImageView.layer.masksToBounds=YES;
    //[logo sd_setImageWithURL:[NSURL URLWithString:obj.knowledgeLogoPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_naobu"]];
        NSLog(@"图片地址＝＝＝＝＝%@",_pointDetailsModel.pgImgPath);
    
    _goodNameLab.text = _pointDetailsModel.pgName;
    
    
    if (_pointDetailsModel.pointType==1) {
        //支出
        if (_pointDetailsModel.receiveStatus) {
            _checkCDKEYBtn.hidden = NO;
            _statusLab.hidden=NO;
            _statusLab.text =@"待领取";
            [_goodImageView sd_setImageWithURL:[NSURL URLWithString:_pointDetailsModel.pgImgPath] placeholderImage:[UIImage imageNamed:@"bg_morentu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image) {
                    //产生逐渐显示的效果
                    _goodImageView.alpha=0.2;
                    [UIView animateWithDuration:0.5 animations:^(){
                        _goodImageView.alpha=1.0;
                    }completion:^(BOOL finished){
                        
                    }];
                }
            }];
        
            
        }else {
            _statusLab.hidden =NO;
            _statusLab.text =@"已领取";
            
            [_goodImageView sd_setImageWithURL:[NSURL URLWithString:_pointDetailsModel.pgImgPath] placeholderImage:[UIImage imageNamed:@"bg_morentu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image) {
                    //产生逐渐显示的效果
                    _goodImageView.alpha=0.2;
                    [UIView animateWithDuration:0.5 animations:^(){
                        _goodImageView.alpha=1.0;
                    }completion:^(BOOL finished){
                        
                    }];
                }
            }];
        [_checkCDKEYBtn removeFromSuperview];
        }
    }else {
        
        _goodImageView.image = [UIImage imageNamed:@"ic_jifenshangjia"];
        
        _statusLab.hidden = YES;
        _checkCDKEYBtn.hidden = YES;
    }
    
    _pointStatus.text = [NSString stringWithFormat:@"%ld",(long)_pointDetailsModel.pgUseNumber];
    [self changeTimeFormatAndShowInLabel];
    
}


-(void)presscheckCDKEY:(id)sender{

//   UIView * codeKeyView = [UIView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
   UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"兑换码" message:@"asdfasfasfasdfdsa" delegate: self cancelButtonTitle:nil otherButtonTitles:@"", nil];
    alert.tag =1000;
    UITapGestureRecognizer * tapGesture0 = [[UITapGestureRecognizer alloc]initWithTarget:self.contentView action:@selector(dissmissSelf:)];
    [alert addGestureRecognizer:tapGesture0];
    alert.userInteractionEnabled = YES;
    NSLog(@"============%@",alert);

    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissSelf:)];
    [alert.maskView addGestureRecognizer:tapGesture1];
    alert.maskView.userInteractionEnabled = YES;
    [alert show];

}

-(void)haha{

    NSLog(@"哈哈");

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"哈哈哈哈哈啊哈");

}

- (void)dissmissSelf:(UITapGestureRecognizer*) tapGesture{
    
    UIAlertView * alert  = [self.contentView viewWithTag:1000];
    [alert removeFromSuperview];
    
    
}


-(void)changeTimeFormatAndShowInLabel{
    if (_pointDetailsModel!=nil) {
        double  creatime = _pointDetailsModel.createTime;
        NSLog(@"---%f",creatime);
//        NSInteger newCreatTime  = [creatime integerValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:creatime/1000];
        NSString *strTime = [dateFormatter stringFromDate:dateTime];
        _timeLabel.text = strTime;
    }
    
    
}

@end
