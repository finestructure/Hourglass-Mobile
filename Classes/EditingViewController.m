
#import "EditingViewController.h"
#import "Task.h"

@implementation EditingViewController

@synthesize textField, editedObject, editedFieldKey, editedFieldName, datePicker;
@synthesize pickList;
@synthesize timerPicker;
@synthesize pickerView;


#pragma mark -
#pragma mark Workers


- (NSArray *)fetchProjects:(NSManagedObjectContext *)moc {
  NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
  NSEntityDescription *entity = [NSEntityDescription 
                                 entityForName:@"Project"
                                 inManagedObjectContext:moc];
  [fetchRequest setEntity:entity];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
  NSError *error;
  NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
  if (array == nil) {
    NSLog(@"Error while fetching projects: %@", [error userInfo]);
  }
  return array;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	// Set the title to the user-visible name of the field.
	self.title = editedFieldName;

	// Configure the save and cancel buttons.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

  textField.hidden = YES;
  datePicker.hidden = YES;
  timerPicker.hidden = YES;
  pickerView.hidden = YES;

  id value = [self.editedObject valueForKey:editedFieldKey];

  // Configure the user interface according to type

  if ([editedFieldKey isEqualToString:@"project"]) {
    pickerView.hidden = NO;
    self.pickList = [self fetchProjects:[self.editedObject managedObjectContext]];

    NSUInteger selectedRow = [self.pickList indexOfObjectPassingTest:
                              ^(id obj, NSUInteger idx, BOOL *stop) {
                                return ([[obj name] isEqualToString:[value name]]);
                              }];
    
    [self.pickerView selectRow:selectedRow inComponent:0 animated:NO];
  } else {
    NSEntityDescription *entitydesc = [self.editedObject entity];
    NSAttributeDescription *attrdesc = [[entitydesc attributesByName] valueForKey:editedFieldKey];

    switch ([attrdesc attributeType]) {
      case NSUndefinedAttributeType:
        NSLog(@"undef attr type");
        break;
      case NSDateAttributeType:
        datePicker.hidden = NO;
        datePicker.date = value;
        break;
      case NSStringAttributeType:
        textField.hidden = NO;
        textField.text = value;
        textField.placeholder = self.title;
        [textField becomeFirstResponder];
        break;
      case NSDecimalAttributeType:
      case NSDoubleAttributeType:
      case NSFloatAttributeType:
        timerPicker.hidden = NO;
        timerPicker.countDownDuration = [value floatValue]*3600;
        break;
    }
  }
}


#pragma mark -
#pragma mark UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [self.pickList count];
}


#pragma mark -
#pragma mark UIPickerViewDelegate


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [[self.pickList objectAtIndex:row] name];
}


#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)save {
  // get changed value
  
  if ([editedFieldKey isEqualToString:@"project"]) {
    id proj = [self.pickList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    [(Task *)editedObject setProject:proj];
  } else {
    NSEntityDescription *entitydesc = [self.editedObject entity];
    NSAttributeDescription *attrdesc = [[entitydesc attributesByName] valueForKey:editedFieldKey];

    switch ([attrdesc attributeType]) {
      case NSDateAttributeType:
        [editedObject setValue:datePicker.date forKey:editedFieldKey];
        break;
      case NSStringAttributeType:
        [editedObject setValue:textField.text forKey:editedFieldKey];
        break;
      case NSDecimalAttributeType:
      case NSDoubleAttributeType:
      case NSFloatAttributeType:
        [editedObject setValue:[NSNumber numberWithFloat:timerPicker.countDownDuration/3600.] forKey:editedFieldKey];
        break;
    }
  }
	
  // save changes
  
  NSError *error;
  if (![[editedObject managedObjectContext] save:&error]) {
    NSLog(@"Error while saving task %@, %@", error, [error userInfo]);
  }

  [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancel {
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [textField release];
    [editedObject release];
    [editedFieldKey release];
    [editedFieldName release];
    [datePicker release];
	[super dealloc];
}


@end

