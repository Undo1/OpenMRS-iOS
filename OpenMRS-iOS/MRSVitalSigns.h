//
//  MRSVitalSigns.h
//  OpenMRS-iOS
//
//  Created by BC Holmes on 2014-12-08.
//

#import "MRSEncounter.h"

@interface MRSVitalSigns : MRSEncounter

@property (nonatomic, strong) NSDate* encounterDatetime;
@property (nonatomic, strong) NSArray* observations;
@property (nonatomic, readonly) NSString* formattedEncounterDatetime;
@property (nonatomic, readonly) NSString* formattedFullEncounterDatetime;

+(NSArray*) fromJsonList:(NSArray*) json;
@end
