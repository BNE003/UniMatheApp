import SwiftUI
import Foundation
import UIKit

// MARK: - Shared Minimal Onboarding Page
private struct MinimalOnboardingPage: View {
    @ObservedObject private var settings = SettingsModel.shared

    let titleDE: String
    let titleEN: String
    let subtitleDE: String
    let subtitleEN: String
    let pointsDE: [String]
    let pointsEN: [String]
    let symbolName: String

    private var isGerman: Bool {
        settings.language == .german
    }

    private var titleText: String {
        isGerman ? titleDE : titleEN
    }

    private var subtitleText: String {
        isGerman ? subtitleDE : subtitleEN
    }

    private var points: [String] {
        isGerman ? pointsDE : pointsEN
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedBackground()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(titleText)
                                .font(.system(size: geometry.size.height < 700 ? 32 : 36, weight: .bold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .lineLimit(2)

                            Text(subtitleText)
                                .font(.system(size: geometry.size.height < 700 ? 18 : 20, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)
                                .lineSpacing(2)
                        }

                        VStack(spacing: 12) {
                            ForEach(points, id: \.self) { point in
                                HStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color.onboardingBlue)

                                    Text(point)
                                        .font(.system(size: geometry.size.height < 700 ? 15 : 16, weight: .medium, design: .rounded))
                                        .foregroundColor(Color.onboardingInk)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white.opacity(0.9))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .strokeBorder(Color.onboardingGray.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                        }

                        Spacer(minLength: 8)

                        VStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color.onboardingBlue.opacity(0.12))
                                    .frame(width: min(geometry.size.width * 0.56, 230), height: min(geometry.size.width * 0.56, 230))

                                Image(systemName: symbolName)
                                    .font(.system(size: geometry.size.height < 700 ? 56 : 64, weight: .light))
                                    .foregroundColor(Color.onboardingBlue)
                            }

                            Text(isGerman ? "Schritt für Schritt zum Ziel" : "Step by step to your goal")
                                .font(.system(size: geometry.size.height < 700 ? 13 : 14, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)
                        }
                        .frame(maxWidth: .infinity)

                        Spacer(minLength: geometry.size.height < 700 ? 95 : 125)
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 18 : 24)
                    .padding(.top, geometry.size.height < 700 ? 18 : 24)
                }
            }
        }
    }
}

// MARK: - Screen 2: Problem Activation
struct ProblemActivationOnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @State private var selection: Int = 1
    @State private var lastHapticSelection: Int = 1

    private let germanOptions: [(emoji: String, title: String)] = [
        ("😅", "Komplett lost"),
        ("🤔", "So halb vorbereitet"),
        ("😎", "Ganz entspannt")
    ]

    private let englishOptions: [(emoji: String, title: String)] = [
        ("😅", "Totally lost"),
        ("🤔", "Half prepared"),
        ("😎", "Fully relaxed")
    ]

    private var isGerman: Bool {
        settings.language == .german
    }

    private var options: [(emoji: String, title: String)] {
        isGerman ? germanOptions : englishOptions
    }

    private var questionTitle: String {
        isGerman ? "Mathe-Klausur bald?" : "Math exam soon?"
    }

    private var questionSubtitle: String {
        isGerman ? "Wie fühlst du dich gerade?" : "How are you feeling?"
    }

    private var questionHint: String {
        isGerman ? "Wähle auf dem Slider aus, was gerade am besten passt." : "Use the slider to choose what fits you best right now."
    }

    private var leftSliderLabel: String {
        options.first?.title ?? ""
    }

    private var rightSliderLabel: String {
        options.last?.title ?? ""
    }

    private var stepLabel: String {
        if isGerman {
            return "Schritt \(onboardingManager.currentProgressStep) von \(onboardingManager.progressStepCount)"
        }
        return "Step \(onboardingManager.currentProgressStep) of \(onboardingManager.progressStepCount)"
    }

    private var sliderProgress: CGFloat {
        guard options.count > 1 else { return 0 }
        return CGFloat(selection) / CGFloat(options.count - 1)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedBackground()

                Circle()
                    .fill(Color.onboardingBlue.opacity(0.11))
                    .frame(width: geometry.size.width * 0.76)
                    .offset(x: 0, y: geometry.size.height * 0.22)
                    .blur(radius: 2)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 18) {
                        HStack(spacing: 12) {
                            Text(stepLabel)
                                .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)

                            Spacer()

                            Text("Onboarding")
                                .font(.system(size: geometry.size.height < 700 ? 13 : 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.92))
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(Color.onboardingGray.opacity(0.22), lineWidth: 1)
                                        )
                                )
                        }

                        segmentedProgress(
                            totalSteps: onboardingManager.progressStepCount,
                            currentStep: onboardingManager.currentProgressStep
                        )
                        .padding(.bottom, 14)

                        VStack(spacing: 8) {
                            Text(questionTitle)
                                .font(.system(size: geometry.size.height < 700 ? 32 : 36, weight: .bold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)

                            Text(questionSubtitle)
                                .font(.system(size: geometry.size.height < 700 ? 22 : 24, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .multilineTextAlignment(.center)

                            Text(questionHint)
                                .font(.system(size: geometry.size.height < 700 ? 16 : 18, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)

                        Spacer(minLength: geometry.size.height < 700 ? 8 : 18)

                        VStack(spacing: 18) {
                            Text(options[selection].emoji)
                                .font(.system(size: geometry.size.height < 700 ? 74 : 82))

                            Text(options[selection].title)
                                .font(.system(size: geometry.size.height < 700 ? 22 : 24, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)

                        VStack(spacing: 12) {
                            GeometryReader { sliderGeometry in
                                let sliderWidth = sliderGeometry.size.width
                                let thumbSize: CGFloat = 44
                                let trackHeight: CGFloat = 16
                                let progress = min(max(sliderProgress, 0), 1)
                                let fillWidth = max(thumbSize * 0.5, progress * sliderWidth)
                                let thumbOffset = progress * (sliderWidth - thumbSize)

                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.onboardingInk.opacity(0.14))
                                        .frame(height: trackHeight)

                                    Capsule()
                                        .fill(Color.onboardingBlue)
                                        .frame(width: fillWidth, height: trackHeight)

                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color.white)
                                        .frame(width: thumbSize, height: thumbSize)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                                        )
                                        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                                        .offset(x: thumbOffset)
                                }
                                .frame(height: thumbSize)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            updateSelection(from: value.location.x, sliderWidth: sliderWidth)
                                        }
                                )
                            }
                            .frame(height: 44)

                            HStack {
                                Text(leftSliderLabel)
                                Spacer()
                                Text(rightSliderLabel)
                            }
                            .font(.system(size: geometry.size.height < 700 ? 16 : 18, weight: .medium, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)
                        }
                        .padding(.horizontal, 10)

                        Spacer(minLength: geometry.size.height < 700 ? 130 : 148)
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 18 : 24)
                    .padding(.top, geometry.size.height < 700 ? 20 : 24)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Button(action: {
                        onboardingManager.nextScreen()
                    }) {
                        HStack(spacing: 8) {
                            Text(isGerman ? "Weiter" : "Continue")
                                .font(.system(size: 18, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.88)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color.onboardingBlue.opacity(0.24), radius: 10, x: 0, y: 5)
                        )
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 18 : 24)
                    .padding(.top, 10)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 12))
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color.onboardingCanvas.opacity(0.0),
                            Color.onboardingCanvas.opacity(0.92),
                            Color.onboardingCanvas
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
            .onAppear {
                lastHapticSelection = selection
            }
        }
    }

    private func segmentedProgress(totalSteps: Int, currentStep: Int) -> some View {
        let safeTotalSteps = max(totalSteps, 1)

        return HStack(spacing: 8) {
            ForEach(0..<safeTotalSteps, id: \.self) { index in
                Capsule()
                    .fill(
                        index < currentStep
                        ? Color.onboardingBlue
                        : Color.onboardingGray.opacity(0.25)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 7)
            }
        }
    }

    private func selectIndex(_ index: Int) {
        guard index >= 0 && index < options.count else { return }
        withAnimation(.spring(response: 0.24, dampingFraction: 0.84)) {
            selection = index
        }
        if index != lastHapticSelection {
            triggerSelectionHaptic()
            lastHapticSelection = index
        }
    }

    private func updateSelection(from xPosition: CGFloat, sliderWidth: CGFloat) {
        guard sliderWidth > 0, options.count > 1 else { return }
        let clampedX = min(max(xPosition, 0), sliderWidth)
        let progress = clampedX / sliderWidth
        let rawIndex = Int((progress * CGFloat(options.count - 1)).rounded())
        selectIndex(rawIndex)
    }

    private func triggerSelectionHaptic() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}

private struct OnboardingExamOption: Identifiable, Hashable {
    let key: String
    let title: String

    var id: String { key }
}

