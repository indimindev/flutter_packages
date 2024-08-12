abstract class IRequest<TResponse> {}

abstract class IRequestHandler<TRequest extends IRequest<TResponse>,
    TResponse> {
  Future<TResponse> handle(TRequest request);
}

class Medartor<T> {
  final Map<String, IRequestHandler> _handlers = {};

  void register<TRequest extends IRequest<TResponse>, TResponse>(
      IRequestHandler<TRequest, TResponse> handler,
      {String? key}) {
    _handlers[key ?? TRequest.toString()] = handler;
  }

  bool containsHandlerFor<TResponse>(IRequest<TResponse> request) {
    return _handlers.containsKey(request.runtimeType.toString());
  }

  bool containsHandlerForKey<TResponse>(String key) {
    return _handlers.containsKey(key);
  }

  Future<TResponse> send<TResponse>(
    IRequest<TResponse> request, {
    String? key,
    Future<TResponse> Function(IRequest<TResponse> request)? defaultHandler,
  }) async {
    var _hanlderKey = key ?? request.runtimeType.toString();
    var handler = _handlers[_hanlderKey];
    if ((handler ?? defaultHandler) == null) {
      throw Exception(
          "You must register handler for ${_hanlderKey} before calling this function");
    }
    return await (handler?.handle(request) ?? defaultHandler?.call(request))
        as TResponse;
  }
}
