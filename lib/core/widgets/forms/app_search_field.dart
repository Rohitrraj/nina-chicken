import 'package:flutter/material.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText = 'Cari...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.enabled = true,
    this.semanticLabel = 'Pencarian',
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool enabled;
  final String semanticLabel;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();

    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);

    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    widget.focusNode?.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: widget.semanticLabel,
      child: TextField(
        controller: _controller,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        textInputAction: TextInputAction.search,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Hapus pencarian',
                  onPressed: _clear,
                  icon: const Icon(Icons.close_rounded),
                ),
        ),
      ),
    );
  }
}
