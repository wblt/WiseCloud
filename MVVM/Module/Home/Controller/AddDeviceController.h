//
//  AddDeviceController.h
//  MVVM
//
//  Created by wb on 2017/6/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^SelectValueBlock) (NSString *returnValue);

@interface AddDeviceController : BaseViewController

@property (strong, nonatomic) SelectValueBlock returnBlock;

@end
