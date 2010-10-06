//
//  TaskViewController.m
//  Hourglass
//
//  Created by Sven A. Schmidt on 29.09.10.
//  Copyright (c) 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import "TaskViewController.h"
#import "Task.h"


@implementation TaskViewController

const int kRowHeight = 80;


@synthesize managedObjectContext;
@synthesize tasks;


#pragma mark -
#pragma mark Workers
#pragma mark -


-(void)fetchEntities {
  NSLog(@"Fetching entities");
  NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
  NSEntityDescription *entity = [NSEntityDescription 
                                 entityForName:@"Task"
                                 inManagedObjectContext:self.managedObjectContext];
  [request setEntity:entity];

  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate"
                                                                   ascending:NO];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  [request setSortDescriptors:sortDescriptors];

  NSError *error;
  NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
  if (mutableFetchResults == nil) {
    // Handle the error.
    NSLog(@"Error while fetching tasks: %@", [error userInfo]);
  }

  self.tasks = mutableFetchResults;
  [mutableFetchResults release];
  [self.tableView reloadData];
}


#pragma mark -
#pragma mark Initialization
#pragma mark -


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle
#pragma mark -


- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Tasks";
    
  // Set up the buttons
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
  UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] 
    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask)] autorelease];
  self.navigationItem.rightBarButtonItem = addButton;
  
  self.tableView.rowHeight = kRowHeight;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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
#pragma mark Workers
#pragma mark -


-(void)addTask {
  id task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
  
  NSError *error;
  if (![self.managedObjectContext save:&error]) {
    // Handle the error.
    NSLog(@"Error while saving task: %@", [error userInfo]);
  }
  
  //  [tasksArray addObject:task];
  //  [self.tableView reloadData];
  [self.tasks insertObject:task atIndex:0];
  NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                        withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
                        atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


#pragma mark -
#pragma mark Configuring table view cells


const CGFloat kRowWidth = 320;
const CGFloat kTopOffset = 5;

const CGFloat kRightOffset = 20;
const CGFloat kLeftMainOffset = 10;
const CGFloat kLeftDateOffset = 220;
const CGFloat kLeftStartOffset = 100;

const CGFloat kTopHeight = 15;
const CGFloat kMiddleHeight = 36;


- (UITableViewCell *)tableViewCellWithReuseIdentifier:(NSString *)identifier {
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];

  // project
  {
    CGFloat x = kLeftMainOffset;
    CGFloat y = kTopOffset;
    CGFloat width = kLeftDateOffset - kLeftMainOffset;
    CGFloat height = kTopHeight;
    CGRect rect = CGRectMake(x, y, width, height);
    UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.tag = 1;
    label.font = [UIFont systemFontOfSize:12];
    label.adjustsFontSizeToFitWidth = NO;
    [cell.contentView addSubview:label];
    label.textColor = [UIColor grayColor];
    label.highlightedTextColor = [UIColor whiteColor];
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
    [cell.contentView addSubview:label];
    label.textColor = [UIColor grayColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentRight;
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
    [cell.contentView addSubview:label];
    label.highlightedTextColor = [UIColor whiteColor];
  }
  
  // length
  {
    CGFloat x = kLeftMainOffset;
    CGFloat y = kTopOffset + kTopHeight + kMiddleHeight;
    CGFloat width = kRowWidth - x - kLeftStartOffset;
    CGFloat height = kRowHeight - y;
    CGRect rect = CGRectMake(x, y, width, height);
    UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.tag = 4;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.adjustsFontSizeToFitWidth = NO;
    [cell.contentView addSubview:label];
    label.highlightedTextColor = [UIColor whiteColor];
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
	
  Task *task = (Task *)[self.tasks objectAtIndex:indexPath.row];

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
}    


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.tasks count];
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
    // Delete the managed object at the given index path.
    NSManagedObject *toDelete = [self.tasks objectAtIndex:indexPath.row];
    [managedObjectContext deleteObject:toDelete];
    
    // Update the array and table view.
    [self.tasks removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                        withRowAnimation:YES];
    
    // Commit the change.
    NSError *error;
    if (![managedObjectContext save:&error]) {
      // Handle the error.
      NSLog(@"Error while deleting task: %@", [error userInfo]);
    }
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
  self.tasks = nil;
}


- (void)dealloc {
  [self.managedObjectContext release];
  [self.tasks release];
  [super dealloc];
}


@end

