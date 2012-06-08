//
//  UIImage+Helpers.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-07.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helpers)
+ (UIImage *) imageFromFont:(UIFont *)font
                      color:(UIColor *)color
                  character:(unichar)character;
@end
