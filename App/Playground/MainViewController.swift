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
	final class MainItemView: ConcreteGridItemView {
		override func setup() {
			super.setup()
			bgColor = .gray
		}
	}

	struct ViewModel {
		let color: ViewColor
		let text: String
	}

	let viewModels: ObservableGrid<ViewModel> = .init(10, 7)

	private(set) lazy var gridView: GridView = {
		.instance(.vertical)
	}()

	private(set) lazy var binder = {
		GridViewBinder<
			ViewModel,
			ObservableGrid<ViewModel>,
			GridView,
			MainItemView
		>(
			grid: viewModels,
			gridView: gridView
		) { gridIndex, viewModel, itemView in
			itemView.bgColor = viewModel?.color
		}
	}()

	func updateRandomElement() {
		let randomRow = Int.random(in: 0..<viewModels.dimensions[0])
		let randomColumn = Int.random(in: 0..<viewModels.dimensions[1])
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

		embed(gridView)

		binder.onSelect { gridIndex, value, itemView in
			print(gridIndex, value?.text as Any)
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
