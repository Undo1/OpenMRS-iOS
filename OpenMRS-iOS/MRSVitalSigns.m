//
//  MRSVitalSigns.m
//  OpenMRS-iOS
//
//  Created by BC Holmes on 2014-12-08.
//

#import "MRSVitalSigns.h"
#import "MRSObservation.h"

@implementation MRSVitalSigns


+(NSArray*) fromJsonList:(NSArray*) json {
    NSMutableArray* result = [[NSMutableArray alloc] init];

    NSDateFormatter* dateTimeFormatter = [[NSDateFormatter alloc] init];
    [dateTimeFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [dateTimeFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    for (NSDictionary* record in json) {
        MRSVitalSigns* element = [[MRSVitalSigns alloc] init];
        element.UUID = record[@"uuid"];
        element.displayName = record[@"display"];
        element.encounterDatetime = [dateTimeFormatter dateFromString:record[@"encounterDatetime"]];
        
        element.observations = [MRSObservation fromJsonList:record[@"obs"]];

        [result addObject:element];
    }
    
    [result sortUsingComparator:^(MRSVitalSigns* v1, MRSVitalSigns* v2) {
        // Descending (most recent first)
        return [v2.encounterDatetime compare:v1.encounterDatetime];
    }];
    
    return result;
}


-(NSString*) formattedEncounterDatetime {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDoesRelativeDateFormatting:YES];
    return [formatter stringFromDate:self.encounterDatetime];
}
-(NSString*) formattedFullEncounterDatetime {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    return [formatter stringFromDate:self.encounterDatetime];
}@end
