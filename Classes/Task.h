//
//  Task.h
//  Hourglass
//
//  Created by Sven A. Schmidt on 17.01.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSManagedObject {

}

- (NSDate*)dateWithDate:(NSDate*)date andTime:(NSDate*)time;


@property(nonatomic, retain) NSDate* startDate;
@property(nonatomic, retain) NSDate* endDate;
@property(nonatomic, retain) NSString* desc;
@property(nonatomic, retain) NSNumber* length;
@property(nonatomic, retain) id project;


@end
