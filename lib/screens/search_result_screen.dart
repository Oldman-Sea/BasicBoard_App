import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const kBrand = Color(0xFF77451E);

class SearchResultScreen extends StatefulWidget {
  final String query;
  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final _ctrl = TextEditingController();

  // ✅ 더미 검색결과 (나중에 API 붙이면 여기만 교체)
  final List<Post> _items = [
    Post(
      id: 1,
      title: '두쫀쿠 먹고 싶어요',
      content: '두쫀쿠 어디서 사나요 두 쫀쿠 어디서 사나요 두쫀쿠 어디서 사나요 두 쫀 쿠 어디서 사나요',
      createdAt: DateTime(2024, 7, 26),
    ),
  ];

  String get _q => _sanitize(_ctrl.text);

  @override
  void initState() {
    super.initState();
    _ctrl.text = widget.query;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _sanitize(String raw) => raw.replaceAll(' ', '').trim();

  void _onSearch() {
    final q = _sanitize(_ctrl.text);
    if (q.isEmpty) return;

    // TODO: API 붙이면 여기서 서버 호출

    FocusScope.of(context).unfocus();
  }

  String _formatFeedDate(DateTime dt) {
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y.$m.$d';
  }

  @override
  Widget build(BuildContext context) {
    final q = _sanitize(widget.query);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _ctrl,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (_) => _onSearch(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '',
                                isCollapsed: true,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _onSearch,
                            icon: SvgPicture.asset(
                              'assets/icons/search.svg',
                              width: 26,
                              height: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              if (_items.isEmpty) ...[

                const SizedBox.shrink(),
              ] else ...[
                Expanded(
                  child: ListView.separated(
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const Divider(
                      thickness: 1,
                      height: 36,
                      color: Color(0xFFE6E6E6),
                    ),
                    itemBuilder: (context, index) {
                      final post = _items[index];
                      return InkWell(
                        onTap: () {
                          // TODO: 상세 이동
                          // Navigator.push(context, MaterialPageRoute(
                          //   builder: (_) => PostDetailScreen(...),
                          // ));
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              HighlightText(
                                text: post.title,
                                query: q,
                                normalStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                  color: Colors.black,
                                ),
                                highlightStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                  color: kBrand,
                                ),
                              ),

                              const SizedBox(height: 8),

                              HighlightText(
                                text: post.content,
                                query: q,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                normalStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                  color: Colors.black.withOpacity(0.75),
                                ),
                                highlightStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  height: 1.45,
                                  color: kBrand,
                                ),
                              ),

                              const SizedBox(height: 14),

                              Text(
                                _formatFeedDate(post.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.45),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------------------
   데이터 모델 (더미)
--------------------------- */

class Post {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
}

/* ---------------------------
   하이라이트 위젯
   - 공백 제거 기준으로 매칭
   - title/content에 매칭 부분만 색 변경
--------------------------- */

class HighlightText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle normalStyle;
  final TextStyle highlightStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  const HighlightText({
    super.key,
    required this.text,
    required this.query,
    required this.normalStyle,
    required this.highlightStyle,
    this.maxLines,
    this.overflow,
  });

  String _sanitize(String s) => s.replaceAll(' ', '');

  @override
  Widget build(BuildContext context) {
    final q = _sanitize(query);
    if (q.isEmpty) {
      return Text(
        text,
        style: normalStyle,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final original = text;
    final compact = _sanitize(original);

    final matchStart = compact.indexOf(q);
    if (matchStart < 0) {
      return Text(
        original,
        style: normalStyle,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    int compactToOriginal(int compactIndex) {
      int c = 0;
      for (int i = 0; i < original.length; i++) {
        if (original[i] != ' ') {
          if (c == compactIndex) return i;
          c++;
        }
      }
      return original.length;
    }

    final startOriginal = compactToOriginal(matchStart);
    final endOriginal = compactToOriginal(matchStart + q.length);
    final safeEnd = endOriginal.clamp(0, original.length);

    final before = original.substring(0, startOriginal);
    final mid = original.substring(startOriginal, safeEnd);
    final after = original.substring(safeEnd);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: before, style: normalStyle),
          TextSpan(text: mid, style: highlightStyle),
          TextSpan(text: after, style: normalStyle),
        ],
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
