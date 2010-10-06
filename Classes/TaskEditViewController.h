//
//  TaskEditViewController.h
//  Hourglass
//
//  Created by Sven A. Schmidt on 06.10.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"


@interface TaskEditViewController : UIViewController<UITextViewDelegate> {

}

@property (nonatomic, retain) IBOutlet UITextView *descriptionView;
@property (nonatomic, retain) Task *task;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
