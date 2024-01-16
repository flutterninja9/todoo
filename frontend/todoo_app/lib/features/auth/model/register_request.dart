import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: 'firstName', includeIfNull: false)
  final String firstName;

  @JsonKey(name: 'lastName', includeIfNull: false)
  final String lastName;

  @JsonKey(name: 'email', includeIfNull: false)
  final String email;

  @JsonKey(name: 'password', includeIfNull: false)
  final String password;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
