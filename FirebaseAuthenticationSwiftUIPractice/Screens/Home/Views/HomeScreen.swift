//
//  HomeScreen.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 17/01/2025.
//

import SwiftUI

struct HomeScreen: View {
    
    let workouts = [
        WorkoutList(thumbnail: "workoutThumbnail0", duration: "25 min", calories: "412kCal", type: "Cardio", description: "Fun workout"),
        WorkoutList(thumbnail: "workoutThumbnail1", duration: "30 min", calories: "350kCal", type: "Strength", description: "Strength training"),
        WorkoutList(thumbnail: "workoutThumbnail2", duration: "40 min", calories: "500kCal", type: "Yoga", description: "Relaxing yoga"),
        WorkoutList(thumbnail: "workoutThumbnail3", duration: "45 min", calories: "600kCal", type: "HIIT", description: "Intense HIIT workout"),
        WorkoutList(thumbnail: "workoutThumbnail4", duration: "20 min", calories: "300kCal", type: "Pilates", description: "Pilates for flexibility")
    ]

    let dietItems = [
        DietList(image: "diet0", proteinAmount: "25g", name: "Fruits & Veggies", calories: "412kCal"),
        DietList(image: "diet1", proteinAmount: "30g", name: "Chicken Breast", calories: "450kCal"),
        DietList(image: "diet2", proteinAmount: "20g", name: "Rice & Broccoli", calories: "350kCal"),
        DietList(image: "diet3", proteinAmount: "15g", name: "Cooked Meat", calories: "250kCal"),
        DietList(image: "diet4", proteinAmount: "25g", name: "Berries & Fruits", calories: "400kCal")
    ]
    
    var body: some View {
        ScrollView {
                    VStack {
                        headerSection
                        
                        Divider()
                            .frame(height: 3)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "393C43").opacity(0.8))
                            .padding(.top, 12)
                        
                        sectionHeader(title: "Workouts", count: 25)
                        workoutsScrollView
                        
                        sectionHeader(title: "Diet & Nutrition", count: 5)
                        dietScrollView
                    }
                }
                .background(.black)
            }
            
            // Header Section
            private var headerSection: some View {
                VStack(alignment: .leading) {
                    HStack {
                        Image("calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Text("July 16, 1996")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.leading, 8)
                        
                        Spacer()
                        
                        Button {
                            // Notification action
                        } label: {
                            Image("notificationBell")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding()
                        }
                        .frame(width: 70, height: 60, alignment: .center)
                        .background(Capsule().fill(Color(hex: "393C43").opacity(0.6)))
                    }
                    .padding(.bottom, 12)
                    
                    HStack {
                        Image("cr7")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(.rect(cornerRadius: 30))
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hello, Cristiano!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            HStack {
                                Image("health")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                Text("88% Healthy")
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                                    .padding(.trailing, 10)
                                
                                Image("star")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                Text("Pro")
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        Spacer()
                        
                        Image("frontArrow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Generic Section Header
            private func sectionHeader(title: String, count: Int) -> some View {
                HStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Text("(\(count))")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Spacer()
                }
                .padding()
            }
            
            // Workouts ScrollView
            private var workoutsScrollView: some View {
                ScrollView(.horizontal) {
                    HStack(spacing: 24) {
                        ForEach(workouts) { workout in
                            workoutCard(workout: workout)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            
            // Diet ScrollView
            private var dietScrollView: some View {
                ScrollView(.horizontal) {
                    HStack(spacing: 24) {
                        ForEach(dietItems) { item in
                            dietCard(dietItem: item)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            
            // Workout Card
            private func workoutCard(workout: WorkoutList) -> some View {
                ZStack {
                    Image(workout.thumbnail)
                        .resizable()
                        .scaledToFit()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image("clock")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(workout.duration)
                                .font(.callout)
                                .foregroundStyle(Color.white.opacity(0.7))
                                .padding(.trailing, 6)
                            
                            Image("fire")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(workout.calories)
                                .font(.callout)
                                .foregroundStyle(Color.white.opacity(0.7))
                                .padding(.leading, -4)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.6))
                        
                        Spacer()
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(workout.type)
                                    .font(.title)
                                    .foregroundStyle(.white)
                                Text(workout.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            .padding(.leading, 8)
                            
                            Spacer()
                            
                            Button {
                                // Play workout action
                            } label: {
                                Image("play")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            .padding(.trailing, 16)
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        .padding(.bottom, 18)
                        .background(Color.black.opacity(0.5))
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 48)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .overlay(
                    RoundedRectangle(cornerRadius: 38)
                        .stroke(Color(hex: "393C43"), lineWidth: 2.7)
                )
            }
            
            // Diet Card
            private func dietCard(dietItem: DietList) -> some View {
                ZStack {
                    Image(dietItem.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.6)
                    
                    VStack(alignment: .leading) {
                        VStack {
                            Text(dietItem.proteinAmount)
                                .font(.title3)
                                .foregroundStyle(.white)
                            Text("Protein")
                                .font(.callout)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(.all, 8)
                        .background(Color(hex: "393C43").opacity(0.75))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding()
                        
                        Spacer()
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(dietItem.name)
                                    .font(.title)
                                    .foregroundStyle(.white)
                                HStack {
                                    Image("fire")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text(dietItem.calories)
                                        .font(.callout)
                                        .foregroundStyle(Color.white.opacity(0.7))
                                }
                                .padding(-12)
                                .padding(.leading, 16)
                            }
                            .padding(.leading, 8)
                            
                            Spacer()
                            
                            ActionButton(label: "", icon: "arrowRight", action: {
                                // Diet item action
                            })
                            .frame(width: 45)
                            .padding(.trailing, 16)
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        .padding(.bottom, 18)
                        .background(Color.black.opacity(0.5))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 45))
                .overlay(
                    RoundedRectangle(cornerRadius: 45)
                        .stroke(Color(hex: "393C43"), lineWidth: 2.7)
                )
            }
}

#Preview {
    HomeScreen()
}
