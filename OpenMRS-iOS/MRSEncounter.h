//
//  MRSEncounter.h
//  OpenMRS-iOS
//
//  Created by Parker Erway on 12/2/14.
//  Copyright (c) 2014 Erway Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRSEncounter : NSObject
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSArray *obs;
@end