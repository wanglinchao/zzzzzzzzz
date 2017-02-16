//
//  MapListtype.m
//  IDIAI
//
//  Created by iMac on 14-12-2.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MapListtype.h"
#import "HexColor.h"

#define kcelltag 100
@implementation MapListtype

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.theDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DistrictCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    }
    
    UIView *line=(UIView *)[cell viewWithTag:kcelltag+indexPath.row];
    if(!line) line=[[UIView alloc]initWithFrame:CGRectMake(20, 43.5, kMainScreenWidth-100, 0.5)];
    line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
    line.tag=kcelltag+indexPath.row;
    [cell addSubview:line];
    
    cell.textLabel.text = [[self.theDataArr objectAtIndex:indexPath.row] objectForKey:@"jobscopeName"];
    if(indexPath.row==self.selected_row) cell.textLabel.textColor=[UIColor redColor];
    else cell.textLabel.textColor=[UIColor blackColor];
    return cell;
}

@end
