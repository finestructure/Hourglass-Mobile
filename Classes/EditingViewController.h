
@interface EditingViewController : UIViewController {
}

@property (nonatomic, retain) IBOutlet UITextField *textField;

@property (nonatomic, retain) NSManagedObject *editedObject;
@property (nonatomic, retain) NSString *editedFieldKey;
@property (nonatomic, retain) NSString *editedFieldName;
@property (nonatomic, retain) NSArray *pickList;

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIDatePicker *timerPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

- (IBAction)cancel;
- (IBAction)save;

@end

