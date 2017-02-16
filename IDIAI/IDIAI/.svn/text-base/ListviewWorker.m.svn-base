//
//  ListviewWorker.m
//  IDIAI
//
//  Created by iMac on 14-12-1.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ListviewWorker.h"
#import "HexColor.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))
#define SECTION_BTN_TAG_BEGIN   1000
#define SECTION_IV_TAG_BEGIN    3000
#define CELL_LINE_TAG  4000

@implementation ListviewWorker

@synthesize array_data_first,array_data_second,array_data_three,delegate;


- (id)initWithFrame:(CGRect)frame  array_name:(NSArray *)arr_name type:(NSInteger)type_{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        currentExtendSection = -1;
        self.selected_cell_first=0;
        self.selected_cell_second=0;
        self.selected_cell_three=0;
        self.backgroundColor=[UIColor whiteColor];
        
        for (int i=0; i<3; i++) {
            UIButton *sectionBtn=(UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN+i];
            if(!sectionBtn) sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake((kMainScreenWidth/3)*i, 1, kMainScreenWidth/3, self.frame.size.height)];
            sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
            [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            [sectionBtn  setTitle:[arr_name objectAtIndex:i] forState:UIControlStateNormal];
            [sectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            sectionBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [sectionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 40)];
            sectionBtn.backgroundColor=[UIColor whiteColor];
            [self addSubview:sectionBtn];
 
            UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth/3)*i +((kMainScreenWidth/3) - 16)-20, (self.frame.size.height-8)/2+1, 15, 8)];
            [sectionBtnIv setImage:[UIImage imageNamed:@"ic_xjt"]];
            [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
            sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
            [self addSubview: sectionBtnIv];
        }
    }
    return self;
}

-(void)CreateViewType:(NSInteger)type_index{
    
    self.selected_type=type_index; //获取按钮的编号
    
    //创建tableview
    if(!self.mTableBaseView) self.mTableBaseView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height , self.frame.size.width, self.mSuperView.frame.size.height - self.frame.origin.y - self.frame.size.height)];
    self.mTableBaseView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.30];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self.mTableBaseView addGestureRecognizer:bgTap];
    
    float height=280;
    if(kMainScreenHeight<=480) height=280;
    else if (kMainScreenHeight>480 &&  kMainScreenHeight<=568) height=300;
    else if (kMainScreenHeight>568 &&  kMainScreenHeight<=667) height=360;
    else if (kMainScreenHeight>667) height=400;
    
        if(!self.mTableView_left) self.mTableView_left=[[UITableView alloc]initWithFrame:CGRectMake(0, 40,kMainScreenWidth, height) style:UITableViewStylePlain];
        self.mTableView_left.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.mTableView_left.delegate=self;
        self.mTableView_left.dataSource=self;
    
    //修改tableview的frame
    CGRect rect_left = self.mTableView_left.frame;
    rect_left.size.height = 0;
    self.mTableView_left.frame = rect_left;
    
    //动画设置位置
    rect_left .size.height = height;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.mTableBaseView.alpha = 1.0;
        self.mTableView_left.alpha = 1.0;
        
        self.mTableView_left.frame =  rect_left;
    }];
    [self.mTableView_left reloadData];
    
    [self.mSuperView addSubview:self.mTableBaseView];
    [self.mSuperView addSubview:self.mTableView_left];
}

-  (void)hideExtendedChooseView:(NSInteger)index
{
    if (currentExtendSection != -1) {
        currentExtendSection = -1;
        
        CGRect rect_left = self.mTableView_left.frame;
        rect_left.size.height = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableBaseView.alpha = 1.0;
            self.mTableView_left.alpha = 1.0;
            
            self.mTableView_left.frame = rect_left;
        }completion:^(BOOL finished) {
            [self.mTableView_left removeFromSuperview];
            self.mTableView_left =nil;
            
            [self.mTableBaseView removeFromSuperview];
            self.mTableBaseView=nil;
        }];
    }
}

