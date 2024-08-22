//
//  RecentSearchView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/22/24.
//

import SwiftUI

/**
 Task 5: Fetching data from CoreData
 */
struct RecentSearchView: View {
    // Accesses the Core Data managed object context from the environment, which is used for interacting with the search CoreData store.
    @Environment(\.managedObjectContext) var objectContext

    // Fetches search results from CoreData, sorted by the 'date' attribute of the 'SearchResult' entity.
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var results: FetchedResults<SearchResult>
    
    var onTapResult: ((String?) -> Void)
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .padding(.bottom, 20)
            
            // if result = Empty
            if results.isEmpty {
                Text("No recent searches.")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .padding(.vertical, 54)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(results, id: \.self) { result in
                            HStack {
                                Button {
                                    onTapResult(result.name)
                                } label: {
                                    Text(result.name ?? "")
                                        .font(.system(size: 14))
                                        .foregroundColor(.uclaBlue)
                                }
                                
                                Spacer()
                                
                                // Delete search history
                                Button {
                                    objectContext.delete(result)
                                    try? objectContext.save()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                }
                            }
                            .accessibilityElement(children: .combine)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 30)
    }
    
    var titleView: some View {
        HStack {
            Text("Recent Searches")
                .font(.system(size: 10, weight: .bold))
            Spacer()
        }
        .accessibilityAddTraits(.isHeader)
    }
}


#Preview {
    RecentSearchView { _ in
        
    }
}
