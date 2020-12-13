//
//  LearningSettingsViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/12/02.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

/**
 * 学習設定VC
 */
class LearningSettingsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var allButton: UIButton!
    @IBOutlet private weak var rememberButton: UIButton!
    @IBOutlet private weak var notRememberButton: UIButton!
    @IBOutlet private weak var defaultButton: UIButton!
    @IBOutlet private weak var randomButton: UIButton!

    @IBOutlet private weak var allCheckImageView: UIImageView!
    @IBOutlet private weak var rememberCheckImageView: UIImageView!
    @IBOutlet private weak var notRememberCheckImageView: UIImageView!
    @IBOutlet private weak var defaultCheckImageView: UIImageView!
    @IBOutlet private weak var randomCheckImageView: UIImageView!

    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var applyButton: UIButton!

    // MARK: - Properties

    // 触感フィードバック
    private let lightFeedBack: UIImpactFeedbackGenerator = {
        let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()

    private let notificationFeedBack: UINotificationFeedbackGenerator = {
        let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
        generator.prepare()
        return generator
    }()

    private var disposeBag = DisposeBag()

    typealias displayCardType = DisplayCardType

    enum DisplayCardType: Int {
        case all
        case remember
        case notRemember
    }

    typealias sortOrderType = SortOrderType

    enum SortOrderType: Int {
        case defaultOrder
        case random
    }

    private var selectedDisplayCardType: DisplayCardType = DisplayCardType(rawValue: ApplicationConfigData.displayCardSetting)!
    private var selectedSortOrderType: SortOrderType = SortOrderType(rawValue: ApplicationConfigData.cardSortOrderType)!

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
        updateDisplayCardSetting()
        updateSortOrderSetting()
    }

    // MARK: - Functions

    private func subscribe() {
        allButton.rx.tap.subscribe(onNext: { [unowned self] in
            lightFeedBack.impactOccurred()
            selectedDisplayCardType = .all
            updateDisplayCardSetting()
        }).disposed(by: disposeBag)

        rememberButton.rx.tap.subscribe(onNext: { [unowned self] in
            lightFeedBack.impactOccurred()
            selectedDisplayCardType = .remember
            updateDisplayCardSetting()
        }).disposed(by: disposeBag)

        notRememberButton.rx.tap.subscribe(onNext: { [unowned self] in
            lightFeedBack.impactOccurred()
            selectedDisplayCardType = .notRemember
            updateDisplayCardSetting()
        }).disposed(by: disposeBag)

        defaultButton.rx.tap.subscribe(onNext: { [unowned self] in
            lightFeedBack.impactOccurred()
            selectedSortOrderType = .defaultOrder
            updateSortOrderSetting()
        }).disposed(by: disposeBag)

        randomButton.rx.tap.subscribe(onNext: { [unowned self] in
            lightFeedBack.impactOccurred()
            selectedSortOrderType = .random
            updateSortOrderSetting()
        }).disposed(by: disposeBag)

        cancelButton.rx.tap.subscribe(onNext: { [unowned self] in
            dismiss(animated: true)
        }).disposed(by: disposeBag)

        applyButton.rx.tap.subscribe(onNext: { [unowned self] in
            notificationFeedBack.notificationOccurred(.success)
            ApplicationConfigData.displayCardSetting = selectedDisplayCardType.rawValue
            ApplicationConfigData.cardSortOrderType = selectedSortOrderType.rawValue
            ApplicationConfigData.shouldUpdateCards = true
            HUD.flash(.label("適用しました！"), delay: 0.5) { [unowned self] _ in
                self.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)

    }

    private func updateDisplayCardSetting() {
        allCheckImageView.isHidden = true
        rememberCheckImageView.isHidden = true
        notRememberCheckImageView.isHidden = true

        switch selectedDisplayCardType {
        case .all:
            allCheckImageView.isHidden = false
        case .remember:
            rememberCheckImageView.isHidden = false
        case .notRemember:
            notRememberCheckImageView.isHidden = false
        }
    }

    private func updateSortOrderSetting() {
        defaultCheckImageView.isHidden = true
        randomCheckImageView.isHidden = true

        switch selectedSortOrderType {
        case .defaultOrder:
            defaultCheckImageView.isHidden = false
        case .random:
            randomCheckImageView.isHidden = false
        }
    }

}

extension LearningSettingsViewController {

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }

}

// MARK: - MakeInstance

extension LearningSettingsViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.learningSettingsViewController.learningSettingsViewController() else {
            assertionFailure("Can't make instance 'LearningSettingsViewController'.")
            return UIViewController()
        }
        return vc
    }

}
