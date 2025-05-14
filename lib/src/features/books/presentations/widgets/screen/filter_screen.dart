import 'package:book_shelf/src/features/books/presentations/blocs/bloc/book_cubit.dart';
import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/utils/book_query_handler.dart';
import '../../../../../shared/widgets/list/dropdown_expanded.dart';
import '../../../../../shared/widgets/others/dynamic_app_bar.dart';

class FilterScreen extends StatefulWidget{
  const FilterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FilterView();
}

class _FilterView extends State<FilterScreen> {
  late BookQuery _bookQuery;
  late BookQuery _newQuery;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _bookQuery = context.read<BookCubit>().state.query ?? BookQuery();
    _newQuery = BookQuery(
      filterBy: _bookQuery.filterBy,
      orderBy: _bookQuery.orderBy,
      langRestrict: _bookQuery.langRestrict,
      generic: _bookQuery.generic,
    );
  }

  bool _checkForChanges() {
    return _newQuery.filterBy != _bookQuery.filterBy ||
        _newQuery.orderBy != _bookQuery.orderBy ||
        _newQuery.langRestrict != _bookQuery.langRestrict;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        backgroundColor: ColorConstant.secondary,
        title: Text("Filter pencarian", style: TextStyle(color: Colors.black, fontSize: 18),),
        titleAlignment: Alignment.centerLeft,
        trailingWidgets: [
          IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.black54)),
        ],
      ),
      backgroundColor: ColorConstant.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDropdown(
                title: "Filter buku",
                items: _bookQuery.filterBook,
                defaultId: _newQuery.filterBy,
                onSelected: (value) {
                  setState(() {
                    _newQuery = BookQuery(
                      filterBy: value.id,
                      orderBy: _newQuery.orderBy,
                      langRestrict: _newQuery.langRestrict,
                      generic: _newQuery.generic,
                    );
                    _hasChanges = _checkForChanges();
                  });
                },
              ),
              _buildDropdown(
                title: "Urutkan berdasarkan",
                items: _bookQuery.orderBook,
                defaultId: _newQuery.orderBy,
                showAllAsDefault: false,
                onSelected: (value) {
                  setState(() {
                    _newQuery = BookQuery(
                      filterBy: _newQuery.filterBy,
                      orderBy: value.id,
                      langRestrict: _newQuery.langRestrict,
                      generic: _newQuery.generic,
                    );
                    _hasChanges = _checkForChanges();
                  });
                },
              ),
              _buildDropdown(
                title: "Bahasa",
                limit: 4,
                items: _bookQuery.languages,
                defaultId: _newQuery.langRestrict,
                onSelected: (value) {
                  setState(() {
                    _newQuery = BookQuery(
                      filterBy: _newQuery.filterBy,
                      orderBy: _newQuery.orderBy,
                      langRestrict: value.id,
                      generic: _newQuery.generic,
                    );
                    _hasChanges = _checkForChanges();
                  });
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorConstant.secondary,
        padding: EdgeInsets.zero,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if(_newQuery.isApplyFilter()){
                      context.read<BookCubit>().setQuery(BookQuery(generic: _bookQuery.generic));
                    }
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: ColorConstant.gray),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.transparent,
                    foregroundColor: ColorConstant.black,
                  ),
                  child: Text(
                    _newQuery.isApplyFilter() ? 'Bersihkan' : 'Batal',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Only apply the query if there are changes
                    if (_hasChanges) {
                      final updatedQuery = BookQuery(
                        filterBy: _newQuery.filterBy,
                        orderBy: _newQuery.orderBy,
                        langRestrict: _newQuery.langRestrict,
                        generic: _bookQuery.generic,
                      );

                      context.read<BookCubit>().resetPagination();
                      context.read<BookCubit>().setQuery(updatedQuery);

                      if (updatedQuery.generic?.isEmpty ?? true) {
                        context.read<BookCubit>().setWaitingSubmit(true);
                      } else {
                        context.read<BookCubit>().setWaitingSubmit(false);
                        Future.microtask(() {
                          context.read<BookCubit>().fetchPagination(0);
                        });
                      }
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.primary,
                    foregroundColor: ColorConstant.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Terapkan',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstant.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required List<DropdownItem> items,
    required String title,
    required Function(DropdownItem value) onSelected,
    int? limit,
    String? defaultId,
    bool showAllAsDefault = true,
  }){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          CustomDropdown(
            items: items,
            limit: limit,
            defaultId: defaultId,
            showAllAsDefault: showAllAsDefault,
            dropdownLabel: '$title lainnya',
            onSelected: onSelected,
          ),
        ],
      ),
    );
  }
}