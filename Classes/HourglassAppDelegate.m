//
//  HourglassAppDelegate.m
//  Hourglass
//
//  Created by Sven A. Schmidt on 29.09.10.
//  Copyright (c) 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import "HourglassAppDelegate.h"

@implementation HourglassAppDelegate


@synthesize window;
@synthesize tabBarController;
@synthesize navController;
@synthesize taskViewController;


#pragma mark -
#pragma mark Application Lifecycle
#pragma mark -


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // set up controller maze
  self.tabBarController = [[[UITabBarController alloc] init] autorelease];
  self.taskViewController = [[[TaskViewController alloc] init] autorelease];
  self.taskViewController.managedObjectContext = [self managedObjectContext];
  self.navController = [[[UINavigationController alloc] initWithRootViewController:self.taskViewController] autorelease];
  self.tabBarController.viewControllers = [NSArray arrayWithObject:navController];
  
  [window addSubview:self.tabBarController.view];
  
  [window makeKeyAndVisible];
  return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
  
  // Saves changes in the application's managed object context before the application terminates.
  NSError *error = nil;
  if (managedObjectContext) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}


- (void)dealloc {
  
  [window release];
  [managedObjectContext release];
  [managedObjectModel release];
  [persistentStoreCoordinator release];
  [super dealloc];
}


#pragma mark -
#pragma mark Core Data Methods
#pragma mark -


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
  
  if (managedObjectContext) {
    return managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator) {
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
  
  if (managedObjectModel) {
    return managedObjectModel;
  }
  managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
  return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  
  if (persistentStoreCoordinator) {
    return persistentStoreCoordinator;
  }
  
  NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Hourglass.sqlite"]];
  
  NSError *error = nil;
  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
     
     Typical reasons for an error here include:
     * The persistent store is not accessible
     * The schema for the persistent store is incompatible with current managed object model
     Check the error message to determine what the actual problem was.
     */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }    
  
  return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory
#pragma mark -


/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end