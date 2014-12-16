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
<<<<<<< HEAD
@property (strong, nonatomic) MRSTheme* theme;

+(AppDelegate*) instance;
=======
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
>>>>>>> upstream/master
@property (nonatomic, strong) AFHTTPRequestOperation *currentSearchOperation;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)clearStore;

@end

