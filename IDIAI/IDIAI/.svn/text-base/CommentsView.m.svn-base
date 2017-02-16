//
//  CommentsView.m
//  IDIAI
//
//  Created by iMac on 14-12-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CommentsView.h"
#import "util.h"

@implementation CommentsView
@synthesize textf;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        control = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
        [control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self createThing];
    }
    return self;
}

-(void)createThing{
    
    self.lab_tx=[[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-140)/2, 10, 140, 20)];
    self.lab_tx.font=[UIFont systemFontOfSize:13];
    self.lab_tx.textAlignment=NSTextAlignmentCenter;
    self.lab_tx.backgroundColor=[UIColor clearColor];
    self.lab_tx.textColor=[UIColor redColor];
    self.lab_tx.text=@"";
    [self addSubview:self.lab_tx];
    
    UILabel *lab_pf=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 20)];
    lab_pf.font=[UIFont systemFontOfSize:16];
    lab_pf.textAlignment=NSTextAlignmentLeft;
    lab_pf.backgroundColor=[UIColor clearColor];
    lab_pf.textColor=[UIColor grayColor];
    lab_pf.text=@"滑动评分";
    [self addSubview:lab_pf];
    
    //加载星级（0-10,0表示无星级）
    self.numberStart = 0;
    self.startView = [[UIView alloc] init];
    self.startView.frame=CGRectMake(10, 35, 160, 20);
    [self.startView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.startView];
    _imageViewArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*20, 3,15, 15)];
            [self.imageViewArray addObject:imageView];
            [self.startView addSubview:imageView];
        }
    }
    [self numberStartReLoad:self.numberStart];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.startView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoGesture:)];
    [self.startView addGestureRecognizer:tapGesture];
    
    UILabel *lab_wyp=[[UILabel alloc]initWithFrame:CGRectMake(20, 65, 120, 20)];
    lab_wyp.font=[UIFont systemFontOfSize:16];
    lab_wyp.textAlignment=NSTextAlignmentLeft;
    lab_wyp.backgroundColor=[UIColor clearColor];
    lab_wyp.textColor=[UIColor grayColor];
    lab_wyp.text=@"我要评";
    [self addSubview:lab_wyp];
    
    textf=[[UITextView alloc]initWithFrame:CGRectMake(20, 95, kMainScreenWidth-40, 90)];
    //    textf.backgroundColor=[UIColor clearColor];
    [[UITextView appearance] setTintColor:[UIColor redColor]]; //设置光标颜色
    textf.returnKeyType=UIReturnKeyDefault;
    textf.font=[UIFont systemFontOfSize:16];
    //给按钮加一个白色的板框
    textf.layer.borderColor = [[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5] CGColor];
    textf.layer.borderWidth = 0.5f;
    textf.scrollEnabled=YES;
    textf.delegate=self;
    [self addSubview:textf];
    [textf becomeFirstResponder];
    
    self.btn_tj = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn_tj setFrame:CGRectMake(kMainScreenWidth-140, 195, 100, 40)];
    [self.btn_tj setTitle:@"提交" forState:UIControlStateNormal];
    [self.btn_tj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn_tj.tag=1;
    //给按钮加一个白色的板框
    self.btn_tj.layer.borderColor = [[UIColor colorWithHexString:@"#CA5A59" alpha:1.0] CGColor];
    self.btn_tj.layer.borderWidth = 0.5f;
    //给按钮设置弧度,这里将按钮变成了圆形
    self.btn_tj.layer.cornerRadius = 5.0f;
    self.btn_tj.layer.masksToBounds = YES;
    [self.btn_tj setBackgroundImage:[util imageWithColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0]] forState:UIControlStateNormal];
    [self.btn_tj setBackgroundImage:[util imageWithColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0]] forState:UIControlStateHighlighted];
    [self.btn_tj addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn_tj];
    
    self.btn_qx = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn_qx setFrame:CGRectMake(40, 195,100, 40)];
    self.btn_qx.tag=2;
    //给按钮加一个白色的板框
    self.btn_qx.layer.borderColor = [[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5] CGColor];
    self.btn_qx.layer.borderWidth = 0.5f;
    //给按钮设置弧度,这里将按钮变成了圆形
    self.btn_qx.layer.cornerRadius = 5.0f;
    self.btn_qx.layer.masksToBounds = YES;
    [self.btn_qx setTitle:@"取消" forState:UIControlStateNormal];
    [self.btn_qx setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.btn_tj.backgroundColor=[UIColor whiteColor];
    [self.btn_qx addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn_qx];
}

