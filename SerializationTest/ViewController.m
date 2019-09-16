//
//  ViewController.m
//  SerializationTest
//
//  Created by 刘艳芹 on 2019/5/9.
//  Copyright © 2019 刘艳芹. All rights reserved.
//

#import "ViewController.h"
#import "NodeModel.h"
@interface ViewController (){
    NSMutableArray *_array;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [NSMutableArray array];
    NSDictionary *dic0 = @{@"city":@"tianjin",@"age":@"11",@"name":@"mike",@"title":@"8",@"like":@"eat",@"education":@"education"};
    NSDictionary *dic1 = @{@"city":@"beijing"};
    NSDictionary *dic2 = @{@"city":@"shanghai"};
    NSDictionary *dic3 = @{@"city":@"shenzhen"};
    NSDictionary *dic4 = @{@"city":@"guangzhou"};
    NSDictionary *dic5 = @{@"city":@"xiamen"};
    NSDictionary *dic6 = @{@"city":@"hebei"};
    NSDictionary *dic7 = @{@"city":@"shanxi"};

    NSArray *array = @[dic0,dic1,dic2,dic3,dic4,dic5,dic6,dic7];
    NSLog(@"%@",[self store:array]);

    [self load:[self store:array]];
    NSLog(@"%@",_array);
    
    [self routePlanning];
}

-(NSString *)store:(NSArray <NSDictionary *>*)array{
    NSString *str = @"";
    for (NSDictionary *dic in array) {
        if (dic.count == 1) {
            for (int i = 0; i<dic.allKeys.count; i++) {
                NSString *key = [dic.allKeys objectAtIndex:i];
                NSString *value = [dic.allValues objectAtIndex:i];
                if (!str.length) {
                    str = [NSString stringWithFormat:@"%@=%@",key,value];
                    str = [str stringByAppendingString:@";"];
                    str = [str stringByAppendingString:@"\n"];
                }else{
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
                    if (i != array.count - 1) {
                        str = [str stringByAppendingString:@"\n"];
                    }
                }
            }
        }else{
            for (int i = 0;i <dic.count;i++) {
                NSString *key = [dic.allKeys objectAtIndex:i];
                NSString *value = [dic.allValues objectAtIndex:i];
                if (!str.length) {
                    str = [NSString stringWithFormat:@"%@=%@",key,value];
                    str = [str stringByAppendingString:@";"];
                }else{
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
                    str = [str stringByAppendingString:@";"];
                }
            }
        }
    }
    return str;
}

-(void)load:(NSString *)string{
    if(([string rangeOfString:@"\n"].location !=NSNotFound)){
        NSRange range = [string rangeOfString:@"\n"];
        NSString *jsonStr = [string substringWithRange:NSMakeRange(0, range.location)];
        NSInteger strCount = [jsonStr length] - [[jsonStr stringByReplacingOccurrencesOfString:@";" withString:@""]length];
        strCount = strCount / [@";" length];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (strCount != 0) {
            for (int i = 0; i<strCount; i++) {
                NSRange jsonRange = [jsonStr rangeOfString:@";"];
                NSString *str = [jsonStr substringWithRange:NSMakeRange(0, jsonRange.location)];
                NSRange jsonRange1 = [jsonStr rangeOfString:@"="];
                NSString *key = [str substringWithRange:NSMakeRange(0, jsonRange1.location)];
                NSString *value = [str substringWithRange:NSMakeRange(jsonRange1.location  + 1, str.length - jsonRange1.location -1)];
                [dic setValue:value forKey:key];
                jsonStr = [jsonStr substringFromIndex:jsonRange.location + 1];
            }
        }else{
            NSRange jsonRange1 = [jsonStr rangeOfString:@"="];
            NSString *key = [jsonStr substringWithRange:NSMakeRange(0, jsonRange1.location)];
            NSString *value = [jsonStr substringWithRange:NSMakeRange(jsonRange1.location  + 1, jsonStr.length - jsonRange1.location -1)];
            [dic setValue:value forKey:key];
        }
        
        [_array addObject:dic];
        if (string.length != 0) {
            string = [string substringWithRange:NSMakeRange(range.location  + 1, string.length - range.location -1)];
            range = [string rangeOfString:@"\n"];
            if (range.location == string.length - 1) {
                string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
            }
            jsonStr = [string substringWithRange:NSMakeRange(0, range.location)];
            strCount = [jsonStr length] - [[jsonStr stringByReplacingOccurrencesOfString:@";" withString:@""]length];
            strCount = strCount / [@";" length];
            [self load:string];
        }
    }
}

