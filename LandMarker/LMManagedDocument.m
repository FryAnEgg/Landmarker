//
//  LMManagedDocument.m
//  LandMarker
//
//  Created by David Lathrop on 7/3/15.
//  Copyright (c) 2015 Fry An Egg Technology. All rights reserved.
//

#import "LMManagedDocument.h"

@implementation LMManagedDocument

-(NSArray *)fetchLandmarks {
    
    NSManagedObjectContext* moc = self.managedObjectContext;
    
    moc.mergePolicy = NSRollbackMergePolicy;
    
    NSFetchRequest* landmarksRequest =  [NSFetchRequest fetchRequestWithEntityName:@"Landmark"];
    
    NSArray* landmarkResults = [moc executeFetchRequest:landmarksRequest error:nil];
    
    return landmarkResults;
}


@end
