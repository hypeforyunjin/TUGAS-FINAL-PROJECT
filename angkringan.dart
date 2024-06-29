import 'dart:io';

class Angkringan {
  List<Map<String, dynamic>> transactionHistory = [];
  List<Map<String, dynamic>> queue = [];
  Map<int, String> menuAngkringan = {
    1: 'Mie ayam',
    2: 'Kopi Hitam',
    3: 'Ayam geprek',
    4: 'Kopi Susu',
    5: 'Chicken Katsu',
  };
  Map<int, double> hargaMenu = {
    1: 20000,
    2: 30000,
    3: 35000,
    4: 40000,
    5: 25000,
  };

  void tampilkanJudul() {
    print('=========== Angkringan & Workspace ===========');
    print('Tanggal dan Waktu: ${DateTime.now()}');
  }

  void tampilkanMenu() {
    print('Menu Angkringan:');
    menuAngkringan.forEach((nomor, nama) {
      print('$nomor. $nama - Rp ${hargaMenu[nomor]}');
    });
  }

  void tambahTransaksi(String namaPelanggan, List<int> nomorMenuList, List<int> jumlahList) {
    List<Map<String, dynamic>> transaksiItems = [];
    double totalPembayaran = 0;

    for (int i = 0; i < nomorMenuList.length; i++) {
      int nomorMenu = nomorMenuList[i];
      int jumlah = jumlahList[i];

      if (!menuAngkringan.containsKey(nomorMenu)) {
        print('Nomor menu tidak valid.');
        return;
      }

      String menu = menuAngkringan[nomorMenu]!;
      double harga = hargaMenu[nomorMenu]! * jumlah;
      totalPembayaran += harga;

      transaksiItems.add({
        'menu': menu,
        'jumlah': jumlah,
        'harga': harga,
      });
    }

    DateTime now = DateTime.now();
    int nomorAntrian = queue.length + 1;

    var transaksi = {
      'nomorAntrian': nomorAntrian,
      'tanggal': now.toIso8601String(),
      'namaPelanggan': namaPelanggan,
      'items': transaksiItems,
      'totalPembayaran': totalPembayaran,
    };

    queue.add(transaksi);
    transactionHistory.add(transaksi);

    tampilkanStruk(nomorAntrian, namaPelanggan, now, transaksiItems, totalPembayaran);
    simpanKeCSV();
  }

  void tampilkanStruk(int nomorAntrian, String namaPelanggan, DateTime tanggal, List<Map<String, dynamic>> items, double totalPembayaran) {
    print('\n======== Nota Pesanan ========');
    print('No. Antrian: $nomorAntrian');
    print('Nama Pemesan: $namaPelanggan');
    print('Tanggal Pesan: $tanggal');
    print('Pesanan:');
    for (var item in items) {
      print('  - ${item['menu']} x${item['jumlah']} - Rp ${item['harga']}');
    }
    print('Total Pembayaran: Rp $totalPembayaran');
    stdout.write('Bayar: Rp ');
    double? bayar = double.tryParse(stdin.readLineSync()!);
    if (bayar != null && bayar >= totalPembayaran) {
      double kembali = bayar - totalPembayaran;
      print('Kembali: Rp $kembali');
    } else {
      print('Pembayaran tidak valid atau kurang.');
    }
    print('=============================\n');
  }

  void simpanKeCSV() {
    File file = File('transaksi.csv');
    String csvContent = 'nomorAntrian,namaPelanggan,tanggal,menu,jumlah,harga,totalPembayaran\n';

    for (var transaction in transactionHistory) {
      for (var item in transaction['items']) {
        csvContent +=
            '${transaction['nomorAntrian']},${transaction['namaPelanggan']},${transaction['tanggal']},${item['menu']},${item['jumlah']},${item['harga']},${transaction['totalPembayaran']}\n';
      }
    }
    file.writeAsStringSync(csvContent);
  }

  void hapusAntrian() {
    if (queue.isNotEmpty) {
      var pesanan = queue.removeAt(0);
      print('Pesanan atas nama ${pesanan['namaPelanggan']} telah dihapus dari antrian.\n');
    } else {
      print('Antrian kosong.\n');
    }
  }

  void listAntrian() {
    if (queue.isNotEmpty) {
      print('Antrian Pesanan:');
      for (var i = 0; i < queue.length; i++) {
        print('${i + 1}. Nama: ${queue[i]['namaPelanggan']}, Pesanan: ${queue[i]['items'].map((item) => item['menu']).join(', ')}, Total: Rp ${queue[i]['totalPembayaran']}, Waktu: ${queue[i]['tanggal']}');
      }
    } else {
      print('Tidak ada antrian.\n');
    }
  }

  void cariTransaksi(String namaPelanggan) {
    List<Map<String, dynamic>> hasilPencarian = transactionHistory.where((transaksi) => transaksi['namaPelanggan'] == namaPelanggan).toList();

    if (hasilPencarian.isNotEmpty) {
      print('Hasil pencarian untuk $namaPelanggan:');
      for (var transaksi in hasilPencarian) {
        print('No. Antrian: ${transaksi['nomorAntrian']}');
        print('Nama Pemesan: ${transaksi['namaPelanggan']}');
        print('Tanggal Pesan: ${transaksi['tanggal']}');
        print('Pesanan: ${transaksi['items'].map((item) => item['menu']).join(', ')}');
        print('Total Pembayaran: Rp ${transaksi['totalPembayaran']}');
        print('----------------------------------------');
      }
    } else {
      print('Tidak ada transaksi ditemukan untuk $namaPelanggan.');
    }
  }

  void urutkanAntrian() {
    queue.sort((a, b) => a['namaPelanggan'].compareTo(b['namaPelanggan']));
    print('Antrian telah diurutkan berdasarkan nama pelanggan.');
  }
}
