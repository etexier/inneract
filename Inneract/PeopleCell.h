//
//  PeopleCell.h
//  Inneract
//
//  Created by Jim Liu on 3/8/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFFile.h>

@class PeopleCell;

@protocol PeopleCellProtocol <NSObject>

- (void) peopleCell:(PeopleCell *) tweetCell didSharePeople:(PFObject*) user;

@end

@interface PeopleCell : PFTableViewCell

@property (weak, nonatomic) PFObject *user;

@property (nonatomic, weak) id<PeopleCellProtocol> userCellHandler;

@end
