import 'cafe.dart';
import 'dart:io';

void main() {
  var angkringan = Angkringan();
  angkringan.tampilkanJudul();

  while (true) {
    printMenuUtama();

    stdout.write('Pilih opsi: ');
    int? pilihan = int.tryParse(stdin.readLineSync()!);

    switch (pilihan) {
      case 1:
        angkringan.tampilkanMenu();
        break;
      case 2:
        tambahTransaksi(angkringan);
        break;
      case 3:
        angkringan.hapusAntrian();
        break;
      case 4:
        angkringan.listAntrian();
        break;
      case 5:
        cariTransaksi(angkringan);
        break;
      case 6:
        angkringan.urutkanAntrian();
        break;
      case 7:
        print('Terima kasih telah menggunakan aplikasi Angkringan & Workspace.');
        return;
      default:
        print('Pilihan tidak valid.');
    }
    print('\nTekan enter untuk melanjutkan...');
    stdin.readLineSync();
    clearScreen();
  }
}

void clearScreen() {
  if (Platform.isWindows) {
    Process.runSync("cmd", ['/c', 'cls']);
  } else {
    Process.runSync("clear", []);
  }
}

void printMenuUtama() {
  print('1. Tampilkan Menu Cafe');
  print('2. Tambah Transaksi');
  print('3. Hapus Antrian');
  print('4. List Antrian');
  print('5. Cari Transaksi');
  print('6. Urutkan Antrian');
  print('7. Keluar');
}

void tambahTransaksi(Angkringan angkringan) {
  stdout.write('Masukkan nama pelanggan: ');
  String namaPelanggan = stdin.readLineSync()!;

  List<int> nomorMenuList = [];
  List<int> jumlahList = [];

  while (true) {
    stdout.write('Masukkan nomor menu yang ingin dipesan (tekan enter untuk selesai): ');
    String? inputNomorMenu = stdin.readLineSync();
    if (inputNomorMenu == null || inputNomorMenu.isEmpty) {
      break;
    }
    int? nomorMenu = int.tryParse(inputNomorMenu);
    if (nomorMenu == null || !angkringan.menuAngkringan.containsKey(nomorMenu)) {
      print('Nomor menu tidak valid.');
      continue;
    }

    stdout.write('Masukkan jumlah: ');
    int? jumlah = int.tryParse(stdin.readLineSync()!);
    if (jumlah == null || jumlah <= 0) {
      print('Jumlah tidak valid.');
      continue;
    }

    nomorMenuList.add(nomorMenu);
    jumlahList.add(jumlah);
  }

  if (nomorMenuList.isNotEmpty && jumlahList.isNotEmpty) {
    angkringan.tambahTransaksi(namaPelanggan, nomorMenuList, jumlahList);
  } else {
    print('Tidak ada pesanan yang ditambahkan.');
  }
}

void cariTransaksi(Angkringan angkringan) {
  stdout.write('Masukkan nama pelanggan yang ingin dicari: ');
  String namaPelanggan = stdin.readLineSync()!;
  angkringan.cariTransaksi(namaPelanggan);
}
