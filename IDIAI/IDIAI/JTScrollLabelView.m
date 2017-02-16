//
//  JTScrollLabelView.m
//  PlayVideoDemo
//
//  Created by iMac on 16/2/17.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "JTScrollLabelView.h"

//屏幕的宽、高
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation JTScrollLabelView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        _showLabelsIndex=0;
        
        _showLabelTop=[[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width-90, 20)];
        _showLabelTop.backgroundColor=[UIColor clearColor];
        _showLabelTop.font=[UIFont systemFontOfSize:13.5];
        _showLabelTop.textColor=[UIColor darkGrayColor];
        _showLabelTop.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_showLabelTop];
        _showLabelTop.alpha=0.05;
        
        _showLabelMiddle=[[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height+25, self.bounds.size.width-90, 20)];
        _showLabelMiddle.backgroundColor=[UIColor clearColor];
        _showLabelMiddle.font=[UIFont systemFontOfSize:13.5];
        _showLabelMiddle.textColor=[UIColor darkGrayColor];
        _showLabelMiddle.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_showLabelMiddle];
        _showLabelMiddle.alpha=0.05;
        
        _showLabelFoot=[[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height+50, self.bounds.size.width-90, 20)];
        _showLabelFoot.backgroundColor=[UIColor clearColor];
        _showLabelFoot.font=[UIFont systemFontOfSize:13.5];
        _showLabelFoot.textColor=[UIColor darkGrayColor];
        _showLabelFoot.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_showLabelFoot];
        _showLabelFoot.alpha=0.05;
        
 /*******************************************************************************************************/
        
        _timeLabelTop=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_showLabelTop.frame)+5, self.bounds.size.height, 85, 20)];
        _timeLabelTop.backgroundColor=[UIColor clearColor];
        _timeLabelTop.font=[UIFont systemFontOfSize:13.5];
        _timeLabelTop.textColor=[UIColor darkGrayColor];
        _timeLabelTop.textAlignment=NSTextAlignmentRight;
        [self addSubview:_timeLabelTop];
        _timeLabelTop.alpha=0.05;
        
        _timeLabelMiddle=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_showLabelMiddle.frame)+5, self.bounds.size.height+25, 85, 20)];
        _timeLabelMiddle.backgroundColor=[UIColor clearColor];
        _timeLabelMiddle.font=[UIFont systemFontOfSize:13.5];
        _timeLabelMiddle.textColor=[UIColor darkGrayColor];
        _timeLabelMiddle.textAlignment=NSTextAlignmentRight;
        [self addSubview:_timeLabelMiddle];
        _timeLabelMiddle.alpha=0.05;
        
        _timeLabelFoot=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_showLabelFoot.frame)+5, self.bounds.size.height+50, 85, 20)];
        _timeLabelFoot.backgroundColor=[UIColor clearColor];
        _timeLabelFoot.font=[UIFont systemFontOfSize:13.5];
        _timeLabelFoot.textColor=[UIColor darkGrayColor];
        _timeLabelFoot.textAlignment=NSTextAlignmentRight;
        [self addSubview:_timeLabelFoot];
        _timeLabelFoot.alpha=0.05;
        
        UIButton *clickBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [clickBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clickBtn];
    }
    return self;
}

-(void)clickBtn{
    [self.delegate JTScrollLabelViewClickedButtonAtIndex:_showLabelsIndex];
}

/**
 @parma 开始执行轮播
*/
- (void)beginScrollDatas:(NSArray *)dataArr TimerDatas:(NSArray *)timerArr TimeInterval:(NSTimeInterval)timer{
    _showLabelArr=dataArr;
    _timerLabelArr=timerArr;
    _scrollTimeInterval=timer;

    if([_showLabelArr count] && _showLabelsIndex<[_showLabelArr count]){
        _strShowTop=_showLabelArr[_showLabelsIndex];
        _strTimeTop=_timerLabelArr[_showLabelsIndex];
        
        _showLabelsIndex+=1;
        if(_showLabelsIndex>=[_showLabelArr count])  {
            _showLabelsIndex=0;
            _strShowMiddle=_showLabelArr[_showLabelsIndex];
            _strTimeMiddle=_timerLabelArr[_showLabelsIndex];
        }
        else {
            _strShowMiddle=_showLabelArr[_showLabelsIndex];
            _strTimeMiddle=_timerLabelArr[_showLabelsIndex];
        }
        
        _showLabelsIndex+=1;
        if(_showLabelsIndex>=[_showLabelArr count]) {
            _showLabelsIndex=0;
            _strShowFoot=_showLabelArr[_showLabelsIndex];
            _strTimeFoot=_timerLabelArr[_showLabelsIndex];
        }
        else {
            _strShowFoot=_showLabelArr[_showLabelsIndex];
            _strTimeFoot=_timerLabelArr[_showLabelsIndex];
        }
        [_timerScr invalidate];
        _timerScr = nil;
        _timerScr = [NSTimer scheduledTimerWithTimeInterval:timer target:self selector:@selector(ScrOllView) userInfo:nil repeats:YES];
    }
}

