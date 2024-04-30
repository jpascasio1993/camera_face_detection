// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detected_face.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DetectedFace {
  Face? get face => throw _privateConstructorUsedError;
  bool get wellPositioned => throw _privateConstructorUsedError;
  Rect? get scaledBoundingBox => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DetectedFaceCopyWith<DetectedFace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetectedFaceCopyWith<$Res> {
  factory $DetectedFaceCopyWith(
          DetectedFace value, $Res Function(DetectedFace) then) =
      _$DetectedFaceCopyWithImpl<$Res, DetectedFace>;
  @useResult
  $Res call({Face? face, bool wellPositioned, Rect? scaledBoundingBox});
}

/// @nodoc
class _$DetectedFaceCopyWithImpl<$Res, $Val extends DetectedFace>
    implements $DetectedFaceCopyWith<$Res> {
  _$DetectedFaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? face = freezed,
    Object? wellPositioned = null,
    Object? scaledBoundingBox = freezed,
  }) {
    return _then(_value.copyWith(
      face: freezed == face
          ? _value.face
          : face // ignore: cast_nullable_to_non_nullable
              as Face?,
      wellPositioned: null == wellPositioned
          ? _value.wellPositioned
          : wellPositioned // ignore: cast_nullable_to_non_nullable
              as bool,
      scaledBoundingBox: freezed == scaledBoundingBox
          ? _value.scaledBoundingBox
          : scaledBoundingBox // ignore: cast_nullable_to_non_nullable
              as Rect?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DetectedFaceCopyWith<$Res>
    implements $DetectedFaceCopyWith<$Res> {
  factory _$$_DetectedFaceCopyWith(
          _$_DetectedFace value, $Res Function(_$_DetectedFace) then) =
      __$$_DetectedFaceCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Face? face, bool wellPositioned, Rect? scaledBoundingBox});
}

/// @nodoc
class __$$_DetectedFaceCopyWithImpl<$Res>
    extends _$DetectedFaceCopyWithImpl<$Res, _$_DetectedFace>
    implements _$$_DetectedFaceCopyWith<$Res> {
  __$$_DetectedFaceCopyWithImpl(
      _$_DetectedFace _value, $Res Function(_$_DetectedFace) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? face = freezed,
    Object? wellPositioned = null,
    Object? scaledBoundingBox = freezed,
  }) {
    return _then(_$_DetectedFace(
      face: freezed == face
          ? _value.face
          : face // ignore: cast_nullable_to_non_nullable
              as Face?,
      wellPositioned: null == wellPositioned
          ? _value.wellPositioned
          : wellPositioned // ignore: cast_nullable_to_non_nullable
              as bool,
      scaledBoundingBox: freezed == scaledBoundingBox
          ? _value.scaledBoundingBox
          : scaledBoundingBox // ignore: cast_nullable_to_non_nullable
              as Rect?,
    ));
  }
}

/// @nodoc

class _$_DetectedFace implements _DetectedFace {
  const _$_DetectedFace(
      {this.face, this.wellPositioned = false, this.scaledBoundingBox});

  @override
  final Face? face;
  @override
  @JsonKey()
  final bool wellPositioned;
  @override
  final Rect? scaledBoundingBox;

  @override
  String toString() {
    return 'DetectedFace(face: $face, wellPositioned: $wellPositioned, scaledBoundingBox: $scaledBoundingBox)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DetectedFace &&
            (identical(other.face, face) || other.face == face) &&
            (identical(other.wellPositioned, wellPositioned) ||
                other.wellPositioned == wellPositioned) &&
            (identical(other.scaledBoundingBox, scaledBoundingBox) ||
                other.scaledBoundingBox == scaledBoundingBox));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, face, wellPositioned, scaledBoundingBox);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DetectedFaceCopyWith<_$_DetectedFace> get copyWith =>
      __$$_DetectedFaceCopyWithImpl<_$_DetectedFace>(this, _$identity);
}

abstract class _DetectedFace implements DetectedFace {
  const factory _DetectedFace(
      {final Face? face,
      final bool wellPositioned,
      final Rect? scaledBoundingBox}) = _$_DetectedFace;

  @override
  Face? get face;
  @override
  bool get wellPositioned;
  @override
  Rect? get scaledBoundingBox;
  @override
  @JsonKey(ignore: true)
  _$$_DetectedFaceCopyWith<_$_DetectedFace> get copyWith =>
      throw _privateConstructorUsedError;
}
