//
//  SLNHistoryTableViewCell.h
//  SLNSearchDemo
//
//  Created by 乔冬 on 17/3/16.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLNHistoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *slnTitleLabel;
@property (nonatomic,copy)void(^callbackDelegteRowBlock)(NSInteger index);
@property (nonatomic,assign)   NSInteger row;
@end
