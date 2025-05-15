import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../shared/constants/color_constant.dart';
import '../../../../../shared/widgets/others/dynamic_app_bar.dart';

class InfoAppScreen extends StatefulWidget {
  const InfoAppScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InfoAppView();
}

class _InfoAppView extends State<InfoAppScreen> {
  String versionNumber = "-.-.-";
  String packageName = "-";
  String buildNumber = "-";

  @override
  void initState() {
    super.initState();

    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionNumber = packageInfo.version;
      packageName = packageInfo.packageName;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        backgroundColor: ColorConstant.secondary,
        title: Text("Info Aplikasi", style: TextStyle(color: Colors.black, fontSize: 18)),
        titleAlignment: Alignment.centerLeft,
        trailingWidgets: [
          IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.black54)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "GEBOK",
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: ColorConstant.primary),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Google e-Book",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorConstant.gray),
                  ),
                ),
                const SizedBox(height: 35),
                _buildSection(
                  "Tentang",
                  "Aplikasi GEBOK atau Google e-Book adalah aplikasi yang saya kembangkan untuk melatih keterampilan "
                      "Flutter saya terutama dalam menerapkan Clean Architecture dan dengan gabungan arsitektur DDD "
                      "(Domain-Drive Design), serta projek ini melatih saya dalam mengelola state dengan BLoC pattern "
                      "menggunakan library bloc. Dalam projek ini saya iseng mencoba menggunakan OAuth 2.0 dari google "
                      "secara gratis berguna untuk membuat pengalaman saya dalam menerapkan metode login menggunakan OAuth"
                      " seperti Google walau masih belum sempurna, namun tidak apa karena saya sudah memiliki pondasi "
                      "kelak pasti akan sempurna 😁.",
                ),
                _buildSection("Developer", "Sofyan Gio Verdiansyah (VerdIXI)"),
                _buildSection("Nama paket", packageName),
                _buildSection("Versi aplikasi", versionNumber),
                _buildSection("Angka pembuatan", buildNumber),
                _buildSection("Di buat pada", "12 Mei 2025"),
                _buildSection("Di buat di", "Madiun"),
                Text(
                  "Sosmed developer",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: ColorConstant.black),
                ),
                const SizedBox(height: 15),
                _buildSosmedLink("Github", "https://github.com/gioVerdiansyah", "gioVerdiansyah"),
                _buildSosmedLink("LinkedIn", "https://linkedin.com/in/gioverdiansyah", "gioverdiansyah"),
                _buildSosmedLink("Instagram", "https://instagram.com/_verdiansyah", "_verdiansyah"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorConstant.black),
        ),
        Text(content, textAlign: TextAlign.justify),
        const SizedBox(height: 35),
      ],
    );
  }

  Widget _buildSosmedLink(String platform, String link, String initial) {
    final Uri linkUri = Uri.parse(link);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$platform: ",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorConstant.black),
        ),
        GestureDetector(
          onTap: () => launchUrl(linkUri),
          child: Text(
            initial,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorConstant.primary),
          ),
        )
      ],
    );
  }
}
