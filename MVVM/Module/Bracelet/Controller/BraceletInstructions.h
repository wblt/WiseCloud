//
//  BraceletInstructions.h
//  MVVM
//
//  Created by wb on 2017/7/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BraceletInstructions : NSObject

/**获取0长度的命令
 * @param instructions 命令
 */
+(NSString *)getZeroLenthInstructions:(NSString *)instructions;

/**获取1长度的命令
 * @param instructions 命令
 **/
+(NSString *)getOneLenthInstructions:(NSString *)instructions withData:(NSString *)data;

/**计算校验码
**/
+(NSString *)calculationCRC:(NSString *)val;

/**计算校验码
*/
+(NSString *)calculationCRC:(NSString *)val withData:(NSData *)adata;


/**校对校验码
*/
+(BOOL)proofreadingCRC:(NSString *)val;

/**获取运动指令
 */
+(NSString *)getMotionInstructions;

/**获取心率指令
 */
+(NSString *)getHeartRateInstructions;
@end
