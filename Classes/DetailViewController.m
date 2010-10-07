
#import "DetailViewController.h"
#import "Task.h"
#import "EditingViewController.h"


@implementation DetailViewController

@synthesize task, dateFormatter;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];	
	self.title = @"Info";
}


- (void)viewWillAppear:(BOOL)animated {
  [self.tableView reloadData];
}


- (void)viewDidUnload {
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	self.dateFormatter = nil;
}


#pragma mark -
#pragma mark Table view data source methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
	
	switch (indexPath.row) {
    case 0: 
			cell.textLabel.text = @"description";
			cell.detailTextLabel.text = task.desc;
			break;
    case 1: 
			cell.textLabel.text = @"start date";
			cell.detailTextLabel.text = [self.dateFormatter stringFromDate:task.startDate];
			break;
    case 2:
			cell.textLabel.text = @"end date";
			cell.detailTextLabel.text = [self.dateFormatter stringFromDate:task.endDate];
			break;
  }
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
  
  controller.editedObject = task;
  switch (indexPath.row) {
    case 0: {
      controller.editedFieldKey = @"desc";
      controller.editedFieldName = NSLocalizedString(@"Description", @"display name for description");
      controller.editingDate = NO;
    } break;
    case 1: {
      controller.editedFieldKey = @"startDate";
			controller.editedFieldName = NSLocalizedString(@"Start Date", @"display name for start date");
			controller.editingDate = YES;
    } break;
    case 2: {
      controller.editedFieldKey = @"endDate";
			controller.editedFieldName = NSLocalizedString(@"End Date", @"display name for end date");
			controller.editingDate = YES;
    } break;
  }
	
  [self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


#pragma mark -
#pragma mark Date Formatter


- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  [dateFormatter release];
  [task release];
  [super dealloc];
}

@end

