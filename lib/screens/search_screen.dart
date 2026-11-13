import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';

enum _Sort { rating, distance }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.tradeFilter});

  /// Shared with the home tab so tapping a trade there filters here.
  final ValueNotifier<Trade?> tradeFilter;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _query = TextEditingController();
  String? _city;
  _Sort _sort = _Sort.rating;

  @override
  void initState() {
    super.initState();
    widget.tradeFilter.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.tradeFilter.removeListener(_refresh);
    _query.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _clear() {
    _query.clear();
    widget.tradeFilter.value = null;
    setState(() => _city = null);
  }

  List<Technician> get _results {
    final q = _query.text.trim();
    final trade = widget.tradeFilter.value;
    final list = technicians.where((t) {
      if (trade != null && t.trade != trade) return false;
      if (_city != null && t.city != _city) return false;
      if (q.isEmpty) return true;
      return t.name.contains(q) ||
          t.trade.label.contains(q) ||
          t.district.contains(q) ||
          t.city.contains(q);
    }).toList();
    if (_sort == _Sort.rating) {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final trade = widget.tradeFilter.value;
    final results = _results;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            child: TextField(
              controller: _query,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'دوّر على فني أو صنعة',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'مسح',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(_query.clear),
                      ),
              ),
            ),
          ),
          SignRail(
            children: [
              for (final t in Trade.values)
                SignChip(
                  label: t.label,
                  icon: t.icon,
                  selected: trade == t,
                  onTap: () => widget.tradeFilter.value = trade == t ? null : t,
                ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Row(
              children: [
                for (final c in cities)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: FilterChip(
                      label: Text(c),
                      selected: _city == c,
                      showCheckmark: false,
                      selectedColor: AppColors.light,
                      backgroundColor: AppColors.surface,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                      onSelected: (on) => setState(() => _city = on ? c : null),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 6, 12, 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${results.length} فني',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(
                    () => _sort = _sort == _Sort.rating
                        ? _Sort.distance
                        : _Sort.rating,
                  ),
                  icon: const Icon(Icons.swap_vert_rounded, size: 20),
                  label: Text(
                    _sort == _Sort.rating ? 'الأعلى تقييماً' : 'الأقرب',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? _EmptyResults(onClear: _clear)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                    itemCount: results.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => TechTile(tech: results[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.muted,
            ),
            const SizedBox(height: 12),
            Text(
              'ما لقينا فني بهالمواصفات',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            const Text(
              'جرّب صنعة أو مدينة ثانية.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 180,
              child: PillButton(
                label: 'امسح الفلاتر',
                outlined: true,
                onPressed: onClear,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
