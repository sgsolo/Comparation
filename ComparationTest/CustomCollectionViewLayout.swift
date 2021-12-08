import UIKit

protocol CustomCollectionViewLayoutDelegate: AnyObject {
    func headerSize(indexPath: IndexPath) -> CGSize
}

class CustomCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: CustomCollectionViewLayoutDelegate?
    
    private var cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var cellAttributesWithoutLocking = [IndexPath: UICollectionViewLayoutAttributes]()
    private var headerAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var contentSize: CGSize = .zero
//    private var lockedColumn: Int? = 1
    
    // MARK: - Constants
    
    private let insets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    private let cellSpacing = CGFloat(6)
    
    // MARK: - UICollectionViewLayout
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        
        guard let collectionView = collectionView, let delegate = delegate else {
            contentSize = .zero
            cellAttributes = [:]
            headerAttributes = [:]
            cellAttributesWithoutLocking = [:]
            return
        }
        
        headerAttributes.removeAll()
        cellAttributes.removeAll()
        cellAttributesWithoutLocking.removeAll()
        
        var yPosition: CGFloat = 0
        var maxWidth: CGFloat = 0
        
        let numberOfSections = collectionView.numberOfSections
        
        for section in 0..<numberOfSections {
            
            let headerIndexPath = IndexPath(item: 0, section: section)
            let supplementaryViewLayoutAttributes = UICollectionViewLayoutAttributes(
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                with: headerIndexPath
            )
            let headerSize = delegate.headerSize(indexPath: headerIndexPath)
            let supplementaryViewYPosition = (section == 0 && collectionView.contentOffset.y > 0) ? collectionView.contentOffset.y : yPosition
            if (section == 0 && collectionView.contentOffset.y > 0) {
                print(supplementaryViewYPosition)
            }
            supplementaryViewLayoutAttributes.frame = CGRect(
                x: collectionView.contentOffset.x,
                y: supplementaryViewYPosition,
                width: headerSize.width,
                height: headerSize.height
            )
            let supplementaryViewZIndex = (section == 0) ? 2 : supplementaryViewLayoutAttributes.zIndex
            supplementaryViewLayoutAttributes.zIndex = supplementaryViewZIndex
            headerAttributes[headerIndexPath] = supplementaryViewLayoutAttributes
            if (section == 0 && collectionView.contentOffset.y > 0) {
                yPosition = 100
            } else {
                yPosition = yPosition + supplementaryViewLayoutAttributes.frame.height
            }
            
            var maxSectionHeght: CGFloat = 0
            
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for item in 0 ..< numberOfItems {
                
                // TODO: получить размер через делегат
                let itemWidth = itemWidth()
                var xPosition = itemWidth * CGFloat(item)
                let originalXPosition = xPosition
                var zIndex = 0
                
                if lockedColumn == item {
                    zIndex = 1
                    if xPosition < collectionView.contentOffset.x {
                        xPosition = collectionView.contentOffset.x
                    } else if xPosition + itemWidth > collectionView.contentOffset.x + collectionView.bounds.width {
                        xPosition = collectionView.contentOffset.x + collectionView.bounds.width - itemWidth
                    }
                }
                
                let origin = CGPoint(
                    x: xPosition,
                    y: yPosition
                )
                
                // TODO: получить размер через делегат
                let itemSize = CGSize(
                    width: itemWidth,
                    height: 50
                )
                
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(
                    origin: origin,
                    size: itemSize
                )
                attributes.zIndex = zIndex
                
                maxSectionHeght = max(maxSectionHeght, attributes.frame.height)
//                maxWidth = max(maxWidth, attributes.frame.maxX)
                
                cellAttributes[indexPath] = attributes
                if let attributesCopy = attributes.copy() as? UICollectionViewLayoutAttributes {
                    attributesCopy.frame.origin.x = originalXPosition
                    // важно получать maxWidth в этом месте
                    maxWidth = max(maxWidth, attributesCopy.frame.maxX)
                    cellAttributesWithoutLocking[indexPath] = attributesCopy
                }
            }
            yPosition = yPosition + maxSectionHeght
        }
        
        contentSize = CGSize(
            width: maxWidth,
            height: yPosition
        )
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return headerAttributes.filter { $1.frame.intersects(rect) }.map { $1 } +
        cellAttributes.filter { $1.frame.intersects(rect) }.map { $1 }
    }
    
    override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        return headerAttributes[indexPath]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributes[indexPath]
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint)
        -> CGPoint
    {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(
                forProposedContentOffset: proposedContentOffset,
                withScrollingVelocity: velocity
            )
        }
        
        let visibleRect = CGRect(
            x: proposedContentOffset.x,
            y: proposedContentOffset.y,
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
        )
        
        // ищем самую левую ячейку из коллекции
        var attributes = cellAttributesWithoutLocking.filter { $1.frame.intersects(visibleRect) }.map { $1 }
        attributes.sort { $0.frame.origin.x < $1.frame.origin.x }
        
        guard let layoutAttributes = attributes.first else {
            return super.targetContentOffset(
                forProposedContentOffset: proposedContentOffset,
                withScrollingVelocity: velocity
            )
        }
        let diff = abs(layoutAttributes.frame.origin.x - proposedContentOffset.x)
        if diff > (itemWidth() / 2) {
            print(layoutAttributes.frame.maxX)
            return CGPoint(
                x: layoutAttributes.frame.maxX,
                y: proposedContentOffset.y
            )
        } else {
            print(layoutAttributes.frame.origin.x)
            return CGPoint(
                x: layoutAttributes.frame.origin.x,
                y: proposedContentOffset.y
            )
        }
    }
    
    private func itemWidth() -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.frame.width / 2
    }
}
