import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const kBrand = Color(0xFF77451E);

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();

  static const int _maxRecents = 10;

  // 더미 최근검색어
  List<_RecentKeyword> recents = [
    _RecentKeyword('두바이', '1.28'),
    _RecentKeyword('쫀득', '1.28'),
    _RecentKeyword('쿠키', '1.28'),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _sanitizeQuery(String raw) {
    return raw.replaceAll(' ', '').trim();
  }

  String _todayLabel() {
    final now = DateTime.now();
    return '${now.month}.${now.day}';
  }

  void _pushRecent(String q) {
    recents.removeWhere((e) => e.keyword == q);

    recents.insert(0, _RecentKeyword(q, _todayLabel()));

    if (recents.length > _maxRecents) {
      recents = recents.take(_maxRecents).toList();
    }
  }

  void _onSearch({String? overrideQuery}) {
    final q = _sanitizeQuery(overrideQuery ?? _ctrl.text);
    if (q.isEmpty) return;

    setState(() {
      _pushRecent(q);
    });

    // TODO: SearchResultScreen으로 이동
    // Navigator.push(context, MaterialPageRoute(builder: (_) => SearchResultScreen(query: q)));
  }

  void _removeOne(int index) {
    setState(() => recents.removeAt(index));
  }

  Future<void> _showClearAllDialog() async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '기록을 삭제하시겠습니까?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                '삭제된 기록은 복구 할 수 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.35),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD0D4DA), width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        '취소',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBrand,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        '삭제',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (ok == true) {
      setState(() => recents.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            onPressed: () => _onSearch(),
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

              const SizedBox(height: 14),

              if (recents.isEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  '최근 검색어 내역이 없습니다.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.35),
                  ),
                ),
              ] else ...[
                const Text(
                  '최근 검색어',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),

                ...List.generate(recents.length, (i) {
                  final item = recents[i];
                  return SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            // ✅ 최근검색어 탭하면 입력 + 검색 실행
                            onTap: () {
                              _ctrl.text = item.keyword;
                              _ctrl.selection = TextSelection.fromPosition(
                                TextPosition(offset: _ctrl.text.length),
                              );
                              _onSearch(overrideQuery: item.keyword);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                item.keyword,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          item.dateLabel,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.25),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () => _removeOne(i),
                          borderRadius: BorderRadius.circular(999),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(Icons.close, size: 22, color: Colors.black.withOpacity(0.35)),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 6),
                const Divider(thickness: 1, height: 1, color: Color(0xFFE6E6E6)),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: GestureDetector(
                    onTap: _showClearAllDialog,
                    child: Text(
                      '전체삭제',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withOpacity(0.35),
                      ),
                    ),
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

class _RecentKeyword {
  final String keyword;
  final String dateLabel;
  _RecentKeyword(this.keyword, this.dateLabel);
}
