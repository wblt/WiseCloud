//
//  CFFuncModel.h
//  CFPopViewDemo
//
//  Created by TheMoon on 16/5/18.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFFuncModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;

- (instancetype)initWithDict:(NSDictionary*)dict;
@end
