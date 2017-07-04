//
//  PlayerViewController.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 
//

import UIKit
import RxSwift
import RxRealm
import RxCocoa
import RxDataSources

final class PlayerViewController: UIViewController {

    @IBOutlet private weak var setQueueButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var rewindButton: UIButton!
    @IBOutlet private weak var pendingTableView: UITableView!
    @IBOutlet private weak var playerTableView: UITableView!
    @IBOutlet private weak var logsTableView: UITableView!

    @IBOutlet private weak var addTrackAButton: UIButton!
    @IBOutlet private weak var addTrackBButton: UIButton!

    private lazy var viewModel: PlayerViewModel = PlayerViewModel()
    private let disposeBag = DisposeBag()

    typealias PendingSection = SectionModel<String, PendingQueue.Track>
    typealias PlayerSection = SectionModel<String, PlayerViewModel.PlayerQueue.Track>
    typealias LogsSection = SectionModel<String, Log>

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.observe(
            setQueueButtonControl: setQueueButton.rx.tap, 
            playButtonControl: playButton.rx.tap,
            pauseButtonControl: pauseButton.rx.tap,
            skipButtonControl:  skipButton.rx.tap,
            rewindButtonControl:  rewindButton.rx.tap,
            addTrackAButtonControl: addTrackAButton.rx.tap,
            addTrackBButtonControl: addTrackBButton.rx.tap
        )

        configurePendingTableView()
        configurePlayerTableView()
        configureLogsTableView()
    }

    private func configurePendingTableView() {
        let pendingDataSource = RxTableViewSectionedReloadDataSource<PendingSection>()
        pendingDataSource.configureCell = { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item.name
            return cell
        }

        viewModel.pendingQueue.asObservable()
            .map({ [PendingSection(model: "", items: $0.tracks)] })
            .bind(to: pendingTableView.rx.items(dataSource: pendingDataSource))
            .disposed(by: disposeBag)
    }

    private func configurePlayerTableView() {
        let playerDataSource = RxTableViewSectionedReloadDataSource<PlayerSection>()
        playerDataSource.configureCell = { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item.track.name + (item.isPlaying ? "▷" : "")
            cell.textLabel?.textColor = item.shouldFocus ? UIColor.red : UIColor.black
            return cell
        }

        viewModel.playerQueue
            .map({ [PlayerSection(model: "", items: $0.tracks())] })
            .bind(to: playerTableView.rx.items(dataSource: playerDataSource))
            .disposed(by: disposeBag)
    }

    private func configureLogsTableView() {
        logsTableView.estimatedRowHeight = 20

        let logsDataSource = RxTableViewSectionedReloadDataSource<LogsSection>()
        logsDataSource.configureCell = { dataSource, tableView, indexPath, log in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LogLineCell
            cell.label?.text = log.buildText()
            cell.label.textColor = log.level.color
            return cell
        }

        viewModel
            .logs
            .map({ [LogsSection(model: "", items: $0)] })
            .bind(to: logsTableView.rx.items(dataSource: logsDataSource))
            .disposed(by: disposeBag)

        // Tailing
        viewModel
            .logs
            .map({[weak self] _ in self?.logsTableView })
            .filterNil()
            .map({ ($0, $0.numberOfRows(inSection: 0) - 1) })
            .filter({ $0.1 > 0 })
            .subscribe(onNext: { $0.0.scrollToRow(at: IndexPath(row: $0.1, section: 0), at: .bottom, animated: false) })
            .addDisposableTo(disposeBag)
    }
}
