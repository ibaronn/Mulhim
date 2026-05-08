import SwiftUI

struct QuranView: View {
    @State private var surahs: [Surah] = []
    @State private var selectedSurah: SurahDetail?
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            Group {
                if let detail = selectedSurah {
                    surahDetailView(detail)
                } else if isLoading {
                    VStack(spacing: 12) {
                        ProgressView().tint(.gold); Text("جاري تحميل القرآن...").foregroundColor(.textS)
                    }
                } else {
                    surahList
                }
            }
            .background(Color.bgGradient.overlay(Color.bg))
            .task { await fetchSurahs() }
        }
    }

    var surahList: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("القرآن الكريم").font(.title).bold().foregroundColor(.textP)
                    Text("اختر سورة للقراءة").font(.subheadline).foregroundColor(.textS)
                }
                Spacer()
            }.padding(.horizontal, 16).padding(.top, 8)

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    ForEach(surahs) { surah in
                        Button {
                            Task { await fetchSurahDetail(number: surah.number) }
                        } label: {
                            GlassCard {
                                HStack {
                                    ZStack {
                                        Circle().fill(Color.gold.opacity(0.12)).frame(width: 40, height: 40)
                                        Text("\(surah.number)").font(.caption).bold().foregroundColor(.gold)
                                    }
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(surah.name).font(.headline).foregroundColor(.textP)
                                        Text(surah.englishName).font(.caption).foregroundColor(.textS)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("\(surah.numberOfAyahs) آية").font(.caption).foregroundColor(.textS)
                                        Text(surah.revelationType == "Meccan" ? "مكية" : "مدنية").font(.caption2).foregroundColor(.gold)
                                    }
                                }.padding(14)
                            }
                        }.buttonStyle(.plain).padding(.horizontal, 16)
                    }
                }.padding(.vertical, 8)
            }
        }
    }

    func surahDetailView(_ detail: SurahDetail) -> some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button { selectedSurah = nil } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.right").font(.headline)
                        Text("العودة").font(.subheadline)
                    }.foregroundColor(.gold)
                }
                Spacer()
                Text(detail.name).font(.headline).foregroundColor(.textP)
                Spacer()
                Color.clear.frame(width: 80)
            }.padding(.horizontal, 16).padding(.vertical, 8)

            Divider()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    // Bismillah
                    Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                        .font(.title2).fontWeight(.medium).foregroundColor(.gold)
                        .padding(.vertical, 20)

                    ForEach(detail.ayahs) { ayah in
                        VStack(spacing: 4) {
                            Text(ayah.text)
                                .font(.system(size: 22))
                                .foregroundColor(.textP)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Text("\(ayah.number)")
                                .font(.caption2).foregroundColor(.textS)
                        }
                        .padding(.vertical, 8)
                    }
                }.padding(.horizontal, 12)
            }
        }
    }

    func fetchSurahs() async {
        guard let u = URL(string: "https://api.alquran.cloud/v1/surah") else { return }
        do {
            let (d, _) = try await URLSession.shared.data(from: u)
            let r = try JSONDecoder().decode(SurahResponse.self, from: d)
            surahs = r.data
        } catch { print("Surah fetch error: \(error)") }
        isLoading = false
    }

    func fetchSurahDetail(number: Int) async {
        guard let u = URL(string: "https://api.alquran.cloud/v1/surah/\(number)") else { return }
        do {
            let (d, _) = try await URLSession.shared.data(from: u)
            let r = try JSONDecoder().decode(SurahDetailResponse.self, from: d)
            selectedSurah = r.data
        } catch { print("Surah detail error: \(error)") }
    }
}
