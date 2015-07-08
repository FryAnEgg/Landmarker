//
//  Landmark.h
//  LandMarker
//
//  Created by David Lathrop on 7/7/15.
//  Copyright (c) 2015 Fry An Egg Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Landmark : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * horiz_accuracy;
@property (nonatomic, retain) NSNumber * vert_accuracy;
@property (nonatomic, retain) NSNumber * altitude;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSNumber * course;
@property (nonatomic, retain) NSString * name;

@end