struct ExamSelectionOnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared

    @State private var examOptions: [OnboardingExamOption] = []
    @State private var selectedExamKey: String?
    @State private var showExamDatePrompt = false
    @State private var includeExamDate = false
    @State private var examDate = Date()

    private enum StorageKey {
        static let selectedExamKey = "onboardingSelectedExamKey"
        static let hasExamDate = "onboardingHasExamDate"
        static let examDate = "onboardingExamDate"
    }

    private var isGerman: Bool {
        settings.language == .german
    }

    private var stepLabel: String {
        if isGerman {
            return "Schritt \(onboardingManager.currentProgressStep) von \(onboardingManager.progressStepCount)"
        }
        return "Step \(onboardingManager.currentProgressStep) of \(onboardingManager.progressStepCount)"
    }

    private var titleText: String {
        isGerman ? "Welche Prüfung steht an?" : "Which exam is coming up?"
    }

    private var subtitleText: String {
        isGerman ? "Wir passen deinen Lernplan darauf an." : "We'll tailor your learning plan accordingly."
    }

    private var datePromptTitleText: String {
        isGerman ? "Wann hast du die Prüfung?" : "When is your exam?"
    }

    private var datePromptSubtitleText: String {
        isGerman ? "Du kannst das auch überspringen und später festlegen." : "You can skip this for now and set it later."
    }

    private var skipText: String {
        isGerman ? "Überspringen" : "Skip"
    }

    private var saveDateText: String {
        isGerman ? "Datum speichern" : "Save date"
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedBackground()

                Circle()
                    .fill(Color.onboardingBlue.opacity(0.1))
                    .frame(width: geometry.size.width * 0.74)
                    .offset(y: geometry.size.height * 0.25)
                    .blur(radius: 2)

                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Text(stepLabel)
                            .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)

                        Spacer()

                        Text("Onboarding")
                            .font(.system(size: geometry.size.height < 700 ? 13 : 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.onboardingInk)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 9)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.92))
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(Color.onboardingGray.opacity(0.22), lineWidth: 1)
                                    )
                            )
                    }

                    segmentedProgress(
                        totalSteps: onboardingManager.progressStepCount,
                        currentStep: onboardingManager.currentProgressStep
                    )
                    .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(titleText)
                            .font(.system(size: geometry.size.height < 700 ? 30 : 34, weight: .bold, design: .rounded))
                            .foregroundColor(Color.onboardingInk)

                        Text(subtitleText)
                            .font(.system(size: geometry.size.height < 700 ? 17 : 19, weight: .medium, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)
                    }

                    GeometryReader { gridGeometry in
                        let cardSpacing: CGFloat = 12
                        let rowCount = max(1, examOptions.count)
                        let totalSpacing = CGFloat(max(0, rowCount - 1)) * cardSpacing
                        let availableHeight = max(0, gridGeometry.size.height - totalSpacing)
                        let cardHeight = max(86, availableHeight / CGFloat(rowCount))

                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(spacing: cardSpacing) {
                                ForEach(examOptions) { option in
                                    Button(action: {
                                        selectedExamKey = option.key
                                        UserDefaults.standard.set(option.key, forKey: StorageKey.selectedExamKey)
                                        examDate = Date()
                                        let generator = UISelectionFeedbackGenerator()
                                        generator.prepare()
                                        generator.selectionChanged()
                                        showExamDatePrompt = true
                                    }) {
                                        HStack(spacing: 14) {
                                            ZStack {
                                                Circle()
                                                    .fill(selectedExamKey == option.key ? Color.onboardingBlue.opacity(0.14) : Color.onboardingGray.opacity(0.12))
                                                    .frame(width: 38, height: 38)

                                                Image(systemName: iconName(for: option.key))
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(selectedExamKey == option.key ? Color.onboardingBlue : Color.onboardingGrayStrong)
                                            }

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(option.title)
                                                    .font(.system(size: geometry.size.height < 700 ? 17 : 18, weight: .semibold, design: .rounded))
                                                    .foregroundColor(Color.onboardingInk)
                                                    .lineLimit(1)

                                                Text(subtitleForExamKey(option.key))
                                                    .font(.system(size: geometry.size.height < 700 ? 13 : 14, weight: .medium, design: .rounded))
                                                    .foregroundColor(Color.onboardingGrayStrong)
                                                    .lineLimit(2)
                                            }

                                            Spacer(minLength: 8)

                                            Image(systemName: selectedExamKey == option.key ? "checkmark.circle.fill" : "circle")
                                                .font(.system(size: 25, weight: .semibold))
                                                .foregroundColor(selectedExamKey == option.key ? Color.onboardingBlue : Color.onboardingGray.opacity(0.6))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: cardHeight)
                                        .padding(.horizontal, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(selectedExamKey == option.key ? Color.onboardingBlue.opacity(0.08) : Color.white.opacity(0.9))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .strokeBorder(
                                                            selectedExamKey == option.key ? Color.onboardingBlue.opacity(0.75) : Color.onboardingGray.opacity(0.24),
                                                            lineWidth: selectedExamKey == option.key ? 1.6 : 1
                                                        )
                                                )
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: gridGeometry.size.height, alignment: .top)
                            .padding(.vertical, 2)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.horizontal, geometry.size.width < 400 ? 18 : 24)
                .padding(.top, geometry.size.height < 700 ? 20 : 24)
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Button(action: {
                        persistSelection()
                        onboardingManager.nextScreen()
                    }) {
                        HStack(spacing: 8) {
                            Text(isGerman ? "Weiter" : "Continue")
                                .font(.system(size: 18, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.88)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color.onboardingBlue.opacity(0.24), radius: 10, x: 0, y: 5)
                        )
                    }
                    .disabled(selectedExamKey == nil)
                    .opacity(selectedExamKey == nil ? 0.55 : 1.0)
                    .padding(.horizontal, geometry.size.width < 400 ? 18 : 24)
                    .padding(.top, 10)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 12))
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color.onboardingCanvas.opacity(0.0),
                            Color.onboardingCanvas.opacity(0.92),
                            Color.onboardingCanvas
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
            .onAppear {
                loadInitialState()
            }
            .sheet(isPresented: $showExamDatePrompt) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 18) {
                        VStack(spacing: 8) {
                            Text(datePromptTitleText)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .multilineTextAlignment(.center)

                            Text(datePromptSubtitleText)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)
                                .multilineTextAlignment(.center)
                        }

                        DatePicker(
                            "",
                            selection: $examDate,
                            in: Date()...,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .tint(Color.onboardingBlue)
                        .padding(.horizontal, 8)

                        HStack(spacing: 12) {
                            Button(action: {
                                includeExamDate = false
                                persistExamDateState()
                                showExamDatePrompt = false
                            }) {
                                Text(skipText)
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color.onboardingInk)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .strokeBorder(Color.onboardingGray.opacity(0.35), lineWidth: 1)
                                            )
                                    )
                            }

                            Button(action: {
                                includeExamDate = true
                                persistExamDateState()
                                showExamDatePrompt = false
                            }) {
                                Text(saveDateText)
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.9)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 28)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 12)
                }
                .presentationDetents([.fraction(0.72)])
                .presentationDragIndicator(.visible)
            }
        }
    }

    private func segmentedProgress(totalSteps: Int, currentStep: Int) -> some View {
        let safeTotalSteps = max(totalSteps, 1)

        return HStack(spacing: 8) {
            ForEach(0..<safeTotalSteps, id: \.self) { index in
                Capsule()
                    .fill(
                        index < currentStep
                        ? Color.onboardingBlue
                        : Color.onboardingGray.opacity(0.25)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 7)
            }
        }
    }

    private func loadInitialState() {
        examOptions = loadExamOptions()

        let defaults = UserDefaults.standard
        selectedExamKey = nil

        if defaults.object(forKey: StorageKey.hasExamDate) != nil {
            includeExamDate = defaults.bool(forKey: StorageKey.hasExamDate)
        }

        if let savedDate = defaults.object(forKey: StorageKey.examDate) as? Date {
            examDate = savedDate
        }
    }

    private func persistSelection() {
        let defaults = UserDefaults.standard
        defaults.set(selectedExamKey, forKey: StorageKey.selectedExamKey)
        persistExamDateState()
    }

    private func persistExamDateState() {
        let defaults = UserDefaults.standard
        defaults.set(includeExamDate, forKey: StorageKey.hasExamDate)
        if includeExamDate {
            defaults.set(examDate, forKey: StorageKey.examDate)
        } else {
            defaults.removeObject(forKey: StorageKey.examDate)
        }
    }

    private func loadExamOptions() -> [OnboardingExamOption] {
        let rawFiles = ExamRepository.shared.loadAvailableExams(language: settings.language)
        var orderedKeys: [String] = []
        var seenKeys: Set<String> = []
        let excludedKeys: Set<String> = ["differentialgleichungen", "differential_equations"]

        for filename in rawFiles {
            let key = canonicalExamKey(from: filename)
            guard !excludedKeys.contains(key) else { continue }
            guard !seenKeys.contains(key) else { continue }
            seenKeys.insert(key)
            orderedKeys.append(key)
        }

        if orderedKeys.isEmpty {
            for key in fallbackExamKeys() {
                guard !excludedKeys.contains(key) else { continue }
                guard !seenKeys.contains(key) else { continue }
                seenKeys.insert(key)
                orderedKeys.append(key)
            }
        }

        let sourceOrder = Dictionary(uniqueKeysWithValues: orderedKeys.enumerated().map { ($0.element, $0.offset) })
        let pinnedOrder = Dictionary(uniqueKeysWithValues: preferredExamOrder().enumerated().map { ($0.element, $0.offset) })

        let sortedKeys = orderedKeys.sorted { lhs, rhs in
            let leftPinned = pinnedOrder[lhs] ?? Int.max
            let rightPinned = pinnedOrder[rhs] ?? Int.max
            if leftPinned != rightPinned {
                return leftPinned < rightPinned
            }

            let leftIndex = sourceOrder[lhs] ?? Int.max
            let rightIndex = sourceOrder[rhs] ?? Int.max
            return leftIndex < rightIndex
        }

        return sortedKeys.map { key in
            OnboardingExamOption(key: key, title: titleForExamKey(key))
        }
    }

    private func preferredExamOrder() -> [String] {
        if isGerman {
            return ["mathematik_1", "mathematik_2", "statistik", "numerische_mathematik"]
        }

        return ["mathematics_1", "mathematics_2", "statistics", "numerical_mathematics"]
    }

    private func canonicalExamKey(from filename: String) -> String {
        var key = filename
        key = key.replacingOccurrences(of: #"_(klausur|exam)_\d+$"#, with: "", options: .regularExpression)
        key = key.replacingOccurrences(of: #"_(anfaenger|fortgeschritten|experte|beginner|intermediate|advanced|expert)$"#, with: "", options: .regularExpression)
        return key
    }

    private func fallbackExamKeys() -> [String] {
        if isGerman {
            return [
                "mathematik_1",
                "analysis_1",
                "lineare_algebra_1",
                "mathematik_2",
                "analysis_2",
                "statistik",
                "numerische_mathematik"
            ]
        }

        return [
            "mathematics_1",
            "analysis_1",
            "linear_algebra_1",
            "mathematics_2",
            "analysis_2",
            "statistics",
            "numerical_mathematics"
        ]
    }

    private func titleForExamKey(_ key: String) -> String {
        if isGerman {
            let map: [String: String] = [
                "mathematik_1": "Mathematik I",
                "mathematik_2": "Mathematik II",
                "analysis_1": "Analysis I",
                "analysis_2": "Analysis II",
                "lineare_algebra_1": "Lineare Algebra I",
                "lineare_algebra": "Lineare Algebra",
                "statistik": "Statistik I",
                "numerische_mathematik": "Numerik"
            ]
            if let mapped = map[key] {
                return mapped
            }
        } else {
            let map: [String: String] = [
                "mathematics_1": "Mathematics I",
                "mathematics_2": "Mathematics II",
                "analysis_1": "Analysis I",
                "analysis_2": "Analysis II",
                "linear_algebra_1": "Linear Algebra I",
                "linear_algebra": "Linear Algebra",
                "statistics": "Statistics I",
                "numerical_mathematics": "Numerics"
            ]
            if let mapped = map[key] {
                return mapped
            }
        }

        return prettyTitle(from: key)
    }

    private func prettyTitle(from key: String) -> String {
        key
            .split(separator: "_")
            .map { token in
                switch token {
                case "1": return "I"
                case "2": return "II"
                case "3": return "III"
                default: return token.prefix(1).uppercased() + token.dropFirst().lowercased()
                }
            }
            .joined(separator: " ")
    }

    private func subtitleForExamKey(_ key: String) -> String {
        if isGerman {
            let map: [String: String] = [
                "mathematik_1": "Grundlagen und Einstieg",
                "mathematik_2": "Aufbau und Vertiefung",
                "analysis_1": "Grenzwerte und Ableitungen",
                "analysis_2": "Integrale und Reihen",
                "lineare_algebra_1": "Matrizen und Vektorräume",
                "lineare_algebra": "Matrizen und lineare Abbildungen",
                "statistik": "Daten, Wahrscheinlichkeiten, Verteilungen",
                "numerische_mathematik": "Algorithmen und Näherungsverfahren"
            ]
            return map[key] ?? "Passender Lernplan für dieses Fach"
        }

        let map: [String: String] = [
            "mathematics_1": "Fundamentals and first concepts",
            "mathematics_2": "Intermediate core concepts",
            "analysis_1": "Limits and derivatives",
            "analysis_2": "Integrals and series",
            "linear_algebra_1": "Matrices and vector spaces",
            "linear_algebra": "Matrices and linear maps",
            "statistics": "Data, probability, distributions",
            "numerical_mathematics": "Approximation and numerical methods"
        ]
        return map[key] ?? "We'll tailor the plan to this subject"
    }

    private func iconName(for key: String) -> String {
        let map: [String: String] = [
            "mathematik_1": "function",
            "mathematik_2": "sum",
            "mathematics_1": "function",
            "mathematics_2": "sum",
            "analysis_1": "chart.line.uptrend.xyaxis",
            "analysis_2": "waveform.path.ecg",
            "lineare_algebra_1": "tablecells",
            "linear_algebra_1": "tablecells",
            "lineare_algebra": "square.grid.3x3",
            "linear_algebra": "square.grid.3x3",
            "statistik": "chart.bar.xaxis",
            "statistics": "chart.bar.xaxis",
            "numerische_mathematik": "number",
            "numerical_mathematics": "number"
        ]

        return map[key] ?? "book.closed"
    }
}

private struct ExamPreviewCardModel: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let icon: String
}

