
#import "EditingViewController.h"

@implementation EditingViewController

@synthesize textField, editedObject, editedFieldKey, editedFieldName, datePicker;
@synthesize timerPicker;


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

  id value = [self.editedObject valueForKey:editedFieldKey];
  NSEntityDescription *entitydesc = [self.editedObject entity];
  NSAttributeDescription *attrdesc = [[entitydesc attributesByName] valueForKey:editedFieldKey];

	// Configure the user interface according to type
  switch ([attrdesc attributeType]) {
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


#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)save {
  NSEntityDescription *entitydesc = [self.editedObject entity];
  NSAttributeDescription *attrdesc = [[entitydesc attributesByName] valueForKey:editedFieldKey];

  // pass current value to the edited object, then pop.
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

