//
//  CollectionViewController.m
//  IDIAI
//
//  Created by Ricky on 15-4-9.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionDetailViewController.h"
#import "LoginView.h"

@interface CollectionViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *_theTableView;
}



@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        self.title = @"收藏";
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    _theTableView = [[UITableView alloc]initWithFrame:kTableViewWithTabBarFrame style:UITableViewStyleGrouped];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    [self.view addSubview:_theTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return 3;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CollectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *nameArr = @[@[@"效果图",@"装修方案",@"装修知识"]];
    NSArray *imgArr = @[@[@"ic_drawing_.png",@"ic_scheme_.png",@"ic_knowledge_.png"]];
    
    cell.imageView.image = [UIImage imageNamed:[[imgArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    cell.textLabel.text = [[nameArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:User_Token]){
        CollectionDetailViewController *collectionDetailVC = [[CollectionDetailViewController alloc]init];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                if([self.data_array count]) [self.data_array removeAllObjects];
                NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* doc_path_ = [path_ objectAtIndex:0];
                NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MyeffectPicture.plist"];
                self.data_array=[NSMutableArray arrayWithContentsOfFile:_filename_];
                if (!self.data_array) {
                    self.data_array=[NSMutableArray arrayWithCapacity:0];
                }
                
                collectionDetailVC.selected_type=@"效果图";
                collectionDetailVC.data_array = self.data_array;
                [self.navigationController pushViewController:collectionDetailVC animated:YES];
            } else if (indexPath.row == 1) {
                if([self.data_array count]) [self.data_array removeAllObjects];
                NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* doc_path_ = [path_ objectAtIndex:0];
                NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MyeffectPictureForTaotu.plist"];
                self.data_array=[NSMutableArray arrayWithContentsOfFile:_filename_];
                if (!self.data_array) {
                    self.data_array=[NSMutableArray arrayWithCapacity:0];
                }
                
                collectionDetailVC.selected_type=@"装修方案";
                collectionDetailVC.data_array = self.data_array;
                [self.navigationController pushViewController:collectionDetailVC animated:YES];
            } else {
                if([self.data_array count]) [self.data_array removeAllObjects];
                NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* doc_path_ = [path_ objectAtIndex:0];
                NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MyknowledgeCollect.plist"];
                self.data_array=[NSMutableArray arrayWithContentsOfFile:_filename_];
                if (!self.data_array) {
                    self.data_array=[NSMutableArray arrayWithCapacity:0];
                }
                
                collectionDetailVC.selected_type=@"装修知识";
                collectionDetailVC.data_array = self.data_array;
                [self.navigationController pushViewController:collectionDetailVC animated:YES];
            }
        }
        //    else if (indexPath.section == 1) {
        //        if([self.data_array count]) [self.data_array removeAllObjects];
        //        NSArray *path_business = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //        NSString* doc_path_business = [path_business objectAtIndex:0];
        //        NSString* _filename_business = [doc_path_business stringByAppendingPathComponent:@"MybusinessCollect.plist"];
        //        self.data_array=[NSMutableArray arrayWithContentsOfFile:_filename_business];
        //        if (!self.data_array) {
        //            self.data_array=[NSMutableArray arrayWithCapacity:0];
        //        }
        //
        //        collectionDetailVC.selected_type=@"材料商";
        //        collectionDetailVC.data_array = self.data_array;
        //        [self.navigationController pushViewController:collectionDetailVC animated:YES];
        //
        //    }
        else {
//            if (indexPath.row == 0) {
//                if([self.data_array count]) [self.data_array removeAllObjects];
//                NSArray *path_desinger = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                NSString* doc_path_designer = [path_desinger objectAtIndex:0];
//                NSString* _filename_designer = [doc_path_designer stringByAppendingPathComponent:@"MydesignerCollect.plist"];
//                self.data_array=[NSMutableArray arrayWithContentsOfFile:_filename_designer];
//                if (!self.data_array) {
//                    self.data_array=[NSMutableArray arrayWithCapacity:0];
//                }
//                
//                collectionDetailVC.selected_type=@"设计师";
//                collectionDetailVC.data_array = self.data_array;
//                [self.navigationController pushViewController:collectionDetailVC animated:YES];
//                
//            } else if (indexPath.row == 1) {
//                if([self.data_array count]) [self.data_array removeAllObjects];
//                NSArray *path_desinger = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                NSString* doc_path_designer = [path_desinger objectAtIndex:0];
//                NSString* _filename_designer = [doc_path_designer stringByAppendingPathComponent:@"MyworkerCollect.plist"];
//                self.data_array=[NSMutableArray arrayWithContentsOfFile:_filename_designer];
//                if (!self.data_array) {
//                    self.data_array=[NSMutableArray arrayWithCapacity:0];
//                }
//                
//                collectionDetailVC.selected_type=@"工人";
//                collectionDetailVC.data_array = self.data_array;
//                [self.navigationController pushViewController:collectionDetailVC animated:YES];
//                
//            } else if (indexPath.row == 2) {
//                if([self.data_array count]) [self.data_array removeAllObjects];
//                NSArray *path_desinger = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                NSString* doc_path_designer = [path_desinger objectAtIndex:0];
//                NSString* _filename_designer = [doc_path_designer stringByAppendingPathComponent:@"MygongzhangCollect.plist"];
//                self.data_array=[NSMutableArray arrayWithContentsOfFile:_filename_designer];
//                if (!self.data_array) {
//                    self.data_array=[NSMutableArray arrayWithCapacity:0];
//                }
//                
//                collectionDetailVC.selected_type=@"工长";
//                collectionDetailVC.data_array = self.data_array;
//                [self.navigationController pushViewController:collectionDetailVC animated:YES];
//            } else {
//                if([self.data_array count]) [self.data_array removeAllObjects];
//                NSArray *path_desinger = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                NSString* doc_path_designer = [path_desinger objectAtIndex:0];
//                NSString* _filename_designer = [doc_path_designer stringByAppendingPathComponent:@"MySupersiorCollect.plist"];
//                self.data_array=[NSMutableArray arrayWithContentsOfFile:_filename_designer];
//                if (!self.data_array) {
//                    self.data_array=[NSMutableArray arrayWithCapacity:0];
//                }
//                
//                collectionDetailVC.selected_type=@"监理";
//                collectionDetailVC.data_array = self.data_array;
//                [self.navigationController pushViewController:collectionDetailVC animated:YES];
//            }
        }
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
    
}


@end
