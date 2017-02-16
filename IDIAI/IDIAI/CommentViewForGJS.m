//
//  CommentViewForGJS.m
//  IDIAI
//
//  Created by iMac on 15/10/26.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CommentViewForGJS.h"
#import "util.h"
#import "TLToast.h"

@implementation CommentViewForGJS
@synthesize textf;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame title:(NSArray *)title_arr{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        control = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
        [control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self createThing:title_arr];
    }
    return self;
}

-(void)createThing:(NSArray *)title_{
    
    /*1111*/
    UILabel *lab_one=[[UILabel alloc]initWithFrame:CGRectMake(20, 11, 70, 20)];
    lab_one.font=[UIFont systemFontOfSize:15];
    lab_one.textAlignment=NSTextAlignmentLeft;
    lab_one.backgroundColor=[UIColor clearColor];
    lab_one.textColor=[UIColor darkGrayColor];
    lab_one.text=title_[0];
    [self addSubview:lab_one];
    
    //加载星级（0-10,0表示无星级）
    self.numberStart = 0;
    self.startView = [[UIView alloc] initWithFrame:CGRectMake(90, 10, 160, 20)];
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
    
    /*2222*/
    UILabel *lab_two=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.startView.frame)+6, 70, 20)];
    lab_two.font=[UIFont systemFontOfSize:15];
    lab_two.textAlignment=NSTextAlignmentLeft;
    lab_two.backgroundColor=[UIColor clearColor];
    lab_two.textColor=[UIColor darkGrayColor];
    lab_two.text=title_[1];
    [self addSubview:lab_two];
    
    //加载星级（0-10,0表示无星级）
    self.numberStart_two = 0;
    self.startView_two = [[UIView alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(self.startView.frame)+5, 160, 20)];
    [self.startView_two setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.startView_two];
    _imageViewArray_two = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*20, 3,15, 15)];
            [self.imageViewArray_two addObject:imageView];
            [self.startView_two addSubview:imageView];
        }
    }
    [self numberStartReLoad_two:self.numberStart_two];
    UIPanGestureRecognizer *panGesture_two = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture_two:)];
    [self.startView_two addGestureRecognizer:panGesture_two];
    
    /*3333*/
    UILabel *lab_three=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.startView_two.frame)+6, 70, 20)];
    lab_three.font=[UIFont systemFontOfSize:15];
    lab_three.textAlignment=NSTextAlignmentLeft;
    lab_three.backgroundColor=[UIColor clearColor];
    lab_three.textColor=[UIColor darkGrayColor];
    lab_three.text=title_[2];
    [self addSubview:lab_three];
    
    //加载星级（0-10,0表示无星级）
    self.numberStart_three = 0;
    self.startView_three = [[UIView alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(self.startView_two.frame)+5, 160, 20)];
    [self.startView_three setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.startView_three];
    _imageViewArray_three = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*20, 3,15, 15)];
            [self.imageViewArray_three addObject:imageView];
            [self.startView_three addSubview:imageView];
        }
    }
    [self numberStartReLoad_three:self.numberStart_three];
    UIPanGestureRecognizer *panGesture_three = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture_three:)];
    [self.startView_three addGestureRecognizer:panGesture_three];
    
    
    UILabel *lab_wyp=[[UILabel alloc]initWithFrame:CGRectMake(20, 95, 60, 20)];
    lab_wyp.font=[UIFont systemFontOfSize:15];
    lab_wyp.textAlignment=NSTextAlignmentLeft;
    lab_wyp.backgroundColor=[UIColor clearColor];
    lab_wyp.textColor=[UIColor darkGrayColor];
    lab_wyp.text=@"我要评";
    [self addSubview:lab_wyp];
    float height =0;
    if (kMainScreenHeight<=480) {
        height =-25;
    }
    
    textf=[[UITextView alloc]initWithFrame:CGRectMake(80, 95, kMainScreenWidth-100, 90+height)];
    //    textf.backgroundColor=[UIColor clearColor];
    [[UITextView appearance] setTintColor:[UIColor redColor]]; //设置光标颜色
    textf.returnKeyType=UIReturnKeyDefault;
    textf.font=[UIFont systemFontOfSize:15];
    //给按钮加一个白色的板框
    textf.layer.borderColor = [[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5] CGColor];
    textf.layer.borderWidth = 0.5f;
    textf.scrollEnabled=YES;
    textf.delegate=self;
    [self addSubview:textf];
    [textf becomeFirstResponder];
    
    self.btn_tj = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn_tj setFrame:CGRectMake(kMainScreenWidth-140, 195+height, 100, 40)];
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
    [self.btn_qx setFrame:CGRectMake(40, 195+height,100, 40)];
    self.btn_qx.tag=2;
    //给按钮加一个白色的板框
    self.btn_qx.layer.borderColor = [[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5] CGColor];
    self.btn_qx.layer.borderWidth = 0.5f;
    //给按钮设置弧度,这里将按钮变成了圆形
    self.btn_qx.layer.cornerRadius = 5.0f;
    self.btn_qx.layer.masksToBounds = YES;
    [self.btn_qx setTitle:@"取消" forState:UIControlStateNormal];
    [self.btn_qx setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.btn_tj.backgroundColor=[UIColor whiteColor];
    [self.btn_qx addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn_qx];
}

