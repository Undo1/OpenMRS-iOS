//
//  MRSVitalSigns.h
//  OpenMRS-iOS
//
//  Created by BC Holmes on 2014-12-08.
//

#import "MRSEncounter.h"

@interface MRSVitalSigns : MRSEncounter

@property (nonatomic, strong) NSDate* encounterDatetime;

+(NSArray*) fromJsonList:(NSDictionary*) json;
@end
