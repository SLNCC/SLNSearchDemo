//
//  SLNLabelView.m
//  标签Demo
//
//  Created by 乔冬 on 17/3/16.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "SLNLabelView.h"
#import "SLNCollectionViewTagFlowLayout.h"
#import "SLNLabelCollectionViewCell.h"

#define SCREENWIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT       [UIScreen mainScreen].bounds.size.height
#define KWIDTH           self.view.frame.size.width
#define KHEIGHT            self.view.frame.size.height
static NSString *myCell = @"MyViewID";


// 是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
@interface SLNLabelView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *slnCollectionView;
@end
@implementation SLNLabelView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpcollectionViewsWithFrame:frame];
        _tags = [NSMutableArray array];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    _slnCollectionView.frame = self.bounds;

}
/**
 *  集合视图
 */
- (void)setUpcollectionViewsWithFrame:(CGRect)frame{
    CGFloat  h = frame.size.height;
    CGFloat  w = frame.size.width;
    CGRect rect1 = CGRectMake(16, 18, w - 32, 31);
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.frame = rect1;
    textLabel.numberOfLines = 1;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.text = @"热门搜索";
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:textLabel];

    CGRect rect ;
    rect = CGRectMake(0, 98/2.0, w, h - 98/2.0-53.0);
    SLNCollectionViewTagFlowLayout *flowLayout= [[SLNCollectionViewTagFlowLayout alloc] init];
    //第二个参数是cell的布局
    _slnCollectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    _slnCollectionView.dataSource = self;
    _slnCollectionView.delegate = self;
    _slnCollectionView.bounces = NO;
    _slnCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_slnCollectionView];
    [_slnCollectionView registerNib:[UINib nibWithNibName:@"SLNLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SLNLabelId"];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tags.copy count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLNCollectionViewTagFlowLayout *layout = (SLNCollectionViewTagFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    SLNHostory *hostory = self.tags.copy[indexPath.item];
    CGRect frame = [hostory.title boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.tagTextFont} context:nil];
    
    return CGSizeMake(frame.size.width + 20.0f, layout.itemSize.height);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SLNLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SLNLabelId" forIndexPath:indexPath];
        SLNHostory *hostory = self.tags.copy[indexPath.item];
    cell.slnTextTagLabel.text = hostory.title;
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(slnDidSelectItemAtIndexPath:SLNHostory:)] ) {
        [self.delegate slnDidSelectItemAtIndexPath:indexPath SLNHostory:(SLNHostory *)self.tags[indexPath.item]];
    }
    NSLog(@" %ld",  (long)indexPath.item);
}

#pragma mark -- setter/getter
//-(UICollectionView *)slnCollectionView{
//    if (!_slnCollectionView) {
//
//    }
//    return _slnCollectionView;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
