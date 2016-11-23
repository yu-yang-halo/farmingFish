//
//  ConstansManager.m
//  farmingFish
//
//  Created by apple on 2016/11/6.
//  Copyright © 2016年 雨神 623240480@qq.com. All rights reserved.
//

#import "ConstansManager.h"

@implementation ConstansManager
+(NSString *)unitForKeyString:(NSString *)key{
    NSArray *objects=@[@"mg/L",@"%",@"",@"mg/L",@"℃",
                       @"mg/L",@"mL",@"mg/L",@"NTU",@"%",
                       @"s/cm",@"mg/L",@"pa",@"m/s",@"度",
                       @"ug/L",@"℃",@"%rh"
                       ];
    NSArray *keys=@[@(0x01),@(0x02),@(0x03),@(0x04),@(0x05),
                    @(0x06),@(0x07),@(0x08),@(0x09),@(0x0a),
                    @(0x0b),@(0x0c),@(0x0d),@(0x0e),@(0x0f),
                    @(0x10),@(0x11),@(0x12)
                    ];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    return dict[key];
}
+(NSString *)contentForKeyInt:(NSNumber *)key{

    NSArray *objects=@[@"溶氧",@"溶氧饱和度",@"PH",@"氨氮",@"水温",
                       @"亚硝酸盐",@"液位",@"硫化氢",@"浊度",@"盐度",
                       @"电导率",@"化学需量",@"大气压",@"风速",@"风向",
                       @"叶绿素",@"大气温度",@"大气湿度"
                       ];
    NSArray *keys=@[@(0x01),@(0x02),@(0x03),@(0x04),@(0x05),
                    @(0x06),@(0x07),@(0x08),@(0x09),@(0x0a),
                    @(0x0b),@(0x0c),@(0x0d),@(0x0e),@(0x0f),
                    @(0x10),@(0x11),@(0x12)
                    ];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    return dict[key];
    
}
//排序使用
+(NSNumber *)indexForKeyInt:(NSNumber *)key{
    
    NSArray *objects=@[@(1),@(7),@(3),@(4),@(2),
                       @(5),@(8),@(9),@(6),@(10),
                       @(11),@(12),@(13),@(14),@(15),
                       @(16),@(17),@(18)
                       ];
    NSArray *keys=@[@(0x01),@(0x02),@(0x03),@(0x04),@(0x05),
                    @(0x06),@(0x07),@(0x08),@(0x09),@(0x0a),
                    @(0x0b),@(0x0c),@(0x0d),@(0x0e),@(0x0f),
                    @(0x10),@(0x11),@(0x12)
                    ];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    return dict[key];
    
}
+(NSArray *)maxWithMinRange:(NSNumber *)key{
    
    NSArray *objects=@[@[@10,@3],@[@10,@3],@[@14,@0],@[@1,@0],@[@30,@(-10)],
                       @[@1,@0],@[@10,@0],@[@1,@0],@[@1,@0],@[@10,@0],
                       @[@10,@0],@[@10,@0],@[@10,@0],@[@10,@0],@[@10,@0],
                       @[@10,@0],@[@40,@(-10)],@[@20,@0]
                       ];
    NSArray *keys=@[@(0x01),@(0x02),@(0x03),@(0x04),@(0x05),
                    @(0x06),@(0x07),@(0x08),@(0x09),@(0x0a),
                    @(0x0b),@(0x0c),@(0x0d),@(0x0e),@(0x0f),
                    @(0x10),@(0x11),@(0x12)
                    ];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    return dict[key];

}
+(NSArray *)yAxisRange:(NSNumber *)key{
    NSArray *objects=@[@[@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"],
                       @[@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"],
                       @[@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14"],
                       @[@"0",@"0.2",@"0.4",@"0.6",@"0.8",@"1"],
                       @[@"-10",@"0",@"10",@"20",@"30"],
                       @[@"0",@"0.2",@"0.4",@"0.6",@"0.8",@"1"],
                       @[@"0",@"2",@"4",@"6",@"8",@"10"],
                       @[@"0",@"0.2",@"0.4",@"0.6",@"0.8",@"1"],
                       @[@"0",@"0.2",@"0.4",@"0.6",@"0.8",@"1"],
                       @[@"0",@"2",@"4",@"6",@"8",@"10"],
                       @[@"0",@"2",@"4",@"6",@"8",@"10"],
                       @[@"0",@"2",@"4",@"6",@"8",@"10"],
                       @[@"0",@"2",@"4",@"6",@"8",@"10"],
                       @[@"0",@"2",@"4",@"6",@"8",@"10"],
                       @[@"0",@"2",@"4",@"6",@"8",@"10"],
                       @[@"0",@"2",@"4",@"6",@"8",@"10"],
                       @[@"-10",@"0",@"10",@"20",@"30",@"40"],
                       @[@"0",@"5",@"10",@"15",@"20"]
                       ];
    NSArray *keys=@[@(0x01),@(0x02),@(0x03),@(0x04),@(0x05),
                    @(0x06),@(0x07),@(0x08),@(0x09),@(0x0a),
                    @(0x0b),@(0x0c),@(0x0d),@(0x0e),@(0x0f),
                    @(0x10),@(0x11),@(0x12)
                    ];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    return dict[key];
}
+(NSString *)contentForKeyString:(NSString *)key{
    NSArray *objects=@[@"溶氧",@"溶氧饱和度",@"PH",@"氨氮",@"水温",
                       @"亚硝酸盐",@"液位",@"硫化氢",@"浊度",@"盐度",
                       @"电导率",@"化学需量",@"大气压",@"风速",@"风向",
                       @"叶绿素",@"大气温度",@"大气湿度"
                       ];
    NSArray *keys=@[@"F_Param1",@"F_Param2",@"F_Param3",@"F_Param4",@"F_Param5",
                    @"F_Param6",@"F_Param7",@"F_Param8",@"F_Param9",@"F_Param10",
                    @"F_Param11",@"F_Param12",@"F_Param13",@"F_Param14",@"F_Param15",
                    @"F_Param16",@"F_Param17",@"F_Param18"
                    ];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    return dict[key];

}

@end
