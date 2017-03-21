//
//  SLNLabelCollectionViewCell.m
//  标签Demo
//
//  Created by 乔冬 on 17/3/16.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "SLNLabelCollectionViewCell.h"
@implementation SLNLabelCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
 
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
        self.slnTextTagLabel.layer.masksToBounds = YES;
        self.slnTextTagLabel.layer.cornerRadius = 15;
    self.slnTextTagLabel.layer.borderWidth = 10;
    self.slnTextTagLabel.layer.borderColor =(__bridge CGColorRef _Nullable)([UIColor blackColor ]);
    // Initialization code
}

@end