struct ExamPreviewOnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @AppStorage("onboardingSelectedExamKey") private var persistedSelectedExamKey: String = ""
    @State private var animateCards = false

    private var isGerman: Bool {
        settings.language == .german
    }

    private var stepLabel: String {
        if isGerman {
            return "Schritt \(onboardingManager.currentProgressStep) von \(onboardingManager.progressStepCount)"
        }
        return "Step \(onboardingManager.currentProgressStep) of \(onboardingManager.progressStepCount)"
    }

    private var titleText: String {
        isGerman ? "\(selectedExamTitle)? Haben wir 👌" : "\(selectedExamTitle)? We got you 👌"
    }

    private var selectedExamKey: String {
        let normalized = persistedSelectedExamKey.trimmingCharacters(in: .whitespacesAndNewlines)
        return normalized.isEmpty ? defaultExamKey() : normalized
    }

    private var subtitleText: String {
        if isGerman {
            return "Wir haben 3 realistische \(selectedExamTitle)-Klausuren für dich vorbereitet - genau im Stil typischer Uni-Prüfungen."
        }
        return "We prepared 3 realistic \(selectedExamTitle) exams for you - just like typical university exams."
    }

    private var motivationText: String {
        if isGerman {
            return "Die meisten starten mit einer Probeklausur, um ihren aktuellen Stand zu checken."
        }
        return "Most learners start with a mock exam to check their current level."
    }

    private var selectedExamTitle: String {
        titleForExamKey(selectedExamKey)
    }

    private var previewCards: [ExamPreviewCardModel] {
        if isGerman {
            return [
                ExamPreviewCardModel(
                    title: selectedExamTitle,
                    detail: "Klausurjahr 2025 - 90 Minuten - 12 Aufgaben",
                    icon: "clock"
                ),
                ExamPreviewCardModel(
                    title: selectedExamTitle,
                    detail: "Klausurjahr 2024 - 120 Minuten - 15 Aufgaben",
                    icon: "list.bullet.clipboard"
                ),
                ExamPreviewCardModel(
                    title: selectedExamTitle,
                    detail: "Klausurjahr 2022 - 105 Minuten - 13 Aufgaben",
                    icon: "doc.text"
                )
            ]
        }

        return [
            ExamPreviewCardModel(
                title: selectedExamTitle,
                detail: "Exam year 2025 - 90 minutes - 12 questions",
                icon: "clock"
            ),
            ExamPreviewCardModel(
                title: selectedExamTitle,
                detail: "Exam year 2024 - 120 minutes - 15 questions",
                icon: "list.bullet.clipboard"
            ),
            ExamPreviewCardModel(
                title: selectedExamTitle,
                detail: "Exam year 2022 - 105 minutes - 13 questions",
                icon: "doc.text"
            )
        ]
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedBackground()

                Circle()
                    .fill(Color.onboardingBlue.opacity(0.1))
                    .frame(width: geometry.size.width * 0.74)
                    .offset(y: geometry.size.height * 0.25)
                    .blur(radius: 2)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Text(stepLabel)
                                .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)

                            Spacer()

                            Text("Onboarding")
                                .font(.system(size: geometry.size.height < 700 ? 13 : 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.92))
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(Color.onboardingGray.opacity(0.22), lineWidth: 1)
                                        )
                                )
                        }

                        segmentedProgress(
                            totalSteps: onboardingManager.progressStepCount,
                            currentStep: onboardingManager.currentProgressStep
                        )
                        .padding(.bottom, 10)

                        VStack(alignment: .leading, spacing: 8) {
                            Text(titleText)
                                .font(.system(size: geometry.size.height < 700 ? 30 : 34, weight: .bold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)

                            Text(subtitleText)
                                .font(.system(size: geometry.size.height < 700 ? 17 : 19, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)
                                .lineSpacing(2)
                        }
                        .padding(.bottom, 4)

                        VStack(spacing: -6) {
                            ForEach(Array(previewCards.enumerated()), id: \.element.id) { index, card in
                                examPreviewCard(card: card, index: index, geometry: geometry)
                                    .opacity(animateCards ? 1 : 0)
                                    .offset(y: animateCards ? 0 : 18)
                                    .scaleEffect(animateCards ? 1.0 : 0.97)
                                    .rotationEffect(.degrees(cardRotation(for: index)))
                                    .offset(x: cardHorizontalOffset(for: index))
                                    .zIndex(Double(previewCards.count - index))
                                    .animation(
                                        .spring(response: 0.58, dampingFraction: 0.84)
                                            .delay(Double(index) * 0.12),
                                        value: animateCards
                                    )
                            }
                        }

                        Text(motivationText)
                            .font(.system(size: geometry.size.height < 700 ? 15 : 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 8)

                        Spacer(minLength: geometry.size.height < 700 ? 126 : 144)
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 18 : 24)
                    .padding(.top, geometry.size.height < 700 ? 20 : 24)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Button(action: {
                        onboardingManager.nextScreen()
                    }) {
                        HStack(spacing: 8) {
                            Text(isGerman ? "Weiter" : "Continue")
                                .font(.system(size: 18, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.88)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color.onboardingBlue.opacity(0.24), radius: 10, x: 0, y: 5)
                        )
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 18 : 24)
                    .padding(.top, 10)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 12))
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color.onboardingCanvas.opacity(0.0),
                            Color.onboardingCanvas.opacity(0.92),
                            Color.onboardingCanvas
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
            .onAppear {
                if persistedSelectedExamKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    persistedSelectedExamKey = defaultExamKey()
                }
                animateCards = false
                DispatchQueue.main.async {
                    animateCards = true
                }
            }
        }
    }

    private func examPreviewCard(card: ExamPreviewCardModel, index: Int, geometry: GeometryProxy) -> some View {
        let accent = accentColor(for: index)

        return HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [accent.opacity(0.2), accent.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 46, height: 46)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(accent.opacity(0.25), lineWidth: 1)
                    )

                Image(systemName: card.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(accent)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(card.title)
                    .font(.system(size: geometry.size.height < 700 ? 18 : 19, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.onboardingInk)
                    .lineLimit(1)

                Text(card.detail)
                    .font(.system(size: geometry.size.height < 700 ? 15 : 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color.onboardingGrayStrong)
                    .lineLimit(2)
            }

            Spacer(minLength: 10)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .frame(minHeight: 98)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.88))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    accent.opacity(0.34),
                                    Color.onboardingGray.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.onboardingInk.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }

    private func cardRotation(for index: Int) -> Double {
        switch index {
        case 0: return 0.9
        case 1: return -0.8
        case 2: return 0.7
        default: return 0
        }
    }

    private func cardHorizontalOffset(for index: Int) -> CGFloat {
        switch index {
        case 0: return 4
        case 1: return -3
        case 2: return 3
        default: return 0
        }
    }

    private func accentColor(for index: Int) -> Color {
        let palette: [Color] = [
            Color.onboardingBlue,
            Color.onboardingInk.opacity(0.8),
            Color.onboardingBlue.opacity(0.9)
        ]
        return palette[index % palette.count]
    }

    private func defaultExamKey() -> String {
        isGerman ? "mathematik_1" : "mathematics_1"
    }

    private func titleForExamKey(_ key: String) -> String {
        if isGerman {
            let map: [String: String] = [
                "mathematik_1": "Mathematik I",
                "mathematik_2": "Mathematik II",
                "analysis_1": "Analysis I",
                "analysis_2": "Analysis II",
                "lineare_algebra_1": "Lineare Algebra I",
                "lineare_algebra": "Lineare Algebra",
                "statistik": "Statistik I",
                "numerische_mathematik": "Numerik"
            ]
            if let mapped = map[key] {
                return mapped
            }
        } else {
            let map: [String: String] = [
                "mathematics_1": "Mathematics I",
                "mathematics_2": "Mathematics II",
                "analysis_1": "Analysis I",
                "analysis_2": "Analysis II",
                "linear_algebra_1": "Linear Algebra I",
                "linear_algebra": "Linear Algebra",
                "statistics": "Statistics I",
                "numerical_mathematics": "Numerics"
            ]
            if let mapped = map[key] {
                return mapped
            }
        }

        return key
            .split(separator: "_")
            .map { token in
                switch token {
                case "1": return "I"
                case "2": return "II"
                case "3": return "III"
                default: return token.prefix(1).uppercased() + token.dropFirst().lowercased()
                }
            }
            .joined(separator: " ")
    }

    private func segmentedProgress(totalSteps: Int, currentStep: Int) -> some View {
        let safeTotalSteps = max(totalSteps, 1)

        return HStack(spacing: 8) {
            ForEach(0..<safeTotalSteps, id: \.self) { index in
                Capsule()
                    .fill(
                        index < currentStep
                        ? Color.onboardingBlue
                        : Color.onboardingGray.opacity(0.25)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 7)
            }
        }
    }
}

private struct MiniDiagnosisOption: Identifiable {
    let id: String
    let titleDE: String
    let titleEN: String
    let emoji: String
}

