//
//  UIImage+Helpers.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-07.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "UIImage+Helpers.h"

@implementation UIImage (Helpers)

+ (UIImage *) imageFromFont:(UIFont *)font
                      color:(UIColor *)color
                  character:(unichar)character {
    
    NSString* text = [NSString stringWithCharacters:&character length:1];
    CGSize	  size = [text sizeWithFont:font];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 2);
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetFillColorWithColor(context, [color CGColor]);

	[text drawInRect:CGRectMake(0, 0, size.width, size.height) withFont:font];

	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();    
    
    return image;
}
@end
