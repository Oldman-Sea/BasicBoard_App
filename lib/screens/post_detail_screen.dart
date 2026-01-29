import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'post_editor_screen.dart';


const kBrand = Color(0xFF77451E);

class PostDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final DateTime createdAt;

  final bool hasPrev;
  final bool hasNext;

  const PostDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.createdAt,
    this.hasPrev = false,
    this.hasNext = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 140),
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
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _formatDetailDate(createdAt),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.45),
                    height: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Divider(thickness: 1, height: 1, color: Color(0xFFE6E6E6)),
              const SizedBox(height: 18),

              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _NavButton(
                    label: '이전글',
                    isEnabled: hasPrev,
                    onTap: hasPrev ? () {} : null,
                    isLeft: true,
                  ),
                  const SizedBox(width: 18),
                  _NavButton(
                    label: '다음글',
                    isEnabled: hasNext,
                    onTap: hasNext ? () {} : null,
                    isLeft: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),




      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE6E6E6))),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;

                const base = 360.0;
                final scale = (w / base).clamp(0.85, 1.25);

                final barH = (60 * scale).clamp(54.0, 74.0);
                final btnW = (150 * scale).clamp(130.0, 180.0);
                final gap = (40 * scale).clamp(24.0, 48.0);
                final btnH = (40 * scale).clamp(36.0, 46.0);

                return SizedBox(
                  height: barH,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: btnW,
                        height: btnH,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                                color: Color(0xFFD4D5D8), width: 1.5),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => _showDeleteDialog(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/trash.svg',
                                width: 18,
                                height: 18,
                                colorFilter: const ColorFilter.mode(
                                    kBrand, BlendMode.srcIn),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '삭제하기',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: gap),
                      SizedBox(
                        width: btnW,
                        height: btnH,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                                color: Color(0xFFD4D5D8), width: 1.5),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PostEditorScreen.edit(
                                    initialTitle: title,
                                    initialContent: content,
                                  ),
                                ),
                              );
                            },

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/pen.svg',
                                width: 18,
                                height: 18,
                                colorFilter: const ColorFilter.mode(
                                    kBrand, BlendMode.srcIn),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '수정하기',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

        static String _formatDetailDate(DateTime dt) {
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y.$m.$d $hh:$mm';
  }

  static Future<void> _showDeleteDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // 바깥 탭 닫기
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
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
                style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.35), fontWeight: FontWeight.w600),
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
                      child: const Text('취소', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBrand,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('삭제', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result == true) {
      // TODO: DELETE API 호출 성공 시 토스트 + 피드로 이동
    }
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool isEnabled;
  final VoidCallback? onTap;
  final bool isLeft;

  const _NavButton({
    required this.label,
    required this.isEnabled,
    required this.onTap,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isEnabled ? kBrand : const Color(0xFFBFC3C9);
    final fg = Colors.white;

    return SizedBox(
      width: 110,
      height: 54,
      child: ElevatedButton(
        onPressed: isEnabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          disabledBackgroundColor: const Color(0xFFBFC3C9),
          disabledForegroundColor: Colors.white.withOpacity(0.85),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLeft) ...[
              const Icon(Icons.chevron_left, size: 18),
              const SizedBox(width: 2),
            ],
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            if (!isLeft) ...[
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}


