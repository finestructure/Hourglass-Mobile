//
//  TaskViewController.h
//  Hourglass
//
//  Created by Sven A. Schmidt on 29.09.10.
//  Copyright (c) 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TaskViewController : UITableViewController {
  NSManagedObjectContext *managedObjectContext;
  NSMutableArray *tasks;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *tasks;

@end