//
//  LMManagedDocument.h
//  LandMarker
//
//  Created by David Lathrop on 7/3/15.
//  Copyright (c) 2015 Fry An Egg Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface LMManagedDocument : UIManagedDocument

-(NSArray *)fetchLandmarks;

@end