-(void)pressbtn:(UIButton *)btn{
    if(btn.tag==1){
        if(textf.text.length && self.numberStart>0.0){
            [textf resignFirstResponder];
            [self.delegate didFinishedComments:textf.text star:self.numberStart];
        }
        else{
            self.lab_tx.text=@"亲，给我们个评价吧";
            [self performSelector:@selector(hideLab:) withObject:@"" afterDelay:1.5];
        }
    }
    else{
        [textf resignFirstResponder];
        [self.delegate didFinishedComments:@"" star:0];
    }
}

-(void)hideLab:(NSString *)title{
    self.lab_tx.text=title;
}

- (void)show {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:control];
    [keywindow addSubview:self];
}

-(void)dismiss{
    [textf resignFirstResponder];
    [UIView animateWithDuration:.35 animations:^{
        self.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245);
    } completion:^(BOOL finished) {
        if (finished) {
            [control removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

#pragma mark -
#pragma mark - UITextFieldDelegate

-(void)textViewDidEndEditing:(UITextView *)textView{
    //[self endEditing:YES];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
   // return YES;
    
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = 50-[new length];
    if(res >= 0){
        return YES;
    }
    else{
        self.lab_tx.text=@"亲，最多输入50个字";
        [self performSelector:@selector(hideLab:) withObject:@"" afterDelay:1.5];
        return NO;
    }
}

-(void)textViewDidChange:(UITextView *)textView{

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
   // [self endEditing:YES];
}

#pragma mark -
#pragma mark - gestrue

- (void)handlePanGesture:(UIGestureRecognizer *)sender {
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart = 0;
        }
        else if (translation.x >10 &&translation.x <25) {
            self.numberStart = 1;
        }
        else if (translation.x >= 25 &&translation.x <40) {
            self.numberStart = 2;
        }
        else if(translation.x >= 40 &&translation.x < 55){
            self.numberStart = 3;
        }
        else if (translation.x >= 55 &&translation.x < 70) {
            self.numberStart = 4;
        }
        else if(translation.x >=70 &&translation.x < 85)
        {
            self.numberStart = 5;
        }
        else if (translation.x >=85 &&translation.x <100) {
            self.numberStart = 6;
        }
        else if (translation.x >= 100 &&translation.x <115) {
            self.numberStart = 7;
        }
        else if(translation.x >= 115 &&translation.x < 130){
            self.numberStart = 8;
        }
        else if (translation.x >= 130 &&translation.x < 145) {
            self.numberStart = 9;
        }
        else if(translation.x >= 145 &&translation.x < 160)
        {
            self.numberStart = 10;
        }
        else if(translation.x >=160)
        {
            self.numberStart = 10;
        }
        [self numberStartReLoad:self.numberStart];
    }
}
-(void)handleTwoGesture:(UIGestureRecognizer *)sender{
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart = 0;
        }
        else if (translation.x >10 &&translation.x <20) {
            self.numberStart = 1;
        }
        else if (translation.x >= 20 &&translation.x <30) {
            self.numberStart = 2;
        }
        else if(translation.x >= 30 &&translation.x < 40){
            self.numberStart = 3;
        }
        else if (translation.x >= 40 &&translation.x < 50) {
            self.numberStart = 4;
        }
        else if(translation.x >=50 &&translation.x < 60)
        {
            self.numberStart = 5;
        }
        else if (translation.x >=60 &&translation.x <70) {
            self.numberStart = 6;
        }
        else if (translation.x >= 70 &&translation.x <80) {
            self.numberStart = 7;
        }
        else if(translation.x >= 80 &&translation.x < 90){
            self.numberStart = 8;
        }
        else if (translation.x >= 90 &&translation.x < 100) {
            self.numberStart = 9;
        }
        else if(translation.x >= 100 &&translation.x < 110)
        {
            self.numberStart = 10;
        }
        else if(translation.x >=110)
        {
            self.numberStart = 10;
        }
        [self numberStartReLoad:self.numberStart];
    }
    
}
- (void)numberStartReLoad:(NSInteger)number {
    int fullNum = (int)number/2;
    int halfNum = number%2;
    int emptyNum = 5 - fullNum -halfNum;
    NSMutableArray *starArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            if (fullNum != 0 ) {
                fullNum --;
                [starArray addObject:@"0"];
            }else if(fullNum == 0 &&halfNum != 0)
            {
                halfNum --;
                [starArray addObject:@"1"];
            }
            else if(fullNum == 0 &&halfNum == 0 &&emptyNum!= 0)
            {
                emptyNum --;
                [starArray addObject:@"2"];
            }
            UIImageView *imageView = [self.imageViewArray objectAtIndex:i];
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_xing_%@",[starArray objectAtIndex:i]]]];
        }
    }
}


@end
