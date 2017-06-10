//
//  MyDeviceModel.h
//  HuiJianKang
//
//  Created by mac on 16/7/26.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDeviceModel : NSObject

/*
 {
 deviceid = 626010110084715;
 openid = "";
 twjMAC = "<null>";
 twjname = "<null>";
 type = 0;
 userid = 35616;
 weixinnickname = "\U6d4b\U8bd5";
 }
 */

@property (nonatomic,copy) NSString *deviceid;

@property (nonatomic,copy) NSString *openid;

@property (nonatomic,copy) NSString *twjMAC;

@property (nonatomic,copy) NSString *twjname;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *userid;

@property (nonatomic,copy) NSString *weixinnickname;

@end