struct MiniDiagnosisOnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @State private var selectedOptions: Set<String> = []

    private enum StorageKey {
        static let diagnosisSelections = "onboardingDiagnosisSelections"
    }

    private let options: [MiniDiagnosisOption] = [
        MiniDiagnosisOption(
            id: "theory",
            titleDE: "Ich verstehe die Theorie nicht",
            titleEN: "I don't understand the theory",
            emoji: "📚"
        ),
        MiniDiagnosisOption(
            id: "tasks",
            titleDE: "Ich scheitere an Aufgaben",
            titleEN: "I fail on exercises",
            emoji: "🧩"
        ),
        MiniDiagnosisOption(
            id: "relevant",
            titleDE: "Ich weiß nicht, was klausurrelevant ist",
            titleEN: "I don't know what is exam-relevant",
            emoji: "🎯"
        ),
        MiniDiagnosisOption(
            id: "procrastination",
            titleDE: "Ich prokrastiniere",
            titleEN: "I procrastinate",
            emoji: "⏳"
        )
    ]

    private var isGerman: Bool {
        settings.language == .german
    }

    private var stepLabel: String {
        if isGerman {
            return "Schritt \(onboardingManager.currentProgressStep) von \(onboardingManager.progressStepCount)"
        }
        return "Step \(onboardingManager.currentProgressStep) of \(onboardingManager.progressStepCount)"
    }

    private var titleText: String {
        isGerman ? "Was ist dein größtes Problem?" : "What's your biggest challenge?"
    }

    private var subtitleText: String {
        if isGerman {
            return "Wähle aus, was dich am meisten ausbremst. Wir richten die App genau darauf aus."
        }
        return "Pick what slows you down most. We'll adapt the app to exactly that."
    }

    private var solutionHintText: String {
        if isGerman {
            return "UniMathe zeigt dir genau die nächsten Schritte, passende Aufgaben und klare Prioritäten."
        }
        return "UniMathe gives you clear next steps, targeted exercises, and focused priorities."
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedBackground()

                Circle()
                    .fill(Color.onboardingBlue.opacity(0.1))
                    .frame(width: geometry.size.width * 0.74)
                    .offset(y: geometry.size.height * 0.25)
                    .blur(radius: 2)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Text(stepLabel)
                                .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)

                            Spacer()

                            Text("Onboarding")
                                .font(.system(size: geometry.size.height < 700 ? 13 : 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.92))
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(Color.onboardingGray.opacity(0.22), lineWidth: 1)
                                        )
                                )
                        }

                        segmentedProgress(
                            totalSteps: onboardingManager.progressStepCount,
                            currentStep: onboardingManager.currentProgressStep
                        )
                        .padding(.bottom, 10)

                        VStack(alignment: .leading, spacing: 8) {
                            Text(titleText)
                                .font(.system(size: geometry.size.height < 700 ? 30 : 34, weight: .bold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)

                            Text(subtitleText)
                                .font(.system(size: geometry.size.height < 700 ? 17 : 19, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)
                                .lineSpacing(2)
                        }

                        VStack(spacing: 12) {
                            ForEach(options) { option in
                                checkboxRow(option: option, geometry: geometry)
                            }
                        }
                        .padding(.top, 6)

                        Text(solutionHintText)
                            .font(.system(size: geometry.size.height < 700 ? 15 : 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)
                            .lineSpacing(2)
                            .padding(.top, 8)

                        Spacer(minLength: geometry.size.height < 700 ? 126 : 144)
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 18 : 24)
                    .padding(.top, geometry.size.height < 700 ? 20 : 24)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Button(action: {
                        persistSelections()
                        onboardingManager.nextScreen()
                    }) {
                        HStack(spacing: 8) {
                            Text(isGerman ? "Weiter" : "Continue")
                                .font(.system(size: 18, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.88)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color.onboardingBlue.opacity(0.24), radius: 10, x: 0, y: 5)
                        )
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 18 : 24)
                    .padding(.top, 10)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 12))
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color.onboardingCanvas.opacity(0.0),
                            Color.onboardingCanvas.opacity(0.92),
                            Color.onboardingCanvas
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
            .onAppear {
                let defaults = UserDefaults.standard
                if let stored = defaults.array(forKey: StorageKey.diagnosisSelections) as? [String] {
                    selectedOptions = Set(stored)
                }
            }
        }
    }

    private func checkboxRow(option: MiniDiagnosisOption, geometry: GeometryProxy) -> some View {
        let isSelected = selectedOptions.contains(option.id)
        let title = isGerman ? option.titleDE : option.titleEN

        return Button(action: {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
                if isSelected {
                    selectedOptions.remove(option.id)
                } else {
                    selectedOptions.insert(option.id)
                }
            }
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }) {
            HStack(spacing: 12) {
                Text("\(option.emoji)  \(title)")
                    .font(.system(size: geometry.size.height < 700 ? 16 : 17, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.onboardingInk)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(isSelected ? Color.onboardingBlue : Color.onboardingGray.opacity(0.6))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.onboardingBlue.opacity(0.08) : Color.white.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                isSelected ? Color.onboardingBlue.opacity(0.7) : Color.onboardingGray.opacity(0.22),
                                lineWidth: isSelected ? 1.6 : 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private func persistSelections() {
        let defaults = UserDefaults.standard
        defaults.set(Array(selectedOptions), forKey: StorageKey.diagnosisSelections)
    }

    private func segmentedProgress(totalSteps: Int, currentStep: Int) -> some View {
        let safeTotalSteps = max(totalSteps, 1)

        return HStack(spacing: 8) {
            ForEach(0..<safeTotalSteps, id: \.self) { index in
                Capsule()
                    .fill(
                        index < currentStep
                        ? Color.onboardingBlue
                        : Color.onboardingGray.opacity(0.25)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 7)
            }
        }
    }
}

private struct TopicShowcaseTileModel: Identifiable, Hashable {
    let id: String
    let title: String
    let icon: String
}

private struct TopicFilePreview: Decodable {
    let id: String
    let title: String
    let icon: String
}

private struct TopicShowcaseMarqueeRow: View {
    let items: [TopicShowcaseTileModel]
    let movesLeft: Bool
    let elapsed: TimeInterval
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let titleFontSize: CGFloat
    let chipContentSpacing: CGFloat
    let chipHorizontalPadding: CGFloat
    let chipVerticalPadding: CGFloat
    let chipCornerRadius: CGFloat
    let iconSize: CGFloat
    let iconSymbolSize: CGFloat
    let assetIconSize: CGFloat
    let fillChipFrame: Bool

    private let spacing: CGFloat = 10
    private let speed: CGFloat = 26

    var body: some View {
        let safeItems = items.isEmpty ? [TopicShowcaseTileModel(id: "placeholder", title: "Topic", icon: "book.fill")] : items
        let contentWidth = CGFloat(safeItems.count) * cardWidth + CGFloat(max(0, safeItems.count - 1)) * spacing
        let cycle = max(contentWidth + spacing, 1)
        let travel = (CGFloat(elapsed) * speed).truncatingRemainder(dividingBy: cycle)
        let offsetX = movesLeft ? -travel : travel - cycle

        HStack(spacing: spacing) {
            rowContent(for: safeItems)
            rowContent(for: safeItems)
            rowContent(for: safeItems)
        }
        .offset(x: offsetX)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: cardHeight)
    }

    private func rowContent(for items: [TopicShowcaseTileModel]) -> some View {
        HStack(spacing: spacing) {
            ForEach(items) { item in
                TopicShowcaseChip(
                    item: item,
                    titleFontSize: titleFontSize,
                    chipContentSpacing: chipContentSpacing,
                    chipHorizontalPadding: chipHorizontalPadding,
                    chipVerticalPadding: chipVerticalPadding,
                    chipCornerRadius: chipCornerRadius,
                    iconSize: iconSize,
                    iconSymbolSize: iconSymbolSize,
                    assetIconSize: assetIconSize,
                    fillChipFrame: fillChipFrame
                )
                    .frame(width: cardWidth, height: cardHeight)
            }
        }
    }
}

private struct TopicShowcaseChip: View {
    let item: TopicShowcaseTileModel
    let titleFontSize: CGFloat
    let chipContentSpacing: CGFloat
    let chipHorizontalPadding: CGFloat
    let chipVerticalPadding: CGFloat
    let chipCornerRadius: CGFloat
    let iconSize: CGFloat
    let iconSymbolSize: CGFloat
    let assetIconSize: CGFloat
    let fillChipFrame: Bool

    var body: some View {
        HStack(spacing: chipContentSpacing) {
            iconView(for: item)

            Text(item.title)
                .font(.system(size: titleFontSize, weight: .semibold, design: .rounded))
                .foregroundColor(Color.onboardingInk)
                .lineLimit(2)
                .truncationMode(.tail)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(
            maxWidth: fillChipFrame ? .infinity : nil,
            maxHeight: fillChipFrame ? .infinity : nil,
            alignment: .leading
        )
        .padding(.horizontal, chipHorizontalPadding)
        .padding(.vertical, chipVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: chipCornerRadius)
                .fill(Color.white.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: chipCornerRadius)
                        .strokeBorder(Color.onboardingGray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.onboardingInk.opacity(0.08), radius: 7, x: 0, y: 4)
        )
    }

    @ViewBuilder
    private func iconView(for item: TopicShowcaseTileModel) -> some View {
        let maybeAsset = customAssetName(for: item.title)

        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            if let asset = maybeAsset {
                Image(asset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: assetIconSize, height: assetIconSize)
                    .foregroundColor(.white)
            } else {
                Image(systemName: item.icon)
                    .font(.system(size: iconSymbolSize, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .frame(width: iconSize, height: iconSize)
        .shadow(color: Color.onboardingBlue.opacity(0.28), radius: 5, x: 0, y: 2)
    }

    private func customAssetName(for title: String) -> String? {
        let map: [String: String] = [
            "Integralrechnung": "integral",
            "Integral Calculus": "integral",
            "Mehrdimensionale Analysis": "mehrdimensionale_analysis",
            "Multidimensional Analysis": "mehrdimensionale_analysis",
            "Multidimensional Calculus": "mehrdimensionale_analysis",
            "Differentialrechnung": "differentialrechnung",
            "Differential Calculus": "differentialrechnung",
            "Matrizen": "matrizen",
            "Matrices": "matrizen",
            "Vektorräume": "vektor",
            "Vector Spaces": "vektor",
            "Lineare Abbildungen": "abbildung",
            "Linear Mappings": "abbildung",
            "Determinanten": "determinante",
            "Determinants": "determinante",
            "Eigenwerte und Eigenvektoren": "eigenwerte",
            "Eigenvalues and Eigenvectors": "eigenwerte"
        ]
        return map[title]
    }
}

struct TopicShowcaseOnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @State private var topicTiles: [TopicShowcaseTileModel] = []
    @State private var animationStartDate = Date()

    private var isGerman: Bool {
        settings.language == .german
    }

    private var stepLabel: String {
        if isGerman {
            return "Schritt \(onboardingManager.currentProgressStep) von \(onboardingManager.progressStepCount)"
        }
        return "Step \(onboardingManager.currentProgressStep) of \(onboardingManager.progressStepCount)"
    }

    private var titleText: String {
        isGerman ? "Alles in einer App" : "Everything in one app"
    }

    private var subtitleText: String {
        if isGerman {
            return "Von Grundlagen bis zur Klausurvorbereitung: UniMathe deckt viele Themenbereiche ab."
        }
        return "From fundamentals to exam prep: UniMathe covers a wide range of topics."
    }

    private var fallbackTiles: [TopicShowcaseTileModel] {
        if isGerman {
            return [
                TopicShowcaseTileModel(id: "de-1", title: "Mengen und Abbildungen", icon: "circle.grid.2x2.fill"),
                TopicShowcaseTileModel(id: "de-2", title: "Logik", icon: "arrow.triangle.branch"),
                TopicShowcaseTileModel(id: "de-3", title: "Vollständige Induktion", icon: "arrow.up.forward"),
                TopicShowcaseTileModel(id: "de-4", title: "Binomische Formeln", icon: "x.squareroot"),
                TopicShowcaseTileModel(id: "de-5", title: "Differentialrechnung", icon: "function"),
                TopicShowcaseTileModel(id: "de-6", title: "Integralrechnung", icon: "integral"),
                TopicShowcaseTileModel(id: "de-7", title: "Mehrdimensionale Analysis", icon: "function"),
                TopicShowcaseTileModel(id: "de-8", title: "Matrizen", icon: "square.grid.2x2.fill"),
                TopicShowcaseTileModel(id: "de-9", title: "Vektorräume", icon: "square.grid.2x2.fill"),
                TopicShowcaseTileModel(id: "de-10", title: "Lineare Abbildungen", icon: "square.grid.2x2.fill"),
                TopicShowcaseTileModel(id: "de-11", title: "Determinanten", icon: "square.grid.2x2.fill"),
                TopicShowcaseTileModel(id: "de-12", title: "Eigenwerte und Eigenvektoren", icon: "square.grid.2x2.fill")
            ]
        }

        return [
            TopicShowcaseTileModel(id: "en-1", title: "Sets and Mappings", icon: "circle.grid.2x2.fill"),
            TopicShowcaseTileModel(id: "en-2", title: "Logic", icon: "arrow.triangle.branch"),
            TopicShowcaseTileModel(id: "en-3", title: "Mathematical Induction", icon: "arrow.up.forward"),
            TopicShowcaseTileModel(id: "en-4", title: "Binomial Formulas", icon: "x.squareroot"),
            TopicShowcaseTileModel(id: "en-5", title: "Differential Calculus", icon: "function"),
            TopicShowcaseTileModel(id: "en-6", title: "Integral Calculus", icon: "integral"),
            TopicShowcaseTileModel(id: "en-7", title: "Multidimensional Calculus", icon: "function"),
            TopicShowcaseTileModel(id: "en-8", title: "Matrices", icon: "square.grid.2x2.fill"),
            TopicShowcaseTileModel(id: "en-9", title: "Vector Spaces", icon: "square.grid.2x2.fill"),
            TopicShowcaseTileModel(id: "en-10", title: "Linear Mappings", icon: "square.grid.2x2.fill"),
            TopicShowcaseTileModel(id: "en-11", title: "Determinants", icon: "square.grid.2x2.fill"),
            TopicShowcaseTileModel(id: "en-12", title: "Eigenvalues and Eigenvectors", icon: "square.grid.2x2.fill")
        ]
    }

    private var topicRows: [[TopicShowcaseTileModel]] {
        let source = topicTiles.isEmpty ? fallbackTiles : topicTiles
        let rowSize = 5
        var rows: [[TopicShowcaseTileModel]] = []
        var cursor = 0

        while cursor < source.count {
            let end = min(cursor + rowSize, source.count)
            rows.append(Array(source[cursor..<end]))
            cursor += rowSize
        }

        if rows.count >= 4 {
            return rows
        }

        var rotated = source
        while rows.count < 4 && !rotated.isEmpty {
            if let first = rotated.first {
                rotated.removeFirst()
                rotated.append(first)
            }
            rows.append(Array(rotated.prefix(min(rowSize, rotated.count))))
        }

        return rows
    }

    var body: some View {
        GeometryReader { geometry in
            let displayBounds = UIScreen.main.bounds
            let screenWidth = min(displayBounds.width, displayBounds.height)
            let screenHeight = max(displayBounds.width, displayBounds.height)
            let isIPhoneMaxDisplay = UIDevice.current.userInterfaceIdiom == .phone
                && (
                    (screenWidth >= 428 && screenHeight >= 926)
                    || (screenWidth >= 414 && screenHeight >= 896)
                )
            let horizontalPadding: CGFloat = geometry.size.width < 400 ? 18 : 24
            let marqueeCardWidth: CGFloat = isIPhoneMaxDisplay
                ? min(244, max(198, geometry.size.width * 0.58))
                : min(176, max(148, geometry.size.width * 0.44))
            let marqueeCardHeight: CGFloat = isIPhoneMaxDisplay ? 80 : 96
            let marqueeTitleFontSize: CGFloat = isIPhoneMaxDisplay ? 16 : 13
            let marqueeChipContentSpacing: CGFloat = isIPhoneMaxDisplay ? 11 : 10
            let marqueeChipHorizontalPadding: CGFloat = isIPhoneMaxDisplay ? 11 : 10
            let marqueeChipVerticalPadding: CGFloat = isIPhoneMaxDisplay ? 10 : 10
            let marqueeChipCornerRadius: CGFloat = isIPhoneMaxDisplay ? 18 : 14
            let marqueeIconSize: CGFloat = isIPhoneMaxDisplay ? 39 : 34
            let marqueeIconSymbolSize: CGFloat = isIPhoneMaxDisplay ? 17 : 15
            let marqueeAssetIconSize: CGFloat = isIPhoneMaxDisplay ? 22 : 18
            let marqueeFillChipFrame: Bool = isIPhoneMaxDisplay
            let marqueeRowSpacing: CGFloat = isIPhoneMaxDisplay ? 6 : 0
            let marqueeContainerHeight: CGFloat = isIPhoneMaxDisplay
                ? min(geometry.size.height * 0.47, 360)
                : min(geometry.size.height * 0.4, 300)

            ZStack {
                AnimatedBackground()

                Circle()
                    .fill(Color.onboardingBlue.opacity(0.1))
                    .frame(width: geometry.size.width * 0.78)
                    .offset(y: geometry.size.height * 0.2)
                    .blur(radius: 2)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Text(stepLabel)
                                .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)

                            Spacer()

                            Text("Onboarding")
                                .font(.system(size: geometry.size.height < 700 ? 13 : 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.92))
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(Color.onboardingGray.opacity(0.22), lineWidth: 1)
                                        )
                                )
                        }

                        segmentedProgress(
                            totalSteps: onboardingManager.progressStepCount,
                            currentStep: onboardingManager.currentProgressStep
                        )
                        .padding(.bottom, 10)

                        VStack(alignment: .leading, spacing: 8) {
                            Text(titleText)
                                .font(.system(size: geometry.size.height < 700 ? 30 : 34, weight: .bold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .lineLimit(2)

                            Text(subtitleText)
                                .font(.system(size: geometry.size.height < 700 ? 17 : 19, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)
                                .lineSpacing(2)
                        }
                        .padding(.bottom, 4)

                        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: false)) { timeline in
                            let elapsed = timeline.date.timeIntervalSince(animationStartDate)

                            VStack(spacing: marqueeRowSpacing) {
                                ForEach(Array(topicRows.enumerated()), id: \.offset) { index, row in
                                    TopicShowcaseMarqueeRow(
                                        items: row,
                                        movesLeft: index.isMultiple(of: 2),
                                        elapsed: elapsed,
                                        cardWidth: marqueeCardWidth,
                                        cardHeight: marqueeCardHeight,
                                        titleFontSize: marqueeTitleFontSize,
                                        chipContentSpacing: marqueeChipContentSpacing,
                                        chipHorizontalPadding: marqueeChipHorizontalPadding,
                                        chipVerticalPadding: marqueeChipVerticalPadding,
                                        chipCornerRadius: marqueeChipCornerRadius,
                                        iconSize: marqueeIconSize,
                                        iconSymbolSize: marqueeIconSymbolSize,
                                        assetIconSize: marqueeAssetIconSize,
                                        fillChipFrame: marqueeFillChipFrame
                                    )
                                }
                            }
                        }
                        .frame(width: geometry.size.width, height: marqueeContainerHeight, alignment: .topLeading)
                        .padding(.horizontal, -horizontalPadding)

                        Spacer(minLength: geometry.size.height < 700 ? 126 : 144)
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, geometry.size.height < 700 ? 20 : 24)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Button(action: {
                        onboardingManager.nextScreen()
                    }) {
                        HStack(spacing: 8) {
                            Text(isGerman ? "Weiter" : "Continue")
                                .font(.system(size: 18, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.88)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color.onboardingBlue.opacity(0.24), radius: 10, x: 0, y: 5)
                        )
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 10)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 12))
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color.onboardingCanvas.opacity(0.0),
                            Color.onboardingCanvas.opacity(0.92),
                            Color.onboardingCanvas
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
            .onAppear {
                animationStartDate = Date()
                loadTopicTiles()
            }
            .onChange(of: settings.language) { _ in
                loadTopicTiles()
            }
        }
    }

    private func loadTopicTiles() {
        let language = settings.language
        let languageSuffix = language == .english ? "_en" : ""
        let indexNames = ["index" + languageSuffix, "index"]
        let subdirectories: [String?] = [nil, "lerninhalt", "lerninhalt/\(language.rawValue)"]

        guard let indexUrl = firstResourceURL(names: indexNames, subdirectories: subdirectories) else {
            topicTiles = fallbackTiles
            return
        }

        do {
            let indexData = try Data(contentsOf: indexUrl)
            let indexResponse = try JSONDecoder().decode(IndexResponse.self, from: indexData)
            var loaded: [TopicShowcaseTileModel] = []

            let subTopics = indexResponse.topics.flatMap { $0.subTopics ?? [] }
            for subTopic in subTopics {
                let baseName = subTopic.filename.replacingOccurrences(of: ".json", with: "")
                let localizedName = baseName + languageSuffix

                guard let topicUrl = firstResourceURL(
                    names: [localizedName, baseName],
                    subdirectories: subdirectories
                ) else {
                    continue
                }

                do {
                    let data = try Data(contentsOf: topicUrl)
                    let preview = try JSONDecoder().decode(TopicFilePreview.self, from: data)
                    loaded.append(
                        TopicShowcaseTileModel(
                            id: preview.id,
                            title: preview.title,
                            icon: preview.icon
                        )
                    )
                } catch {
                    continue
                }
            }

            if loaded.isEmpty {
                topicTiles = fallbackTiles
                return
            }

            var seen = Set<String>()
            topicTiles = loaded.filter { seen.insert($0.id).inserted }
        } catch {
            topicTiles = fallbackTiles
        }
    }

    private func firstResourceURL(names: [String], subdirectories: [String?]) -> URL? {
        for name in names {
            for subdirectory in subdirectories {
                if let subdirectory {
                    if let url = Bundle.main.url(forResource: name, withExtension: "json", subdirectory: subdirectory) {
                        return url
                    }
                } else if let url = Bundle.main.url(forResource: name, withExtension: "json") {
                    return url
                }
            }
        }
        return nil
    }

    private func segmentedProgress(totalSteps: Int, currentStep: Int) -> some View {
        let safeTotalSteps = max(totalSteps, 1)

        return HStack(spacing: 8) {
            ForEach(0..<safeTotalSteps, id: \.self) { index in
                Capsule()
                    .fill(
                        index < currentStep
                        ? Color.onboardingBlue
                        : Color.onboardingGray.opacity(0.25)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 7)
            }
        }
    }
}

