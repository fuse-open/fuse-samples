#pragma once

#include <Uno/Uno.h>
#include <UIKit/UIKit.h>

@interface UIControlEventHandler : NSObject { }
- (void)action:(id)sender forEvent:(UIEvent *)event;
@property (copy) void (^callback)(id, id);
@end