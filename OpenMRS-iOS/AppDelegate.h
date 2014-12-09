//
//  AppDelegate.h
//  OpenMRS-iOS
//
//  Created by Parker Erway on 12/1/14.
//

#import <UIKit/UIKit.h>
#import "MRSTheme.h"
#import "AFNetworking.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MRSTheme* theme;

+(AppDelegate*) instance;
@property (nonatomic, strong) AFHTTPRequestOperation *currentSearchOperation;

@end

