import 'package:flutter/material.dart';

const kBrand = Color(0xFF77451E);

enum EditorMode { create, edit }

class PostEditorScreen extends StatefulWidget {
  final EditorMode mode;

  final String initialTitle;
  final String initialContent;

  const PostEditorScreen.create({super.key})
      : mode = EditorMode.create,
        initialTitle = '',
        initialContent = '';

  const PostEditorScreen.edit({
    super.key,
    required this.initialTitle,
    required this.initialContent,
  }) : mode = EditorMode.edit;

  @override
  State<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<PostEditorScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;

  bool _isDirty = false;

  bool get _canSave {
    final t = _titleCtrl.text.trim();
    final c = _contentCtrl.text.trim();
    return t.isNotEmpty && c.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTitle);
    _contentCtrl = TextEditingController(text: widget.initialContent);

    _titleCtrl.addListener(_handleChanged);
    _contentCtrl.addListener(_handleChanged);
  }

  void _handleChanged() {
    final nowDirty = widget.mode == EditorMode.create
        ? (_titleCtrl.text.trim().isNotEmpty || _contentCtrl.text.trim().isNotEmpty)
        : (_titleCtrl.text != widget.initialTitle || _contentCtrl.text != widget.initialContent);

    if (nowDirty != _isDirty) {
      setState(() => _isDirty = nowDirty);
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<bool> _confirmLeaveIfDirty() async {
    if (!_isDirty) return true;

    final shouldLeave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '기록을 중단하시겠습니까?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '작성 중인 내용은 저장되지 않습니다.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.35),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD0D4DA), width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        '아니요',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBrand,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        '그만두기',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
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

    return shouldLeave == true;
  }

  Future<void> _onClose() async {
    final ok = await _confirmLeaveIfDirty();
    if (!ok) return;
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _onSave() {
    if (!_canSave) return;

    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();

    // TODO: 여기서 API 붙일 예정이면 호출
    // - create: POST /posts
    // - edit: PUT /posts/{id}

    Navigator.pop(context, {'title': title, 'content': content});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmLeaveIfDirty,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, size: 28, color: Colors.black),
            onPressed: _onClose,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
              child: ElevatedButton(
                onPressed: _canSave ? _onSave : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBrand,
                  disabledBackgroundColor: kBrand.withOpacity(0.35),
                  elevation: 0,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
                child: const Text(
                  '저장',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleCtrl,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    hintText: '제목',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withOpacity(0.25),
                    ),
                    border: InputBorder.none,
                  ),
                ),
                const Divider(thickness: 1, height: 1, color: Color(0xFFE6E6E6)),
                const SizedBox(height: 14),

                Expanded(
                  child: TextField(
                    controller: _contentCtrl,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(fontSize: 14, height: 1.6),
                    decoration: InputDecoration(
                      hintText: '오늘의 시간을, 여기 남겨보세요',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.25),
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

