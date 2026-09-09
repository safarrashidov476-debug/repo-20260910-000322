class Channel {
  final String id;
  final String name;
  final String url;
  final String? logo;
  final String group;
  final String category; // 'davlat', 'xususiy', 'hududiy', 'boshqa'

  Channel({
    required this.id,
    required this.name,
    required this.url,
    this.logo,
    required this.group,
    required this.category,
  });

  factory Channel.fromM3U({
    required String name,
    required String url,
    String? logo,
    String? groupTitle,
    required String id,
  }) {
    final group = groupTitle?.trim().isNotEmpty == true ? groupTitle! : 'Boshqa';
    final category = _detectCategory(name, group);
    return Channel(
      id: id,
      name: name.trim(),
      url: url.trim(),
      logo: logo,
      group: group,
      category: category,
    );
  }

  static String _detectCategory(String name, String group) {
    final lowerName = name.toLowerCase();
    final lowerGroup = group.toLowerCase();

    // Hududiy kanallar
    if (lowerName.contains('mtrk') ||
        lowerName.contains('farg') ||
        lowerName.contains('navoiy') ||
        lowerName.contains('qaraqalpaq') ||
        lowerName.contains('andijon') ||
        lowerName.contains('namangan') ||
        lowerName.contains('xorazm') ||
        lowerName.contains('buxoro') ||
        lowerName.contains('samarqand') ||
        lowerName.contains('jizzax') ||
        lowerName.contains('sirdaryo') ||
        lowerName.contains('surxondaryo') ||
        lowerName.contains('qashqadaryo')) {
      return 'hududiy';
    }

    // Davlat / MTRK asosiy kanallar
    if (lowerName.contains("o'zbekiston") ||
        lowerName.contains('ozbekiston') ||
        lowerName.contains('yoshlar') ||
        lowerName.contains('sport') ||
        lowerName.contains('toshkent') ||
        lowerName.contains('mahalla') ||
        lowerName.contains('madaniyat') ||
        lowerName.contains('dunyo') ||
        lowerName.contains('bolajon') ||
        lowerName.contains('navo') ||
        lowerName.contains('kinoteatr') ||
        lowerName.contains('tarix')) {
      return 'davlat';
    }

    // Xususiy kanallar
    if (lowerName.contains('biz') ||
        lowerName.contains('sevimli') ||
        lowerName.contains("zo'r") ||
        lowerName.contains('zor') ||
        lowerName.contains('milliy') ||
        lowerName.contains('nurafshon') ||
        lowerName.contains('renessans') ||
        lowerName.contains('my5') ||
        lowerName.contains('ftv') ||
        lowerName.contains('muz') ||
        lowerName.contains('futbol') ||
        lowerName.contains('cheksiz') ||
        lowerName.contains('dasturxon') ||
        lowerName.contains('makon') ||
        lowerName.contains('taraqqiyot') ||
        lowerName.contains('uzreport')) {
      return 'xususiy';
    }

    return 'boshqa';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'logo': logo,
        'group': group,
        'category': category,
      };

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json['id'] as String,
        name: json['name'] as String,
        url: json['url'] as String,
        logo: json['logo'] as String?,
        group: json['group'] as String,
        category: json['category'] as String,
      );
}
