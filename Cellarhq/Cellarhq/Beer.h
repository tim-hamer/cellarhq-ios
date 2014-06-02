#import <Foundation/Foundation.h>

@interface Beer : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *brewery;
@property (nonatomic) int quantity;
@property (nonatomic) NSString *bottleDate;
@property (nonatomic) NSString *size;
@property (nonatomic) NSString *style;
@property (nonatomic) NSString *notes;


@property (nonatomic) NSString *uniqueId;
@property (nonatomic) NSString *beerId;
@property (nonatomic) NSString *breweryId;
@property (nonatomic) NSString *styleId;

- (BOOL)validate;

@end
