//
//  PersonalInformationView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.04.2025.
//

import SwiftUI

struct PersonalInformationView: View {
    @ObservedObject var vm: PersonalInformationViewModel

    @State private var showDatePicker = false
    @State private var showSaveAlert = false
    
    private var sixYearsAgo: Date {
        Calendar.current.date(byAdding: .year, value: -6, to: Date()) ?? Date()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                // Emoji Avatar
                emojiAvatarSection
                
                // Personal Info Section
                personalInfoSection
                
                // Birth Date Section
                birthDateSection
                
                // Save Button
                saveButton
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showDatePicker) {
            datePickerSheet
        }
        .alert("Saved", isPresented: $showSaveAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your information has been saved successfully")
        }
    }
    
    // MARK: - Components
    private var emojiAvatarSection: some View {
        VStack() {
            Text(vm.selectedEmoji)
                .font(.system(size: 80))
                .padding()
                .background(
                    Circle()
                        .fill(.gray.opacity(0.1))
                        .frame(width: 120, height: 120)
                )
        }
    }
    
    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Personal Information")
                        .font(.system(size: 23, weight: .semibold))
                Text("Do not forget to save data")
                    .font(customFont: .MarcellusRegular, size: 15)
            }
            
            CustomFieldView(name: $vm.name, placeholderName: "Name")
            CustomFieldView(name: $vm.surname, placeholderName: "Surname")
        }
    }
    
    private var birthDateSection: some View {
        Button(action: {
            showDatePicker = true
        }) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(vm.birthDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.custom(CustomFonts.MarcellusRegular.rawValue, size: 18))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }
                .frame(height: 35)
                .overlay(
                    Rectangle()
                        .frame(height: 1),
                    alignment: .bottomLeading
                )
                .foregroundColor(.black)
            }
        }
        .frame(width: 320)
        .padding()
    }
    
    private var saveButton: some View {
        Button {
            showSaveAlert = true
            Task {
                await vm.saveUserData()
            }
        } label: {
            Text("Save Changes")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.black)
                .cornerRadius(12)
                .padding(.vertical, 20)
                .opacity(!vm.isFormValid ? 0.6 : 1)
        }
        .disabled(!vm.isFormValid)
    }
    
    private var datePickerSheet: some View {
        VStack {
            DatePicker(
                "Select Birth Date",
                selection: $vm.birthDate,
                in: ...sixYearsAgo,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
            
            Button("Done") {
                showDatePicker = false
            }
            .padding()
        }
        .presentationDetents([.medium])
    }
}
#Preview {
    PersonalInformationView(vm: PersonalInformationViewModel())
}

private struct CustomFieldView: View {
    @Binding var name: String
    var placeholderName: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("")
                .font(customFont: .MarcellusRegular, size: 15)
            
            ZStack(alignment: .leading) {
                // Плейсхолдер, который виден только когда поле пустое
                if name.isEmpty {
                    Text(placeholderName)
                        .font(.custom(CustomFonts.MarcellusRegular.rawValue, size: 18))
                        .foregroundColor(.gray)
                        .frame(height: 35)
                }
                
                TextField("", text: $name)
                    .font(.custom(CustomFonts.MarcellusRegular.rawValue, size: 18))
                    .frame(height: 35)
                    .foregroundColor(.black)
                    .background(Color.clear) // Прозрачный фон для видимости плейсхолдера
                    .overlay(
                        Rectangle().frame(height: 1),
                        alignment: .bottomLeading
                    )
            }
        }
        .frame(width: 320)
        .padding()
    }
}
