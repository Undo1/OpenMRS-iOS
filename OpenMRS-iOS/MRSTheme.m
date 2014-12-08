//
//  MRSTheme.m
//  OpenMRS-iOS
//
//  Created by BC Holmes on 2014-12-08.
//  Copyright (c) 2014 Erway Software. All rights reserved.
//

#import "MRSTheme.h"

@interface MRSTheme ()

@property (nonatomic, strong) UIColor* darkGreen;

@end

@implementation MRSTheme

-(id) init {
    if ((self = [super init])) {
        self.darkGreen = UIColorFromRGB(0x00463F);
        
        self.navigationBarColor = self.darkGreen;
    }
    return self;
}

@end
