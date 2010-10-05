//
//  HourglassAppDelegate.h
//  Hourglass
//
//  Created by Sven A. Schmidt on 29.09.10.
//  Copyright (c) 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskViewController.h"
#import "DropboxSDK.h"


@interface HourglassAppDelegate : NSObject <UIApplicationDelegate, DBSessionDelegate, DBRestClientDelegate> {
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) TaskViewController *taskViewController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) DBRestClient *restClient;
@property (nonatomic, retain) NSString *localPath;
@property (nonatomic) UIBackgroundTaskIdentifier bgTask;

- (NSString *)applicationDocumentsDirectory;
- (NSString *)loadFile:(NSString *)fileName;
- (DBRestClient *)restClient;

@end
