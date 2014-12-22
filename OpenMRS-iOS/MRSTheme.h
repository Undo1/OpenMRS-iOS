//
//  MRSTheme.h
//  OpenMRS-iOS
//
//  Created by BC Holmes on 2014-12-08.
//  Copyright (c) 2014 Erway Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
    blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
    alpha:1.0]

@interface MRSTheme : NSObject

@property (nonatomic, strong) UIColor* navigationBarColor;

@end