-(void)pressbtn:(UIButton *)btn{
    if(btn.tag==1){
        if(textf.text.length && self.numberStart>0.0 && self.numberStart_two>0.0 && self.numberStart_three>0.0){
            [textf resignFirstResponder];
            [self.delegate didFinishedComments:textf.text star:@[@(self.numberStart),@(self.numberStart_two),@(self.numberStart_three)]];
        }
        else{
            if(textf.text.length==0) [TLToast showWithText:@"请填写描述"];
            else [TLToast showWithText:@"请进行评分"];
        }
    }
    else{
        [textf resignFirstResponder];
        [self dismiss];
    }
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
    NSInteger res = 200-[new length];
    if(res >= 0){
        return YES;
    }
    else{
        [TLToast showWithText:@"最多输入200个字"];
        return NO;
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self endEditing:YES];
}

#pragma mark -
#pragma mark - gestrue 11111

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

#pragma mark -
#pragma mark - gestrue 222222

- (void)handlePanGesture_two:(UIGestureRecognizer *)sender {
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart_two = 0;
        }
        else if (translation.x >10 &&translation.x <25) {
            self.numberStart_two = 1;
        }
        else if (translation.x >= 25 &&translation.x <40) {
            self.numberStart_two = 2;
        }
        else if(translation.x >= 40 &&translation.x < 55){
            self.numberStart_two = 3;
        }
        else if (translation.x >= 55 &&translation.x < 70) {
            self.numberStart_two = 4;
        }
        else if(translation.x >=70 &&translation.x < 85)
        {
            self.numberStart_two = 5;
        }
        else if (translation.x >=85 &&translation.x <100) {
            self.numberStart_two = 6;
        }
        else if (translation.x >= 100 &&translation.x <115) {
            self.numberStart_two = 7;
        }
        else if(translation.x >= 115 &&translation.x < 130){
            self.numberStart_two = 8;
        }
        else if (translation.x >= 130 &&translation.x < 145) {
            self.numberStart_two = 9;
        }
        else if(translation.x >= 145 &&translation.x < 160)
        {
            self.numberStart_two = 10;
        }
        else if(translation.x >=160)
        {
            self.numberStart_two = 10;
        }
        [self numberStartReLoad_two:self.numberStart_two];
    }
}

- (void)numberStartReLoad_two:(NSInteger)number {
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
            UIImageView *imageView = [self.imageViewArray_two objectAtIndex:i];
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_xing_%@",[starArray objectAtIndex:i]]]];
        }
    }
}

#pragma mark -
#pragma mark - gestrue 333333

- (void)handlePanGesture_three:(UIGestureRecognizer *)sender {
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart_three = 0;
        }
        else if (translation.x >10 &&translation.x <25) {
            self.numberStart_three = 1;
        }
        else if (translation.x >= 25 &&translation.x <40) {
            self.numberStart_three = 2;
        }
        else if(translation.x >= 40 &&translation.x < 55){
            self.numberStart_three = 3;
        }
        else if (translation.x >= 55 &&translation.x < 70) {
            self.numberStart_three = 4;
        }
        else if(translation.x >=70 &&translation.x < 85)
        {
            self.numberStart_three = 5;
        }
        else if (translation.x >=85 &&translation.x <100) {
            self.numberStart_three = 6;
        }
        else if (translation.x >= 100 &&translation.x <115) {
            self.numberStart_three = 7;
        }
        else if(translation.x >= 115 &&translation.x < 130){
            self.numberStart_three = 8;
        }
        else if (translation.x >= 130 &&translation.x < 145) {
            self.numberStart_three = 9;
        }
        else if(translation.x >= 145 &&translation.x < 160)
        {
            self.numberStart_three = 10;
        }
        else if(translation.x >=160)
        {
            self.numberStart_three = 10;
        }
        [self numberStartReLoad_three:self.numberStart_three];
    }
}

- (void)numberStartReLoad_three:(NSInteger)number {
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
            UIImageView *imageView = [self.imageViewArray_three objectAtIndex:i];
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_xing_%@",[starArray objectAtIndex:i]]]];
        }
    }
}

@end