struct LearningTopicsOnboardingView: View {
    var body: some View {
        MinimalOnboardingPage(
            titleDE: "Alle Themen meistern",
            titleEN: "Master All Topics",
            subtitleDE: "Von Grundlagen bis fortgeschrittener Mathematik.",
            subtitleEN: "From fundamentals to advanced university math.",
            pointsDE: [
                "Strukturierte Lernpfade",
                "Klar erklärte Kernkonzepte",
                "Praktische Beispiele"
            ],
            pointsEN: [
                "Structured learning paths",
                "Clearly explained core concepts",
                "Practical examples"
            ],
            symbolName: "book.pages.fill"
        )
    }
}

struct StepByStepOnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @State private var currentDemoStep = 0
    @State private var formulaHeight: CGFloat = 56

    private let demoTimer = Timer.publish(every: 2.8, on: .main, in: .common).autoconnect()

    private var isGerman: Bool {
        settings.language == .german
    }

    private var stepLabel: String {
        if isGerman {
            return "Schritt \(onboardingManager.currentProgressStep) von \(onboardingManager.progressStepCount)"
        }
        return "Step \(onboardingManager.currentProgressStep) of \(onboardingManager.progressStepCount)"
    }

    private var titleText: String {
        isGerman ? "Schritt für Schritt Erklärungen" : "Step by Step Explanations"
    }

    private var subtitleText: String {
        if isGerman {
            return "Komplexe Lerninhalte werden in klare, verständliche Einzelschritte aufgeteilt."
        }
        return "Complex learning content is split into clear, understandable steps."
    }

    private var highlightTitle: String {
        isGerman ? "Von komplex zu einfach" : "From complex to simple"
    }

    private var highlightSubtitle: String {
        isGerman ? "Schritt für Schritt zum Verständnis" : "Step by step to understanding"
    }

    private var formulaTitle: String {
        isGerman ? "Formel" : "Formula"
    }

    private var simpleTitle: String {
        isGerman ? "Einfach erklärt" : "In simple words"
    }

    private var learningSteps: [StepByStepDemoItem] {
        if isGerman {
            return [
                StepByStepDemoItem(
                    title: "Was ist ein Vektor?",
                    explanation: "Ein Vektor beschreibt eine Richtung und eine Länge. Er wird als Koordinatenpaar dargestellt.",
                    formula: "\\vec{v} = (x, y)",
                    simpleExplanation: "Stell dir einen Pfeil vor: Er zeigt wohin und wie weit."
                ),
                StepByStepDemoItem(
                    title: "Länge berechnen",
                    explanation: "Die Länge eines Vektors berechnest du mit dem Satz des Pythagoras.",
                    formula: "\\lVert \\vec{v} \\rVert = \\sqrt{x^2 + y^2}",
                    simpleExplanation: "Du berechnest die Pfeillänge wie bei einem rechtwinkligen Dreieck."
                ),
                StepByStepDemoItem(
                    title: "Vektoren addieren",
                    explanation: "Addiere x-Werte und y-Werte getrennt. So erhältst du den Ergebnisvektor.",
                    formula: "(2,3) + (1,4) = (3,7)",
                    simpleExplanation: "Komponente für Komponente addieren, fertig."
                )
            ]
        }

        return [
            StepByStepDemoItem(
                title: "What is a vector?",
                explanation: "A vector has a direction and a magnitude, represented by coordinates.",
                formula: "\\vec{v} = (x, y)",
                simpleExplanation: "Think of an arrow: it points somewhere and has a length."
            ),
            StepByStepDemoItem(
                title: "Find the length",
                explanation: "You compute vector length with the Pythagorean theorem.",
                formula: "\\lVert \\vec{v} \\rVert = \\sqrt{x^2 + y^2}",
                simpleExplanation: "It is the same triangle rule used for hypotenuse calculations."
            ),
            StepByStepDemoItem(
                title: "Add vectors",
                explanation: "Add x-values and y-values separately to get the result vector.",
                formula: "(2,3) + (1,4) = (3,7)",
                simpleExplanation: "Add each component one by one."
            )
        ]
    }

    private var safeStepIndex: Int {
        guard !learningSteps.isEmpty else { return 0 }
        return currentDemoStep % learningSteps.count
    }

    private var activeStep: StepByStepDemoItem {
        learningSteps[safeStepIndex]
    }

    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = geometry.size.width < 400 ? 18 : 24
            let cardCornerRadius: CGFloat = geometry.size.height < 700 ? 22 : 26
            let cardMaxWidth: CGFloat = min(geometry.size.width * 0.82, 332)

            ZStack {
                AnimatedBackground()

                Circle()
                    .fill(Color.onboardingBlue.opacity(0.11))
                    .frame(width: geometry.size.width * 0.76)
                    .offset(y: geometry.size.height * 0.16)
                    .blur(radius: 2)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Text(stepLabel)
                                .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)

                            Spacer()

                            Text("Onboarding")
                                .font(.system(size: geometry.size.height < 700 ? 13 : 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.92))
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(Color.onboardingGray.opacity(0.22), lineWidth: 1)
                                        )
                                )
                        }

                        segmentedProgress(
                            totalSteps: onboardingManager.progressStepCount,
                            currentStep: onboardingManager.currentProgressStep
                        )
                        .padding(.bottom, 10)

                        VStack(alignment: .leading, spacing: 8) {
                            Text(titleText)
                                .font(.system(size: geometry.size.height < 700 ? 30 : 34, weight: .bold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .lineLimit(2)

                            Text(subtitleText)
                                .font(.system(size: geometry.size.height < 700 ? 17 : 19, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)
                                .lineSpacing(2)
                        }
                        .padding(.bottom, 2)

                        VStack(alignment: .leading, spacing: 12) {
                            Text(activeStep.title)
                                .font(.system(size: geometry.size.height < 700 ? 20 : 22, weight: .bold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .lineLimit(2)

                            Text(activeStep.explanation)
                                .font(.system(size: geometry.size.height < 700 ? 15 : 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)
                                .lineSpacing(2)

                            VStack(alignment: .leading, spacing: 7) {
                                Text(formulaTitle)
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color.onboardingGrayStrong)

                                LaTeXView(
                                    content: "<div class=\"math-block\">$$\(activeStep.formula)$$</div>",
                                    height: $formulaHeight
                                )
                                    .frame(height: max(44, min(formulaHeight, 86)))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text(simpleTitle)
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color.onboardingGrayStrong)

                                Text(activeStep.simpleExplanation)
                                    .font(.system(size: geometry.size.height < 700 ? 14 : 15, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.onboardingInk)
                                    .lineSpacing(2)
                            }

                            HStack(spacing: 8) {
                                ForEach(learningSteps.indices, id: \.self) { index in
                                    Capsule()
                                        .fill(
                                            index == safeStepIndex
                                            ? Color.onboardingBlue
                                            : Color.onboardingGray.opacity(0.3)
                                        )
                                        .frame(width: index == safeStepIndex ? 24 : 8, height: 8)
                                        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: safeStepIndex)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 2)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .frame(maxWidth: cardMaxWidth, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: cardCornerRadius)
                                .fill(Color.white.opacity(0.93))
                                .overlay(
                                    RoundedRectangle(cornerRadius: cardCornerRadius)
                                        .strokeBorder(Color.onboardingGray.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: Color.onboardingInk.opacity(0.12), radius: 12, x: 0, y: 8)
                        )
                        .frame(maxWidth: .infinity, alignment: .center)

                        VStack(spacing: 6) {
                            Text(highlightTitle)
                                .font(.system(size: geometry.size.height < 700 ? 17 : 18, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.onboardingBlue)
                                .multilineTextAlignment(.center)

                            Text(highlightSubtitle)
                                .font(.system(size: geometry.size.height < 700 ? 13 : 14, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)

                        Spacer(minLength: geometry.size.height < 700 ? 126 : 144)
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, geometry.size.height < 700 ? 20 : 24)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Button(action: {
                        onboardingManager.nextScreen()
                    }) {
                        HStack(spacing: 8) {
                            Text(isGerman ? "Weiter" : "Continue")
                                .font(.system(size: 18, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.88)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color.onboardingBlue.opacity(0.24), radius: 10, x: 0, y: 5)
                        )
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 10)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 12))
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color.onboardingCanvas.opacity(0.0),
                            Color.onboardingCanvas.opacity(0.92),
                            Color.onboardingCanvas
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
            .onReceive(demoTimer) { _ in
                guard learningSteps.count > 1 else { return }
                withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                    currentDemoStep = (currentDemoStep + 1) % learningSteps.count
                }
            }
            .onChange(of: settings.language) { _ in
                currentDemoStep = 0
                formulaHeight = 56
            }
            .onChange(of: safeStepIndex) { _ in
                formulaHeight = 56
            }
        }
    }

    private func segmentedProgress(totalSteps: Int, currentStep: Int) -> some View {
        let safeTotalSteps = max(totalSteps, 1)

        return HStack(spacing: 8) {
            ForEach(0..<safeTotalSteps, id: \.self) { index in
                Capsule()
                    .fill(
                        index < currentStep
                        ? Color.onboardingBlue
                        : Color.onboardingGray.opacity(0.25)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 7)
            }
        }
    }
}

private struct StepByStepDemoItem {
    let title: String
    let explanation: String
    let formula: String
    let simpleExplanation: String
}

private struct PersonalizedPlanPhase: Identifiable {
    let id = UUID()
    let startDay: Int
    let endDay: Int
    let titleDE: String
    let titleEN: String
    let detailDE: String
    let detailEN: String
    let icon: String
}

private struct DashedVerticalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

struct PersonalizedPlanOnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @AppStorage("onboardingSelectedExamKey") private var persistedSelectedExamKey: String = ""

    private enum StorageKey {
        static let hasExamDate = "onboardingHasExamDate"
        static let examDate = "onboardingExamDate"
    }

    private var isGerman: Bool {
        settings.language == .german
    }

    private var daysUntilExam: Int {
        let defaults = UserDefaults.standard
        let hasDate = defaults.bool(forKey: StorageKey.hasExamDate)
        guard hasDate, let examDate = defaults.object(forKey: StorageKey.examDate) as? Date else {
            return 21
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: examDate)
        let diff = calendar.dateComponents([.day], from: today, to: target).day ?? 21
        return max(1, diff)
    }

    private var selectedExamKey: String {
        let trimmed = persistedSelectedExamKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return isGerman ? "mathematik_1" : "mathematics_1"
        }
        return trimmed
    }

    private var selectedExamTitle: String {
        titleForExamKey(selectedExamKey)
    }

    private var practiceUnitsPerWeek: Int {
        switch daysUntilExam {
        case ...10:
            return 5
        case ...21:
            return 4
        case ...42:
            return 3
        default:
            return 2
        }
    }

    private var simulationCount: Int {
        switch daysUntilExam {
        case ...10:
            return 1
        case ...28:
            return 2
        case ...56:
            return 3
        default:
            return 4
        }
    }

    private var theoryPhaseTitleDE: String {
        "Theorie verstehen"
    }

    private var theoryPhaseTitleEN: String {
        "Understand theory instead of step-by-step explanations"
    }

    private var theoryPhaseDetailDE: String {
        let bullets = theoryMainTopics.de.map { "• \($0)" }.joined(separator: "\n")
        return "\(bullets)\n+ 6 weitere prüfungsrelevante Themen"
    }

    private var theoryPhaseDetailEN: String {
        let bullets = theoryMainTopics.en.map { "• \($0)" }.joined(separator: "\n")
        return "\(bullets)\n+ 6 more exam-relevant topics"
    }

    private var theoryMainTopics: (de: [String], en: [String]) {
        switch selectedExamKey {
        case "lineare_algebra_1", "lineare_algebra", "linear_algebra_1", "linear_algebra":
            return (
                ["Vektorräume", "Matrizenrechnung", "Eigenwerte und Eigenvektoren"],
                ["Vector spaces", "Matrix operations", "Eigenvalues and eigenvectors"]
            )
        case "statistik", "statistics":
            return (
                ["Wahrscheinlichkeitsrechnung", "Verteilungen", "Hypothesentests"],
                ["Probability theory", "Distributions", "Hypothesis tests"]
            )
        case "analysis_1":
            return (
                ["Grenzwerte", "Ableitungsregeln", "Kurvendiskussion"],
                ["Limits", "Derivative rules", "Curve analysis"]
            )
        case "analysis_2":
            return (
                ["Integralrechnung", "Reihen", "Mehrdimensionale Analysis"],
                ["Integral calculus", "Series", "Multivariable analysis"]
            )
        case "numerische_mathematik", "numerical_mathematics":
            return (
                ["Fehlerrechnung", "Newton-Verfahren", "Lineare Gleichungssysteme"],
                ["Error analysis", "Newton's method", "Linear equation systems"]
            )
        case "mathematik_2", "mathematics_2":
            return (
                ["Integralrechnung", "Folgen und Reihen", "Differentialgleichungen"],
                ["Integral calculus", "Sequences and series", "Differential equations"]
            )
        case "mathematik_1", "mathematics_1":
            return (
                ["Komplexe Zahlen", "Gruppen, Ringe und Körper", "Lineare Abbildungen", "Gauss-Verfahren"],
                ["Complex numbers", "Groups, rings, and fields", "Linear maps", "Gaussian elimination"]
            )
        default:
            return (
                [
                    "\(selectedExamTitle): Grundlagen",
                    "\(selectedExamTitle): zentrale Methoden",
                    "\(selectedExamTitle): typische Klausuraufgaben"
                ],
                [
                    "\(selectedExamTitle): fundamentals",
                    "\(selectedExamTitle): core methods",
                    "\(selectedExamTitle): typical exam tasks"
                ]
            )
        }
    }

    private var timelineRanges: [(Int, Int)] {
        let total = max(daysUntilExam, 3)
        let firstEnd = min(max(1, Int(round(Double(total) * 0.2))), total - 2)
        let secondEnd = min(max(firstEnd + 1, Int(round(Double(total) * 0.7))), total - 1)
        return [
            (1, firstEnd),
            (firstEnd + 1, secondEnd),
            (secondEnd + 1, total)
        ]
    }

    private var phases: [PersonalizedPlanPhase] {
        let ranges = timelineRanges
        let simulationsTitleDE = simulationCount == 1 ? "1 realistische Klausur-Simulation" : "\(simulationCount) realistische Klausur-Simulationen"
        let simulationsTitleEN = simulationCount == 1 ? "1 realistic mock exam simulation" : "\(simulationCount) realistic mock exam simulations"

        return [
            PersonalizedPlanPhase(
                startDay: ranges[0].0,
                endDay: ranges[0].1,
                titleDE: theoryPhaseTitleDE,
                titleEN: theoryPhaseTitleEN,
                detailDE: theoryPhaseDetailDE,
                detailEN: theoryPhaseDetailEN,
                icon: "list.number"
            ),
            PersonalizedPlanPhase(
                startDay: ranges[1].0,
                endDay: ranges[1].1,
                titleDE: "Aufgabenroutine aufbauen",
                titleEN: "Build a problem routine",
                detailDE: "• 50 gezielte Übungseinheiten\n• Von Grundlagen bis Klausurniveau\n• Schritt-für-Schritt Lösungen inklusive",
                detailEN: "• 50 focused practice sessions\n• From fundamentals to exam level\n• Step-by-step solutions included",
                icon: "calendar.badge.clock"
            ),
            PersonalizedPlanPhase(
                startDay: ranges[2].0,
                endDay: ranges[2].1,
                titleDE: simulationsTitleDE,
                titleEN: simulationsTitleEN,
                detailDE: "Prüfungsnahe Simulationen unter realistischen Bedingungen.",
                detailEN: "Exam-like simulations under realistic conditions.",
                icon: "doc.text.magnifyingglass"
            )
        ]
    }

    private var stepLabel: String {
        if isGerman {
            return "Schritt \(onboardingManager.currentProgressStep) von \(onboardingManager.progressStepCount)"
        }
        return "Step \(onboardingManager.currentProgressStep) of \(onboardingManager.progressStepCount)"
    }

    private var titleText: String {
        isGerman ? "Okay. Hier ist dein Plan." : "Okay. Here is your plan."
    }

    private var subtitleText: String {
        if isGerman {
            return "Basierend auf deiner Klausur in \(daysUntilExam) Tagen empfehlen wir:"
        }
        return "Based on your exam in \(daysUntilExam) days, we recommend:"
    }

    private var goalTitleText: String {
        if isGerman {
            return "Bestehe \(selectedExamTitle) im ersten Versuch."
        }
        return "Pass \(selectedExamTitle) on your first attempt."
    }

    private var goalSubtitleText: String {
        if isGerman {
            return "Klarer Fokus bis zum Prüfungstag."
        }
        return "A focused path all the way to exam day."
    }

    private var timelineTitleText: String {
        isGerman ? "So erreichen wir das:" : "How we get you there:"
    }

    private var startButtonText: String {
        isGerman ? "Plan starten" : "Start Plan"
    }

    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = geometry.size.width < 400 ? 18 : 24
            let goalCardMaxWidth: CGFloat = min(geometry.size.width * 0.86, 340)
            let timelineCardMaxWidth: CGFloat = min(geometry.size.width * 0.8, 310)
            let timelineItemSpacing: CGFloat = 14

            ZStack {
                AnimatedBackground()

                Circle()
                    .fill(Color.onboardingBlue.opacity(0.11))
                    .frame(width: geometry.size.width * 0.76)
                    .offset(y: geometry.size.height * 0.16)
                    .blur(radius: 2)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Text(stepLabel)
                                .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)

                            Spacer()

                            Text("Onboarding")
                                .font(.system(size: geometry.size.height < 700 ? 13 : 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.onboardingInk)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.92))
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(Color.onboardingGray.opacity(0.22), lineWidth: 1)
                                        )
                                )
                        }

                        segmentedProgress(
                            totalSteps: onboardingManager.progressStepCount,
                            currentStep: onboardingManager.currentProgressStep
                        )
                        .padding(.bottom, 8)

                        Text(titleText)
                            .font(.system(size: geometry.size.height < 700 ? 34 : 38, weight: .bold, design: .rounded))
                            .foregroundColor(Color.onboardingInk)
                            .lineLimit(2)

                        Text(subtitleText)
                            .font(.system(size: geometry.size.height < 700 ? 17 : 19, weight: .medium, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)
                            .lineSpacing(2)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 10) {
                                Text("🎯")
                                    .font(.system(size: 30))

                                Text(goalTitleText)
                                    .font(.system(size: geometry.size.height < 700 ? 24 : 26, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.onboardingInk)
                                    .lineLimit(2)
                            }

                            Text(goalSubtitleText)
                                .font(.system(size: geometry.size.height < 700 ? 15 : 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.onboardingGrayStrong)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .frame(maxWidth: goalCardMaxWidth, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white.opacity(0.9))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .strokeBorder(Color.onboardingGray.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: Color.onboardingInk.opacity(0.1), radius: 10, x: 0, y: 5)
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 2)

                        Text(timelineTitleText)
                            .font(.system(size: geometry.size.height < 700 ? 28 : 30, weight: .bold, design: .rounded))
                            .foregroundColor(Color.onboardingInk)
                            .padding(.top, 6)

                        VStack(spacing: timelineItemSpacing) {
                            ForEach(Array(phases.enumerated()), id: \.element.id) { index, phase in
                                HStack(alignment: .top, spacing: 12) {
                                    VStack(spacing: 0) {
                                        Circle()
                                            .fill(Color.onboardingBlue)
                                            .frame(width: 12, height: 12)
                                    }
                                    .frame(width: 20)

                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(dayRangeLabel(for: phase))
                                            .font(.system(size: geometry.size.height < 700 ? 20 : 21, weight: .bold, design: .rounded))
                                            .foregroundColor(Color.onboardingBlue)

                                        HStack(alignment: .top, spacing: 12) {
                                            Image(systemName: phase.icon)
                                                .font(.system(size: 20, weight: .semibold))
                                                .foregroundColor(Color.onboardingBlue)
                                                .frame(width: 30, height: 30)

                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(isGerman ? phase.titleDE : phase.titleEN)
                                                    .font(.system(size: geometry.size.height < 700 ? 19 : 20, weight: .bold, design: .rounded))
                                                    .foregroundColor(Color.onboardingInk)
                                                    .fixedSize(horizontal: false, vertical: true)

                                                Text(isGerman ? phase.detailDE : phase.detailEN)
                                                    .font(.system(size: geometry.size.height < 700 ? 14 : 15, weight: .medium, design: .rounded))
                                                    .foregroundColor(Color.onboardingGrayStrong)
                                                    .lineSpacing(2)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: timelineCardMaxWidth, alignment: .leading)
                                        .background(
                                            RoundedRectangle(cornerRadius: 22)
                                                .fill(Color.white.opacity(0.9))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 22)
                                                        .strokeBorder(Color.onboardingGray.opacity(0.2), lineWidth: 1)
                                                )
                                                .shadow(color: Color.onboardingInk.opacity(0.08), radius: 8, x: 0, y: 4)
                                        )
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .background(alignment: .leading) {
                                    if index < phases.count - 1 {
                                        GeometryReader { proxy in
                                            DashedVerticalLine()
                                                .stroke(
                                                    Color.onboardingBlue.opacity(0.42),
                                                    style: StrokeStyle(lineWidth: 2, dash: [6, 6])
                                                )
                                                .frame(width: 2, height: max(0, proxy.size.height + timelineItemSpacing))
                                                .offset(x: 9, y: 6)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 10)

                        Spacer(minLength: geometry.size.height < 700 ? 126 : 144)
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, geometry.size.height < 700 ? 20 : 24)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Button(action: {
                        onboardingManager.nextScreen()
                    }) {
                        Text(startButtonText)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 26)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.88)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: Color.onboardingBlue.opacity(0.24), radius: 10, x: 0, y: 5)
                            )
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 10)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 12))
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color.onboardingCanvas.opacity(0.0),
                            Color.onboardingCanvas.opacity(0.92),
                            Color.onboardingCanvas
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
        }
    }

    private func segmentedProgress(totalSteps: Int, currentStep: Int) -> some View {
        let safeTotalSteps = max(totalSteps, 1)

        return HStack(spacing: 8) {
            ForEach(0..<safeTotalSteps, id: \.self) { index in
                Capsule()
                    .fill(
                        index < currentStep
                        ? Color.onboardingBlue
                        : Color.onboardingGray.opacity(0.25)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 7)
            }
        }
    }

    private func dayRangeLabel(for phase: PersonalizedPlanPhase) -> String {
        if phase.startDay == phase.endDay {
            return isGerman ? "TAG \(phase.startDay)" : "DAY \(phase.startDay)"
        }
        return isGerman ? "TAG \(phase.startDay)-\(phase.endDay)" : "DAY \(phase.startDay)-\(phase.endDay)"
    }

    private func titleForExamKey(_ key: String) -> String {
        if isGerman {
            let map: [String: String] = [
                "mathematik_1": "Mathematik I",
                "mathematik_2": "Mathematik II",
                "analysis_1": "Analysis I",
                "analysis_2": "Analysis II",
                "lineare_algebra_1": "Lineare Algebra I",
                "lineare_algebra": "Lineare Algebra",
                "statistik": "Statistik I",
                "numerische_mathematik": "Numerik"
            ]
            if let mapped = map[key] {
                return mapped
            }
        } else {
            let map: [String: String] = [
                "mathematics_1": "Mathematics I",
                "mathematics_2": "Mathematics II",
                "analysis_1": "Analysis I",
                "analysis_2": "Analysis II",
                "linear_algebra_1": "Linear Algebra I",
                "linear_algebra": "Linear Algebra",
                "statistics": "Statistics I",
                "numerical_mathematics": "Numerics"
            ]
            if let mapped = map[key] {
                return mapped
            }
        }

        return prettyTitle(from: key)
    }

    private func prettyTitle(from key: String) -> String {
        key
            .split(separator: "_")
            .map { token in
                switch token {
                case "1": return "I"
                case "2": return "II"
                case "3": return "III"
                default: return token.prefix(1).uppercased() + token.dropFirst().lowercased()
                }
            }
            .joined(separator: " ")
    }
}

