//
//  NoticePhotoSelectCell.h
//  ThankYou
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 2011-2013 湖南长沙阳环科技实业有限公司 @license http://www.yhcloud.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICollectionViewCell;

@protocol CXXPhotoCellDelegate <NSObject>

@optional

- (void)photoCellRemovePhotoBtnClickForCell:(UICollectionViewCell *)cell;
@end

@interface NoticePhotoSelectCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic,strong) UIButton *closeButton;

@property (nonatomic, weak) id <CXXPhotoCellDelegate>delegate;
@end
