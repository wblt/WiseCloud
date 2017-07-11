//
//  MyAnimatedAnnotationVC.h
//  ThankYou
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 2011-2013 湖南长沙阳环科技实业有限公司 @license http://www.yhcloud.com.cn. All rights reserved.
//


#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface MyAnimatedAnnotationVC : BMKAnnotationView

@property (nonatomic, strong) NSMutableArray *annotationImages;
@property (nonatomic, strong) UIImageView *annotationImageView;
@property (nonatomic,strong) UILabel *titlLabel;

@end
