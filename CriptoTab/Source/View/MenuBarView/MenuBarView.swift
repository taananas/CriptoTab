//
//  MenuBarView.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 12.03.2023.
//

import SwiftUI

struct MenuBarView: View {
    @ObservedObject var viewModel: MenuBarCoinViewModel
    var body: some View {
        HStack(spacing: 4){
            Image(systemName: "bitcoinsign.circle.fill")
                .foregroundColor(viewModel.color)
            VStack(alignment: .trailing, spacing: -2){
                Text(viewModel.name)
                Text(viewModel.value)
            }
            .font(.caption)
        }
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView(viewModel: MenuBarCoinViewModel(name: "Bitcoin", value: "20598.13", color: .green))
    }
}
