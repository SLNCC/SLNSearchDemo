//
//  SLNLabelView.h
//  标签Demo
//
//  Created by 乔冬 on 17/3/16.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  SLNLabelViewDelegate<NSObject>
-(void)slnDidSelectItemAtIndexPath:(NSIndexPath *)indexPath  SLNHostory:(SLNHostory *)slnHostory;
@end
@interface SLNLabelView : UIView
@property (nonatomic,weak) id<SLNLabelViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic,strong) UIFont *tagTextFont;
@end
