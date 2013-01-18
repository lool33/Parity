//
//  Icon+Fetch.h
//  Parity
//
//  Created by Laurent GAIDON on 26/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "Icon.h"

@interface Icon (Fetch)


+(Icon *)singleIconInManagedObjectContext:(NSManagedObjectContext *)context withFlickrInfo:(NSDictionary *)flickrInfo;

+(NSSet *)iconsForIconSet:(NSString *)iconSetName inManagedObjectContext:(NSManagedObjectContext *)context;

+(Icon *)iconForFlickrInfo:(NSDictionary *)flickrInfo
    inManagedObjectContext:(NSManagedObjectContext *)context;


@end
