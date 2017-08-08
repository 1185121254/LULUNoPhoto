

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HerderStyle)
{
    HerderStyleNone,
    HerderStyleTotal
};

@protocol FoldSectionHeaderViewDelegate <NSObject>

- (void)foldHeaderInSection:(NSInteger)SectionHeader;

@end

@interface FoldHeaderView : UITableViewHeaderFooterView

@property(nonatomic, assign) BOOL fold;/**< 是否折叠 */
@property(nonatomic, assign) NSInteger section;/**< 选中的section */
@property(nonatomic, weak) id<FoldSectionHeaderViewDelegate> delegate;/**< 代理 */

- (void)setFoldSectionHeaderViewWithTitle:(NSString *)title detail:(NSString *)detail type:(HerderStyle)type section:(NSInteger)section canFold:(BOOL)canFold;

@end
