//
//  SettingsSubView.swift
//  DrPillman
//
//  Created by Анастасия Ищенко on 10.03.2023.
//

import Foundation
import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var selectedLanguage: Language = .selectedLanguage
    @State var selectedStyle: Theme = .current
    @State private var scrollViewContentOffset: CGFloat = 0

    private enum Constants {
        static let padding: CGFloat = 16
        static let cellHeight: CGFloat = 48
        static let helpCellHeight: CGFloat = 52
        static let cornerRadius: CGFloat = 13
    }

    private var textColor: Color {
        Color(Asset.Colors.Text.mainTextColor.color)
    }

    private var backgroundColor: Color {
        Color(Asset.Colors.Background.dimColor.color)
    }

    private var cellBackgroundColor: Color {
        Color(Asset.Colors.Background.brightColor.color)
    }

    private func getCornersForLanguage(lang: Language) -> UIRectCorner {
        switch lang {
        case .english: return [.topLeft, .topRight]
        case .russian: return [.bottomRight, .bottomLeft]
        }
    }

    private func getCornersForStyle(style: Theme) -> UIRectCorner {
        switch style {
        case .system:
            return [.topLeft, .topRight]
        case .light:
            return []
        case .dark:
            return [.bottomLeft, .bottomRight]
        }
    }

    @ViewBuilder
    var body: some View {
        if viewModel.viewType == .help {
            TrackableScrollView(.vertical,
                                showIndicators: false,
                                contentOffset: $scrollViewContentOffset) {
                Spacer()
                    .frame(height: 16)
                LazyVStack(spacing: Constants.padding) {
                    helpView.padding(.horizontal, Constants.padding)
                    Spacer()
                        .frame(height: 16)
                }
            }
            .background(backgroundColor, ignoresSafeAreaEdges: .all)

        } else {
            List {
                mainView
                    .frame(height: Constants.cellHeight)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparatorTint(backgroundColor, edges: .top)
            }
            .padding(Constants.padding)
            .listStyle(.plain)
            .background(backgroundColor, ignoresSafeAreaEdges: .all)
            .onChange(of: selectedStyle) { style in
                viewModel.styleDidChange(style)
            }
            .onChange(of: selectedLanguage) { language in
                viewModel.languageDidChange(language)
            }
        }
    }

    @ViewBuilder
    private var mainView: some View {
        switch viewModel.viewType {
        case .style:
            styleView

        case .language:
            languageView

        case .help:
            helpView

        case .rate:
            styleView

        case .info:
            styleView
        }
    }

    @ViewBuilder
    private var styleView: some View {
        ForEach(viewModel.styles) { style in
            Button(action: {
                selectedStyle = style
            }, label: {
                HStack {
                    Text(style.localized)
                        .tint(textColor)
                        .offset(x: Constants.padding)
                    if style == selectedStyle {
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                            .padding([.trailing], Constants.padding)
                    }
                }
            })
            .listRowBackground(
                RoundedCornersShape(corners: getCornersForStyle(style: style),
                                    radius: Constants.cornerRadius)
                    .fill(cellBackgroundColor)
            )
        }
    }

    @ViewBuilder
    private var languageView: some View {
        ForEach(viewModel.languageTypes) { language in
            Button(action: {
                selectedLanguage = language
            }, label: {
                HStack {
                    Text(language.rawValue)
                        .tint(textColor)
                        .offset(x: Constants.padding)
                    if selectedLanguage == language {
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                            .padding([.trailing], Constants.padding)
                    }
                }
            }).listRowBackground(
                RoundedCornersShape(corners: getCornersForLanguage(lang: language),
                                    radius: Constants.cornerRadius)
                    .fill(cellBackgroundColor)
            )
        }
    }

    @ViewBuilder
    private var helpView: some View {
        ForEach(viewModel.helps) { help in
            Button(action: {
                viewModel.helpButtonDidTap(help)
            }, label: {
                HStack {
                    Text(help.localized)
                        .tint(textColor)
                        .offset(x: Constants.padding)
                        .frame(alignment: .center)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(textColor)
                        .padding([.trailing], Constants.padding)
                }.frame(height: Constants.helpCellHeight)
            })
            .background(cellBackgroundColor
                .cornerRadius(Constants.cornerRadius))
        }
    }
}
