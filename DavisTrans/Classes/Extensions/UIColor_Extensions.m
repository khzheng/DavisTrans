//
//  UIColor_Extensions.m
//  DavisTrans
//
//  Created by Kip Nicol on 11/9/09.
//  Copyright 2009 Kip Nicol & Ken Zheng
//

#import "UIColor_Extensions.h"


@implementation UIColor (UIColor_Extensions)

+ (UIColor *)colorFromHexadecimal:(NSInteger )hex alpha:(CGFloat)alpha
{    
    NSUInteger mask = 0x000000FF;

    CGFloat r = ((hex >> 16) & mask) / 255.0;
    CGFloat g = ((hex >> 8) & mask) / 255.0;
    CGFloat b = (hex & mask) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)extraLightGrayColor
{
    return [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.0];
}

@end
