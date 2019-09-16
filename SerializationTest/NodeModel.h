//
//  NodeModel.h
//  SerializationTest
//
//  Created by 刘艳芹 on 2019/5/9.
//  Copyright © 2019 刘艳芹. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeModel : NSObject

@property (nonatomic, copy) NSString *node;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger value;
-(void)currentValueAndIndex:(NSString *)node;
@end

NS_ASSUME_NONNULL_END
