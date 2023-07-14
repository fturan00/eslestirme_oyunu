import 'package:flutter/material.dart';

class ModelKart {
  bool acikMi = false;
  bool eslestiMi = false;
  final int id;
  final String resimYolu;

  ModelKart(this.id, this.resimYolu);
}

class Oyun extends StatefulWidget {
  const Oyun({Key? key}) : super(key: key);

  @override
  State<Oyun> createState() => _OyunState();
}

class _OyunState extends State<Oyun> {
  List<ModelKart> kartlar = [];
  List<int> acilanKartlar = [];
  int eslesenSayisi = 0;
  bool aktif = true;

  @override
  void initState() {
    super.initState();
    kartlariDagit();
  }

  void kartlariDagit() {
    List<int> dagitilanKartlar = List.generate(6, (index) => index + 1);
    dagitilanKartlar.addAll(List.generate(6, (index) => index + 1));
    dagitilanKartlar.shuffle();

    kartlar = dagitilanKartlar
        .map((id) => ModelKart(id, "resimler/$id.png"))
        .toList();
  }

  void kartiAc(int index) {
    if (!kartlar[index].acikMi && !kartlar[index].eslestiMi) {
      setState(() {
        kartlar[index].acikMi = true;
        acilanKartlar.add(index);

        if (acilanKartlar.length == 2) {
          setState(() {
            aktif = false;
          });

          Future.delayed(const Duration(milliseconds: 800), () {
            kontrolEt();
          });
        }
      });
    }
  }

  void kontrolEt() {
    if (kartlar[acilanKartlar[0]].id == kartlar[acilanKartlar[1]].id) {
      setState(() {
        kartlar[acilanKartlar[0]].eslestiMi = true;
        kartlar[acilanKartlar[1]].eslestiMi = true;
        acilanKartlar.clear();
        eslesenSayisi += 2;
        aktif = true;

        if (eslesenSayisi == kartlar.length) {
          showDialog(
            context: context,
            builder: ((context) => AlertDialog(
                  title: const Text("oyun bitti"),
                  content: const Text("tebrikler, tüm kartları eşleştirdiniz!"),
                  actions: [
                    TextButton(
                      child: const Text('yeniden oyna'),
                      onPressed: () {
                        setState(() {
                          kartlariDagit();
                          eslesenSayisi = 0;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
          );
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 20), () {
        setState(() {
          kartlar[acilanKartlar[0]].acikMi = false;
          kartlar[acilanKartlar[1]].acikMi = false;
          acilanKartlar.clear();
          aktif = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title:
            const Text('Kart Eşleştirme Oyunu', style: TextStyle(fontSize: 24)),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: kartlar.map((kart) {
          return GestureDetector(
            onTap: () {
              if (aktif) {
                kartiAc(kartlar.indexOf(kart));
              }
            },
            child: Card(
              color: kart.acikMi
                  ? kart.eslestiMi
                      ? Colors.green
                      : Colors.white
                  : Colors.grey,
              child: Center(
                child: kart.acikMi
                    ? Image.asset(kart.resimYolu)
                    : const Text(
                        'Kart Arka Yüzü',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
