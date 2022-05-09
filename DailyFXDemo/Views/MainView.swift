//
//  MainView.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 06/05/2022.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("News Feed", systemImage: "list.dash")
                }
            
            MarketsView()
                .tabItem {
                    Label("Markets", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
