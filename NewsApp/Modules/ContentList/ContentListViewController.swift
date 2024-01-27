//
//  ContentListViewController.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import UIKit

class ContentListViewController: UIViewController {
    
    var vm: ContentListViewModelProtocol!
    
    private let contentView = ContentListView()
    
    private var collectionView: UICollectionView {
        contentView.collectionView
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News List"
        
        setupDataSource()
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.zero])
        dataSource.apply(snapshot)
        
        collectionView.delegate = self
        
        vm.setupContent()
    }
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ContentCollectionCell, ContentCollectionCellConfiguration> { cell, indexPath, configuration in
            cell.configuration = configuration
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return nil }
            
            
            
            let configuration = self.vm.contentConfigurations[indexPath.row]
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: configuration)
        }
        
        self.dataSource = dataSource
    }
}

extension ContentListViewController: ContentListViewModelOutput {
    func contentDidChange() {
        var snapshot = dataSource.snapshot(for: .zero)
        snapshot.deleteAll()
        snapshot.append(vm.contentConfigurations.map { $0.id })
        dataSource.apply(snapshot, to: .zero)
    }
}

extension ContentListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vm.didSelectContent(with: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == vm.contentConfigurations.count - 10 {
            vm.setupContent()
        }
    }
}
