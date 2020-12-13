//
//  UnitListViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/07/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PKHUD
import RxDataSources

/**
 * 単元一覧画面VC
 */
class UnitListViewController: UIViewController, UIScrollViewDelegate, UIAdaptivePresentationControllerDelegate {

    private lazy var viewModel: UnitListViewModel = UnitListViewModel()

    private lazy var dataSource: RxTableViewSectionedReloadDataSource<UnitListSectionDomainModel> = setupDataSource()

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingButton: UIButton!
    
    // MARK: - Properties

    // 触感フィードバック
    private let lightFeedBack: UIImpactFeedbackGenerator = {
        let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()

    private var disposeBag = DisposeBag()

    private lazy var emptyView: EmptyView = {
        let v = R.nib.emptyView.firstView(owner: nil)!
        v.backgroundColor = R.color.study()
        v.retryAction = { [weak self] in
            self?.fetch()
        }
        v.page = .tab
        v.status = .none
        view.addSubview(v)
        view.allSafePin(subView: v, top: 45)
        return v
    }()

    private var shouldShowEmptyView = true

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)

        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.tableView.rowHeight = 98

        // ユーザ未作成の場合はユーザ作成画面に遷移
        if ApplicationConfigData.authToken == "" {
            let vc = CreateUserViewController.makeInstance()
            vc.presentationController?.delegate = self
            present(vc, animated: false)
        }

        subscribe()
        fetch()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 更新されていない学習履歴がある場合は更新する
        if !ApplicationConfigData.rememberIdsArray.isEmpty || !ApplicationConfigData.notRememberIdsArray.isEmpty {
            postLearningHistories()
        }

        if !ApplicationConfigData.hasShowedUnitList {
            fetch()
        }

    }

}

// MARK: - Functions

extension UnitListViewController {

    private func subscribe() {

        // loading
        viewModel.loadingDriver
            .map { [unowned self] isLoading in
                if isLoading && shouldShowEmptyView {
                    return .loading
                } else {
                    return .none
                }
            }
            .drive(onNext: {[weak self] in
                self?.emptyView.status = $0
            }).disposed(by: disposeBag)

        // データソースと紐付ける
        viewModel.unitsObservable
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        // セルタップ
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                lightFeedBack.impactOccurred()
                let vc = LearningUnitViewController.makeInstance(unitMasterId: viewModel.units[indexPath.row].id, unitTitle: viewModel.units[indexPath.row].vietnamese)
                vc.presentationController?.delegate = self
                self.present(vc, animated: true)
            }).disposed(by: disposeBag)

    }

    private func fetch() {
        viewModel.fetch(authToken: ApplicationConfigData.authToken)
            .subscribe(
                onNext: { [unowned self] _ in
                    // 一度fetchに成功したらEmptyViewは表示しない
                    shouldShowEmptyView = false
                    ApplicationConfigData.hasShowedUnitList = true
                },
                onError: { [unowned self] in
                    log.error($0.descriptionOfType)

                    if shouldShowEmptyView {
                        self.emptyView.status = .errorAndRetry($0.descriptionOfType)
                    }
                }).disposed(by: disposeBag)
    }

    /// 学習履歴を更新
    private func postLearningHistories() {
        
        viewModel.postLearningHistories()
            .subscribe(
                onNext: { [unowned self] _ in
                    // 学習履歴の更新に成功した場合、UserDefaultsを初期化する
                    ApplicationConfigData.rememberIdsArray = []
                    ApplicationConfigData.notRememberIdsArray = []

                    // 単元一覧を更新
                    fetch()
                }
            ).disposed(by: disposeBag)
    }

}

// MARK: - TableViewDataSource

extension UnitListViewController {

    private func setupDataSource() -> RxTableViewSectionedReloadDataSource<UnitListSectionDomainModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<UnitListSectionDomainModel>(configureCell: { (_, tableView, indexPath, item) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.unitListCell.identifier, for: indexPath) as?
                    UnitListCell else {
                log.error("Can't cast R.reuseIdentifier.unitListCell to UnitListCell")
                return UITableViewCell()
            }

            cell.configure(item)

            return cell
        })
        return dataSource
    }

}

// MARK: - MakeInstance

extension UnitListViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.unitList.unitListViewController() else {
            assertionFailure("Can't make instance 'UnitListViewController'.")
            return UIViewController()
        }
        return vc
    }

}
