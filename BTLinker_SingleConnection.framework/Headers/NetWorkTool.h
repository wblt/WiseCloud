//
//  NetWorkTool.h
//  TijiyiClone
//
//  Created by xiejunpeng on 14-7-30.
//  Copyright (c) 2014年 twohe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SendDataToDevice.h"
@protocol NetWorkDelegate <NSObject>


-(void)getDataFromServer:(id)responseObject;


@optional


//-(void)Updatafaill:(NSString*)fail;

@end


@interface NetWorkTool : NSObject{

id<NetWorkDelegate>delegate;

}


@property (strong,nonatomic) id<NetWorkDelegate>delegate;


+(NetWorkTool*)getNetWorkToolInstance;
//电子秤升级。FileData下载的文件内容
- (void)downloadFileURL:(NSData *)FileData;

- (void)downloadNordicFileURL:(NSString *)FileName :(CBPeripheral*)peripheral :(id)myself;
//nordic type:1,   ti:type:0
-(void)checkVersion:(int)type :(NSString*)FirmwareVersion;
@end
