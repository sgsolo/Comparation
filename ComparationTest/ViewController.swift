//
//  ViewController.swift
//  ComparationTest
//
//  Created by gssolovev on 06.12.2021.
//

import UIKit

class ViewController: UIViewController {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CustomCollectionViewLayout())
    let sectionData: [SectionData] = [
        SectionData(
            headerTitle: "Заголовок 1",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 2",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 3",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 4",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 5",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 6",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 7",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 8",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 9",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 10",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 11",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 12",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 13",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        ),
        SectionData(
            headerTitle: "Заголовок 14",
            cellsData: ["ячейка 1", "ячейка 2", "ячейка 3", "ячейка 3"]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        collectionView.isDirectionalLockEnabled = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        view.topAnchor.constraint(
            equalTo: collectionView.topAnchor,
            constant: -64
        ).isActive = true
        view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: collectionView.rightAnchor).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            CollectionViewCell.self,
            forCellWithReuseIdentifier: Spec.cellReuseIdentifier
        )
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Spec.supplementaryViewReuseIdentifier
        )
        
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sectionData[section].cellsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Spec.cellReuseIdentifier,
            for: indexPath
        ) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let data = sectionData[indexPath.section].cellsData[indexPath.row]
        
        cell.setData(text: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Spec.supplementaryViewReuseIdentifier,
            for: indexPath
        ) as? HeaderView else {
            return UICollectionViewCell()
        }
        
        let data = sectionData[indexPath.section]
        
        supplementaryView.setData(text: data.headerTitle)
        
        return supplementaryView
    }
}

//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
////        let header = HeaderView()
////        let data = sectionData[section]
////        header.setData(text: data.headerTitle)
////        header.setNeedsLayout()
////        header.layoutIfNeeded()
//////        header.sizeToFit()
////        print(header.sizeThatFits(collectionView.bounds.size))
//        return CGSize(width: collectionView.bounds.width, height: 30)
//    }
//}

extension ViewController {
    struct Spec {
        static let cellReuseIdentifier = "cell"
        static let supplementaryViewReuseIdentifier = "supplementaryView"
    }
}


class CustomCollectionViewLayout: UICollectionViewLayout {
    private var cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var cellAttributesWithoutLocking = [IndexPath: UICollectionViewLayoutAttributes]()
    private var headerAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var contentSize: CGSize = .zero
    private var lockedColumn: Int? = 1
    
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
        
        guard let collectionView = collectionView else {
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
            let supplementaryViewlayoutAttributes = UICollectionViewLayoutAttributes(
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                with: headerIndexPath
            )
            // TODO: получить размер через делегат
            supplementaryViewlayoutAttributes.frame = CGRect(
                x: collectionView.contentOffset.x,
                y: yPosition,
                width: collectionView.bounds.width,
                height: 30
            )
            headerAttributes[headerIndexPath] = supplementaryViewlayoutAttributes
            yPosition = yPosition + supplementaryViewlayoutAttributes.frame.height
            
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
                    print("xPos: \(xPosition + itemWidth)")
                    print(collectionView.contentOffset.x + collectionView.bounds.width)
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
                maxWidth = max(maxWidth, attributes.frame.maxX)
                
                cellAttributes[indexPath] = attributes
                if let attributesCopy = attributes.copy() as? UICollectionViewLayoutAttributes {
                    attributesCopy.frame.origin.x = originalXPosition
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
        print(proposedContentOffset)
        
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
            return CGPoint(
                x: layoutAttributes.frame.maxX,
                y: proposedContentOffset.y
            )
        } else {
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
