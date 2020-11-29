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
class UnitListViewController: UIViewController, UIScrollViewDelegate {

    private lazy var viewModel: UnitListViewModel = UnitListViewModel()

    private lazy var dataSource: RxTableViewSectionedReloadDataSource<UnitListSectionDomainModel> = setupDataSource()

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    private var disposeBag = DisposeBag()

    private lazy var emptyView: EmptyView = {
        let v = R.nib.emptyView.firstView(owner: nil)!
        v.backgroundColor = .white
        v.retryAction = { [weak self] in
            self?.fetch(authToken: ApplicationConfigData.authToken)
        }
        v.status = .none
        view.addSubview(v)
        //view.all
        return v
    }()

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)

        // ユーザ未作成の場合はユーザ作成画面に遷移
        if ApplicationConfigData.authToken == "" {
            let vc = CreateUserViewController.makeInstance()
            present(vc, animated: false)
        }

        subscribe()
        fetch(authToken: ApplicationConfigData.authToken)

//        self.tableView.dataSource = nil
//        self.tableView.delegate = nil

    }

}


// MARK: - Functions

extension UnitListViewController {

    private func subscribe() {

        // loading
        viewModel.loadingDriver
            .map { [weak self] isLoading in
//                guard let _self = self else {
//                    return .none
//                }
                if isLoading {
                    return .loading
                } else if !isLoading {
                    return .showPage
                }
                return .none
            }
            .drive(onNext: {[weak self] in
                self?.emptyView.status = $0
            }).disposed(by: disposeBag)

        // データソースと紐付ける
        viewModel.unitsObservable
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }


    private func fetch(authToken: String) {
        viewModel.fetch(authToken: authToken)
            .subscribe(
                onNext: { domain in
                    HUD.flash(.label("登録しました！"), delay: 1.0) { [weak self] _ in
                        self?.dismiss(animated: true)
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

//// MARK: - TableViewDataSource
//
//extension UnitListViewController: UITableViewDataSource, UITableViewDelegate {
//
//    // TODO: API取得次第変更
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 20
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.unitListCell.identifier, for: indexPath) as? UnitListCell else{
//            return UITableViewCell()
//        }
//
//        cell.cellTappedSubject.subscribe(onNext: { [weak self] in
//            let vc = LearningUnitViewController.makeInstance()
//            self?.present(vc, animated: true)
//        }).disposed(by: cell.disposeBag)
//
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 82
//    }
//
//}

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