struct PremiumTrialOfferOnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared

    private var isGerman: Bool {
        settings.language == .german
    }

    private var stepLabel: String {
        if isGerman {
            return "Schritt \(onboardingManager.currentProgressStep) von \(onboardingManager.progressStepCount)"
        }
        return "Step \(onboardingManager.currentProgressStep) of \(onboardingManager.progressStepCount)"
    }

    private var titleText: Text {
        if isGerman {
            return Text("Wir schenken dir ")
                + Text("3 Tage").foregroundColor(Color.onboardingBlue)
                + Text(" Premiumzugang.")
        }

        return Text("We offer ")
            + Text("3 days").foregroundColor(Color.onboardingBlue)
            + Text(" of premium access, just for you")
    }

    private var subtitleText: String {
        if isGerman {
            return "Starte direkt mit allen Premium-Funktionen. Jetzt ist noch keine Zahlung fällig."
        }
        return "Start right away with all premium features. No payment is due now."
    }

    private var premiumBadgeText: String {
        isGerman ? "Premium-Zugang" : "Premium Access"
    }

    private var footnoteText: String {
        isGerman ? "Jetzt keine Zahlung fällig" : "No Payment Due Now"
    }

    private var buttonText: String {
        isGerman ? "Jetzt für 0,00 € testen" : "Try now for €0.00"
    }

    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = geometry.size.width < 400 ? 18 : 24

            ZStack {
                AnimatedBackground()

                Circle()
                    .fill(Color.onboardingBlue.opacity(0.1))
                    .frame(width: geometry.size.width * 0.7)
                    .offset(y: geometry.size.height * 0.12)
                    .blur(radius: 4)

                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Text(stepLabel)
                            .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)

                        Spacer()

                        Text("Onboarding")
                            .font(.system(size: geometry.size.height < 700 ? 13 : 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.onboardingInk)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 9)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.92))
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(Color.onboardingGray.opacity(0.22), lineWidth: 1)
                                    )
                            )
                    }

                    segmentedProgress(
                        totalSteps: onboardingManager.progressStepCount,
                        currentStep: onboardingManager.currentProgressStep
                    )
                    .padding(.top, 16)

                    Spacer(minLength: geometry.size.height < 700 ? 70 : 96)

                    VStack(spacing: 24) {
                        Text(premiumBadgeText)
                            .font(.system(size: geometry.size.height < 700 ? 14 : 15, weight: .bold, design: .rounded))
                            .foregroundColor(Color.onboardingBlue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.92))
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(Color.onboardingBlue.opacity(0.18), lineWidth: 1)
                                    )
                            )

                        titleText
                            .font(.system(size: geometry.size.height < 700 ? 33 : 38, weight: .bold, design: .rounded))
                            .foregroundColor(Color.onboardingInk)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .frame(maxWidth: 320)

                        Text(subtitleText)
                            .font(.system(size: geometry.size.height < 700 ? 16 : 18, weight: .medium, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                            .frame(maxWidth: 300)
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, geometry.size.height < 700 ? 20 : 24)
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.onboardingGrayStrong)

                        Text(footnoteText)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)
                    }

                    Button(action: {
                        onboardingManager.nextScreen()
                    }) {
                        Text(buttonText)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 26)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.88)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: Color.onboardingBlue.opacity(0.24), radius: 10, x: 0, y: 5)
                            )
                    }
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 12))
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 10)
                .background(
                    LinearGradient(
                        colors: [
                            Color.onboardingCanvas.opacity(0.0),
                            Color.onboardingCanvas.opacity(0.92),
                            Color.onboardingCanvas
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
        }
    }

    private func segmentedProgress(totalSteps: Int, currentStep: Int) -> some View {
        let safeTotalSteps = max(totalSteps, 1)

        return HStack(spacing: 8) {
            ForEach(0..<safeTotalSteps, id: \.self) { index in
                Capsule()
                    .fill(
                        index < currentStep
                        ? Color.onboardingBlue
                        : Color.onboardingGray.opacity(0.25)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 7)
            }
        }
    }
}

