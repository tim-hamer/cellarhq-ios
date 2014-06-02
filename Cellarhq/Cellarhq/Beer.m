#import "Beer.h"

@implementation Beer

-(NSString *)notes {
    if (!_notes) {
        return @"";
    }
    return _notes;
}

- (BOOL)validate {
    return self.name.length > 0 && self.brewery.length > 0 && self.quantity > 0 && self.bottleDate.length > 0 && self.size.length > 0 && self.style.length > 0 && self.beerId.length > 0 && self.breweryId.length > 0 && self.styleId.length > 0;
}

@end
