import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('tr', 'TR'),
    Locale('en', 'US'),
  ];

  // Common
  String get appName => locale.languageCode == 'tr'
      ? 'Namaz ve Kur\'an Asistanı'
      : 'Prayer & Quran Assistant';

  String get welcome =>
      locale.languageCode == 'tr' ? 'Hoş Geldiniz' : 'Welcome';
  String get settings => locale.languageCode == 'tr' ? 'Ayarlar' : 'Settings';
  String get cancel => locale.languageCode == 'tr' ? 'İptal' : 'Cancel';
  String get save => locale.languageCode == 'tr' ? 'Kaydet' : 'Save';
  String get close => locale.languageCode == 'tr' ? 'Kapat' : 'Close';
  String get loading =>
      locale.languageCode == 'tr' ? 'Yükleniyor...' : 'Loading...';
  String get error => locale.languageCode == 'tr' ? 'Hata' : 'Error';
  String get success => locale.languageCode == 'tr' ? 'Başarılı' : 'Success';

  // Bottom Navigation
  String get home => locale.languageCode == 'tr' ? 'Anasayfa' : 'Home';
  String get qibla => locale.languageCode == 'tr' ? 'Kıble' : 'Qibla';
  String get quran => locale.languageCode == 'tr' ? 'Kur\'an' : 'Quran';
  String get more => locale.languageCode == 'tr' ? 'Daha Fazla' : 'More';

  // Prayer Times
  String get prayerTimes =>
      locale.languageCode == 'tr' ? 'Namaz Vakitleri' : 'Prayer Times';
  String get fajr => locale.languageCode == 'tr' ? 'İmsak' : 'Fajr';
  String get sunrise => locale.languageCode == 'tr' ? 'Güneş' : 'Sunrise';
  String get dhuhr => locale.languageCode == 'tr' ? 'Öğle' : 'Dhuhr';
  String get asr => locale.languageCode == 'tr' ? 'İkindi' : 'Asr';
  String get maghrib => locale.languageCode == 'tr' ? 'Akşam' : 'Maghrib';
  String get isha => locale.languageCode == 'tr' ? 'Yatsı' : 'Isha';

  // Settings Page
  String get appearance =>
      locale.languageCode == 'tr' ? 'Görünüm ve Tema' : 'Appearance & Theme';
  String get useSystemTheme => locale.languageCode == 'tr'
      ? 'Sistem temasını kullan'
      : 'Use system theme';
  String get lightTheme =>
      locale.languageCode == 'tr' ? 'Açık tema' : 'Light theme';
  String get darkTheme =>
      locale.languageCode == 'tr' ? 'Koyu tema' : 'Dark theme';
  String get animations =>
      locale.languageCode == 'tr' ? 'Animasyonlar' : 'Animations';
  String get showAnimations => locale.languageCode == 'tr'
      ? 'Sayfa geçişlerinde animasyon göster'
      : 'Show page transition animations';
  String get language => locale.languageCode == 'tr' ? 'Dil' : 'Language';
  String get turkish => locale.languageCode == 'tr' ? 'Türkçe' : 'Turkish';
  String get english => locale.languageCode == 'tr' ? 'İngilizce' : 'English';
  String get fontSize =>
      locale.languageCode == 'tr' ? 'Yazı Boyutu' : 'Font Size';
  String get fontSizeSmall => locale.languageCode == 'tr' ? 'Küçük' : 'Small';
  String get fontSizeMedium => locale.languageCode == 'tr' ? 'Orta' : 'Medium';
  String get fontSizeLarge => locale.languageCode == 'tr' ? 'Büyük' : 'Large';
  String get fontSizeExtraLarge =>
      locale.languageCode == 'tr' ? 'Çok Büyük' : 'Extra Large';
  String get notifications => locale.languageCode == 'tr'
      ? 'Bildirimler ve Ezan'
      : 'Notifications & Adhan';
  String get prayerNotifications => locale.languageCode == 'tr'
      ? 'Namaz vakti bildirimleri'
      : 'Prayer time notifications';
  String get adhanNotifications => locale.languageCode == 'tr'
      ? 'Ezan bildirimleri (tümü)'
      : 'Adhan notifications (all)';
  String get locationAndQibla =>
      locale.languageCode == 'tr' ? 'Konum ve Kıble' : 'Location & Qibla';
  String get dataManagement =>
      locale.languageCode == 'tr' ? 'Veri Yönetimi' : 'Data Management';
  String get other => locale.languageCode == 'tr' ? 'Diğer' : 'Other';
  String get privacyAndPermissions => locale.languageCode == 'tr'
      ? 'Gizlilik ve izinler'
      : 'Privacy & Permissions';

  // More Page Items
  String get tesbih => locale.languageCode == 'tr' ? 'Tesbih' : 'Tasbih';
  String get prayerCalendar =>
      locale.languageCode == 'tr' ? 'Namaz Takvimi' : 'Prayer Calendar';
  String get quranAndDuas =>
      locale.languageCode == 'tr' ? 'Kur\'an & Dualar' : 'Quran & Duas';
  String get namesOfAllah =>
      locale.languageCode == 'tr' ? '99 İsim' : '99 Names';
  String get prayerTracker =>
      locale.languageCode == 'tr' ? 'Namaz Sayacı' : 'Prayer Tracker';
  String get reminders =>
      locale.languageCode == 'tr' ? 'Hatırlatıcılar' : 'Reminders';
  String get hadith => locale.languageCode == 'tr' ? 'Hadis-i Şerif' : 'Hadith';
  String get prayerGuide =>
      locale.languageCode == 'tr' ? 'Namaz Rehberi' : 'Prayer Guide';
  String get prayerJournal =>
      locale.languageCode == 'tr' ? 'Dua Defteri' : 'Prayer Journal';
  String get ramadan => locale.languageCode == 'tr' ? 'Ramazan' : 'Ramadan';
  String get hajjUmrah =>
      locale.languageCode == 'tr' ? 'Hac & Umre' : 'Hajj & Umrah';
  String get islamicCalendar =>
      locale.languageCode == 'tr' ? 'İslami Takvim' : 'Islamic Calendar';
  String get nearbyMosques =>
      locale.languageCode == 'tr' ? 'Yakındaki Camiler' : 'Nearby Mosques';
  String get favorites =>
      locale.languageCode == 'tr' ? 'Favoriler' : 'Favorites';
  String get support => locale.languageCode == 'tr' ? 'Destek' : 'Support';
  String get accountData =>
      locale.languageCode == 'tr' ? 'Hesap & Veri' : 'Account & Data';
  String get about => locale.languageCode == 'tr' ? 'Hakkında' : 'About';

  // Permissions
  String get permissions =>
      locale.languageCode == 'tr' ? 'İzinler' : 'Permissions';
  String get alarmsAndReminders => locale.languageCode == 'tr'
      ? 'Alarmlar ve Hatırlatıcılar'
      : 'Alarms & Reminders';
  String get granted =>
      locale.languageCode == 'tr' ? 'İzin verildi' : 'Granted';
  String get denied =>
      locale.languageCode == 'tr' ? 'İzin verilmedi' : 'Denied';

  // Common UI
  String get today => locale.languageCode == 'tr' ? 'Bugün' : 'Today';
  String get tomorrow => locale.languageCode == 'tr' ? 'Yarın' : 'Tomorrow';
  String get remaining => locale.languageCode == 'tr' ? 'Kalan' : 'Remaining';
  String get target => locale.languageCode == 'tr' ? 'Hedef' : 'Target';
  String get reset => locale.languageCode == 'tr' ? 'Sıfırla' : 'Reset';
  String get increment =>
      locale.languageCode == 'tr' ? 'Sayaç Artır' : 'Increment';
  String get add => locale.languageCode == 'tr' ? 'Ekle' : 'Add';
  String get edit => locale.languageCode == 'tr' ? 'Düzenle' : 'Edit';
  String get delete => locale.languageCode == 'tr' ? 'Sil' : 'Delete';
  String get share => locale.languageCode == 'tr' ? 'Paylaş' : 'Share';
  String get search => locale.languageCode == 'tr' ? 'Ara' : 'Search';
  String get filter => locale.languageCode == 'tr' ? 'Filtrele' : 'Filter';
  String get back => locale.languageCode == 'tr' ? 'Geri' : 'Back';
  String get next => locale.languageCode == 'tr' ? 'İleri' : 'Next';
  String get done => locale.languageCode == 'tr' ? 'Tamam' : 'Done';
  String get ok => locale.languageCode == 'tr' ? 'Tamam' : 'OK';
  String get yes => locale.languageCode == 'tr' ? 'Evet' : 'Yes';
  String get no => locale.languageCode == 'tr' ? 'Hayır' : 'No';

  // Tesbih/Counter
  String get tasbihCounter =>
      locale.languageCode == 'tr' ? 'Tesbih / Zikirmatik' : 'Tasbih / Counter';
  String get tasbihSettings =>
      locale.languageCode == 'tr' ? 'Tesbih Ayarları' : 'Tasbih Settings';
  String get selectZikr =>
      locale.languageCode == 'tr' ? 'Zikir Seç:' : 'Select Zikr:';
  String get vibration =>
      locale.languageCode == 'tr' ? 'Titreşim' : 'Vibration';
  String get vibrateOnCount => locale.languageCode == 'tr'
      ? 'Her sayımda titreşim'
      : 'Vibrate on each count';

  // Location
  String get location => locale.languageCode == 'tr' ? 'Konum' : 'Location';
  String get locationSettings =>
      locale.languageCode == 'tr' ? 'Konum ayarları' : 'Location settings';
  String get currentCity => locale.languageCode == 'tr'
      ? 'Şu anki şehir ve GPS konumunu yönet'
      : 'Manage current city and GPS location';

  // Time related
  String get now => locale.languageCode == 'tr' ? 'Şimdi' : 'Now';
  String get current => locale.languageCode == 'tr' ? 'Şu anki' : 'Current';
  String get upcoming => locale.languageCode == 'tr' ? 'Gelecek' : 'Upcoming';
  String get past => locale.languageCode == 'tr' ? 'Geçmiş' : 'Past';
  String get countdown =>
      locale.languageCode == 'tr' ? 'Geri Sayım' : 'Countdown';
  String get hour => locale.languageCode == 'tr' ? 'Saat' : 'Hour';
  String get minute => locale.languageCode == 'tr' ? 'Dakika' : 'Minute';
  String get second => locale.languageCode == 'tr' ? 'Saniye' : 'Second';

  // Ramadan
  String get suhoorTime =>
      locale.languageCode == 'tr' ? 'Sahur Vakti' : 'Suhoor Time';
  String get iftarTime =>
      locale.languageCode == 'tr' ? 'İftar Vakti' : 'Iftar Time';
  String get ramadanTips =>
      locale.languageCode == 'tr' ? 'Ramazan İpuçları' : 'Ramadan Tips';
  String get fasting =>
      locale.languageCode == 'tr' ? 'Oruçlusunuz' : 'You are fasting';
  String get notFasting => locale.languageCode == 'tr'
      ? 'Oruç Saatleri Dışında'
      : 'Outside Fasting Hours';
  String get untilIftar =>
      locale.languageCode == 'tr' ? 'İftar vaktine kadar' : 'Until Iftar time';
  String get untilSuhoor =>
      locale.languageCode == 'tr' ? 'Sahur vaktine kadar' : 'Until Suhoor time';
  String get suhoorFajr =>
      locale.languageCode == 'tr' ? 'Sahur (İmsak)' : 'Suhoor (Fajr)';
  String get iftarMaghrib =>
      locale.languageCode == 'tr' ? 'İftar (Akşam)' : 'Iftar (Maghrib)';
  String get ramadanAdvice =>
      locale.languageCode == 'tr' ? 'Ramazan Tavsiyeleri' : 'Ramadan Advice';

  List<String> get ramadanTipsList {
    if (locale.languageCode == 'tr') {
      return [
        'Sahurda bol su için ve hafif yiyecekler tercih edin',
        'İftar açarken acele etmeyin, mideyi yavaş alıştırın',
        'Teravih namazını kaçırmamaya özen gösterin',
        'Kur\'an-ı Kerim okumaya zaman ayırın',
        'Sadaka ve yardımlaşmayı unutmayın',
        'Fazla yağlı ve ağır yemeklerden kaçının',
      ];
    } else {
      return [
        'Drink plenty of water and choose light foods for suhoor',
        'Don\'t rush when breaking fast, let your stomach adjust slowly',
        'Make sure not to miss Taraweeh prayers',
        'Dedicate time to reading the Qur\'an',
        'Remember charity and helping others',
        'Avoid excessively fatty and heavy meals',
      ];
    }
  }

  // Hadith
  String get hadithOfTheDay =>
      locale.languageCode == 'tr' ? 'Günün Hadisi' : 'Hadith of the Day';
  String get hadithCollection =>
      locale.languageCode == 'tr' ? 'Hadis Koleksiyonu' : 'Hadith Collection';
  String get allHadiths =>
      locale.languageCode == 'tr' ? 'Tüm Hadisler' : 'All Hadiths';
  String get addToFavorites =>
      locale.languageCode == 'tr' ? 'Favorilere Ekle' : 'Add to Favorites';
  String get removeFromFavorites => locale.languageCode == 'tr'
      ? 'Favorilerden Kaldır'
      : 'Remove from Favorites';

  // Prayer Tracker
  String get thisWeek => locale.languageCode == 'tr' ? 'Bu Hafta' : 'This Week';
  String get prayed => locale.languageCode == 'tr' ? 'Kılındı' : 'Prayed';
  String get notPrayed =>
      locale.languageCode == 'tr' ? 'Kılınmadı' : 'Not Prayed';
  String get prayedPrayers =>
      locale.languageCode == 'tr' ? 'Kılınan Namazlar' : 'Prayed Prayers';
  String get statistics =>
      locale.languageCode == 'tr' ? 'İstatistikler' : 'Statistics';

  // Prayer Guide
  String get step => locale.languageCode == 'tr' ? 'Adım' : 'Step';

  // Prayer Journal
  String get noPrayersYet => locale.languageCode == 'tr'
      ? 'Henüz dua eklemediniz'
      : 'No prayers added yet';
  String get newPrayer =>
      locale.languageCode == 'tr' ? 'Yeni Dua' : 'New Prayer';
  String get addPrayer =>
      locale.languageCode == 'tr' ? 'Dua Ekle' : 'Add Prayer';
  String get myPrayers =>
      locale.languageCode == 'tr' ? 'Dualarım' : 'My Prayers';
  String get answered =>
      locale.languageCode == 'tr' ? 'Kabul Edildi' : 'Answered';
  String get markAsAnswered => locale.languageCode == 'tr'
      ? 'Kabul Edildi Olarak İşaretle'
      : 'Mark as Answered';
  String get editPrayer =>
      locale.languageCode == 'tr' ? 'Duayı Düzenle' : 'Edit Prayer';
  String get deletePrayer =>
      locale.languageCode == 'tr' ? 'Duayı Sil' : 'Delete Prayer';
  String get enterPrayer => locale.languageCode == 'tr'
      ? 'Duayınızı girin...'
      : 'Enter your prayer...';
  String get title => locale.languageCode == 'tr' ? 'Başlık' : 'Title';
  String get prayer => locale.languageCode == 'tr' ? 'Dua' : 'Prayer';
  String get undo => locale.languageCode == 'tr' ? 'Geri Al' : 'Undo';

  // Names of Allah
  String get meaning => locale.languageCode == 'tr' ? 'Anlam' : 'Meaning';

  // Hajj & Umrah
  String get hajjUmrahGuide => locale.languageCode == 'tr'
      ? 'Hac ve Umre Rehberi'
      : 'Hajj & Umrah Guide';
  String get umrah => locale.languageCode == 'tr' ? 'Umre' : 'Umrah';
  String get hajj => locale.languageCode == 'tr' ? 'Hac' : 'Hajj';

  // Home Page
  String get prayerTimesLoading => locale.languageCode == 'tr'
      ? 'Namaz vakitleri yükleniyor...'
      : 'Loading prayer times...';
  String get errorLoadingTimes => locale.languageCode == 'tr'
      ? 'Vakitler alınırken hata oluştu:'
      : 'Error loading prayer times:';
  String get yourLocation =>
      locale.languageCode == 'tr' ? 'Bulunduğun konum' : 'Your location';
  String get locationAuto =>
      locale.languageCode == 'tr' ? 'Konum (otomatik)' : 'Location (auto)';
  String get nextPrayer =>
      locale.languageCode == 'tr' ? 'Sonraki Vakit' : 'Next Prayer';

  // Month names
  List<String> get monthNames {
    if (locale.languageCode == 'tr') {
      return [
        'Ocak',
        'Şubat',
        'Mart',
        'Nisan',
        'Mayıs',
        'Haziran',
        'Temmuz',
        'Ağustos',
        'Eylül',
        'Ekim',
        'Kasım',
        'Aralık',
      ];
    } else {
      return [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
    }
  }

  // Prayer names in notification context (with context)
  String get imsak => locale.languageCode == 'tr' ? 'İmsak' : 'Fajr';
  String get imsakSabah =>
      locale.languageCode == 'tr' ? 'İmsak / Sabah' : 'Fajr / Dawn';
  String get ogle => locale.languageCode == 'tr' ? 'Öğle' : 'Dhuhr';
  String get ikindi => locale.languageCode == 'tr' ? 'İkindi' : 'Asr';
  String get aksam => locale.languageCode == 'tr' ? 'Akşam' : 'Maghrib';
  String get yatsi => locale.languageCode == 'tr' ? 'Yatsı' : 'Isha';
  String get gunes => locale.languageCode == 'tr' ? 'Güneş' : 'Sunrise';

  // Qibla Page
  String get qiblaPermissionNeeded => locale.languageCode == 'tr'
      ? 'Kıble hesaplaması için konum bilgisine ihtiyaç var.'
      : 'Location is needed to calculate Qibla direction.';
  String get giveLocationPermission => locale.languageCode == 'tr'
      ? 'Kıble hesaplaması için konum izni ver'
      : 'Give location permission for Qibla';
  String get qiblaDirection =>
      locale.languageCode == 'tr' ? 'Kıble Yönü' : 'Qibla Direction';
  String get deviceHeading =>
      locale.languageCode == 'tr' ? 'Cihaz başı' : 'Device heading';
  String get keepDeviceFlat => locale.languageCode == 'tr'
      ? 'Cihazı yatay düzlemde tutun.'
      : 'Keep device on a flat surface.';
  String get calibrateCompass => locale.languageCode == 'tr'
      ? 'Pusulayı düzeltmek için kalibrasyon yapabilirsiniz.'
      : 'You can calibrate to adjust the compass.';
  String get completeCalibration => locale.languageCode == 'tr'
      ? 'Kalibrasyonu tamamla'
      : 'Complete calibration';
  String get calibrationCompleted => locale.languageCode == 'tr'
      ? 'Kalibrasyon tamamlandı.'
      : 'Calibration completed.';
  String get calibrate =>
      locale.languageCode == 'tr' ? 'Kalibre et' : 'Calibrate';
  String get compassCalibration => locale.languageCode == 'tr'
      ? 'Pusula Kalibrasyonu'
      : 'Compass Calibration';
  String get calibrationInstructions => locale.languageCode == 'tr'
      ? 'Cihazınızı aşağıdaki animasyondaki gibi "8" çizer şekilde havada yavaşça hareket ettirin.'
      : 'Move your device slowly in the air drawing a "figure 8" as shown in the animation below.';

  // Cardinal directions
  String get north => locale.languageCode == 'tr' ? 'Kuzey' : 'North';
  String get south => locale.languageCode == 'tr' ? 'Güney' : 'South';
  String get east => locale.languageCode == 'tr' ? 'Doğu' : 'East';
  String get west => locale.languageCode == 'tr' ? 'Batı' : 'West';

  // Short compass letters
  String get northShort => locale.languageCode == 'tr' ? 'K' : 'N';
  String get southShort => locale.languageCode == 'tr' ? 'G' : 'S';
  String get eastShort => locale.languageCode == 'tr' ? 'D' : 'E';
  String get westShort => locale.languageCode == 'tr' ? 'B' : 'W';

  String get compassDirections => locale.languageCode == 'tr'
      ? 'K: Kuzey  •  D: Doğu  •  G: Güney  •  B: Batı'
      : 'N: North  •  E: East  •  S: South  •  W: West';

  // Quran & Duas Page
  String get quranAndDuasTitle =>
      locale.languageCode == 'tr' ? 'Kur\'an & Dualar' : 'Quran & Duas';
  String get searchSurah =>
      locale.languageCode == 'tr' ? 'Sure ara...' : 'Search surah...';
  String get searchDua =>
      locale.languageCode == 'tr' ? 'Dua ara...' : 'Search dua...';
  String get searchFavorite =>
      locale.languageCode == 'tr' ? 'Favori ara...' : 'Search favorite...';
  String get surahs => locale.languageCode == 'tr' ? 'Sureler' : 'Surahs';
  String get duas => locale.languageCode == 'tr' ? 'Dualar' : 'Duas';
  String get favoriteSurahs =>
      locale.languageCode == 'tr' ? 'Favori Sureler' : 'Favorite Surahs';
  String get favoriteDuas =>
      locale.languageCode == 'tr' ? 'Favori Dualar' : 'Favorite Duas';
  String get noFavoritesFound =>
      locale.languageCode == 'tr' ? 'Favori bulunamadı' : 'No favorites found';
  String get noResultsFound =>
      locale.languageCode == 'tr' ? 'Sonuç bulunamadı' : 'No results found';
  String get errorLoadingSurahs => locale.languageCode == 'tr'
      ? 'Sureler yüklenirken hata oluştu:'
      : 'Error loading surahs:';
  String get verse => locale.languageCode == 'tr' ? 'ayet' : 'verse';
  String get verses => locale.languageCode == 'tr' ? 'ayet' : 'verses';
  String get mecca => locale.languageCode == 'tr' ? 'Mekke' : 'Meccan';
  String get medina => locale.languageCode == 'tr' ? 'Medine' : 'Medinan';

  // Dua Titles & Subtitles
  String get subhanekeTitle =>
      locale.languageCode == 'tr' ? 'Sübhaneke Duası' : 'Subhaneke Prayer';
  String get subhanekeSubtitle => locale.languageCode == 'tr'
      ? 'Namazın başlangıcında okunur'
      : 'Recited at the beginning of prayer';
  String get tahiyyatTitle =>
      locale.languageCode == 'tr' ? 'Tahiyyat (Ettahiyyâtü)' : 'Tahiyyat';
  String get tahiyyatSubtitle => locale.languageCode == 'tr'
      ? 'Namazların oturuşlarında okunur'
      : 'Recited during sitting in prayer';
  String get salliBarikTitle => locale.languageCode == 'tr'
      ? 'Salli Barik Duaları'
      : 'Salli Barik Prayers';
  String get salliBarikSubtitle => locale.languageCode == 'tr'
      ? 'Namazların son oturuşunda okunur'
      : 'Recited in the final sitting of prayer';
  String get barikTitle =>
      locale.languageCode == 'tr' ? 'Barik Duası' : 'Barik Prayer';
  String get barikSubtitle => locale.languageCode == 'tr'
      ? 'Namazların son oturuşunda okunur'
      : 'Recited in the final sitting of prayer';
  String get rabbenaTitle =>
      locale.languageCode == 'tr' ? 'Rabbena Duaları' : 'Rabbena Prayers';
  String get rabbenaSubtitle => locale.languageCode == 'tr'
      ? 'Her türlü dilek için okunur'
      : 'Recited for all kinds of wishes';
  String get ayetelkursiTitle =>
      locale.languageCode == 'tr' ? 'Âyetel Kürsî' : 'Ayatul Kursi';
  String get ayetelkursiSubtitle => locale.languageCode == 'tr'
      ? 'Korunma ve bereket için okunur'
      : 'Recited for protection and abundance';
  String get rabbiYessirTitle => locale.languageCode == 'tr'
      ? 'Rabbi Yessir Duası'
      : 'Rabbi Yessir Prayer';
  String get rabbiYessirSubtitle => locale.languageCode == 'tr'
      ? 'İşlere başlarken kolaylık için'
      : 'For ease when starting tasks';
  String get seyyidulIstigfarTitle => locale.languageCode == 'tr'
      ? 'Seyyidü\'l İstiğfar'
      : 'Sayyidul Istighfar';
  String get seyyidulIstigfarSubtitle => locale.languageCode == 'tr'
      ? 'En faziletli istiğfar duası'
      : 'The most virtuous prayer for forgiveness';
  String get hasbunallahTitle =>
      locale.languageCode == 'tr' ? 'Hasbünâllâhu' : 'Hasbunallahu';
  String get hasbunallahSubtitle => locale.languageCode == 'tr'
      ? 'Sıkıntılı anlarda tevekkül için'
      : 'For reliance on Allah during troubled times';
  String get kunut1Title =>
      locale.languageCode == 'tr' ? 'Kunut Duası 1' : 'Qunut Prayer 1';
  String get kunut1Subtitle => locale.languageCode == 'tr'
      ? 'Vitir namazı duası'
      : 'Witr prayer supplication';
  String get kunut2Title =>
      locale.languageCode == 'tr' ? 'Kunut Duası 2' : 'Qunut Prayer 2';
  String get kunut2Subtitle => locale.languageCode == 'tr'
      ? 'Vitir namazı duası'
      : 'Witr prayer supplication';
  String get yemekTitle =>
      locale.languageCode == 'tr' ? 'Yemek Duası' : 'Meal Prayer';
  String get yemekSubtitle => locale.languageCode == 'tr'
      ? 'Yemekten sonra okunur'
      : 'Recited after meals';

  // Welcome Page
  String get welcomeTitle => locale.languageCode == 'tr'
      ? 'Namaz ve Kur\'an Asistanı'
      : 'Prayer & Quran Assistant';
  String get prayerTimesFeature =>
      locale.languageCode == 'tr' ? 'Namaz Vakitleri' : 'Prayer Times';
  String get prayerTimesDesc => locale.languageCode == 'tr'
      ? 'Anlık namaz vakitleri'
      : 'Real-time prayer times';
  String get qiblaCompass =>
      locale.languageCode == 'tr' ? 'Kıble Pусуласı' : 'Qibla Compass';
  String get qiblaCompassDesc => locale.languageCode == 'tr'
      ? 'Doğru kıble yönü'
      : 'Accurate Qibla direction';
  String get holyQuran =>
      locale.languageCode == 'tr' ? 'Kur\'an-ı Kerim' : 'Holy Quran';
  String get holyQuranDesc => locale.languageCode == 'tr'
      ? 'Kutsal kitabımızı okuyun'
      : 'Read our holy book';
  String get remindersDesc => locale.languageCode == 'tr'
      ? 'Önemli anlar için'
      : 'For important moments';
  String get locationPermissionNeeded => locale.languageCode == 'tr'
      ? 'Namaz vakitlerini doğru gösterebilmemiz için konum iznine ihtiyacımız olacak.'
      : 'We need location permission to show accurate prayer times.';
  String get letsStart =>
      locale.languageCode == 'tr' ? 'Başlayalım' : 'Let\'s Start';
  String get dataNotStored => locale.languageCode == 'tr'
      ? 'Kişisel verileriniz saklanmaz.'
      : 'Your personal data is not stored.';

  // Location Permission Page
  String get allowLocationAccess => locale.languageCode == 'tr'
      ? 'Konum erişimine izin ver'
      : 'Allow location access';
  String get locationPermissionDescription => locale.languageCode == 'tr'
      ? 'Bulunduğun şehre göre namaz vakitlerini otomatik hesaplayabilmemiz için konum iznine ihtiyacımız var. Bu izin sadece cihazında kullanılır, verilerin saklanmaz.'
      : 'We need location permission to automatically calculate prayer times based on your city. This permission is only used on your device, no data is stored.';
  String get continueWithoutPermission => locale.languageCode == 'tr'
      ? 'İzin vermeden devam et'
      : 'Continue without permission';
  String get deviceLocationServiceOff => locale.languageCode == 'tr'
      ? 'Cihaz konum servisi kapalı.'
      : 'Device location service is off.';
  String get locationPermissionDenied => locale.languageCode == 'tr'
      ? 'Konum izni reddedildi.'
      : 'Location permission denied.';
  String get locationPermissionPermanentlyDenied => locale.languageCode == 'tr'
      ? 'Konum izni kalıcı olarak reddedildi. Lütfen ayarlardan açıp tekrar deneyin.'
      : 'Location permission permanently denied. Please enable it in settings and try again.';
  String get notificationPermissionPermanentlyDenied =>
      locale.languageCode == 'tr'
      ? 'Bildirim izni kalıcı olarak reddedildi. Ezan alarmları için ayarlardan izin vermeniz gerekmektedir.'
      : 'Notification permission permanently denied. You need to grant permission in settings for adhan alarms.';
  String get notificationPermissionRequired => locale.languageCode == 'tr'
      ? 'Ezan alarmlarının çalışması için bildirim izni gereklidir.'
      : 'Notification permission is required for adhan alarms to work.';
  String get locationAndNotificationPermission => locale.languageCode == 'tr'
      ? 'Konum ve Bildirim İzni'
      : 'Location and Notification Permission';
  String get locationAndNotificationPermissionDescription =>
      locale.languageCode == 'tr'
      ? 'Doğru namaz vakitleri için konumunuza, ezan alarmları için bildirimlere erişmemiz gerekiyor.'
      : 'We need access to your location for accurate prayer times and notifications for adhan alarms.';
  String get grantPermissions =>
      locale.languageCode == 'tr' ? 'İzinleri Ver' : 'Grant Permissions';

  // Surah Detail Page
  String get errorLoadingSurah => locale.languageCode == 'tr'
      ? 'Sure yüklenirken hata oluştu:'
      : 'Error loading surah:';
  String ayahNumber(int number) =>
      locale.languageCode == 'tr' ? '$number. ayet' : 'Verse $number';

  // Settings Page - Extended
  String get searchInSettings => locale.languageCode == 'tr'
      ? 'Ayarlarda ara...'
      : 'Search in settings...';
  String get quickAccess =>
      locale.languageCode == 'tr' ? 'Hızlı Erişim' : 'Quick Access';
  String get theme => locale.languageCode == 'tr' ? 'Tema' : 'Theme';
  String get backup => locale.languageCode == 'tr' ? 'Yedekle' : 'Backup';
  String get followPhoneTheme => locale.languageCode == 'tr'
      ? 'Telefonunun tema ayarına göre'
      : 'According to your phone theme';

  // Notifications - Extended
  String get prayerBarInNotification => locale.languageCode == 'tr'
      ? 'Bildirim çubuğunda namaz çubuğu'
      : 'Prayer bar in notification tray';
  String get prayerBarDescription => locale.languageCode == 'tr'
      ? 'Bugünkü vakitleri bildirim çubuğunda sürekli göster'
      : 'Show today\'s prayer times permanently in notification bar';
  String get prayerNotificationsDesc => locale.languageCode == 'tr'
      ? 'Her vakitten önce hatırlatma gönder'
      : 'Send reminder before each prayer time';
  String get adhanNotificationsAll => locale.languageCode == 'tr'
      ? 'Ezan bildirimleri (tümü)'
      : 'Adhan notifications (all)';
  String get adhanNotificationsDesc => locale.languageCode == 'tr'
      ? 'Tüm namaz vakitlerinde ezan sesini aç/kapat'
      : 'Turn on/off adhan sound for all prayer times';
  String get whichPrayersAdhan => locale.languageCode == 'tr'
      ? 'Hangi vakitlerde ezan okunsun?'
      : 'Which prayers should play adhan?';
  String get fajrWithTranslation =>
      locale.languageCode == 'tr' ? 'İmsak / Sabah (Fajr)' : 'Fajr / Dawn';
  String get dhuhrWithTranslation =>
      locale.languageCode == 'tr' ? 'Öğle (Dhuhr)' : 'Dhuhr (Noon)';
  String get asrWithTranslation =>
      locale.languageCode == 'tr' ? 'İkindi (Asr)' : 'Asr (Afternoon)';
  String get maghribWithTranslation =>
      locale.languageCode == 'tr' ? 'Akşam (Maghrib)' : 'Maghrib (Sunset)';
  String get ishaWithTranslation =>
      locale.languageCode == 'tr' ? 'Yatsı (Isha)' : 'Isha (Night)';
  String get notificationTiming => locale.languageCode == 'tr'
      ? 'Bildirim zamanlaması'
      : 'Notification timing';
  String get notificationTime =>
      locale.languageCode == 'tr' ? 'Bildirim zamanı' : 'Notification time';
  String get atPrayerTime =>
      locale.languageCode == 'tr' ? 'Vakit girdiğinde' : 'At prayer time';
  String minutesBefore(int minutes) => locale.languageCode == 'tr'
      ? '$minutes dakika önce'
      : '$minutes minutes before';
  String get adhanVolume =>
      locale.languageCode == 'tr' ? 'Ezan ses seviyesi' : 'Adhan volume level';
  String get vibrateOnNotification => locale.languageCode == 'tr'
      ? 'Bildirimde telefon titresin'
      : 'Vibrate on notification';
  String get adhanSound =>
      locale.languageCode == 'tr' ? 'Ezan sesi' : 'Adhan sound';
  String get silentHours =>
      locale.languageCode == 'tr' ? 'Sessiz saatler' : 'Silent hours';
  String get silentHoursDesc => locale.languageCode == 'tr'
      ? 'Belirli saatlerde bildirimleri sustur'
      : 'Mute notifications during specific hours';
  String get silentHoursStart => locale.languageCode == 'tr'
      ? 'Sessiz saatler başlangıcı'
      : 'Silent hours start';
  String get silentHoursEnd => locale.languageCode == 'tr'
      ? 'Sessiz saatler bitişi'
      : 'Silent hours end';
  String get setSilentHours => locale.languageCode == 'tr'
      ? 'Sessiz saatleri ayarla'
      : 'Set silent hours';
  String get clearAllAdhan => locale.languageCode == 'tr'
      ? 'Tüm ezan bildirimlerini temizle'
      : 'Clear all adhan notifications';
  String get clearAllAdhanDesc => locale.languageCode == 'tr'
      ? 'Bugün için planlanmış ezan bildirimlerini iptal et'
      : 'Cancel scheduled adhan notifications for today';
  String get allAdhanCleared => locale.languageCode == 'tr'
      ? 'Tüm ezan bildirimleri temizlendi.'
      : 'All adhan notifications cleared.';
  String get checkAdhanPermissions => locale.languageCode == 'tr'
      ? 'Ezan bildirim izinlerini kontrol et'
      : 'Check adhan notification permissions';
  String get checkAdhanPermissionsDesc => locale.languageCode == 'tr'
      ? 'Bazı cihazlarda "kesin alarmlar" izni kapalıysa bildirimler çalışmayabilir.'
      : 'On some devices, notifications may not work if "exact alarms" permission is disabled.';
  String get checkNotificationSettingsInfo => locale.languageCode == 'tr'
      ? 'Bildirim ayarlarını cihazının sistem menüsünden kontrol edebilirsin.'
      : 'You can check notification settings from your device\'s system menu.';
  String get testAdhanNow => locale.languageCode == 'tr'
      ? 'Ezan bildirimi test et (hemen)'
      : 'Test adhan notification (now)';
  String get testAdhanNowDesc => locale.languageCode == 'tr'
      ? 'Hemen bir ezan bildirimi gösterir'
      : 'Shows an adhan notification immediately';
  String get testAdhanSent => locale.languageCode == 'tr'
      ? 'Test ezanı hemen gönderildi.'
      : 'Test adhan sent immediately.';
  String get testAdhanIn5Seconds => locale.languageCode == 'tr'
      ? '5 saniye sonra ezan bildirimi'
      : 'Adhan notification in 5 seconds';
  String get testAdhanIn5SecondsDesc => locale.languageCode == 'tr'
      ? '5 saniye sonrası için zamanlanmış ezan bildirimi test eder'
      : 'Tests scheduled adhan notification in 5 seconds';
  String get testAdhanScheduledInfo => locale.languageCode == 'tr'
      ? 'Test ezanı 5 saniye sonrası için zamanlandı. Ekranı kilitle ve bekle.'
      : 'Test adhan scheduled for 5 seconds. Lock screen and wait.';
  String get dailyReminder =>
      locale.languageCode == 'tr' ? 'Günlük hatırlatma' : 'Daily reminder';
  String get dailyReminderDesc => locale.languageCode == 'tr'
      ? 'Kur\'an okuma veya dua için günlük uyarı'
      : 'Daily reminder for Quran reading or prayer';

  // Location & Qibla - Extended
  String get qiblaCalibration => locale.languageCode == 'tr'
      ? 'Kıble yönü kalibrasyonu'
      : 'Qibla direction calibration';
  String get calibrateAndTest => locale.languageCode == 'tr'
      ? 'Pusulanı kalibre et ve test et'
      : 'Calibrate and test compass';

  // Data Management - Extended
  String get clearCache =>
      locale.languageCode == 'tr' ? 'Önbelleği temizle' : 'Clear cache';
  String get clearCacheDesc => locale.languageCode == 'tr'
      ? 'Geçici verileri sil'
      : 'Delete temporary data';
  String get clearCacheConfirm => locale.languageCode == 'tr'
      ? 'Geçici veriler silinecek. Ayarlarınız korunacak.'
      : 'Temporary data will be deleted. Your settings will be preserved.';
  String get clear => locale.languageCode == 'tr' ? 'Temizle' : 'Clear';
  String get cacheCleared =>
      locale.languageCode == 'tr' ? 'Önbellek temizlendi.' : 'Cache cleared.';
  String get backupData =>
      locale.languageCode == 'tr' ? 'Verileri yedekle' : 'Backup data';
  String get backupDataDesc => locale.languageCode == 'tr'
      ? 'Ayarlarını ve verilerini kaydet'
      : 'Save your settings and data';
  String settingsBackedUp(int count) => locale.languageCode == 'tr'
      ? '$count ayar yedeklendi.'
      : '$count settings backed up.';
  String get resetAllData =>
      locale.languageCode == 'tr' ? 'Tüm verileri sıfırla' : 'Reset all data';
  String get resetAllDataDesc => locale.languageCode == 'tr'
      ? 'Tüm ayarlar ve veriler silinir'
      : 'All settings and data will be deleted';
  String get resetAllDataConfirm => locale.languageCode == 'tr'
      ? 'TÜM ayarlar, veriler ve tercihler silinecek. Bu işlem geri alınamaz!'
      : 'ALL settings, data and preferences will be deleted. This cannot be undone!';
  String get allDataReset => locale.languageCode == 'tr'
      ? 'Tüm veriler sıfırlandı. Uygulama yeniden başlatılıyor...'
      : 'All data reset. Restarting app...';

  // Language Selection
  String get languageSelection => locale.languageCode == 'tr'
      ? 'Dil Seçimi / Language Selection'
      : 'Language Selection / Dil Seçimi';
  String get languageChanged => locale.languageCode == 'tr'
      ? 'Dil Türkçe olarak değiştirildi'
      : 'Language changed to English';
  String get privacyPermissionsDesc => locale.languageCode == 'tr'
      ? 'Konum, bildirimler vb.'
      : 'Location, notifications, etc.';

  // About - Extended
  String get appVersion =>
      locale.languageCode == 'tr' ? 'Uygulama sürümü' : 'App version';
  String get developer =>
      locale.languageCode == 'tr' ? 'Geliştirici' : 'Developer';
  String get rateApp =>
      locale.languageCode == 'tr' ? 'Uygulamayı değerlendir' : 'Rate the app';
  String get rateAppDesc => locale.languageCode == 'tr'
      ? 'Google Play Store\'da yorum bırak'
      : 'Leave a review on Google Play Store';
  String get openingPlayStore => locale.languageCode == 'tr'
      ? 'Play Store açılıyor...'
      : 'Opening Play Store...';
  String get privacyPolicy =>
      locale.languageCode == 'tr' ? 'Gizlilik politikası' : 'Privacy policy';
  String get showingPrivacyPolicy => locale.languageCode == 'tr'
      ? 'Gizlilik politikası gösteriliyor...'
      : 'Showing privacy policy...';
  String get termsOfUse =>
      locale.languageCode == 'tr' ? 'Kullanım koşulları' : 'Terms of use';
  String get showingTermsOfUse => locale.languageCode == 'tr'
      ? 'Kullanım koşulları gösteriliyor...'
      : 'Showing terms of use...';

  // Adhan Sound Names
  String get adhanSoundDefault =>
      locale.languageCode == 'tr' ? 'Varsayılan' : 'Default';
  String get adhanSoundMecca => locale.languageCode == 'tr' ? 'Mekke' : 'Mecca';
  String get adhanSoundMedina =>
      locale.languageCode == 'tr' ? 'Medine' : 'Medina';
  String get adhanSoundIstanbul =>
      locale.languageCode == 'tr' ? 'İstanbul' : 'Istanbul';
  String get adhanSoundEgypt => locale.languageCode == 'tr' ? 'Mısır' : 'Egypt';

  // Prayer Times Bar
  String get loadingPrayerTimes => locale.languageCode == 'tr'
      ? 'Namaz vakitleri yükleniyor...'
      : 'Loading prayer times...';
  String get todaysPrayerTimes => locale.languageCode == 'tr'
      ? 'Bugünkü namaz vakitleri'
      : 'Today\'s prayer times';
  String get cannotLoadTodaysTimes => locale.languageCode == 'tr'
      ? 'Bugünkü vakitler alınamadı:'
      : 'Cannot load today\'s times:';
  String get prayerTimeTitle =>
      locale.languageCode == 'tr' ? 'Namaz Vakti' : 'Prayer Time';
  String get prayerTimeBody =>
      locale.languageCode == 'tr' ? 'vakti girdi.' : 'time has arrived.';

  // Developer Menu
  String get developerMenu =>
      locale.languageCode == 'tr' ? 'Geliştirici Menüsü' : 'Developer Menu';
  String get adhanSoundAndNotificationTests => locale.languageCode == 'tr'
      ? 'Ezan sesi ve bildirim testleri'
      : 'Adhan sound and notification tests';
  String get stopSound =>
      locale.languageCode == 'tr' ? 'Sesi Durdur' : 'Stop Sound';
  String get testSound =>
      locale.languageCode == 'tr' ? 'Sesi Test Et' : 'Test Sound';
  String get notificationTestInfo => locale.languageCode == 'tr'
      ? 'Bildirim Testi (5 sn sonra çalar)'
      : 'Notification Test (plays in 5s)';
  String get pendingNotifications => locale.languageCode == 'tr'
      ? 'Bekleyen Bildirimler'
      : 'Pending Notifications';
  String get checkPendingNotifications => locale.languageCode == 'tr'
      ? 'Bekleyen Bildirimleri Kontrol Et'
      : 'Check Pending Notifications';
  String get resetNotificationSettings => locale.languageCode == 'tr'
      ? 'Bildirim ve Ezan Ayarlarını Sıfırla'
      : 'Reset Notification & Adhan Settings';
  String get resetSettingsConfirm => locale.languageCode == 'tr'
      ? 'Tüm bildirim ve ezan ayarları varsayılana dönecek. Onaylıyor musunuz?'
      : 'All notification and adhan settings will be reset to default. Are you sure?';
  String get settingsReset =>
      locale.languageCode == 'tr' ? 'Ayarlar sıfırlandı' : 'Settings reset';
  String get developerMenuOpened => locale.languageCode == 'tr'
      ? 'Geliştirici menüsü açıldı'
      : 'Developer menu opened';
  String get notificationScheduled => locale.languageCode == 'tr'
      ? 'bildirimi 5 saniye sonrasına planlandı. Uygulamayı arka plana atın.'
      : 'notification scheduled for 5 seconds later. Background the app.';

  // Notification Settings
  String get notificationSettings => locale.languageCode == 'tr'
      ? 'Bildirim Ayarları'
      : 'Notification Settings';
  String get prayerTimesNotification => locale.languageCode == 'tr'
      ? 'Namaz Vakti Bildirimleri'
      : 'Prayer Time Notifications';

  // About Page
  String get aboutAppTitle =>
      locale.languageCode == 'tr' ? 'Uygulama hakkında' : 'About the app';
  String get aboutAppDescription => locale.languageCode == 'tr'
      ? 'Namaz vakitlerini, kıble yönünü ve Kur\'an surelerini tek bir yerden takip edebilmen için tasarlandı. Konumuna göre günlük namaz vakitlerini gösterir, ezan bildirimleriyle seni uyarır ve Kur\'an & dua içerikleri sunar.'
      : 'Designed for you to track prayer times, Qibla direction, and Quran surahs in one place. It shows daily prayer times based on your location, alerts you with adhan notifications, and offers Quran & prayer content.';
  String get privacyTitle =>
      locale.languageCode == 'tr' ? 'Gizlilik' : 'Privacy';
  String get privacyDescription => locale.languageCode == 'tr'
      ? 'Konum verilerin sadece cihazında kullanılır; sunucuya gönderilmez veya saklanmaz. Namaz vakitleri için yalnızca koordinat bilgisiyle dış API\'lere istek yapılır.'
      : 'Your location data is used only on your device; it is not sent to or stored on a server. Only coordinate information is used to request prayer times from external APIs.';
  String get version => locale.languageCode == 'tr' ? 'Sürüm' : 'Version';
  // Islamic Calendar
  String get islamicCalendarTitle =>
      locale.languageCode == 'tr' ? 'İslami Takvim' : 'Islamic Calendar';
  String get hijriCalendarAndDays => locale.languageCode == 'tr'
      ? 'Hicri takvim ve önemli günler'
      : 'Hijri calendar and important days';
  String get hijriCalendarDesc => locale.languageCode == 'tr'
      ? 'Bulunduğun şehre göre günlük hicri tarih ve aylık namaz takvimi Aladhan servisinden alınır.'
      : 'Daily Hijri date and monthly prayer calendar based on your city are fetched from Aladhan service.';

  String get gregorianDateLoading => locale.languageCode == 'tr'
      ? 'Miladi tarih: Yükleniyor...'
      : 'Gregorian date: Loading...';
  String get gregorianDateError => locale.languageCode == 'tr'
      ? 'Miladi tarih: hata'
      : 'Gregorian date: error';
  String get gregorianDate =>
      locale.languageCode == 'tr' ? 'Miladi tarih' : 'Gregorian date';
  String get hijriDate =>
      locale.languageCode == 'tr' ? 'Hicri tarih' : 'Hijri date';
  String get noDataForMonth => locale.languageCode == 'tr'
      ? 'Bu ay için veri bulunamadı'
      : 'No data found for this month';
  String get monthlyCalendarError => locale.languageCode == 'tr'
      ? 'Aylık takvim yüklenemedi'
      : 'Could not load monthly calendar';

  // Nearby Mosques
  String get nearbyMosquesTitle =>
      locale.languageCode == 'tr' ? 'Yakın Camiler' : 'Nearby Mosques';
  String get closestMosques => locale.languageCode == 'tr'
      ? 'Bulunduğun yere en yakın camiler'
      : 'Mosques closest to your location';
  String get nearbyMosquesDesc => locale.languageCode == 'tr'
      ? 'Konumuna göre yakınındaki camileri listelemek için harita servisi ve cami verileri eklendiğinde burada görebileceksin.'
      : 'You will see nearby mosques listed here based on your location when map service and mosque data are added.';
  String get locationLoading =>
      locale.languageCode == 'tr' ? 'Konum alınıyor...' : 'Getting location...';
  String get locationError => locale.languageCode == 'tr'
      ? 'Konum alınamadı'
      : 'Could not get location';
  String get nearbyMosquesLoading => locale.languageCode == 'tr'
      ? 'Yakın camiler aranıyor...'
      : 'Searching for nearby mosques...';
  String get nearbyMosquesError => locale.languageCode == 'tr'
      ? 'Yakın camiler alınamadı'
      : 'Could not fetch nearby mosques';
  String get noMosquesFound => locale.languageCode == 'tr'
      ? 'Bu bölgede kayıtlı cami bulunamadı. Aşağıdaki haritadan Google Haritalar üzerinde arama yapabilirsin.'
      : 'No registered mosques found in this area. You can search on Google Maps using the map below.';
  String get distance => locale.languageCode == 'tr' ? 'Mesafe' : 'Distance';
  String get openInMap =>
      locale.languageCode == 'tr' ? 'Haritada aç' : 'Open in Map';
  String get mapError =>
      locale.languageCode == 'tr' ? 'Harita açılamadı.' : 'Could not open map.';

  // Zikir Options
  String get subhanallah =>
      locale.languageCode == 'tr' ? 'Sübhanallah' : 'Subhanallah';
  String get alhamdulillah =>
      locale.languageCode == 'tr' ? 'Elhamdülillah' : 'Alhamdulillah';
  String get allahuEkber =>
      locale.languageCode == 'tr' ? 'Allahu Ekber' : 'Allahu Akbar';
  String get laIlaheIllallah =>
      locale.languageCode == 'tr' ? 'La ilahe illallah' : 'La ilaha illallah';
  String get estagfirullah =>
      locale.languageCode == 'tr' ? 'Estağfirullah' : 'Astaghfirullah';
  String get subhanallahiVeBihamdihi => locale.languageCode == 'tr'
      ? 'Sübhanallahi ve bihamdihi'
      : 'Subhanallahi wa bihamdihi';
  String get laHavle => locale.languageCode == 'tr'
      ? 'La havle vela kuvvete illa billah'
      : 'La hawla wa la quwwata illa billah';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['tr', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