-(void)sectionBtnTouch:(UIButton *)btn{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    
    UIImageView *currentIV= (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN +currentExtendSection)];
    
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    
    if (currentExtendSection == section) {
        [self hideExtendedChooseView:section];
    }else{
        [self.mTableView_left removeFromSuperview];
        self.mTableView_left =nil;

        currentExtendSection = section;
        currentIV = (UIImageView *)[self viewWithTag:SECTION_IV_TAG_BEGIN + currentExtendSection];
        [UIView animateWithDuration:0.3 animations:^{
            currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
        }];
        
        [self CreateViewType:section];
    }
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    [self hideExtendedChooseView:SECTION_IV_TAG_BEGIN + currentExtendSection];
}

#pragma mark -- UITableView DataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.selected_type==0){
        return [array_data_first count];
    }
    else if(self.selected_type==1){
        return [array_data_second count];
    }
    else{
        return [array_data_three count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString * cellIdentifier = [NSString stringWithFormat:@"mycellid_%ld",(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
    
        if(self.selected_type==0){
            cell.textLabel.text =[[array_data_first objectAtIndex:indexPath.row] objectForKey:@"areaName"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            if(indexPath.row!=self.selected_cell_first){
                UIView *line=(UIView *)[cell viewWithTag:CELL_LINE_TAG + indexPath.row];
                if(!line) line=[[UIView alloc]initWithFrame:CGRectMake(20, cell.frame.size.height-1, kMainScreenWidth-40, 1)];
                line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
                line.tag=CELL_LINE_TAG+indexPath.row;
                [cell addSubview:line];
                cell.textLabel.textColor=[UIColor blackColor];
            }
            else{
                UIView *line=(UIView *)[cell viewWithTag:CELL_LINE_TAG + indexPath.row];
                if(!line) line=[[UIView alloc]initWithFrame:CGRectMake(20, cell.frame.size.height-1, kMainScreenWidth-40, 1)];
                line.backgroundColor=[UIColor redColor];
                line.tag=CELL_LINE_TAG+indexPath.row;
                [cell addSubview:line];
                cell.textLabel.textColor=[UIColor redColor];
            }
        }
        else if(self.selected_type==1){
            if(indexPath.row==0) cell.backgroundColor=[UIColor whiteColor];
            else cell.backgroundColor=[UIColor clearColor];
            cell.textLabel.text = [[array_data_second objectAtIndex:indexPath.row] objectForKey:@"jobscopeName"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            if(indexPath.row!=self.selected_cell_second){
                UIView *line=(UIView *)[cell viewWithTag:CELL_LINE_TAG + indexPath.row];
                if(!line) line=[[UIView alloc]initWithFrame:CGRectMake(20, cell.frame.size.height-1, kMainScreenWidth-40, 1)];
                line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
                line.tag=CELL_LINE_TAG+indexPath.row;
                [cell addSubview:line];
                cell.textLabel.textColor=[UIColor blackColor];
            }
            else{
                UIView *line=(UIView *)[cell viewWithTag:CELL_LINE_TAG + indexPath.row];
                if(!line) line=[[UIView alloc]initWithFrame:CGRectMake(20, cell.frame.size.height-1, kMainScreenWidth-40, 1)];
                line.backgroundColor=[UIColor redColor];
                line.tag=CELL_LINE_TAG+indexPath.row;
                [cell addSubview:line];
                cell.textLabel.textColor=[UIColor redColor];
            }
        }
        else{
            cell.textLabel.text = [array_data_three objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            if(indexPath.row!=self.selected_cell_three){
                UIView *line=(UIView *)[cell viewWithTag:CELL_LINE_TAG + indexPath.row];
                if(!line) line=[[UIView alloc]initWithFrame:CGRectMake(20, cell.frame.size.height-1, kMainScreenWidth-40, 1)];
                line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
                line.tag=CELL_LINE_TAG+indexPath.row;
                [cell addSubview:line];
                cell.textLabel.textColor=[UIColor blackColor];
            }
            else{
                UIView *line=(UIView *)[cell viewWithTag:CELL_LINE_TAG + indexPath.row];
                if(!line) line=[[UIView alloc]initWithFrame:CGRectMake(20, cell.frame.size.height-1, kMainScreenWidth-40, 1)];
                line.backgroundColor=[UIColor redColor];
                line.tag=CELL_LINE_TAG+indexPath.row;
                [cell addSubview:line];
                cell.textLabel.textColor=[UIColor redColor];
            }
        }
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selected_type==0){
        
        //上次选中的cell
        UITableViewCell *selectedcell_pre=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selected_cell_first inSection:0]];
        UIView *line_pre=(UIView *)[selectedcell_pre viewWithTag:CELL_LINE_TAG+self.selected_cell_first];
        line_pre.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        selectedcell_pre.textLabel.textColor=[UIColor blackColor];
        
        //当前即将选择的cell
        UITableViewCell *selectedcell_next=[tableView cellForRowAtIndexPath:indexPath];
        UIView *line_next=(UIView *)[selectedcell_next viewWithTag:CELL_LINE_TAG+indexPath.row];
        line_next.backgroundColor=[UIColor orangeColor];
        selectedcell_next.textLabel.textColor=[UIColor redColor];
        
        self.selected_cell_first=indexPath.row;
        
        //改变top按钮颜色
        for (int i=0; i<3; i++) {
            UIButton *btn=(UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN+i];
            if(i==0) {
                [btn setTitle:[[array_data_first objectAtIndex:indexPath.row] objectForKey:@"areaName"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }

        
        [self bgTappedAction:nil];
        if([delegate respondsToSelector:@selector(chooseAtSection:indexId:)])
            [delegate chooseAtSection:self.selected_type indexId:[[array_data_first objectAtIndex:indexPath.row] objectForKey:@"areaCode"]];
    }
    else if (self.selected_type==1) {
        
        //上次选中的cell
        UITableViewCell *selectedcell_pre=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selected_cell_second inSection:0]];
        UIView *line_pre=(UIView *)[selectedcell_pre viewWithTag:CELL_LINE_TAG+self.selected_cell_second];
        line_pre.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        selectedcell_pre.textLabel.textColor=[UIColor blackColor];
        
        //当前即将选择的cell
        UITableViewCell *selectedcell_next=[tableView cellForRowAtIndexPath:indexPath];
        UIView *line_next=(UIView *)[selectedcell_next viewWithTag:CELL_LINE_TAG+indexPath.row];
        line_next.backgroundColor=[UIColor redColor];
        selectedcell_next.textLabel.textColor=[UIColor redColor];
        
        self.selected_cell_second=indexPath.row;
        
        //改变top按钮颜色
        for (int i=0; i<3; i++) {
            UIButton *btn=(UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN+i];
            if(i==1) {
                [btn setTitle:[[array_data_second objectAtIndex:indexPath.row] objectForKey:@"jobscopeName"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }

        
            [self bgTappedAction:nil];
            if([delegate respondsToSelector:@selector(chooseAtSection:indexId:)])
                [delegate chooseAtSection:self.selected_type indexId:[NSString stringWithFormat:@"%@",[[array_data_second objectAtIndex:indexPath.row] objectForKey:@"jobscopeId"]]];
    }
    else{
        
        //上次选中的cell
        UITableViewCell *selectedcell_pre=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selected_cell_three inSection:0]];
        UIView *line_pre=(UIView *)[selectedcell_pre viewWithTag:CELL_LINE_TAG+self.selected_cell_three];
        line_pre.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        selectedcell_pre.textLabel.textColor=[UIColor blackColor];
        
        //当前即将选择的cell
        UITableViewCell *selectedcell_next=[tableView cellForRowAtIndexPath:indexPath];
        UIView *line_next=(UIView *)[selectedcell_next viewWithTag:CELL_LINE_TAG+indexPath.row];
        line_next.backgroundColor=[UIColor orangeColor];
        selectedcell_next.textLabel.textColor=[UIColor redColor];
        
        self.selected_cell_three=indexPath.row;
        
        //改变top按钮颜色
        for (int i=0; i<3; i++) {
            UIButton *btn=(UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN+i];
            if(i==2) {
                [btn setTitle:[array_data_three objectAtIndex:indexPath.row] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }

        
        [self bgTappedAction:nil];
        if([delegate respondsToSelector:@selector(chooseAtSection:indexId:)])
            [delegate chooseAtSection:self.selected_type indexId:[NSString stringWithFormat:@"%d",[array_data_three indexOfObject:[array_data_three objectAtIndex:indexPath.row]]+1]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