struct TrialReminderOnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @State private var animateBell = false

    private var isGerman: Bool {
        settings.language == .german
    }

    private var stepLabel: String {
        if isGerman {
            return "Schritt \(onboardingManager.currentProgressStep) von \(onboardingManager.progressStepCount)"
        }
        return "Step \(onboardingManager.currentProgressStep) of \(onboardingManager.progressStepCount)"
    }

    private var titleText: Text {
        if isGerman {
            return Text("Wir erinnern dich ")
                + Text("1 Tag").foregroundColor(Color.onboardingBlue)
                + Text(" bevor dein Test endet")
        }

        return Text("We'll send you a reminder ")
            + Text("1 day").foregroundColor(Color.onboardingBlue)
            + Text(" before your trial ends")
    }

    private var subtitleText: String {
        if isGerman {
            return "Du wirst rechtzeitig erinnert und behältst die volle Kontrolle."
        }
        return "You'll get a heads-up in time and stay fully in control."
    }

    private var footnoteText: String {
        isGerman ? "Jetzt keine Zahlung fällig" : "No Payment Due Now"
    }

    private var buttonText: String {
        isGerman ? "Kostenlos weiter" : "Continue for FREE"
    }

    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = geometry.size.width < 400 ? 18 : 24

            ZStack {
                AnimatedBackground()

                Circle()
                    .fill(Color.onboardingBlue.opacity(0.1))
                    .frame(width: geometry.size.width * 0.68)
                    .offset(y: geometry.size.height * 0.08)
                    .blur(radius: 4)

                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Text(stepLabel)
                            .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)

                        Spacer()

                        Text("Onboarding")
                            .font(.system(size: geometry.size.height < 700 ? 13 : 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.onboardingInk)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 9)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.92))
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(Color.onboardingGray.opacity(0.22), lineWidth: 1)
                                    )
                            )
                    }

                    segmentedProgress(
                        totalSteps: onboardingManager.progressStepCount,
                        currentStep: onboardingManager.currentProgressStep
                    )
                    .padding(.top, 16)

                    Spacer(minLength: geometry.size.height < 700 ? 54 : 72)

                    VStack(spacing: 24) {
                        Text("🔔")
                            .font(.system(size: geometry.size.height < 700 ? 82 : 94))
                            .rotationEffect(.degrees(animateBell ? 12 : -12), anchor: .top)
                            .scaleEffect(animateBell ? 1.05 : 0.94)
                            .offset(y: animateBell ? -4 : 4)
                            .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: animateBell)

                        titleText
                            .font(.system(size: geometry.size.height < 700 ? 33 : 38, weight: .bold, design: .rounded))
                            .foregroundColor(Color.onboardingInk)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .frame(maxWidth: 320)

                        Text(subtitleText)
                            .font(.system(size: geometry.size.height < 700 ? 16 : 18, weight: .medium, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                            .frame(maxWidth: 300)
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, geometry.size.height < 700 ? 20 : 24)
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.onboardingGrayStrong)

                        Text(footnoteText)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.onboardingGrayStrong)
                    }

                    Button(action: {
                        onboardingManager.nextScreen()
                    }) {
                        Text(buttonText)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 26)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.88)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: Color.onboardingBlue.opacity(0.24), radius: 10, x: 0, y: 5)
                            )
                    }
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 12))
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 10)
                .background(
                    LinearGradient(
                        colors: [
                            Color.onboardingCanvas.opacity(0.0),
                            Color.onboardingCanvas.opacity(0.92),
                            Color.onboardingCanvas
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
            .onAppear {
                animateBell = true
            }
        }
    }

    private func segmentedProgress(totalSteps: Int, currentStep: Int) -> some View {
        let safeTotalSteps = max(totalSteps, 1)

        return HStack(spacing: 8) {
            ForEach(0..<safeTotalSteps, id: \.self) { index in
                Capsule()
                    .fill(
                        index < currentStep
                        ? Color.onboardingBlue
                        : Color.onboardingGray.opacity(0.25)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 7)
            }
        }
    }
}

