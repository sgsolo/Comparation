//
//  ViewController.swift
//  ComparationTest
//
//  Created by gssolovev on 06.12.2021.
//

import UIKit

var lockedColumn: Int? = 1

class ViewController: UIViewController {

    let maxHeaderHeight: CGFloat = 100
    let minHeaderHeight: CGFloat = 30
    
    let customCollectionViewLayout = CustomCollectionViewLayout()
    lazy var collectionView: UICollectionView = { UICollectionView(frame: .zero, collectionViewLayout: customCollectionViewLayout) }()
    let sectionData: [SectionData] = [
        SectionData(
            headerTitle: "ЗАГОЛОВОК С КАРТИНКАМИ",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4", "столбец 5", "столбец 6"]
        ),
        SectionData(
            headerTitle: "Заголовок 2",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 3",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 4",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 5",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 6",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 7",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 8",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 9",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 10",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 11",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 12",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 13",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        ),
        SectionData(
            headerTitle: "Заголовок 14",
            cellsData: ["столбец 1", "столбец 2", "столбец 3", "столбец 4"]
        )
    ]
    
    var headerTransitionProgress: CGFloat = 0 {
        didSet {
            if oldValue != headerTransitionProgress {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customCollectionViewLayout.delegate = self
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
        
        cell.setData(text: data, isLockVisible: indexPath.section == 0, isLockEnabled: lockedColumn == indexPath.row) { [weak self] isLocked in
            lockedColumn = indexPath.row
            self?.collectionView.reloadData()
        }
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

extension ViewController {
    struct Spec {
        static let cellReuseIdentifier = "cell"
        static let supplementaryViewReuseIdentifier = "supplementaryView"
    }
}

extension ViewController: CustomCollectionViewLayoutDelegate {
    func headerSize(indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(
                width: collectionView.bounds.width,
                height: max(minHeaderHeight, ((maxHeaderHeight) * (1 - headerTransitionProgress)))
            )
        } else {
            return CGSize(
                width: collectionView.bounds.width,
                height: minHeaderHeight
            )
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeHeaderTransitionProgress(offset: scrollView.contentOffset.y)
    }
    
    func changeHeaderTransitionProgress(offset: CGFloat) {
        var progress: CGFloat = 0
        if offset < 0 {
            progress = 0
        } else if offset > maxHeaderHeight {
            progress = 1
        } else {
            progress = (offset) / (maxHeaderHeight)
        }
        headerTransitionProgress = progress
    }
}
