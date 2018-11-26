//
//  ICEDebugUIRuler.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/14.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugUIRuler.h"
#import "ICEDebugMacro.h"
#import "ICEDebugUIRulerVerticalView.h"
#import "ICEDebugUIRulerHorizontalView.h"

@interface ICEDebugUIRuler()
{
    UILabel* _hintLabel;
    ICEDebugUIRulerVerticalView* _vRuler;
    ICEDebugUIRulerHorizontalView* _hRuler;
}
@end

@implementation ICEDebugUIRuler
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = ICE_DEBUG_RGB(0xff, 0xff, 0xff, 0.1);
        
        
        _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 50, 50)];
        _hintLabel.backgroundColor = ICE_DEBUG_RGB(0, 0, 0, 0.5);
        _hintLabel.textColor = [UIColor whiteColor];
        _hintLabel.font = [UIFont systemFontOfSize:10];
        _hintLabel.numberOfLines = 0;
        
        [self addSubview:_hintLabel];
        
        _vRuler = [[ICEDebugUIRulerVerticalView alloc]initWithFrame:CGRectMake(0, 0, 10, ICE_DEBUG_SCREEN_HEIGHT)];
        _hRuler = [[ICEDebugUIRulerHorizontalView alloc]initWithFrame:CGRectMake(0, 0, ICE_DEBUG_SCREEN_WIDTH, 15)];
        
        [self addSubview:_vRuler];
        [self addSubview:_hRuler];
        
        
    }
    return self;
}

-(void)closeBtnAction
{
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self];
    if (_isMovedInMiddle == YES) {
        CGFloat gap = 40;
//        if (point.y > (ICE_DEBUG_SCREEN_HEIGHT/2.0f)) {
//            gap = -40;
//        }
        ICE_DEBUG_MX(_vRuler, point.x);
        ICE_DEBUG_MY(_hRuler, point.y-gap);
        [_vRuler setZero:point.y-gap];
        [_hRuler setZero:point.x];
        _hintLabel.text = [NSString stringWithFormat:@"x:%d\ny:%d", (int)point.x, (int)point.y-gap];
    }
    else
    {
        BOOL ver = [self isInVer:point];
        BOOL her = [self isInHer:point];
        if (ver == YES) {
            ICE_DEBUG_MY(_hRuler, point.y);
        }
        if (her == YES) {
            ICE_DEBUG_MX(_vRuler, point.x);
        }
        _hintLabel.text = [NSString stringWithFormat:@"x:%d\ny:%d", (int)point.x, (int)point.y];
    }
    
    BOOL isIn = [self isInBtn:point];
    if (isIn == YES) {
        [self removeFromSuperview];
    }
    

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self];
    
    if (_isMovedInMiddle == YES) {
        CGFloat gap = 40;
//        if (point.y > (ICE_DEBUG_SCREEN_HEIGHT/2.0f)) {
//            gap = -40;
//        }
        ICE_DEBUG_MX(_vRuler, point.x);
        ICE_DEBUG_MY(_hRuler, point.y-gap);
        [_vRuler setZero:point.y-gap];
        [_hRuler setZero:point.x];
        _hintLabel.text = [NSString stringWithFormat:@"x:%d\ny:%d", (int)point.x, (int)point.y-gap];
    }
    else
    {
        BOOL ver = [self isInVer:point];
        BOOL her = [self isInHer:point];
        if (ver == YES) {
            ICE_DEBUG_MY(_hRuler, point.y);
        }
        if (her == YES) {
            ICE_DEBUG_MX(_vRuler, point.x);
        }
        _hintLabel.text = [NSString stringWithFormat:@"x:%d\ny:%d", (int)point.x, (int)point.y];
    }
    
    BOOL isIn = [self isInBtn:point];
    if (isIn == YES) {
        int x = arc4random() % ((int)(ICE_DEBUG_SCREEN_WIDTH - ICE_DEBUG_VW(_hintLabel)));
        int y = arc4random() % ((int)(ICE_DEBUG_SCREEN_HEIGHT - ICE_DEBUG_VH(_hintLabel)));
        [UIView animateWithDuration:0.1 animations:^{
            ICE_DEBUG_MO(_hintLabel, CGPointMake(x, y));
        }];
    }
}

-(BOOL)isInBtn:(CGPoint)point
{
    if ((point.x < ICE_DEBUG_VR(_hintLabel)) && (point.x > ICE_DEBUG_VL(_hintLabel))) {
        if ((point.y < ICE_DEBUG_VB(_hintLabel))&&(point.y > ICE_DEBUG_VT(_hintLabel))) {
            return YES;
        }
    }
    return NO;
}

#define _ICE_DEBUG_TOUCH_WIDH 100
-(BOOL)isInVer:(CGPoint)point
{
    if ((point.x < _ICE_DEBUG_TOUCH_WIDH) && (point.x > 0)) {
        if (point.y < (ICE_DEBUG_SCREEN_HEIGHT-_ICE_DEBUG_TOUCH_WIDH)) {
            return YES;
        }
    }
    
    if ((point.x < ICE_DEBUG_SCREEN_WIDTH) && (point.x > (ICE_DEBUG_SCREEN_WIDTH-_ICE_DEBUG_TOUCH_WIDH))) {
        if (point.y > _ICE_DEBUG_TOUCH_WIDH) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isInHer:(CGPoint)point
{
    if ((point.y < _ICE_DEBUG_TOUCH_WIDH) && (point.y > 0)) {
        if (point.x > _ICE_DEBUG_TOUCH_WIDH) {
            return YES;
        }
    }
    
    if ((point.y < ICE_DEBUG_SCREEN_HEIGHT) && (point.y > (ICE_DEBUG_SCREEN_HEIGHT-_ICE_DEBUG_TOUCH_WIDH))) {
        if (point.x < (ICE_DEBUG_SCREEN_WIDTH-_ICE_DEBUG_TOUCH_WIDH)) {
            return YES;
        }
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