-(void)routePlanning{
    NSMutableArray *nodeArray = [@[@"A", @"B", @"D", @"D", @"C", @"F", @"F", @"H", @"A"]copy];
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *allDic = [NSMutableDictionary dictionary];
    for (int i = 0; i<nodeArray.count; i++) {
        NodeModel *model = [[NodeModel alloc]init];
        model.node = [nodeArray objectAtIndex:i];
        [model currentValueAndIndex:model.node];
        [array addObject:model];
    }
    
    [array sortUsingComparator:^NSComparisonResult(NodeModel *obj1, NodeModel *obj2) {
        return obj1.index > obj2.index;
    }];
    
    [self search:array allDic:allDic];
    NSNumber *max = [allDic.allKeys valueForKeyPath:@"@max.floatValue"];
    NSLog(@"%@",max);
    NSArray *resultArray = [allDic valueForKey:[NSString stringWithFormat:@"%@",max]];
    [resultArray enumerateObjectsUsingBlock:^(NodeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@ %ld %ld",obj.node,obj.index,obj.value);
    }];
}

-(void)search:(NSMutableArray *)array allDic:(NSMutableDictionary *)allDic{
    for (int i = 0; i<array.count; i++) {
        NSMutableArray *sortArray = [NSMutableArray array];
        /** 存储搜索后的model集合 */
        NodeModel *lastModel = [array objectAtIndex:i];
        NSMutableArray *nextArray = [[NSMutableArray arrayWithArray:array]mutableCopy];
        [nextArray removeObject:lastModel];
        /** 去重，减少循环次数 */
        if (sortArray.count) {
            NSMutableSet *nextSet = [NSMutableSet setWithArray:nextArray];
            NSMutableSet *sortSet = [NSMutableSet setWithArray:sortArray];
            [nextSet minusSet:sortSet];
            nextArray = [nextSet.allObjects mutableCopy];
        }
        NodeModel *finalModel;
        NodeModel *currentModel;
        for (int j = 0; j<nextArray.count; j++) {
            
            currentModel = [nextArray objectAtIndex:j];
            if (!(currentModel.value > lastModel.value && currentModel.index > lastModel.index)) {
                continue;
            }
            if (sortArray.count == 0) {
                [sortArray addObject:lastModel];
                finalModel = currentModel;
                [sortArray addObject:finalModel];
            }
            /** 判断是否在左侧与右侧的范围 */
            BOOL isLeftRange =
            currentModel.value >= lastModel.value &&
            currentModel.index >= lastModel.index &&
            currentModel.value <= finalModel.value &&
            currentModel.index <= finalModel.index;
            /** 判断是否大于最右侧的范围 */
            BOOL isRightRange =
            currentModel.value > finalModel.value &&
            currentModel.index > finalModel.index;
            if (isRightRange) {
                if (![sortArray containsObject:finalModel]) {
                    [sortArray addObject:finalModel];
                }
                if (![sortArray containsObject:currentModel]) {
                    [sortArray addObject:currentModel];
                }
                lastModel = finalModel;
                finalModel = currentModel;
                continue;
            }
            
            if (isLeftRange) {
                if (![sortArray containsObject:lastModel]) {
                    [sortArray addObject:lastModel];
                }
                if (![sortArray containsObject:currentModel]) {
                    [sortArray addObject:currentModel];
                }
                if (sortArray.count == 2) {
                    lastModel = sortArray.firstObject;
                }else{
                    lastModel = currentModel;
                }
                continue;
            }
        }
        __block NSInteger sum = 0;
        [sortArray enumerateObjectsUsingBlock:^(NodeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            sum = sum + obj.value;
        }];
        [allDic setValue:sortArray forKey:[NSString stringWithFormat:@"%ld",sum]];
    }
}

@end
