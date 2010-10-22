//
//  TaskViewController.m
//  Hourglass
//
//  Created by Sven A. Schmidt on 29.09.10.
//  Copyright (c) 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import "TaskViewController.h"
#import "Task.h"
#import "DetailViewController.h"
#import "AddViewController.h"


@implementation TaskViewController

const int kRowHeight = 80;


@synthesize managedObjectContext;
@synthesize addingManagedObjectContext;
@synthesize fetchedResultsController;


#pragma mark -
#pragma mark Workers


-(void)fetchEntities {
  NSLog(@"Fetching entities");

  NSError *error;
  BOOL success = [self.fetchedResultsController performFetch:&error];
  if (!success) {
    NSLog(@"Error while fetching tasks: %@", [error userInfo]);
  }
}


#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
  if ((self = [super initWithStyle:style])) {
    self.title = NSLocalizedString(@"Tasks", @"Task tab bar item title");
    self.tabBarItem.image = [UIImage imageNamed:@"tasks.png"];
  }
  return self;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
  [super viewDidLoad];

  // Set up the buttons
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
  UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] 
    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask)] autorelease];
  self.navigationItem.rightBarButtonItem = addButton;
  
  self.tableView.rowHeight = kRowHeight;
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Adding a Task


- (IBAction)addTask {
	
  AddViewController *addViewController = [[AddViewController alloc] initWithStyle:UITableViewStyleGrouped];
	addViewController.delegate = self;
	
	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	self.addingManagedObjectContext = addingContext;
	[addingContext release];
	
	[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
  
	addViewController.task = (Task *)[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:addingContext];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addViewController];
	
  [self.navigationController presentModalViewController:navController animated:YES];
	
	[addViewController release];
	[navController release];
}


- (void)addViewController:(AddViewController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {
		/*
		 The new book is associated with the add controller's managed object context.
		 This is good because it means that any edits that are made don't affect the application's main managed object context -- it's a way of keeping disjoint edits in a separate scratchpad -- but it does make it more difficult to get the new book registered with the fetched results controller.
		 First, you have to save the new book.  This means it will be added to the persistent store.  Then you can retrieve a corresponding managed object into the application delegate's context.  Normally you might do this using a fetch or using objectWithID: -- for example
		 
		 NSManagedObjectID *newBookID = [controller.book objectID];
		 NSManagedObject *newBook = [applicationContext objectWithID:newBookID];
		 
		 These techniques, though, won't update the fetch results controller, which only observes change notifications in its context.
		 You don't want to tell the fetch result controller to perform its fetch again because this is an expensive operation.
		 You can, though, update the main context using mergeChangesFromContextDidSaveNotification: which will emit change notifications that the fetch results controller will observe.
		 To do this:
		 1	Register as an observer of the add controller's change notifications
		 2	Perform the save
		 3	In the notification method (addControllerContextDidSave:), merge the changes
		 4	Unregister as an observer
		 */
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
		
		NSError *error;
		if (![addingManagedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Error while adding task %@, %@", error, [error userInfo]);
		}
		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
	}
	// Release the adding managed object context.
	self.addingManagedObjectContext = nil;
  
	// Dismiss the modal view to return to the main list
  [self dismissModalViewControllerAnimated:YES];
}


- (void)addControllerContextDidSave:(NSNotification*)saveNotification {	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];	
}


#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
  if (fetchedResultsController != nil) {
    return fetchedResultsController;
  }
  
	// Create and configure a fetch request
  NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
  NSEntityDescription *entity = [NSEntityDescription 
                                 entityForName:@"Task"
                                 inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];

  // Create the sort descriptors array
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate"
                                                                   ascending:NO];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
		
	// Create and initialize the fetch results controller
  self.fetchedResultsController = [[[NSFetchedResultsController alloc]
                                    initWithFetchRequest:fetchRequest
                                    managedObjectContext:self.managedObjectContext
                                    sectionNameKeyPath:nil
                                    cacheName:nil] autorelease];
	fetchedResultsController.delegate = self;
	
	return fetchedResultsController;
}    


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  NSLog(@"begin update");
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] forIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  NSLog(@"end update");
	[self.tableView endUpdates];
}


#pragma mark -
#pragma mark Configuring table view cells


const CGFloat kRowWidth = 320;
const CGFloat kTopOffset = 5;

const CGFloat kRightOffset = 24;
const CGFloat kLeftMainOffset = 10;
const CGFloat kLeftDateOffset = 220;
const CGFloat kLeftStartOffset = 100;

const CGFloat kTopHeight = 15;
const CGFloat kMiddleHeight = 40;


