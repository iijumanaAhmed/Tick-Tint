//
//  CategoryView.swift
//  Tick&Tint
//
//  Created by RAZAN  on 17/05/1448 AH.
//

import SwiftUI

struct PaintingCategory: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}
// last update 
struct CategoryView: View {
    let totalRounds: Int
    let workDurationMinutes: Int
    
    // Shared navigation path
    @Binding var navigationPath: [AppRoute]
    
    let categories: [PaintingCategory] = [
        PaintingCategory(title: "Words", imageName: "12-dream"),
        PaintingCategory(title: "Animals", imageName: "cat"),
        PaintingCategory(title: "Nature", imageName: "02-owl"),
        PaintingCategory(title: "Doodles", imageName: "06-doodles")
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: AppSpacing.medium),
        GridItem(.flexible(), spacing: AppSpacing.medium)
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    // Page heading
                    VStack(spacing: AppSpacing.small) {
                        Text("Painting Categories")
                            .font(.system(size: AppFonts.title2, weight: .bold))
                            .foregroundStyle(Color.primaryText)
                        
                        Text("Your Painting Will Start After Your Focus Session.\nChoose The Category You Like")
                            .font(.system(size: AppFonts.caption))
                            .foregroundStyle(Color.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, AppSpacing.small)
                    
                    // Category cards
                    LazyVGrid(columns: columns, spacing: AppSpacing.medium) {
                        ForEach(categories) { category in
                            Button {
                                navigationPath.append(
                                    .timer(
                                        totalRounds: totalRounds,
                                        workDurationMinutes: workDurationMinutes
                                    )
                                )
                            } label: {
                                CategoryCard(category: category)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.screenPadding)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CategoryCard: View {
    let category: PaintingCategory
    
    var body: some View {
        VStack(spacing: 6) {
            Text(category.title)
                .font(.system(size: AppFonts.headline, weight: .medium))
                .foregroundStyle(Color.primaryText)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                Image(category.imageName)
                    .resizable()
                    .scaledToFill()
            }
            .aspectRatio(1.3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.secondaryBrand, lineWidth: 1.5)
            )
        }
    }
}

#Preview {
    NavigationStack {
        CategoryView(
            totalRounds: 3,
            workDurationMinutes: 25,
            navigationPath: .constant([])
        )
    }
}
