typedef PagedLoaderCallback<T> = Future<List<T>> Function(int page, int conentId);

typedef AsyncValueChanged<R, T> = Future<R> Function(T);
