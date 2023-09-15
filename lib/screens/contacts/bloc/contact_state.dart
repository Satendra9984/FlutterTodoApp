part of 'contact_cubit.dart';

class ContactState extends Equatable {
  final LoadState? loadState;
  final List<ContactModel> listContactModel;
  final LoadState? addLoadState;
  final LoadState? editLoadState;
  final LoadState? deleteLoadState;

  const ContactState({
    this.loadState,
    required this.listContactModel,
    this.addLoadState,
    this.editLoadState,
    this.deleteLoadState,
  });

  ContactState copyWith({
    LoadState? loadState,
    List<ContactModel>? listContactModel,
    LoadState? addLoadState,
    LoadState? editLoadState,
    LoadState? deleteLoadState,
  }) {
    return ContactState(
      loadState: loadState ?? this.loadState,
      listContactModel: listContactModel ?? this.listContactModel,
      addLoadState: addLoadState ?? this.addLoadState,
      editLoadState: editLoadState ?? this.editLoadState,
      deleteLoadState: deleteLoadState ?? this.deleteLoadState,
    );
  }

  @override
  List<Object?> get props => [
        loadState,
        listContactModel,
        addLoadState,
        editLoadState,
        deleteLoadState,
      ];
}

enum LoadState {
  initial,
  loading,
  loaded,
  errorLoading,
}
