//
//  SLNCollectionViewTagFlowLayout.h
//  标签Demo
//
//  Created by 乔冬 on 17/3/16.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLNCollectionViewTagFlowLayout : UICollectionViewFlowLayout
- (CGFloat)calculateContentHeight:(NSArray *)tags;
@end
