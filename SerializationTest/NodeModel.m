//
//  NodeModel.m
//  SerializationTest
//
//  Created by 刘艳芹 on 2019/5/9.
//  Copyright © 2019 刘艳芹. All rights reserved.
//

#import "NodeModel.h"

@implementation NodeModel

-(void)currentValueAndIndex:(NSString *)node{
    _node = node;
    if ([_node isEqualToString:@"A"]) {
        _value = 0;
    }else if ([_node isEqualToString:@"B"]) {
        _value = 10;
    }else if ([_node isEqualToString:@"C"]) {
        _value = 3;
    }else if ([_node isEqualToString:@"D"]) {
        _value = 4;
    }else if ([_node isEqualToString:@"E"]) {
        _value = 5;
    }else if ([_node isEqualToString:@"F"]) {
        _value = 20;
    }else if ([_node isEqualToString:@"G"]) {
        _value = 7;
    }else if ([_node isEqualToString:@"H"]) {
        _value = 80;
    }else if ([_node isEqualToString:@"I"]) {
        _value = 9;
    }
    
    if ([_node isEqualToString:@"A"]) {
        _index = 0;
    }else if ([_node isEqualToString:@"B"]) {
        _index = 1;
    }else if ([_node isEqualToString:@"C"]) {
        _index = 2;
    }else if ([_node isEqualToString:@"D"]) {
        _index = 3;
    }else if ([_node isEqualToString:@"E"]) {
        _index = 4;
    }else if ([_node isEqualToString:@"F"]) {
        _index = 5;
    }else if ([_node isEqualToString:@"G"]) {
        _index = 6;
    }else if ([_node isEqualToString:@"H"]) {
        _index = 7;
    }else if ([_node isEqualToString:@"I"]) {
        _index = 8;
    }
}

@end
