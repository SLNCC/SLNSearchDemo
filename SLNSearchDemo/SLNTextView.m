//
//  SLNTextView.m
//  SLNSearchDemo
//
//  Created by 乔冬 on 17/3/16.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "SLNTextView.h"
@interface SLNTextView()
@property (nonatomic,strong)  UITextField *slnTextView ;
@end
@implementation SLNTextView

-(void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    _slnTextView.text = _searchText;
}

-(void)setSearchPlaceholder:(NSString *)searchPlaceholder{
    _searchPlaceholder = searchPlaceholder;
    _slnTextView.placeholder = _searchPlaceholder;
}



-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat h = frame.size.height;
        CGRect rect = CGRectMake(0, 0, frame.size.width , h);
        
        CGFloat imgW = 14;
        CGFloat imgH = 14;
        CGFloat left = 8;
        
        UIView *leftView = [[UIView alloc]init];
        leftView.frame = CGRectMake(0, (h -imgW)/2.0, imgW +left,imgH);
        leftView.backgroundColor = [UIColor clearColor];
        
        UIImage *Img = [UIImage imageNamed:@"home_search"];
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame =    CGRectMake(left, 0, imgW ,imgH);
        [leftView addSubview:imgView];
        imgView.image = Img;
        
         _slnTextView = [[UITextField alloc]initWithFrame:rect];
        _slnTextView.placeholder = @"";
        _slnTextView.leftViewMode = UITextFieldViewModeAlways;
        _slnTextView.leftView =  leftView;
        _slnTextView.clearButtonMode = UITextFieldViewModeAlways;
        _slnTextView.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:_slnTextView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
