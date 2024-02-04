//
//  BrowseViewController.swift
//  HowsTheWear
//
//  Created by 제민우 on 1/2/24.
//

import UIKit

import SnapKit

final class BrowseMainViewController: UIViewController {
    
    private var thisWeekStyleArray = [
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage")
    ]
    
    private var nextWeekStyleArray = [
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage")
    ]
    
    private var lastYearStyleArray = [
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage"),
        UIImage(named: "StyleTestImage")
    ]

    private lazy var browseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: generateCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSubViews()
        configureLayout()
    }
    
}

// MARK: - Configure CollectionView

extension BrowseMainViewController {
    
    private func configureCollectionView() {
        browseCollectionView.dataSource = self
        browseCollectionView.register(BrowseCollectionViewCell.self, forCellWithReuseIdentifier: BrowseCollectionViewCell.reuseIdentifier)
        browseCollectionView.backgroundColor = .clear
        
        browseCollectionView.register(BrowseCollectionReusableView.self,
                                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                      withReuseIdentifier: BrowseCollectionReusableView.reuseIdentifier)
        // 모델, 데이터매니저 구현 후 데이터 받아오는 메서드 작성예정
    }

    private func generateCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.32),
            heightDimension: .estimated(130)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // screen의 height가 890 이상일 시 (XR, Plus, Max기종) header의 높이를 65로 설정 나머지는 35로 설정.
        let screenHeight = UIScreen.main.bounds.height
        let headerHeight: CGFloat = screenHeight >= 890 ? 65 : 35
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 30, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [headerElement]

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

// MARK: - Implementation CollectionView DataSource

extension BrowseMainViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return thisWeekStyleArray.count
        case 1:
            return nextWeekStyleArray.count
        case 2:
            return lastYearStyleArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BrowseCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? BrowseCollectionViewCell else { return UICollectionViewCell() }
        
        let section = indexPath.section
        
        switch section {
        case 0:
            cell.styleImageView.image = thisWeekStyleArray[indexPath.item]
        case 1:
            cell.styleImageView.image = nextWeekStyleArray[indexPath.item]
        case 2:
            cell.styleImageView.image = lastYearStyleArray[indexPath.item]
        default:
            fatalError()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: BrowseCollectionReusableView.reuseIdentifier,
            for: indexPath) as? BrowseCollectionReusableView else { fatalError("Cannot create new supplementary") }
        
        headerView.browseHeaderRightArrowButton.tag = indexPath.section
        headerView.delegate = self
        return headerView
    }
    
}

// MARK: - delegate
extension BrowseMainViewController: browseCollectionReusableDelegate{
    func browseHeaderRightArrowButtonTapped(section: Int) {
        switch section {
        case 0:
            let browseThisWeekViewController = BrowseThisWeekViewController()
            navigationController?.pushViewController(browseThisWeekViewController, animated: true)
        case 1:
            print("2")
        case 2:
            print("3")
        default:
            break
        }
    }
    
}

// MARK: - Configure UI

extension BrowseMainViewController {
    
    private func configureSubViews() {
        [browseCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        browseCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).offset(30)
            make.bottom.equalTo(safeArea.snp.bottom)
            make.leading.equalTo(safeArea.snp.leading).offset(15)
            make.trailing.equalTo(safeArea.snp.trailing)
        }
    }
    
}