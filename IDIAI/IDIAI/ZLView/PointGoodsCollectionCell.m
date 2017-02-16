//
//  PointGoodsCollectionCell.m
//  IDIAI
//
//  Created by PM on 16/6/14.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PointGoodsCollectionCell.h"
#import "UIImageView+WebCache.h"
@implementation PointGoodsCollectionCell{
    UIImageView * _goodImgView;//商品图片；
    UILabel * _goodDesLabel;//商品描述；
    UIImageView * _pointImgView;//积分图片
    UILabel * _needPointLabel;//所需积分
 }


-(void)layoutSubviews{
  
 
    _goodImgView.frame = CGRectMake(8, 8, CGRectGetWidth(self.frame)-16, (CGRectGetWidth(self.frame)-16)*3/4);
    
    _goodDesLabel.frame =CGRectMake(8,CGRectGetMaxY(_goodImgView.frame)+5,CGRectGetWidth(_goodImgView.frame),CGRectGetHeight(self.frame)-44-CGRectGetHeight(_goodImgView.frame));
    
    _pointImgView.frame = CGRectMake(8, CGRectGetMaxY(_goodDesLabel.frame)+6,16,16);
    
    _needPointLabel.frame = CGRectMake(CGRectGetMaxX(_pointImgView.frame)+5,CGRectGetMinY(_pointImgView.frame),60, CGRectGetHeight(_pointImgView.frame));
    
    _exchangeBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-68,CGRectGetMaxY(_goodDesLabel.frame)+3,60,22);
    
    
}





-(void)setGoodsModel:(PointGoodsModel *)GoodsModel{
    _GoodsModel = GoodsModel;
    if (!_goodImgView) {
        _goodImgView = [[UIImageView alloc]init];
        _goodImgView.contentMode =UIViewContentModeScaleAspectFill;
        _goodImgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_goodImgView];
    }
    
    if (!_goodDesLabel) {
        _goodDesLabel = [[UILabel alloc]init];
        _goodDesLabel.numberOfLines = 2;
        _goodDesLabel.font = [UIFont systemFontOfSize:12];
        _goodDesLabel.textColor = subHeadingColor;
        [self.contentView addSubview:_goodDesLabel];
    }
    
    if (!_pointImgView) {
        _pointImgView = [[UIImageView alloc]init];
        [self.contentView addSubview:_pointImgView];
    }
    
    if (!_needPointLabel) {
        _needPointLabel = [[UILabel alloc]init];
        _needPointLabel.font = [UIFont systemFontOfSize:14];
        _needPointLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_needPointLabel];
    }
    if (!_exchangeBtn) {
        
        _exchangeBtn = [[UIButton alloc]init];
        _exchangeBtn.layer.cornerRadius = 3;
        _exchangeBtn.layer.masksToBounds = YES;
        [_exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [_exchangeBtn setBackgroundColor:emphasizeTextColor];
        [self.contentView addSubview:_exchangeBtn];
    }
  
    
    [_goodImgView sd_setImageWithURL:[NSURL URLWithString:_GoodsModel.pgImgPath] placeholderImage:[UIImage imageNamed:@"bg_morentu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image) {
            //产生逐渐显示的效果
            _goodImgView.alpha=0.2;
            [UIView animateWithDuration:0.5 animations:^(){
                _goodImgView.alpha=1.0;
            }completion:^(BOOL finished){
                
            }];
        }
    }];
    

    
    _goodDesLabel.text = _GoodsModel.pgName;
    _pointImgView.image =[UIImage imageNamed:@"ic_jifen"];
    _needPointLabel.text =[NSString stringWithFormat:@"%ld",(long)GoodsModel.pgNumber];
 
  
}




@end
