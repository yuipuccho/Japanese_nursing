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

    // MARK: - Properties

    private var disposeBag = DisposeBag()

    private lazy var emptyView: EmptyView = {
        let v = R.nib.emptyView.firstView(owner: nil)!
        v.backgroundColor = R.color.study()
        v.retryAction = { [weak self] in
            self?.fetch()
        }
        v.page = .learn
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

    // 遷移先の画面が閉じられた時に呼ばれる
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        fetch()
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
                },
                onError: { [unowned self] in
                    log.error($0.descriptionOfType)

                    if shouldShowEmptyView {
                        self.emptyView.status = .errorAndRetry($0.descriptionOfType)
                    }
                }).disposed(by: disposeBag)
    }

}

// MARK: - TableViewDataSource

extension UnitListViewController {

    private func setupDataSource() -> RxTableViewSectionedReloadDataSource<UnitListSectionDomainModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<UnitListSectionDomainModel>(configureCell: { (_, tableView, indexPath, item) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.unitListCell.identifier, for: indexPath) as?
                    UnitListCell else {
                log.error("Can't cast R.reuseIdentifier.unitListCell to UnitLIstCell")
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
