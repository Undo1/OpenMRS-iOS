//
//  MRSObservation.h
//  OpenMRS-iOS
//
//  Created by BC Holmes on 2014-12-09.
//

#import <Foundation/Foundation.h>

@interface MRSObservation : NSObject

@property (nonatomic, strong) NSString* UUID;
@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* conceptUUID;
@property (nonatomic, strong) NSString* conceptDisplayName;
@property (nonatomic, strong) NSDecimalNumber* value;

+(NSArray*) fromJsonList:(NSArray*) json;

@end