- (UITableViewCell *)tableViewCellWithReuseIdentifier:(NSString *)identifier {
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];

  // project
  {
    CGFloat x = kLeftMainOffset +2;
    CGFloat y = kTopOffset;
    CGFloat width = kLeftDateOffset - kLeftMainOffset;
    CGFloat height = kTopHeight;
    CGRect rect = CGRectMake(x, y, width, height);
    UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.tag = 1;
    label.font = [UIFont systemFontOfSize:12];
    label.adjustsFontSizeToFitWidth = NO;
    label.textColor = [UIColor grayColor];
    label.highlightedTextColor = [UIColor whiteColor];
    [cell.contentView addSubview:label];
  }
  
  // date
  {
    CGFloat x = kLeftDateOffset;
    CGFloat y = kTopOffset;
    CGFloat width = kRowWidth - x - kRightOffset;
    CGFloat height = kTopHeight;
    CGRect rect = CGRectMake(x, y, width, height);
    UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.tag = 2;
    label.font = [UIFont systemFontOfSize:12];
    label.adjustsFontSizeToFitWidth = NO;
    label.textColor = [UIColor grayColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentRight;
    [cell.contentView addSubview:label];
  }
  
  // desc
  {
    CGFloat x = kLeftMainOffset;
    CGFloat y = kTopOffset + kTopHeight;
    CGFloat width = kRowWidth - x - kRightOffset;
    CGFloat height = kMiddleHeight;
    CGRect rect = CGRectMake(x, y, width, height);
    UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.tag = 3;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.adjustsFontSizeToFitWidth = NO;
    label.highlightedTextColor = [UIColor whiteColor];
    [cell.contentView addSubview:label];
  }
  
  // length
  {
    CGFloat x = kLeftMainOffset +2;
    CGFloat y = kTopOffset + kTopHeight + kMiddleHeight -5;
    CGFloat width = kRowWidth - x - kLeftStartOffset;
    CGFloat height = kRowHeight - y;
    CGRect rect = CGRectMake(x, y, width, height);
    UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.tag = 4;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.adjustsFontSizeToFitWidth = NO;
    label.highlightedTextColor = [UIColor whiteColor];
    [cell.contentView addSubview:label];
  }
  
  // start & end
  {
    CGFloat x = kLeftStartOffset;
    CGFloat y = kTopOffset + kTopHeight + kMiddleHeight -5;
    CGFloat width = kRowWidth - x - kRightOffset;
    CGFloat height = kRowHeight - y;
    CGRect rect = CGRectMake(x, y, width, height);
    UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.tag = 5;
    label.font = [UIFont systemFontOfSize:12];
    label.adjustsFontSizeToFitWidth = NO;
    label.textColor = [UIColor grayColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentRight;
    [cell.contentView addSubview:label];
  }
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
	return cell;
}


- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
  
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"LLL dd"];
	}
	static NSDateFormatter *timeFormatter = nil;
	if (timeFormatter == nil) {
		timeFormatter = [[NSDateFormatter alloc] init];
		[timeFormatter setDateFormat:@"HH:mm"];
	}
	
  Task *task = (Task *)[self.fetchedResultsController objectAtIndexPath:indexPath];

	// project
  {
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = [task.project name];
  }
	
	// date
	{
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    label.text = [dateFormatter stringFromDate:task.startDate];
  }

	// desc
  {
    UILabel *label = (UILabel *)[cell viewWithTag:3];
    label.text = task.desc;
  }
  
	// length
  {
    UILabel *label = (UILabel *)[cell viewWithTag:4];
    label.text = [NSString stringWithFormat:@"%.2f h", [task.length floatValue]];
  }
  
	// start + end
  {
    UILabel *label = (UILabel *)[cell viewWithTag:5];
    label.text = [NSString stringWithFormat:@"%@ – %@", [timeFormatter stringFromDate:task.startDate], [timeFormatter stringFromDate:task.endDate]];
  }
}    


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"TaskCell";
    
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
		cell = [self tableViewCellWithReuseIdentifier:CellIdentifier];
  }
    
  // A date formatter for the time stamp
  static NSDateFormatter *dateFormatter = nil;
  if (dateFormatter == nil) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  }
  
  [self configureCell:cell forIndexPath:indexPath];

  return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object.
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Error in tableView:commitEditingStyle: %@, %@", error, [error userInfo]);
		}
  } 
  
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
  Task *task = (Task *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
  detailViewController.task = task;
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  self.fetchedResultsController = nil;
}


- (void)dealloc {
  [self.managedObjectContext release];
  [self.fetchedResultsController release];
  [super dealloc];
}


@end

