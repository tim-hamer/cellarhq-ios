#import "Beer.h"

@implementation Beer

-(NSString *)notes {
    if (!_notes) {
        return @"";
    }
    return _notes;
}

@end
