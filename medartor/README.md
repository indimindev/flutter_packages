# MeDARTor

Simple, unambitious CQRS mediator implementation, .NET MediatR inspired.

```dart
// declares the message class (command/query) that is constructed with a username and returns a string
class GreetUserRequest implements IRequest<String> {
  final String userName;

  GreetUserRequest({
    required this.userName,
  });
}

// declare a class to handle the 'GreetUserRequest' message, which returns a string
class GreetUserHandler extends IRequestHandler<GreetUserRequest, String> {
  @override
  Future<String> handle(GreetUserRequest request) async {
    return "Hello ${request.userName}!";
  }
}

// Create a Mediator instance
final mediator = Medartor();

// Register the handler for the 'GreetUserRequest' message
mediator.register(GreetUserHandler());

// Create a 'GreetUserRequest' object
final request = GreetUserRequest(userName: "John");

// Send the message and get the response
final response = await mediator.send(request);

// print the answer
print(response); // print "Hello John!"
```

Multiple `handlers` can also be used to attend to the same `Request`, for this case a `Key` associated with each handler must be registered to identify it and pass it as a parameter to the `send` method.

```dart
class HelloUserHandler extends IRequestHandler<GreetUserRequest, String> {
  @override
  Future<String> handle(GreetUserRequest request) async {
    return "Hello ${request.userName}!";
  }
}

class GoodbyeUserHandler extends IRequestHandler<GreetUserRequest, String> {
  @override
  Future<String> handle(GreetUserRequest request) async {
    return "Goodbye ${request.userName}!";
  }
}

// Create a Mediator instance
final mediator = Medartor();

// Register the handler for the 'GreetUserRequest' message with different keys
mediator.register(HelloUserHandler(), key: "helloHandler");
mediator.register(GoodbyeUserHandler(), key: "goodbyeHandler");

// Create a 'GreetUserRequest' object
final request = GreetUserRequest(userName: "John");

// Send the message and get the response
final response = await mediator.send(request, key: "helloHandler");
// print the answer
print(response); // print "Hello John!"

// Send the message and get the response
final response = await mediator.send(request, key: "goodbyeHandler");

// print the answer
print(response); // print "Goodbye John!"
```

a good way to implement it in an architecture is to instantiate it and register its handlers at startup in a dependency injector.
