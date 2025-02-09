//
//  MBTICollectionView.swift
//  Moviegram
//
//  Created by 이빈 on 2/8/25.
//

import UIKit
import SnapKit

protocol PassMBTIDelegate: AnyObject {
    func passMBTI(data: String)
}

final class MBTICollectionView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var mbtiData: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: PassMBTIDelegate?
    
    init(mbtiData: [String]) {
        super.init(frame: .zero)
        self.mbtiData = mbtiData
    }
    
    override func configureHierarchy() {
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(130)
        }
    }
    
    override func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MBTICollectionViewCell.self, forCellWithReuseIdentifier: MBTICollectionViewCell.identifier)
        collectionView.collectionViewLayout = configureCollectionViewLayout()
        collectionView.backgroundColor = .clear
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 60, height: 60)
        return layout
    }
}

extension MBTICollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        return mbtiData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MBTICollectionViewCell.identifier, for: indexPath) as? MBTICollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureData(data: mbtiData[indexPath.item])
        if cell.isSelected {
            delegate?.passMBTI(data: mbtiData[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print(#function)
        guard let cell = collectionView.cellForItem(at: indexPath) as? MBTICollectionViewCell else {
            print("컬렉션뷰 셀 오류")
            return false
        }
        
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: false)
            delegate?.passMBTI(data: mbtiData[indexPath.item])
            return false
        } else {
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        // 선택된 값 넘겨주기
        delegate?.passMBTI(data: mbtiData[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(#function)
        delegate?.passMBTI(data: mbtiData[indexPath.item])
    }
    
}
