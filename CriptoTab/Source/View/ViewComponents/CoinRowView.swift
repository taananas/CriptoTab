//
//  CoinRowView.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 13.03.2023.
//

import SwiftUI

struct CoinRowView: View {
    @State private var onHover: Bool = false
    let isSelected: Bool
    let coin: CoinModel
    let onTap: (CoinModel) -> Void
    var body: some View {
        HStack(spacing: 0){
            letfColum
            Spacer()
            rightColum
        }
        .font(.subheadline)
        .padding(6)
        .background(onHover ? Color.secondary.opacity(0.15) : .clear, in: RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
        .onHover { isHover in
            withAnimation {
                onHover = isHover
            }
        }
        .onTapGesture {
            withAnimation {
                onTap(coin)
            }
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CoinRowView(isSelected: false, coin: dev.coin, onTap: {_ in})
            CoinRowView(isSelected: false, coin: dev.coin, onTap: {_ in})
        }
    }
}


extension CoinRowView{
    private var letfColum: some View{
        HStack(spacing: 6){
            NukeLazyImage(strUrl: coin.image)
                .frame(width: 25, height: 25)
            VStack(alignment: .leading) {
                Text(coin.name.capitalized)
                    .font(.headline)
                Text(coin.symbol.uppercased())
                    .font(.subheadline)
            }
        }
    }

    private var rightColum: some View{
        VStack(alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(coin.isIncreasedPrice ? .green : .red)
        }
    }
}
