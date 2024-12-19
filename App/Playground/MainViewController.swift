//
//  MainViewController.swift
//  DemoApp
//
//  Created by Piyush Banerjee on 06-Mar-2022.
//  Copyright © 2022 Piyush Banerjee. All rights reserved.
//

import Collections
import Foundation
import Observe
import UISwift

class MainViewController: ViewController {
	final class MainItemView: ConcreteListItemView {
		override func setup() {
			super.setup()
			bgColor = .gray
		}
	}

	struct ViewModel {
		let color: ViewColor
		let text: String
	}

	let viewModels: ObservableList<ViewModel> = .init(
		rows: 10,
		columns: 7
	)

	private(set) lazy var listView: ListView = {
		.instance(.vertical)
	}()

	private(set) lazy var binder = {
		ListViewBinder<
			ViewModel,
			ObservableList<ViewModel>,
			ListView,
			MainItemView
		>(
			list: viewModels,
			listView: listView
		) { listIndex, viewModel, itemView in
			itemView.bgColor = viewModel?.color
		}
	}()

	func updateRandomElement() {
		let randomRow = Int.random(in: 0..<viewModels.rows)
		let randomColumn = Int.random(in: 0..<viewModels.columns)
		let viewModel = ViewModel(
			color: .random(),
			text: "[\(randomRow), \(randomColumn)]"
		)

		viewModels[randomRow, randomColumn] = viewModel
	}

	func clearTimers() {
		viewModels.removeAllObservers()
		timer.invalidate()
		timer2.invalidate()
	}

	private(set) lazy var timer = {
		Timer.scheduledTimer(
			withTimeInterval: 0.000005, // 5 nanoseconds
			repeats: true
		) { [weak self] _ in
			self?.updateRandomElement()
		}
	}()

	private(set) lazy var timer2 = {
		Timer.scheduledTimer(
			withTimeInterval: 60 * 1, // 1 minute
			repeats: false
		) { [weak self] _ in
			self?.clearTimers()
		}
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		bgColor = .white

		embed(listView)

		binder.onSelect { listIndex, value, itemView in
			print(listIndex, value?.text as Any)
		}
    }

#if canImport(UIKit)
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let _ = timer
		let _ = timer2
	}
#endif
}
