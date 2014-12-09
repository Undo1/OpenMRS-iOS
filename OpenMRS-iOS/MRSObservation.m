//
//  MRSObservation.m
//  OpenMRS-iOS
//
//  Created by BC Holmes on 2014-12-09.
//

#import "MRSObservation.h"

@implementation MRSObservation


+(NSArray*) fromJsonList:(NSArray*) json {
    NSMutableArray* result = [[NSMutableArray alloc] init];

    for (NSDictionary* record in json) {
        MRSObservation* element = [[MRSObservation alloc] init];
        element.UUID = record[@"uuid"];
        element.displayName = record[@"display"];
        
        element.conceptUUID = record[@"concept"][@"uuid"];
        element.conceptDisplayName = record[@"concept"][@"display"];
        
        element.value = [NSDecimalNumber decimalNumberWithDecimal:[record[@"value"] decimalValue]];
        [result addObject:element];
    }
    return result;
}
@end
