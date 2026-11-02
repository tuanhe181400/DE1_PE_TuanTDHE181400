// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskViewModel)
final taskViewModelProvider = TaskViewModelProvider._();

final class TaskViewModelProvider
    extends $AsyncNotifierProvider<TaskViewModel, List<TaskModel>> {
  TaskViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskViewModelHash();

  @$internal
  @override
  TaskViewModel create() => TaskViewModel();
}

String _$taskViewModelHash() => r'fdab87a7d4ddc3c5178907a8d1e82a7553050a5d';

abstract class _$TaskViewModel extends $AsyncNotifier<List<TaskModel>> {
  FutureOr<List<TaskModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<TaskModel>>, List<TaskModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<TaskModel>>, List<TaskModel>>,
              AsyncValue<List<TaskModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
