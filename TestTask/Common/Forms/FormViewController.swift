//
//  FormViewController.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

class FormViewController: TableBackedViewController {

    var closeAction: (() -> Void) = { print("closeAction not overridden") }
    var selectItem: (Int, String?, @escaping (String?) -> Void) -> Void = { _, _, _ in print("selectItem not overridden") }
    var selectedInternalURL: (URL) -> Void = { _ in print("selectedInternalURL not overridden") }
    var onRowSelected: (IndexPath) -> Void = { _ in print("onRowSelected is not overridden") }

    var viewModel: FormViewModel! {
        didSet {
            viewModel.redrawRow = { [weak self] in self?.redrawRow(indexPath: $0) }
            viewModel.redrawSection = { [weak self] in self?.redrawSection(section: $0) }
            viewModel.notifySectionAdded = { [weak self] in self?.tableView.insertSections(IndexSet([$0]), with: .fade)}
            viewModel.hideLoadingView = { [weak self] in self?.hideLoadingView() }
            viewModel.displayLoadingView = { [weak self] in
                self?.endEditing() // all the time we show the loading view it means that editing ended. !!should fix all the "keyboard cases"!!
                self?.displayLoadingView()
            }
            viewModel.modelDidUpdate = { [weak self] in self?.updateUI() }
            viewModel.actionButtonAccessibility = { [weak self] in self?.actionButtonAccessibility(isEnabled: $0) }
        }
    }

    public var height: CGFloat = 0.0

    private(set) var hasActionButton: Bool = false

    private var knownIdentifiers: [String] = []
    private var actionToolbarBottomConstraint: NSLayoutConstraint!

    lazy var actionToolbar = ActionToolbarView()

    public lazy var headerView: HeaderView = {
        let headerView: HeaderView = .fromNib()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = nil
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(true, animated: false)

        configureCells()
        actionToolbar.actionButton.setTitle("submit".localized, for: .normal)
        actionToolbar.actionButtonTapped = viewModel.submit
        configureActionToolbar()
        configureTableViewContentInsets()

        viewModel.subscribe { [weak self] err in
            MainThread.run { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.hideLoadingView()
                if let error = err {
                    strongSelf.handle(error)
                    return
                }
                strongSelf.updateUI()
            }
        }
    }

    internal func updateUI() {
        registerCellNIBs()
        tableView.reloadData()
    }

    internal func handle(_ message: String) {
        AppMessage.shared.display(message)
    }

    func actionButtonAccessibility(isEnabled: Bool) {
        actionToolbar.actionButton.isEnabled = isEnabled
    }

    private func configureCells() {
        var knownIdentifiers: [String] = []
        for section in viewModel.sections {
            for item in section.cells {
                guard !knownIdentifiers.contains(item.reuseIdentifier) else { continue }
                let nib = UINib(nibName: item.nibName, bundle: .main)
                tableView.register(nib, forCellReuseIdentifier: item.reuseIdentifier)
                knownIdentifiers.append(item.reuseIdentifier)
            }
        }
    }

    private func configureActionToolbar() {
        guard hasActionButton else { return }
        view.addSubview(actionToolbar)
        actionToolbar.translatesAutoresizingMaskIntoConstraints = false
        actionToolbarBottomConstraint = view.bottomAnchor.constraint(equalTo: actionToolbar.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([
            actionToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actionToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actionToolbarBottomConstraint
        ])
    }

    func configureTableViewContentInsets(bottomInset: CGFloat = 0) {
        let isKeyboardVisible = bottomInset != 0
        let bottomSafeAreaInsetAdjustment = isKeyboardVisible ? -view.safeAreaInsets.bottom : 0
        let actionToolbarHeight = actionToolbar.height()
        let contentInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: bottomInset + actionToolbarHeight + bottomSafeAreaInsetAdjustment + 12,
            right: 0
        )

        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        startMonitoringKeyboard()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let headerView = tableView.tableHeaderView as? HeaderView, headerView.isConfigured else { return }
        setupHeaderView(headerView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopMonitoringKeyboard()
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard parent == nil else { return }
        closeAction()
    }

    override func animateKeyboardHeight(to height: CGFloat) {
        let actionToolbarHeight = hasActionButton ? actionToolbar.frame.height : 0
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: height + 20 + actionToolbarHeight, right: 0.0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        if hasActionButton {
            actionToolbarBottomConstraint.constant = height
            view.layoutIfNeeded()
        }
    }

    private func setupHeaderView(_ headerView: UIView) {
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var headerFrame = headerView.frame

        guard height != headerView.frame.size.height else { return }
        headerFrame.size.height = height
        headerView.frame = headerFrame
        tableView.tableHeaderView = headerView
    }

    private func setupTableHeaderView(with title: String) -> UIView {
        let label = UILabel()
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyStyle(.textH1)
        let headerView = UIView()
        headerView.addSubview(label)

        headerView.addConstraints([
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12.0),
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 16.0),
            label.heightAnchor.constraint(equalToConstant: 24.0)
        ])
        return headerView
    }

    func focusOnInput() {
//        inputViews.forEach { $0.focusOnInputField() }
    }

    func unfocusInput() {
//        inputViews.forEach { $0.unfocusInputField() }
    }

    func cleanup() {
        closeAction = { print("closeAction unbound") }
        selectItem = { _, _, _ in print("selectItem unbound") }
        selectedInternalURL = { _ in print("selectedInternalURL unbound") }
        viewModel = nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        registerCellNIBsIfNeeded()
        return viewModel?.sections[section].cells.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = viewModel?.item(at: indexPath) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath)
        return cellType.configure(cell, indexPath: indexPath, sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellType = viewModel?.item(at: indexPath) else {
            return view.bounds.height - headerView.bounds.height
        }
        return cellType.preferredHeight(for: indexPath)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        registerCellNIBsIfNeeded()
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerTitle = viewModel?.sections[section].title else { return nil }
        return setupTableHeaderView(with: headerTitle)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard viewModel?.sections[section].title != nil else { return 0 }
        return 48.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onRowSelected(indexPath)
    }

    func redrawRow(indexPath: IndexPath) {
        registerCellNIBs()

        tableView.reloadRows(at: [indexPath], with: .fade)
    }

    private func registerCellNIBsIfNeeded() {
        if !viewModel.sections.isEmpty, knownIdentifiers.isEmpty {
            registerCellNIBs()
        }
    }

    func redrawSection(section: Int) {
        registerCellNIBs()
        tableView.reloadSections(IndexSet([section]), with: .fade)
    }

    func endEditing() {
        view.endEditing(true)
    }

    func registerCellNIBs() {
        for section in viewModel.sections {
            for item in section.cells {
                guard !knownIdentifiers.contains(item.reuseIdentifier) else { continue }
                let nib = UINib(nibName: item.nibName, bundle: .main)
                tableView.register(nib, forCellReuseIdentifier: item.reuseIdentifier)
                knownIdentifiers.append(item.reuseIdentifier)
            }
        }
    }

    deinit {
        print("---- \(self) deinit")
    }

}
