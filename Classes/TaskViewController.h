//
//  TaskViewController.h
//  Hourglass
//
//  Created by Sven A. Schmidt on 29.09.10.
//  Copyright (c) 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddViewController.h"


@interface TaskViewController : UITableViewController<NSFetchedResultsControllerDelegate, AddViewControllerDelegate> {
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)fetchEntities;
- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;

@end