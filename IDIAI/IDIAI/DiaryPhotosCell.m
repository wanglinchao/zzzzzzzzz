//
//  DiaryPhotosCell.m
//  IDIAI
//
//  Created by Ricky on 15/11/24.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DiaryPhotosCell.h"
#import "HexColor.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
@implementation DiaryPhotosCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.pics =[NSMutableArray array];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGFloat)getCellHeight{
//    self.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    int count =0;
    __block float height =0;
    for (NSString *picurl in self.pics) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        BOOL cachedImage = [manager cachedImageExistsForURL:[NSURL URLWithString:picurl]]; // 将需要缓存的图片加载进来
        UIImageView *photoimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, count*(kMainScreenWidth/4*3+23), kMainScreenWidth, kMainScreenWidth/4*3)];
        photoimage.backgroundColor =[UIColor redColor];
        photoimage.clipsToBounds=YES;
        photoimage.contentMode=UIViewContentModeScaleAspectFill;
        if (cachedImage) {
            UIImage *image = [manager.imageCache imageFromDiskCacheForKey:picurl];
        
            photoimage.frame =CGRectMake(photoimage.frame.origin.x, height, kMainScreenWidth, image.size.height*kMainScreenWidth/image.size.width);
            photoimage.image =[self OriginImage:image scaleToSize:CGSizeMake(kMainScreenWidth, image.size.height*kMainScreenWidth/image.size.width)];
            height +=23+photoimage.frame.size.height;
        } else {
            [photoimage sd_setImageWithURL:[NSURL URLWithString:picurl] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (picurl.length>0) {
                    photoimage.frame =CGRectMake(photoimage.frame.origin.x, height, kMainScreenWidth, image.size.height*kMainScreenWidth/image.size.width);
                    height+=image.size.height*kMainScreenWidth/image.size.width;
                    photoimage.image =[self OriginImage:image scaleToSize:CGSizeMake(kMainScreenWidth, kMainScreenWidth/4*3)];
                    if (count ==self.pics.count-1) {
                        [self.delegate reloadCell];
                    }
                }
                
            }];
        }
        [self addSubview:photoimage];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        photoimage.userInteractionEnabled =YES;
        [photoimage addGestureRecognizer:tap];
        photoimage.tag =100+count;
        
        if (count !=self.pics.count-1) {
            UIImageView *footimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, height, kMainScreenWidth, 23)];
            footimage.backgroundColor =[UIColor clearColor];
            [self addSubview:footimage];
        }
        count++;
    }
    if (height==0) {
        height =count*(kMainScreenWidth/4*3+23);
    }
    if (height ==0) {
        return 0;
    }else{
        return height-23;
    }
    
}
-(void)tapAction:(UIGestureRecognizer *)sender{
    [self.delegate touchPhotos:self.pics index:sender.view.tag-100 view:(UIImageView *)sender.view];
}
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
@end
