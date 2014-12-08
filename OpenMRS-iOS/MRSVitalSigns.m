//
//  MRSVitalSigns.m
//  OpenMRS-iOS
//
//  Created by BC Holmes on 2014-12-08.
//

#import "MRSVitalSigns.h"

@implementation MRSVitalSigns


+(NSArray*) fromJsonList:(NSDictionary*) json {
    NSMutableArray* result = [[NSMutableArray alloc] init];

    NSDateFormatter* dateTimeFormatter = [[NSDateFormatter alloc] init];
    [dateTimeFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [dateTimeFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    for (NSDictionary* record in json[@"results"]) {
        MRSVitalSigns* element = [[MRSVitalSigns alloc] init];
        element.UUID = record[@"uuid"];
        element.displayName = record[@"display"];
        element.encounterDatetime = [dateTimeFormatter dateFromString:record[@"encounterDatetime"]];

        [result addObject:element];
    }
    return result;
}

@end
