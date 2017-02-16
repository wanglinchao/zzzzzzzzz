//
//  DistrictView.m
//  IDIAI
//
//  Created by Ricky on 14-11-26.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DistrictView.h"

@implementation DistrictView


#pragma mark - table view datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.theDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[self.theDataArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"DistrictCell%ld%ld",(long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UIView *line=(UIView *)[cell viewWithTag:1000*(indexPath.section+1)+indexPath.row];
    if(!line) line=[[UIView alloc]initWithFrame:CGRectMake(10, 34.5, kMainScreenWidth-100, 0.3)];
    line.tag=1000*(indexPath.section+1)+indexPath.row;
    line.backgroundColor=[UIColor lightGrayColor];
    line.alpha=0.3;
    [cell addSubview:line];

    if([self.theDataArr count]){
        cell.textLabel.text = [[self.theDataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        
        NSInteger i = [[[NSUserDefaults standardUserDefaults]objectForKey:kUDEffectyTypeOfRow_Style]integerValue];
        NSInteger j = [[[NSUserDefaults standardUserDefaults]objectForKey:kUDEffectyTypeOfRow_DoorModel]integerValue];
        NSInteger k = [[[NSUserDefaults standardUserDefaults]objectForKey:kUDEffectyTypeOfRow_Price]integerValue];
        
        _theIndexPath_one = [NSIndexPath indexPathForRow:i inSection:0];
        _theIndexPath_two = [NSIndexPath indexPathForRow:j  inSection:1];
        _theIndexPath_three = [NSIndexPath indexPathForRow:k inSection:2];
      
        if (indexPath == _theIndexPath_one) cell.textLabel.textColor = kThemeColor;
        else if (indexPath == _theIndexPath_two) cell.textLabel.textColor = kThemeColor;
        else if (indexPath == _theIndexPath_three) cell.textLabel.textColor = kThemeColor;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
