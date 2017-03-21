//
//  SLNHistoryTableViewCell.m
//  SLNSearchDemo
//
//  Created by 乔冬 on 17/3/16.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "SLNHistoryTableViewCell.h"
@interface SLNHistoryTableViewCell()
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@end
@implementation SLNHistoryTableViewCell
- (IBAction)slnDeletePerRowAction:(UIButton *)sender {
    NSInteger row = sender.tag;
    if (_callbackDelegteRowBlock) {
        _callbackDelegteRowBlock(row);
    }
}
-(void)setRow:(NSInteger)row{
    _row = row;
    self.deleteBtn.tag = _row;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
