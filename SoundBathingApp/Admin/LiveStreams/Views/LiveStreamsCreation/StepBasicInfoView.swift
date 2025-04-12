//
//  StepBasicInfoView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import SwiftUI

struct StepBasicInfoView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var youTubeUrl: String
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, description, url
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                /// Заголовок.
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: "text.bubble.fill")
                            .font(.title3)
                            .foregroundColor(.indigo)
                            .symbolEffect(.bounce, value: focusedField == .title)
                        
                        Text("Stream Title")
                            .font(.system(.title2, design: .rounded).bold())
                            .foregroundColor(.primary)
                    }
                    .transition(.opacity)
                    
                    TextField("Enter stream title", text: $title)
                        .focused($focusedField, equals: .title)
                        .font(.system(.body, design: .rounded))
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.tertiarySystemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(focusedField == .title ? Color.indigo.opacity(0.6) : Color.gray.opacity(0.1),
                                       lineWidth: focusedField == .title ? 2 : 1)
                        )
                        .submitLabel(.next)
                }
                
                /// Описание.
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: "text.alignleft")
                            .font(.title3)
                            .foregroundColor(.indigo)
                            .symbolEffect(.bounce, value: focusedField == .description)
                        
                        Text("Description")
                            .font(.system(.title2, design: .rounded).bold())
                            .foregroundColor(.primary)
                    }
                    
                    TextEditor(text: $description)
                        .focused($focusedField, equals: .description)
                        .font(.system(.body, design: .rounded))
                        .frame(minHeight: 100)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.tertiarySystemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(focusedField == .description ? Color.indigo.opacity(0.6) : Color.gray.opacity(0.1),
                                       lineWidth: focusedField == .description ? 2 : 1)
                        )
                        .scrollContentBackground(.hidden)
                        .submitLabel(.next)
                    
                    Text("\(description.count)/500")
                        .font(.caption)
                        .foregroundColor(description.count > 500 ? .red : .secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 8)
                }
                
                /// Url.
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: "link")
                            .font(.title3)
                            .foregroundColor(.indigo)
                            .symbolEffect(.bounce, value: focusedField == .url)
                        
                        Text("YouTube URL")
                            .font(.system(.title2, design: .rounded).bold())
                            .foregroundColor(.primary)
                    }
                    
                    TextField("", text: $youTubeUrl, prompt:
                        Text("Link")
                            .font(.system(.body, design: .rounded)))

                        .focused($focusedField, equals: .url)
                    
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.tertiarySystemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(focusedField == .url ? Color.indigo.opacity(0.6) : Color.gray.opacity(0.1),
                                       lineWidth: focusedField == .url ? 2 : 1)
                        )
                        .submitLabel(.done)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)


                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    StepBasicInfoView(
        title: .constant(""),
        description: .constant(""),
        youTubeUrl: .constant("")
    )
}
