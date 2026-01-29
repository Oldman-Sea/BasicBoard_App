import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'post_detail_screen.dart';
import 'post_editor_screen.dart';
import 'search_screen.dart';



const kBrand = Color(0xFF77451E);

class Post {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;

  Post({required this.id, required this.title, required this.content, required this.createdAt});
}

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // 더미 데이터
    final posts = <Post>[
      Post(
        id: 1,
        title: '테스트1',
        content: '테스트용글 1',
        createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
      Post(
        id: 2,
        title: '테스트2',
        content: '테스트용글 2',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Post(
        id: 3,
        title: '테스트3',
        content: '테스트3 이거 길어지면 잘리는거 제대로 되는지 테스트 한번 해보자 아아아아아아아 아직 짧나 두줄이 생각보다 길지도 아직도 안되나 이젠 되지? 되는거 맞지? 제발 맞다고 해줘 제발.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        leadingWidth: 160,

        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/service_logo.png',
              height: 48,
              fit: BoxFit.contain,
            ),
          ),
        ),
          actions:[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },

            icon: SvgPicture.asset(
        'assets/icons/search.svg',
        width: 26,
        height: 26,
            ),

          ),
      ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Center(
                child:Text(
                '나의 B 로그',
                style: TextStyle(
                  fontFamily: 'NotoSerifKR',
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: kBrand,
                  letterSpacing: 0.5,
                ),
              ),
              ),
              const SizedBox(height: 18),

              Expanded(
                child: ListView.separated(
                  itemCount: posts.length,
                  separatorBuilder: (_, __) => const Divider(
                      height: 24,
                      color:const Color(0xFFECEDEE)),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(
                      title: post.title,
                      preview: post.content.replaceAll(RegExp(r'\s+'), ' ').trim(),
                      timeLabel: _formatFeedTime(post.createdAt),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostDetailScreen(
                              title: post.title,
                              content: post.content,
                              createdAt: post.createdAt,
                              // hasPrev/hasNext는 일단 더미로
                              hasPrev: index > 0,
                              hasNext: index < posts.length - 1,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: 200,
          height: 58,
          child: FloatingActionButton.extended(
            backgroundColor: kBrand,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(500), // ✅ 더 둥글게(완전 pill)
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PostEditorScreen.create()),
              );
            },

            icon: SvgPicture.asset(
              'assets/icons/pen.svg',
              width: 18,
              height: 18,
            ),
            label: const Text(
              '기록하기',
              style: TextStyle(fontWeight: FontWeight.w700,color:Colors.white,fontSize: 20),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

  }




  static String _formatFeedTime(DateTime dt) {
    final now = DateTime.now();

    final isSameDay =
        now.year == dt.year && now.month == dt.month && now.day == dt.day;

    if (isSameDay) {
      final hh = dt.hour.toString().padLeft(2, '0');
      final mm = dt.minute.toString().padLeft(2, '0');
      return '$hh:$mm';
    }

    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y.$m.$d';
  }
}

class PostCard extends StatelessWidget {
  final String title;
  final String preview;
  final String timeLabel;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.title,
    required this.preview,
    required this.timeLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),


            Text(
              preview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.65),
                height: 1.35,
              ),
            ),

            const SizedBox(height: 32),

            Text(
              timeLabel,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.45),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}