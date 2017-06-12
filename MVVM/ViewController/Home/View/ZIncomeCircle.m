//
//  ZTodayIncomCircle.m
//  DrawCircle学习
//
//  Created by cz. on 15/9/6.
//  Copyright (c) 2015年 CZDomain. All rights reserved.
//

#import "ZIncomeCircle.h"

static  const int  kTrackTodayWith = 5; //轨道宽度
static  const int  kTrackAdrWith = 10; //轨道宽度
static  const int  kTrackDepthWith = 15; //轨道宽度
@interface ZIncomeCircle (){
    CAShapeLayer *_trackLayer;
    CAShapeLayer *_progressLayer;
    
    CAShapeLayer *_innerLayer;
    
    UIBezierPath *_trackPath;
    UIBezierPath *_progressPath;
    
    CGRect _rect;
    CGFloat _lineWidth;
    
    //亮点
    UIImageView *_lightPoint;
	
    CABasicAnimation *advAni;
    
}

@end

@implementation ZIncomeCircle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle]loadNibNamed:@"ZIncomeCircle" owner:self options:nil]lastObject];
    self.frame = frame;
    _rect = frame;
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setHeadType:(ZIncomeHeadType)headType{
    _headType = headType;
    //轨道层
    _trackLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = [UIColor clearColor].CGColor;
    _trackLayer.strokeColor = self.backLineColor.CGColor;
    
    if (_headType == ZIncomeHeadTypeToday) {

        _lineWidth = kTrackTodayWith;
        
        //亮点
        _lightPoint = [[UIImageView alloc]initWithFrame:CGRectMake((_rect.size.width-5)*1.0/2*(1-cos(M_PI_4))-10.5, (_rect.size.width-5)*1.0/2*(1-sin(M_PI_4))-10.5, 26, 26)];
        if (self.isHome) {
            _lightPoint.image = [UIImage imageNamed:@"光点"];
            
        }
  
    }else if (_headType == ZIncomeHeadTypeAdv){
        _lineWidth = kTrackAdrWith;
        _trackLayer.lineDashPattern = @[@2,@2];
 
    }else if(_headType == ZIncomeHeadTypeDepth){
        _lineWidth = kTrackDepthWith;
        [self addInnerCircle];
        
    }
    _trackLayer.lineWidth = _lineWidth;
    _trackPath = [UIBezierPath bezierPath];
    [_trackPath addArcWithCenter:CGPointMake(_rect.size.width/2, _rect.size.height/2) radius:(_rect.size.width-_lineWidth)/2.0 startAngle:0 endAngle:2*M_PI clockwise:YES];
    _trackLayer.path = _trackPath.CGPath;
    
}
- (void)setIsIphone4:(BOOL)isIphone4{
    _isIphone4 = isIphone4;
    if (_trackLayer) {
        [_trackLayer removeFromSuperlayer];
    }
    if (_progressLayer) {
        [_progressLayer removeFromSuperlayer];
    }
    if (_innerLayer) {
        [_innerLayer removeFromSuperlayer];
    }
    if (_lightPoint) {
        _lightPoint.hidden = YES;
    }
	
}

- (void)addInnerCircle{
    //内层圈
   _innerLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_innerLayer];
    _innerLayer.fillColor = [UIColor clearColor].CGColor;
    _innerLayer.strokeColor = [UIColor whiteColor].CGColor;
    _innerLayer.lineWidth = 1;
    
    UIBezierPath *_innerPath = [UIBezierPath bezierPath];
    [_innerPath addArcWithCenter:CGPointMake(_rect.size.width/2, _rect.size.height/2) radius:(_rect.size.width/2-_lineWidth-2) startAngle:0 endAngle:2*M_PI clockwise:YES];
    _innerLayer.path = _innerPath.CGPath;
}


- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    if (kScreenHeight == 480){
        return;
    }

    if (_progressLayer) {
        [_progressLayer removeFromSuperlayer];
        
    }
    if (_lightPoint) {
        [_lightPoint removeFromSuperview];
    }
    //进度层
    _progressLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_progressLayer];
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = self.lineColor.CGColor;
    _progressLayer.lineWidth = _lineWidth;
    [self addSubview:_lightPoint];
    //起始角度
    CGFloat startAngle = 0;
    if (_headType == ZIncomeHeadTypeToday) {
        startAngle = -M_PI_4*3;
    }else if (_headType == ZIncomeHeadTypeAdv){
        _progressLayer.lineDashPattern = @[@2,@2];
        startAngle = -M_PI_2*3;
        
    }else if(_headType == ZIncomeHeadTypeDepth){
        startAngle = -M_PI_2*3;
    }
    _progressPath = [UIBezierPath bezierPath];
    
    [_progressPath addArcWithCenter:CGPointMake(_rect.size.width/2, _rect.size.height/2)  radius:(_rect.size.width-_lineWidth)/2.0 startAngle:startAngle endAngle:_progress*2*M_PI+startAngle clockwise:YES];
    _progressLayer.path = _progressPath.CGPath;
    
    //进度层加动画：（若为今日收益，同时有亮点动画）
    if (_headType == ZIncomeHeadTypeToday) {
//        进度层加动画
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 1.0;
        animation.delegate = self;
        animation.fromValue = [NSNumber numberWithInteger:0];
        
        animation.toValue = [NSNumber numberWithInteger:1];

        
        [_progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
        //亮点加动画
        CAKeyframeAnimation *keyAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        keyAni.duration = 1.0;
        keyAni.delegate = self;
        keyAni.calculationMode = kCAAnimationCubicPaced;
        keyAni.path = _progressPath.CGPath;
        [_lightPoint.layer addAnimation:keyAni forKey:@"position"];
    }else{
        //进度层加动画
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 1;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.delegate = self;
        animation.fromValue = [NSNumber numberWithInteger:0];
        animation.toValue = [NSNumber numberWithInteger:1];
        [_progressLayer addAnimation:animation forKey:@"animation"];

    }
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if(_headType == ZIncomeHeadTypeToday){
        
        _lightPoint.frame = CGRectMake((_rect.size.width-5)*1.0/2*(1-cos(M_PI_4+2*M_PI*_progress))-10.5, (_rect.size.width-5)*1.0/2*(1-sin(M_PI_4+2*M_PI*_progress))-10.5, 26, 26);
    }
}

@end




























