//
//  ProfileDelegate.h
//  Inneract
//
//  Created by Jim Liu on 3/17/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#ifndef Inneract_ProfileDelegate_h
#define Inneract_ProfileDelegate_h

@protocol ProfileDelegate <NSObject>

- (void) onEditProfile;

- (void) onViewProfileLink;

- (void) onGiveBadge;

@end

#endif
