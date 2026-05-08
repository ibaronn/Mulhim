import SwiftUI

struct QuranView: View {
    @State private var surahs: [Surah] = []
    @State private var selectedSurah: Surah?
    @State private var loading = true

    var body: some View {
        Group {
            if let surah = selectedSurah {
                SurahDetailView(surah: surah, back: { selectedSurah = nil })
            } else {
                surahList
            }
        }
        .background(AppBackground())
    }

    private var surahList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                SectionHeader(title: "القرآن الكريم", subtitle: "اختر سورة للقراءة")
                    .padding(.top, 12)

                if loading {
                    ProgressView().tint(.gold).padding(.top, 40)
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(surahs) { surah in
                            Button {
                                selectedSurah = surah
                            } label: {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle().fill(Color.greenIslamic.opacity(0.08)).frame(width: 44, height: 44)
                                        Text("\(surah.number)").font(.system(size: 15, weight: .bold)).foregroundColor(.gold)
                                    }
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(surah.name).font(.system(size: 17, weight: .bold)).foregroundColor(.textDark)
                                        Text("\(surah.englishName) - \(surah.numberOfAyahs) آية").font(.caption).foregroundColor(.textMuted)
                                    }
                                    Spacer()
                                    Text(surah.revelationType == "Meccan" ? "مكية" : "مدنية")
                                        .font(.system(size: 11, weight: .medium)).foregroundColor(.gold)
                                        .padding(.horizontal, 8).padding(.vertical, 3)
                                        .background(Color.gold.opacity(0.08), in: RoundedRectangle(cornerRadius: 6))
                                }
                                .padding(.horizontal, 20).padding(.vertical, 10)
                            }
                            .buttonStyle(.plain)
                            Divider().padding(.leading, 78)
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .padding(.bottom, 24)
        }
        .task {
            await fetchSurahs()
        }
    }

    func fetchSurahs() async {
        guard let url = URL(string: "https://api.alquran.cloud/v1/surah") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let r = try JSONDecoder().decode(SurahResponse.self, from: data)
            surahs = r.data
            loading = false
        } catch { loading = false }
    }
}

struct SurahDetailView: View {
    let surah: Surah
    let back: () -> Void
    @State private var detail: SurahDetail?
    @State private var loading = true

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: back) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.right").font(.system(size: 14))
                        Text("العودة").font(.system(size: 15, weight: .medium))
                    }.foregroundColor(.gold)
                }
                Spacer()
                Text(surah.name).font(.system(size: 18, weight: .bold)).foregroundColor(.textDark)
                Spacer()
            }
            .padding(.horizontal, 20).padding(.vertical, 12)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    // Bismillah
                    Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                        .font(.system(size: 24)).foregroundColor(.gold).padding(20)

                    if loading {
                        ProgressView().tint(.gold).padding(.top, 20)
                    } else if let detail = detail {
                        ForEach(detail.ayahs) { ayah in
                            AyaCard(ayah: ayah)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .background(AppBackground())
        .task {
            await fetchDetail()
        }
    }

    func fetchDetail() async {
        guard let url = URL(string: "https://api.alquran.cloud/v1/surah/\(surah.number)") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let r = try JSONDecoder().decode(SurahDetailResponse.self, from: data)
            detail = r.data
            loading = false
        } catch { loading = false }
    }
}