struct ExamsOnboardingView: View {
    var body: some View {
        MinimalOnboardingPage(
            titleDE: "Klausuren üben",
            titleEN: "Practice Exams",
            subtitleDE: "Trainiere mit realistischen Aufgaben unter Prüfungsbedingungen.",
            subtitleEN: "Train with realistic tasks under exam conditions.",
            pointsDE: [
                "Typische Fragestellungen",
                "Zeitnahes Feedback",
                "Mehr Sicherheit in Prüfungen"
            ],
            pointsEN: [
                "Typical exam questions",
                "Fast feedback",
                "More confidence in exams"
            ],
            symbolName: "graduationcap.fill"
        )
    }
}

struct ExercisesOnboardingView: View {
    var body: some View {
        MinimalOnboardingPage(
            titleDE: "400+ Aufgaben",
            titleEN: "400+ Problems",
            subtitleDE: "Übe gezielt und baue Routine auf.",
            subtitleEN: "Practice with focus and build consistency.",
            pointsDE: [
                "Viele Schwierigkeitsstufen",
                "Thematisch sortiert",
                "Sofort startklar"
            ],
            pointsEN: [
                "Multiple difficulty levels",
                "Topic-based organization",
                "Ready to start instantly"
            ],
            symbolName: "checklist"
        )
    }
}

struct MatrixMethodsOnboardingView: View {
    var body: some View {
        MinimalOnboardingPage(
            titleDE: "Matrix-Rechnen",
            titleEN: "Matrix Skills",
            subtitleDE: "Löse Matrixaufgaben mit nachvollziehbaren Rechenschritten.",
            subtitleEN: "Solve matrix tasks with transparent calculations.",
            pointsDE: [
                "Gauss-Verfahren",
                "Determinanten",
                "Systematische Lösungen"
            ],
            pointsEN: [
                "Gaussian elimination",
                "Determinants",
                "Systematic solutions"
            ],
            symbolName: "tablecells.fill"
        )
    }
}

struct LearningPlanOnboardingView: View {
    var body: some View {
        MinimalOnboardingPage(
            titleDE: "Dein Lernplan",
            titleEN: "Your Learning Plan",
            subtitleDE: "Passe das Lernen an dein Tempo und Ziel an.",
            subtitleEN: "Adapt learning to your pace and goals.",
            pointsDE: [
                "Persönliche Prioritäten",
                "Klare Struktur",
                "Nachhaltiger Fortschritt"
            ],
            pointsEN: [
                "Personal priorities",
                "Clear structure",
                "Sustainable progress"
            ],
            symbolName: "calendar.badge.clock"
        )
    }
}

// MARK: - Monthly Updates Onboarding Screen
struct MonthlyUpdatesOnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @State private var showPaywall = false

    var body: some View {
        MinimalOnboardingPage(
            titleDE: "Immer aktuell bleiben",
            titleEN: "Stay Up to Date",
            subtitleDE: "Monatlich neue Inhalte, Aufgaben und Verbesserungen.",
            subtitleEN: "New content, problems, and improvements every month.",
            pointsDE: [
                "Regelmäßige Inhaltsupdates",
                "Neue Aufgaben und Prüfungen",
                "Kontinuierliche Verbesserungen"
            ],
            pointsEN: [
                "Regular content updates",
                "New exercises and exams",
                "Continuous improvements"
            ],
            symbolName: "sparkles"
        )
        .fullScreenCover(isPresented: $showPaywall) {
            PurchaseView(isPresented: $showPaywall)
                .onDisappear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        onboardingManager.completeOnboarding()
                    }
                }
        }
        .onReceive(onboardingManager.$shouldShowPaywall) { shouldShow in
            if shouldShow {
                showPaywall = true
                onboardingManager.shouldShowPaywall = false
            }
        }
    }
}

// MARK: - Supporting Views
struct AnimatedBackground: View {
    @State private var animateBackground = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.onboardingCanvas,
                        Color.onboardingBlue.opacity(0.14)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Circle()
                    .fill(Color.onboardingBlue.opacity(0.08))
                    .frame(width: geometry.size.width * 0.62)
                    .offset(
                        x: animateBackground ? geometry.size.width * 0.28 : -geometry.size.width * 0.25,
                        y: -geometry.size.height * 0.18
                    )
                    .animation(
                        .easeInOut(duration: 18).repeatForever(autoreverses: true),
                        value: animateBackground
                    )

                Circle()
                    .fill(Color.onboardingInk.opacity(0.05))
                    .frame(width: geometry.size.width * 0.86)
                    .offset(
                        x: animateBackground ? -geometry.size.width * 0.24 : geometry.size.width * 0.2,
                        y: geometry.size.height * 0.32
                    )
                    .animation(
                        .easeInOut(duration: 14).repeatForever(autoreverses: true).delay(2),
                        value: animateBackground
                    )
            }
        }
        .onAppear {
            animateBackground = true
        }
    }
}
