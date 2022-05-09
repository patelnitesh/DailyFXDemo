//
//  MarketsView.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 07/05/2022.
//

import SwiftUI

struct MarketsView: View {
    @Environment(\.openURL) var openURL
    
    @StateObject var viewModel = MarketsViewModel(service: DailyFxServiceImpl())
    @State private var marketType: MarketType = .Commodities
    
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .failed(let error):
            ErrorView(error: error) {
                self.viewModel.getMarkets()
            }
        case .success:
            NavigationView {
                VStack{
                    HStack{
                    Spacer(minLength: 10)
                    Picker("", selection: $marketType) {
                        ForEach(MarketType.allCases, id: \.self) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    Spacer(minLength: 10)
                    }
                    List {
                        ForEach(viewModel.sectionItems(marketType: marketType), id: \.id) { section in
                            Section(header: Text(section.header)) {
                                ForEach(section.rows, id: \.id) { market in
                                    HStack(alignment: .center, spacing: 5) {
                                        Text(market.displayName ?? "Market not available")
                                        Spacer()
                                        if market.topMarket == true {
                                            Image(systemName:"star")
                                        }
                                    }
                                    .onTapGesture {
                                        load(url: market.rateDetailURL)
                                    }
                                } // foreach
                            } // section
                        } // foreach
                    } // List end
                } // V stack
                .navigationTitle("Markets")
                .refreshable {
                    viewModel.getMarkets()
                }
            } // Nav end
        }
    }
    
    func load(url: String?) {
        guard let url = url,
              let linkUrl = URL(string: url) else {
            return
        }
        openURL(linkUrl)
    }
}

struct MarketsView_Previews: PreviewProvider {
    static var previews: some View {
        MarketsView()
    }
}
