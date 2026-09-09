# 📺 O'zbek TV Mobile

[![Build APK](https://github.com/YOUR_USERNAME/ozbek_tv_mobile/actions/workflows/build-apk.yml/badge.svg)](https://github.com/YOUR_USERNAME/ozbek_tv_mobile/actions/workflows/build-apk.yml)

**O'zbekiston telekanallarini bepul ko'rish uchun ochiq manbali (open-source) mobil ilova.**

Ilova MTRK davlat telekanallari, xususiy telekanallar va hududiy telekanallarni qo'llab-quvvatlaydi.

## ✨ Xususiyatlar

- 📡 **Live TV** — M3U playlist orqali jonli efir
- 🏛 **Davlat (MTRK)** kanallari
- 🏢 **Xususiy** kanallar
- 🗺 **Hududiy** kanallar
- ❤️ Sevimlilar ro'yxati
- 🔍 Qidiruv
- 🌙 Toza Dark tema
- 📱 Android va iOS (Flutter)
- 🔓 100% ochiq manba, hech qanday hisob yoki obuna yo'q

## 📺 Qo'llab-quvvatlanadigan kanallar (misol)

**Davlat / MTRK:**
- O'zbekiston
- O'zbekiston 24
- Yoshlar
- Sport
- Toshkent
- Mahalla
- Madaniyat va ma'rifat
- Dunyo bo'ylab
- Bolajon
- Navo
- Kinoteatr
- O'zbekiston Tarixi

**Xususiy:**
- BIZ TV / BIZ Cinema / BIZ Music
- Sevimli TV
- Zo'r TV
- Milliy
- Nurafshon TV
- Renessans TV
- MY5
- Futbol TV
- va boshqalar

**Hududiy:**
- Farg'ona MTRK
- Navoiy MTRK
- Qaraqalpaqstan
- va boshqalar

Playlist manbai: [iptv-org/iptv](https://github.com/iptv-org/iptv) (ochiq, jamiyat tomonidan yangilanadi).

## 🚀 O'rnatish va ishga tushirish

### Talablar
- Flutter SDK 3.0+
- Android Studio yoki VS Code
- Android 5.0+ / iOS 12+

### Qadamlar

```bash
# 1. Reponi klonlash
git clone https://github.com/YOUR_USERNAME/ozbek_tv_mobile.git
cd ozbek_tv_mobile

# 2. Platform papkalarini yaratish (birinchi marta)
flutter create . --project-name ozbek_tv_mobile

# 3. Bog'liqliklarni o'rnatish
flutter pub get

# 4. Ishga tushirish
flutter run
```

### APK yig'ish (Android)

```bash
flutter build apk --release
# Natija: build/app/outputs/flutter-apk/app-release.apk
```

## 🛠 Texnologiyalar

| Qism              | Texnologiya          |
|-------------------|----------------------|
| Framework         | Flutter 3            |
| Video player      | video_player + Chewie|
| HTTP              | http                 |
| Saqlash           | shared_preferences   |
| Rasmlar           | cached_network_image |

## 📁 Loyiha tuzilmasi

```
lib/
├── main.dart
├── models/
│   └── channel.dart
├── services/
│   ├── playlist_service.dart
│   └── favorites_service.dart
├── screens/
│   ├── home_screen.dart
│   └── player_screen.dart
└── widgets/
    └── channel_tile.dart
```

## ⚠️ Muhim eslatma

- Ilova **hech qanday kontentni host qilmaydi**. U faqat ochiq internetdagi M3U playlistlarni o'qiydi.
- Kanallar ishlashi internet sifatiga va manba serverlariga bog'liq.
- Ba'zi oqimlar vaqti-vaqti bilan ishlamasligi mumkin — playlist avtomatik yangilanadi.
- Faqat o'quv va shaxsiy foydalanish uchun.

## 🤖 GitHub Actions (Avtomatik APK qurish)

Loyihada `.github/workflows/build-apk.yml` mavjud.

**Nima qiladi:**
- `main` branchga push qilinganda APK avtomatik yig'iladi
- Release yaratilganda APK Release sahifasiga biriktiriladi
- Qo'lda ishga tushirish mumkin (Actions → Build APK → Run workflow)

**Qanday ishlatish:**
1. Reponi GitHubga yuklang
2. `YOUR_USERNAME` ni README dagi badge da o'z usernameingizga almashtiring
3. Actions tabida "Build APK" workflowini ko'rasiz
4. Tayyor APK ni **Artifacts** yoki **Releases** bo'limidan yuklab olasiz

> **Eslatma:** Hozircha debug-signing ishlatiladi. Production uchun keystore qo'shing.

## 📄 Litsenziya

MIT License — erkin foydalanish, o'zgartirish va tarqatish mumkin.

## 🤝 Hissa qo'shish

Pull Request'lar mamnuniyat bilan qabul qilinadi!

1. Fork qiling
2. Feature branch yarating (`git checkout -b feature/yangi-xususiyat`)
3. Commit qiling
4. Push qiling va Pull Request oching

---

**Yaratuvchi:** Ochiq manba jamiyati uchun  
**Manba:** iptv-org + Flutter  
**Yil:** 2026
