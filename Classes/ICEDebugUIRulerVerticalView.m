//
//  ICEDebugUIRulerVerticalView.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/14.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugUIRulerVerticalView.h"
#import "ICEDebugMacro.h"
@interface ICEDebugUIRulerVerticalView()
{
    UIView* _contentView;
}
@end

@implementation ICEDebugUIRulerVerticalView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)getFontWithFontName:(NSString*)fontName displayStr:(NSString*)string fontSize:(CGFloat)size label:(UILabel*)label
{
    UIFont * titleFont = nil;
    NSString* _tempName = nil;
    if (fontName == nil) {
        _tempName = @"Helvetica";
    }
    else
    {
        _tempName = fontName;
    }
    
    if (size < 0.001) {
        size = 17.0f;
    }
    titleFont = [UIFont fontWithName:_tempName size:size];
    if (titleFont == nil) {
        titleFont = [UIFont fontWithName:@"Helvetica" size:size];
    }
    CGSize titleSize;
    
    if (string == nil) {
        titleSize.height = 0;
        titleSize.width = 0;
    }
    else
    {
        titleSize = [string sizeWithAttributes: @{NSFontAttributeName: titleFont}];
    }
    
    label.font = titleFont;
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, titleSize.width, titleSize.height);
    label.text = string;
}


-(void)setupViews
{
    
    int bigNumbers = 10;
    int tempNumber = ICE_DEBUG_SCREEN_HEIGHT;
    CGFloat cellWidth = 2;
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ICE_DEBUG_VW(self), ICE_DEBUG_SCREEN_HEIGHT*2)];
    [self addSubview:_contentView];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.35, ICE_DEBUG_SCREEN_HEIGHT*2)];
    [self addSubview:view];
    view.backgroundColor = [UIColor greenColor];
    
    for (int i=(tempNumber/2); i < tempNumber; i++) {
        CGFloat width = 0.4*ICE_DEBUG_VW(self);
        int realPoisiton = (int)(i-(tempNumber/2));
        int flag = (int)(i-(tempNumber/2))%bigNumbers;
        if (flag == 0) {
            width = ICE_DEBUG_VW(self)*0.8;
        }
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, cellWidth*i, width, 0.35)];
        view.backgroundColor = [UIColor greenColor];
        
        if (flag == 0) {
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(ICE_DEBUG_VR(view), 0, 0, 0)];
            [self getFontWithFontName:nil displayStr:[NSString stringWithFormat:@"%d",(int)(0-(realPoisiton*cellWidth))] fontSize:6 label:label];
            label.frame = CGRectMake(label.frame.origin.x, (i*cellWidth) - (label.frame.size.height/2.0f), label.frame.size.width, label.frame.size.height);
            label.backgroundColor = [UIColor clearColor];
            [_contentView addSubview:label];
        }
        
        [_contentView addSubview:view];
    }
    
    for (int i=(tempNumber/2); i >= 0; i--) {
        CGFloat width = 0.4*ICE_DEBUG_VW(self);
        int realPoisiton = (int)(i-(tempNumber/2));
        int flag = (int)(i-(tempNumber/2))%bigNumbers;
        if (flag == 0) {
            width = ICE_DEBUG_VW(self)*0.8;
        }
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, cellWidth*i, width, 0.35)];
        view.backgroundColor = [UIColor greenColor];
        
        if (flag == 0) {
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(ICE_DEBUG_VR(view), 0, 0, 0)];
            [self getFontWithFontName:nil displayStr:[NSString stringWithFormat:@"%d",(int)(0-(realPoisiton*cellWidth))] fontSize:6 label:label];
            label.frame = CGRectMake(label.frame.origin.x, (i*cellWidth) - (label.frame.size.height/2.0f), label.frame.size.width, label.frame.size.height);
            label.backgroundColor = [UIColor clearColor];
            [_contentView addSubview:label];
        }
        
        [_contentView addSubview:view];
    }
    
    [self setZero:0];
}

-(void)setZero:(CGFloat)point
{
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, point-ICE_DEBUG_SCREEN_HEIGHT, ICE_DEBUG_VW(_contentView), ICE_DEBUG_VH(_contentView));
}

    -(void)modifyRuleY:(CGFloat)gap
    {
        ICE_DEBUG_MY(_contentView, ICE_DEBUG_VT(_contentView)-gap);
    }
@end
