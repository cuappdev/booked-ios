//
//  SearchView.swift
//  Booked
//
//  Created by Alyssa Wang on 11/11/26.
//


import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    @FocusState private var isFocused: Bool

    init(
        initialQuery: String = "",
        libraries: [Library] = Library.sampleData,
        onSearch: @escaping (String) -> Void = { _ in },
        onClose: @escaping () -> Void = {}
    ) {
        _viewModel = State(
            initialValue: SearchViewModel(
                initialQuery: initialQuery,
                libraries: libraries,
                onSearch: onSearch,
                onClose: onClose
            )
        )
    }

    // MARK: Body

    var body: some View {
        ZStack(alignment: .top) {
            Constants.Colors.creamBg.ignoresSafeArea()

            VStack(spacing: 0) {
                searchField

                ScrollView {
                    content
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .task {
            // Give the cover a moment to finish presenting, or the keyboard won't come up.
            try? await Task.sleep(for: .milliseconds(150))
            isFocused = true
        }
    }

    // MARK: Search field

    private var searchField: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18))
                    .foregroundStyle(Constants.Colors.secondaryText)

                TextField("Where to book?", text: $viewModel.query)
                    .font(.system(size: 18))
                    .foregroundStyle(Constants.Colors.primaryText)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit(viewModel.submit)

                if !viewModel.query.isEmpty {
                    Button(action: viewModel.clearQuery) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(Constants.Colors.tertiaryText)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(Constants.Colors.creamBg, in: Capsule())
            .overlay(Capsule().stroke(Constants.Colors.cardBorder, lineWidth: 1.5))

            Button("Close", action: viewModel.close)
                .font(.system(size: 16))
                .foregroundStyle(Constants.Colors.secondaryText)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isSearching {
            suggestionsList
        } else if !viewModel.recentSearches.isEmpty {
            recentSearchesList
        }
    }

    private var recentSearchesList: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: "clock.arrow.circlepath")
                Text("Recent Searches")
            }
            .font(.system(size: 13))
            .foregroundStyle(Constants.Colors.tertiaryText)
            .padding(.bottom, 8)

            ForEach(viewModel.recentSearches, id: \.self) { term in
                HStack(spacing: 8) {
                    Button { viewModel.select(term) } label: {
                        Text(term)
                            .font(.system(size: 17))
                            .foregroundStyle(Constants.Colors.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    Button { viewModel.removeRecent(term) } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16))
                            .foregroundStyle(Constants.Colors.secondaryText)
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Remove \(term) from recent searches")
                }
                .padding(.leading, 24)
                .frame(minHeight: 52)

                divider
                    .padding(.leading, 24)
            }
        }
    }

    @ViewBuilder
    private var suggestionsList: some View {
        let suggestions = viewModel.suggestions

        if suggestions.isEmpty {
            Text("No rooms match “\(viewModel.trimmedQuery)”")
                .font(.subheadline)
                .foregroundStyle(Constants.Colors.secondaryText)
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
        } else {
            VStack(spacing: 0) {
                ForEach(suggestions, id: \.self) { title in
                    Button { viewModel.select(title) } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18))
                                .foregroundStyle(Constants.Colors.secondaryText)

                            Text(viewModel.highlighted(title))
                                .font(.system(size: 17))
                                .lineLimit(1)

                            Spacer(minLength: 0)
                        }
                        .frame(minHeight: 56)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if title != suggestions.last {
                        divider
                    }
                }
            }
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Constants.Colors.cardBorder)
            .frame(height: 1)
    }
}

#Preview {
    SearchView(initialQuery: "Group Study")
}
