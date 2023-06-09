import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streetanimals/constans/material_color.dart';
import 'package:streetanimals/constans/text_pref.dart';
import 'package:streetanimals/models/user_info.dart';
import 'package:streetanimals/riverpod_management.dart';
import 'package:streetanimals/utils/db_firebase.dart';
import '../classes/app_bar_profile.dart';

class profilePage extends ConsumerStatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<profilePage> createState() => _profilePage();
}

class _profilePage extends ConsumerState <profilePage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pagecount = PageController();
  Future<Userinfo?> ?user; // Değişkeni tanımladık

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {

  }

  bool ?isLike ; //şimdilik

  @override
  Widget build(BuildContext context) {
    isLike = false;
    var size = MediaQuery.of(context).size;
    var profileRiv = ref.read(profileRiverpod);
    var authRiv = ref.read(AuthenticationServiceRiverpod);
    Future<Userinfo?> userpre = dbFirebase().getUser(FirebaseAuth.instance.currentUser?.uid);

    return SafeArea(
      child: Scaffold(
        appBar: appBarCustom(title: 'Profil'),
        body: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: FutureBuilder(
            future: userpre,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                Userinfo? user = snapshot.data;
                return Column(
                  children: [
                    SizedBox(
                      height: size.width * 0.35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              Text(
                                "${user?.followers_list?.length}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text("Takipçi"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: size.width * 0.15,
                                      width:  size.width * 0.15,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:size.width * 0.14,
                                        width: size.width * 0.14,
                                        child: Image.network("https://cdn-icons-png.flaticon.com/512/3135/3135715.png")//Hero
                                    ),
                                    Positioned(
                                      bottom: 0.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          height: 17,
                                          width: 50,
                                          color: Colors.black,
                                          child: Center(
                                            child: Text(
                                              user?.rewards_list?.length == 0
                                              ? "Acemi"
                                              : "Usta",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]
                              ),
                              Text("${user?.name}"),
                              Text("${user?.surname}"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              Text(
                                "${user?.follow_list?.length}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text("Takip"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  user?.id != FirebaseAuth.instance.currentUser?.uid
                    ?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        profilCustomBtn("Mesaj"),
                        SizedBox(width: 10),
                        profilCustomBtn("Takip Et"),
                        SizedBox(width: 10),
                        profilCustomBtn(""),
                      ],
                    )
                  : Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      profilCustomBtn("Düzenle"),
                    ],
                  ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          profileBox(user, size, "Gönderi"),
                          profileBox(user, size, "Rozetler"),
                          profileBox(user, size, "Bağış"),
                        ],
                      ),
                    ), //info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        profileBtn(context, size),
                      ],
                    ),
                    SizedBox(
                      height: 500,
                      child: PageView(
                          onPageChanged: (value) {
                            if(value == 1) {
                              profileRiv.setChoice("ilanlar");
                            }else{
                              profileRiv.setChoice("gönderiler");
                            }
                          },
                          controller: _pagecount,
                          scrollDirection: Axis.horizontal,
                          children:[
                            firstPage(context, size, user),
                            secondPage(context, size)
                          ]
                      ),
                    ),
                  ],
                );
              }else{
                return Text("Giriş yapılamadı Hacker çık git çabuk");
              }
            },
          ),
        ),
      ),
    );
  }

  Widget profileBox(Userinfo ?user, Size size, String title) {
    var Cheight = size.width * 0.26;
    var Cwidth = size.width * 0.25;
    IconData ?myIcon ;
    if(title == "Gönderi"){
      myIcon = Icons.photo_camera;
    }else if(title == "Rozetler"){
      myIcon = Icons.account_balance;
    }else{
      myIcon = Icons.animation_outlined;
    }
    return GestureDetector(
      onTap: () {
        print("selamun looo");
      },
      child: SizedBox(
        height: Cheight,
        width: Cwidth,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorConstants.pink2,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 8,
                    offset: Offset(3, 3),
                  ),
                ]
            ),
            child: Stack(
                children: [
                  CustomPaint(
                    size: size,
                    painter: shadowProfileBox(),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          myIcon,
                          color: Colors.white,
                          size: 30,
                        ),
                        textMod("$title"),
                        title == "Gönderi"
                              ? textMod("${user?.post_list?.length}")
                            : title == "Rozetler"
                              ? const textMod("widget")
                            : title == "Bağış"
                              ?textMod("${user?.donate} PC")
                            :textMod("?")
                      ],
                    ),
                  ),
                ]
            )
        ),
      ),
    );
  }
  Widget profilCustomBtn(String title) {
    IconData ?myicon ;
    if(title == "Mesaj"){
      myicon = Icons.mail ;
    }else if(title == "Takip Et"){
      myicon = Icons.add;
    }else if(title == "Takip") {
      myicon = Icons.minimize ;
    } else {
      myicon = Icons.more_horiz;
    }
    return InkWell(
      onTap: () {
        print("viiyyğğhh");
      },
      child: DecoratedBox(decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8)
      ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  myicon,
                  color : Colors.white,
                  size: 14,
                ),
                SizedBox(width: 7),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget profileBtn(BuildContext context, Size size) {
    var profileRiv = ref.watch(profileRiverpod);
    if (profileRiv.choice == "gönderiler"){
      profileRiv.setpre(size.width * 0.21);
    }else{
      profileRiv.setpre(size.width * 0.599);
    }
    return SizedBox(
      width: size.width,
      height: 34,
      child: Stack(
        children: [
          AnimatedPositioned(
            bottom: 0,
            left: profileRiv.pre,
            duration: Duration(milliseconds: 200),
            curve: Curves.linear,
            child:const SizedBox(
              width: 90,
              child: Divider(
                color: Colors.black,
                thickness: 2.5,
              ),
            ) ,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () {
                    _pagecount.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.linear);
                    profileRiv.setChoice("Gönderiler");
                  },
                  child: const Text(
                    "Gönderiler",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ),
              GestureDetector(
                  onTap: () {
                    _pagecount.animateTo(size.width, duration: Duration(milliseconds: 400), curve: Curves.linear);
                    profileRiv.setChoice("ilanlar");
                  },
                  child: const Text(
                    "İlanlar",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget firstPage(BuildContext context, Size size, Userinfo? user) {
    return SizedBox(
      height: user!.post_list!.length / 2 * 20,
      width: size.width,
      child: GridView.count(
          padding: EdgeInsets.symmetric(vertical:  5, horizontal: 25),
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.87,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          controller: _scrollController,
          children: List.generate(user!.post_list!.length, (index) {
            return SizedBox(
              height: 20,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1),
                    boxShadow:  const [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 7,
                          offset: Offset(3, 3)
                      )
                    ]
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/image/dog1.png",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Row(
                            children: const [
                              Icon(
                                Icons.favorite,
                                color: ColorConstants.pink,
                                size: 17,
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.comment_rounded,
                                color: ColorConstants.pink,
                                size: 17,
                              ),
                            ],
                          ),
                          const Text(
                            "333 Beğeni",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          )
      ),
    );
  }
  Widget secondPage(BuildContext context, Size size) {
    return SizedBox(
      height: 200,
      width: size.width,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: size.height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorConstants.lightpink,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                      child: Image.asset(
                          "assets/image/dog1.png"
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.2,
                      width: size.width * 0.47,
                      child: Column(
                        children: [
                          SizedBox(
                            height : size.height * 0.16,
                            width: size.width * 0.47,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Text("Ad"),
                                    Text("Soyad"),
                                    Text("il/ilçe"),
                                    Text("Yayın Tarihi"),
                                  ],
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Text("Gas"),
                                    Text("Jhefert"),
                                    Text(
                                      "İstanbul/Beşiktaş",
                                      style: TextStyle(
                                          fontSize: 12
                                      ),
                                    ),
                                    Text("08/06/2023"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.remove_red_eye,
                                size: 17,
                              ),
                              Text("48 Görünülenme")
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          );
        },
      ),
    );
  }
}

class shadowProfileBox extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var height = size.height * 0.85 ;
    var width = size.width ;
    Paint paint = Paint()
      ..color = Colors.white38
      ..isAntiAlias = true
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 5)
      ..style = PaintingStyle.fill ;
    Path myPath = Path();
    myPath.moveTo(width, height * 0.2);

    var firststartpoint = Offset(width , - height * 0.01); // eğim noktası
    var firstendpoint = Offset(width * 0.7 , 0); // son NOkta

    var secondstartpoint = Offset(width* 0.2, height * 0.1);
    var secondendpoint = Offset(0, height);

    var editstartpoint = Offset(width * 0.001, height * 0.95);
    var editendpoint = Offset(width * 0.035 , height * 0.945);

    var thirdstartpoint = Offset(width* 0.35, height * 0.65);
    var thirdendpoint = Offset(width, height * 0.80);

    var fourthstartpoint = Offset(width , 0);
    var fourthendpoint = Offset(width , height * 0.1);

    myPath.quadraticBezierTo(firststartpoint.dx, firststartpoint.dy, firstendpoint.dx, firstendpoint.dy);
    myPath.quadraticBezierTo(secondstartpoint.dx, secondstartpoint.dy, secondendpoint.dx, secondendpoint.dy);
    myPath.quadraticBezierTo(editstartpoint.dx, editstartpoint.dy, editendpoint.dx, editendpoint.dy);
    myPath.quadraticBezierTo(thirdstartpoint.dx, thirdstartpoint.dy, thirdendpoint.dx, thirdendpoint.dy);
    myPath.quadraticBezierTo(fourthstartpoint.dx, fourthstartpoint.dy, fourthendpoint.dx, fourthendpoint.dy);

    myPath.lineTo(width , height * 0.9);
    canvas.drawPath(myPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true; //Herhangi bir güncelleme durumunda boyama işlemini tekrar yapar
  }
}
