//
//  PopoverView.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 12.03.2023.
//

import SwiftUI

struct PopoverView: View {
    @ObservedObject var viewModel: PopoverViewModel
    var body: some View {
        VStack(spacing: 0){
            popapHeaderSection
            if viewModel.isLoading{
                Spacer()
                ProgressView()
                Spacer()
            }else{
                VStack{
                    coinHeaderSection
                    graphSection
                }
                .padding()
                Divider()
                ScrollView {
                    VStack(spacing: 6){
                        ForEach(viewModel.topCoins.filter({$0.id != viewModel.selectedCoinId})){ coin in
                            CoinRowView(isSelected: false, coin: coin, onTap: viewModel.selectCoin)
                        }
                    }
                    .padding([.horizontal, .top])
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            viewModel.startCoinDataSubscription()
            viewModel.subscribeToWebSocket()
        }
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView(viewModel: PopoverViewModel())
            .frame(width: 380, height: 400)
    }
}


extension PopoverView{
    
    
    private var popapHeaderSection: some View{
        Text("CriptoTab")
            .font(.headline.bold())
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(alignment: .trailing) {
                Button {
                    NSApp.terminate(self)
                } label: {
                    Image(systemName: "power")
                }
                .buttonStyle(.plain)
            }
            .padding(10)
    }
    
    @ViewBuilder
    private var graphSection: some View{
        if let coin = viewModel.selectedCoin, let prices = coin.sparklineIn7D?.price{
            VStack {
                LineGraph(data: prices, profit: coin.isIncreasedPrice)
                    .frame(height: 100)
                HStack{
                    Spacer()
                    Text(Helpers.dayBefore(7).formatted(date: .abbreviated, time: .omitted))
                    Image(systemName: "arrow.right")
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                }
                .font(.system(size: 10, weight: .light))
            }
            
        }
    }
    
    private var coinHeaderSection: some View{
        HStack{
            if let selectedCoin = viewModel.selectedCoin{
                NukeLazyImage(strUrl: selectedCoin.image)
                    .frame(width: 30, height: 30)
                VStack(alignment: .leading) {
                    Text(selectedCoin.name.capitalized)
                        .font(.title2.bold())
                    Text(selectedCoin.symbol.uppercased())
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(selectedCoin.currentPrice.asCurrencyWith6Decimals())
                        .font(.title3.bold())
                    Text(selectedCoin.priceChangePercentage24H?.asPercentString() ?? "NaN")
                        .foregroundColor(selectedCoin.isIncreasedPrice ? .green : .red)
                        .font(.headline)
                }
            }
        }
    }
}