-(void)ScrOllView{
    /*Top*/
    _showLabelTop.text=_strShowTop;
    CGRect rect_Top=_showLabelTop.frame;
    rect_Top.origin.y=rect_Top.origin.y-0.5;
    _showLabelTop.frame=rect_Top;
    if(rect_Top.origin.y==self.bounds.size.height) _showLabelTop.alpha+=0.0;
    else if(rect_Top.origin.y<self.bounds.size.height && rect_Top.origin.y>self.bounds.size.height/2) _showLabelTop.alpha+=0.012;
    else if (rect_Top.origin.y==self.bounds.size.height/2-5) _showLabelTop.alpha+=0.1;
    else if(rect_Top.origin.y<self.bounds.size.height/2-5){
        _showLabelTop.alpha-=0.012;
    }
    
    if(rect_Top.origin.y<=-20){
        rect_Top.origin.y=self.bounds.size.height;
        _showLabelTop.frame=rect_Top;
        _showLabelTop.alpha=0.05;
        
        _showLabelsIndex+=1;
        if(_showLabelsIndex>=[_showLabelArr count]) _showLabelsIndex=0;
        _strShowTop=_showLabelArr[_showLabelsIndex];
    }
    
    _timeLabelTop.text=_strTimeTop;
    CGRect rect_Time_Top=_timeLabelTop.frame;
    rect_Time_Top.origin.y=rect_Time_Top.origin.y-0.5;
    _timeLabelTop.frame=rect_Time_Top;
    if(rect_Time_Top.origin.y==self.bounds.size.height) _timeLabelTop.alpha+=0.0;
    else if(rect_Time_Top.origin.y<self.bounds.size.height && rect_Time_Top.origin.y>self.bounds.size.height/2) _timeLabelTop.alpha+=0.012;
    else if (rect_Time_Top.origin.y==self.bounds.size.height/2-5) _timeLabelTop.alpha+=0.1;
    else if(rect_Time_Top.origin.y<self.bounds.size.height/2-5){
        _timeLabelTop.alpha-=0.012;
    }
    
    if(rect_Time_Top.origin.y<=-20){
        rect_Time_Top.origin.y=self.bounds.size.height;
        _timeLabelTop.frame=rect_Time_Top;
        _timeLabelTop.alpha=0.05;

        if(_showLabelsIndex>=[_timerLabelArr count]) _strTimeTop=@"";
        else _strTimeTop=_timerLabelArr[_showLabelsIndex];
    }
    
    /*Middle*/
    float SecondOriginY=CGRectGetMinY(_showLabelMiddle.frame);
    _showLabelMiddle.text=_strShowMiddle;
    CGRect rect_Middle=_showLabelMiddle.frame;
    rect_Middle.origin.y=SecondOriginY-0.5;  //
    _showLabelMiddle.frame=rect_Middle;
    if(rect_Middle.origin.y==self.bounds.size.height) _showLabelMiddle.alpha+=0.0;
    else if(rect_Middle.origin.y<self.bounds.size.height && rect_Middle.origin.y>self.bounds.size.height/2) _showLabelMiddle.alpha+=0.012;
    else if (rect_Middle.origin.y==self.bounds.size.height/2-5) _showLabelMiddle.alpha+=0.1;
    else if(rect_Middle.origin.y<self.bounds.size.height/2-5) {
        _showLabelMiddle.alpha-=0.012;
    }
    
    if(rect_Middle.origin.y<=-20){
        rect_Middle.origin.y=self.bounds.size.height;
        _showLabelMiddle.frame=rect_Middle;
        _showLabelMiddle.alpha=0.05;
        
        _showLabelsIndex+=1;
        if(_showLabelsIndex>=[_showLabelArr count]) _showLabelsIndex=0;
        _strShowMiddle=_showLabelArr[_showLabelsIndex];
    }
    
    _timeLabelMiddle.text=_strTimeMiddle;
    CGRect rect_Time_Middle=_timeLabelMiddle.frame;
    rect_Time_Middle.origin.y=rect_Time_Middle.origin.y-0.5;
    _timeLabelMiddle.frame=rect_Time_Middle;
    if(rect_Time_Middle.origin.y==self.bounds.size.height) _timeLabelMiddle.alpha+=0.0;
    else if(rect_Time_Middle.origin.y<self.bounds.size.height && rect_Time_Middle.origin.y>self.bounds.size.height/2) _timeLabelMiddle.alpha+=0.012;
    else if (rect_Time_Middle.origin.y==self.bounds.size.height/2-5) _timeLabelMiddle.alpha+=0.1;
    else if(rect_Time_Middle.origin.y<self.bounds.size.height/2-5){
        _timeLabelMiddle.alpha-=0.012;
    }
    
    if(rect_Time_Middle.origin.y<=-20){
        rect_Time_Middle.origin.y=self.bounds.size.height;
        _timeLabelMiddle.frame=rect_Time_Middle;
        _timeLabelMiddle.alpha=0.05;
        
        if(_showLabelsIndex>=[_timerLabelArr count]) _strTimeMiddle=@"";
        else _strTimeMiddle=_timerLabelArr[_showLabelsIndex];
    }
    
    /*Foot*/
    float ThreeOriginY=CGRectGetMinY(_showLabelFoot.frame);
    _showLabelFoot.text=_strShowFoot;
    CGRect rect_Foot=_showLabelFoot.frame;
    rect_Foot.origin.y=ThreeOriginY-0.5;   //
    _showLabelFoot.frame=rect_Foot;
    if(rect_Foot.origin.y==self.bounds.size.height) _showLabelFoot.alpha+=0.0;
    else if(rect_Foot.origin.y<self.bounds.size.height && rect_Foot.origin.y>self.bounds.size.height/2) _showLabelFoot.alpha+=0.012;
    else if (rect_Foot.origin.y==self.bounds.size.height/2-5) _showLabelFoot.alpha+=0.1;
    else if(rect_Foot.origin.y<self.bounds.size.height/2-5){
        _showLabelFoot.alpha-=0.012;
    }
    
    if(rect_Foot.origin.y<=-20){
        rect_Foot.origin.y=self.bounds.size.height;
        _showLabelFoot.frame=rect_Foot;
        _showLabelFoot.alpha=0.05;
        
        _showLabelsIndex+=1;
        if(_showLabelsIndex>=[_showLabelArr count]) _showLabelsIndex=0;
        _strShowFoot=_showLabelArr[_showLabelsIndex];
    }
    
    _timeLabelFoot.text=_strTimeFoot;
    CGRect rect_Time_Foot=_timeLabelFoot.frame;
    rect_Time_Foot.origin.y=rect_Time_Foot.origin.y-0.5;
    _timeLabelFoot.frame=rect_Time_Foot;
    if(rect_Time_Foot.origin.y==self.bounds.size.height) _timeLabelFoot.alpha+=0.0;
    else if(rect_Time_Foot.origin.y<self.bounds.size.height && rect_Time_Foot.origin.y>self.bounds.size.height/2) _timeLabelFoot.alpha+=0.012;
    else if (rect_Time_Foot.origin.y==self.bounds.size.height/2-5) _timeLabelFoot.alpha+=0.1;
    else if(rect_Time_Foot.origin.y<self.bounds.size.height/2-5){
        _timeLabelFoot.alpha-=0.012;
    }
    
    if(rect_Time_Foot.origin.y<=-20){
        rect_Time_Foot.origin.y=self.bounds.size.height;
        _timeLabelFoot.frame=rect_Time_Foot;
        _timeLabelFoot.alpha=0.05;
        
        if(_showLabelsIndex>=[_timerLabelArr count]) _strTimeFoot=@"";
        else _strTimeFoot=_timerLabelArr[_showLabelsIndex];
    }
}

/***********************************************/

- (NSString *)getDateString:(NSString *) msecStr{
    NSDate *getDate = [[NSDate alloc]initWithTimeIntervalSince1970:[msecStr doubleValue]/1000.0];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM/dd HH:mm"];
    NSString *locationString=[dateformatter stringFromDate:getDate];
    
    return locationString;
}

@end
