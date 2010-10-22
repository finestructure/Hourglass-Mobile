
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
    return 5;
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
			cell.textLabel.text = @"start";
			cell.detailTextLabel.text = [self.dateFormatter stringFromDate:task.startDate];
			break;
    case 2:
			cell.textLabel.text = @"end";
			cell.detailTextLabel.text = [self.dateFormatter stringFromDate:task.endDate];
			break;
    case 3:
			cell.textLabel.text = @"length";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f h", [task.length floatValue]];
			break;
    case 4: 
			cell.textLabel.text = @"project";
			cell.detailTextLabel.text = [task.project name];
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
    } break;
    case 1: {
      controller.editedFieldKey = @"startDate";
			controller.editedFieldName = NSLocalizedString(@"Start", @"display name for start date");
    } break;
    case 2: {
      controller.editedFieldKey = @"endDate";
			controller.editedFieldName = NSLocalizedString(@"End", @"display name for end date");
    } break;
    case 3: {
      controller.editedFieldKey = @"length";
      controller.editedFieldName = NSLocalizedString(@"Length", @"display name for length");
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
		[dateFormatter setDateFormat:@"LLL dd – HH:mm"];
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

