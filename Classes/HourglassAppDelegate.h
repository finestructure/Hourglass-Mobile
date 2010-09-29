//
//  HourglassAppDelegate.h
//  Hourglass
//
//  Created by Sven A. Schmidt on 29.09.10.
//  Copyright (c) 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskViewController.h"


@interface HourglassAppDelegate : NSObject <UIApplicationDelegate> {
  // UI
  UIWindow *window;
  UITabBarController *tabBarController;
  TaskViewController *taskViewController;
  
  // Core Data
  NSManagedObjectContext *managedObjectContext;
  NSManagedObjectModel *managedObjectModel;
  NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) TaskViewController *taskViewController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@end
