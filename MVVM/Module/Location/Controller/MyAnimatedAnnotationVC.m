//
//  MyAnimatedAnnotationVC.m
//  ThankYou
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 2011-2013 湖南长沙阳环科技实业有限公司 @license http://www.yhcloud.com.cn. All rights reserved.
//


#import "MyAnimatedAnnotationVC.h"

@implementation MyAnimatedAnnotationVC

@synthesize annotationImageView = _annotationImageView;

@synthesize annotationImages = _annotationImages;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 35.f, 32.f)];
        [self setBackgroundColor:[UIColor clearColor]];
        _annotationImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _annotationImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_annotationImageView];
        _titlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 35, 12)];
        _titlLabel.font = [UIFont systemFontOfSize:12];
        _titlLabel.textAlignment = NSTextAlignmentCenter;
        _titlLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titlLabel];
    }
    return self;
}


- (void)setAnnotationImages:(NSMutableArray *)images {
    _annotationImages = images;
    [self updateImageView];
}

- (void)updateImageView {
    if ([_annotationImageView isAnimating]) {
        [_annotationImageView stopAnimating];
    }
    _annotationImageView.animationImages = _annotationImages;
    _annotationImageView.animationDuration = 0.5 * [_annotationImages count];
    _annotationImageView.animationRepeatCount = 0;
    [_annotationImageView startAnimating];
}

@end
