import SwiftUI

struct AzkarView: View {
    private let categories = azkarData

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("الأذكار").font(.title).bold().foregroundColor(.textP)
                        Text("أذكار الصباح والمساء والأدعية").font(.subheadline).foregroundColor(.textS)
                    }
                    Spacer()
                }.padding(.horizontal, 16).padding(.top, 8)

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(categories) { cat in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(cat.name).font(.title3).bold().foregroundColor(.gold).padding(.horizontal, 16)

                                ForEach(cat.items) { zikr in
                                    ZikrCard(zikr: zikr).padding(.horizontal, 16)
                                }
                            }
                        }
                    }.padding(.vertical, 8)
                }
            }
            .background(Color.bgGradient.overlay(Color.bg))
        }
    }
}

let azkarData: [ZikrCategory] = [
    ZikrCategory(name: "أذكار الصباح", items: [
        Zikr(text: "اللَّهُمَّ إِنِّي أَصْبَحْتُ مِنْكَ فِي نِعْمَةٍ وَعَافِيَةٍ وَسِتْرٍ، فَأَتِمَّ عَلَيَّ نِعْمَتَكَ وَعَافِيَتَكَ وَسِتْرَكَ فِي الدُّنْيَا وَالْآخِرَةِ", count: 1, description: "مرة واحدة"),
        Zikr(text: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ", count: 1, description: "مرة واحدة"),
        Zikr(text: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ", count: 3, description: "3 مرات"),
        Zikr(text: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ", count: 1, description: "مرة واحدة"),
        Zikr(text: "اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ", count: 1, description: "مرة واحدة"),
    ]),
    ZikrCategory(name: "أذكار المساء", items: [
        Zikr(text: "اللَّهُمَّ إِنِّي أَمْسَيْتُ مِنْكَ فِي نِعْمَةٍ وَعَافِيَةٍ وَسِتْرٍ، فَأَتِمَّ عَلَيَّ نِعْمَتَكَ وَعَافِيَتَكَ وَسِتْرَكَ فِي الدُّنْيَا وَالْآخِرَةِ", count: 1, description: "مرة واحدة"),
        Zikr(text: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ", count: 1, description: "مرة واحدة"),
        Zikr(text: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ", count: 3, description: "3 مرات"),
        Zikr(text: "اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ", count: 1, description: "مرة واحدة"),
    ]),
    ZikrCategory(name: "أذكار بعد الصلاة", items: [
        Zikr(text: "أَسْتَغْفِرُ اللَّهَ", count: 3, description: "3 مرات"),
        Zikr(text: "اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ", count: 1, description: "مرة واحدة"),
        Zikr(text: "سُبْحَانَ اللَّهِ", count: 33, description: "33 مرة"),
        Zikr(text: "الْحَمْدُ لِلَّهِ", count: 33, description: "33 مرة"),
        Zikr(text: "اللَّهُ أَكْبَرُ", count: 33, description: "33 مرة"),
        Zikr(text: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ", count: 1, description: "مرة واحدة"),
    ]),
    ZikrCategory(name: "أدعية متنوعة", items: [
        Zikr(text: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ", count: 1, description: "بعد كل صلاة"),
        Zikr(text: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى", count: 1, description: "دعاء"),
        Zikr(text: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ زَوَالِ نِعْمَتِكَ، وَتَحَوُّلِ عَافِيَتِكَ، وَفُجَاءَةِ نِقْمَتِكَ، وَجَمِيعِ سَخَطِكَ", count: 1, description: "دعاء"),
        Zikr(text: "حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ", count: 1, description: "عند الخوف"),
        Zikr(text: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ", count: 1, description: "دعاء"),
    ]),
]
