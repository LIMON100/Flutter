/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the History type in your schema. */
class History extends amplify_core.Model {
  static const classType = const _HistoryModelType();
  final String id;
  final String? _userUniqueId;
  final double? _latitude;
  final double? _longitude;
  final amplify_core.TemporalDate? _date;
  final amplify_core.TemporalTime? _time;
  final String? _position;
  final String? _imageUrl;
  final String? _imagekey;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  HistoryModelIdentifier get modelIdentifier {
      return HistoryModelIdentifier(
        id: id
      );
  }
  
  String? get userUniqueId {
    return _userUniqueId;
  }
  
  double? get latitude {
    return _latitude;
  }
  
  double? get longitude {
    return _longitude;
  }
  
  amplify_core.TemporalDate? get date {
    return _date;
  }
  
  amplify_core.TemporalTime? get time {
    return _time;
  }
  
  String? get position {
    return _position;
  }
  
  String? get imageUrl {
    return _imageUrl;
  }
  
  String? get imagekey {
    return _imagekey;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const History._internal({required this.id, userUniqueId, latitude, longitude, date, time, position, imageUrl, imagekey, createdAt, updatedAt}): _userUniqueId = userUniqueId, _latitude = latitude, _longitude = longitude, _date = date, _time = time, _position = position, _imageUrl = imageUrl, _imagekey = imagekey, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory History({String? id, String? userUniqueId, double? latitude, double? longitude, amplify_core.TemporalDate? date, amplify_core.TemporalTime? time, String? position, String? imageUrl, String? imagekey}) {
    return History._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userUniqueId: userUniqueId,
      latitude: latitude,
      longitude: longitude,
      date: date,
      time: time,
      position: position,
      imageUrl: imageUrl,
      imagekey: imagekey);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is History &&
      id == other.id &&
      _userUniqueId == other._userUniqueId &&
      _latitude == other._latitude &&
      _longitude == other._longitude &&
      _date == other._date &&
      _time == other._time &&
      _position == other._position &&
      _imageUrl == other._imageUrl &&
      _imagekey == other._imagekey;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("History {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userUniqueId=" + "$_userUniqueId" + ", ");
    buffer.write("latitude=" + (_latitude != null ? _latitude!.toString() : "null") + ", ");
    buffer.write("longitude=" + (_longitude != null ? _longitude!.toString() : "null") + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("time=" + (_time != null ? _time!.format() : "null") + ", ");
    buffer.write("position=" + "$_position" + ", ");
    buffer.write("imageUrl=" + "$_imageUrl" + ", ");
    buffer.write("imagekey=" + "$_imagekey" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  History copyWith({String? userUniqueId, double? latitude, double? longitude, amplify_core.TemporalDate? date, amplify_core.TemporalTime? time, String? position, String? imageUrl, String? imagekey}) {
    return History._internal(
      id: id,
      userUniqueId: userUniqueId ?? this.userUniqueId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      date: date ?? this.date,
      time: time ?? this.time,
      position: position ?? this.position,
      imageUrl: imageUrl ?? this.imageUrl,
      imagekey: imagekey ?? this.imagekey);
  }
  
  History copyWithModelFieldValues({
    ModelFieldValue<String?>? userUniqueId,
    ModelFieldValue<double?>? latitude,
    ModelFieldValue<double?>? longitude,
    ModelFieldValue<amplify_core.TemporalDate?>? date,
    ModelFieldValue<amplify_core.TemporalTime?>? time,
    ModelFieldValue<String?>? position,
    ModelFieldValue<String?>? imageUrl,
    ModelFieldValue<String?>? imagekey
  }) {
    return History._internal(
      id: id,
      userUniqueId: userUniqueId == null ? this.userUniqueId : userUniqueId.value,
      latitude: latitude == null ? this.latitude : latitude.value,
      longitude: longitude == null ? this.longitude : longitude.value,
      date: date == null ? this.date : date.value,
      time: time == null ? this.time : time.value,
      position: position == null ? this.position : position.value,
      imageUrl: imageUrl == null ? this.imageUrl : imageUrl.value,
      imagekey: imagekey == null ? this.imagekey : imagekey.value
    );
  }
  
  History.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userUniqueId = json['userUniqueId'],
      _latitude = (json['latitude'] as num?)?.toDouble(),
      _longitude = (json['longitude'] as num?)?.toDouble(),
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _time = json['time'] != null ? amplify_core.TemporalTime.fromString(json['time']) : null,
      _position = json['position'],
      _imageUrl = json['imageUrl'],
      _imagekey = json['imagekey'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userUniqueId': _userUniqueId, 'latitude': _latitude, 'longitude': _longitude, 'date': _date?.format(), 'time': _time?.format(), 'position': _position, 'imageUrl': _imageUrl, 'imagekey': _imagekey, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userUniqueId': _userUniqueId,
    'latitude': _latitude,
    'longitude': _longitude,
    'date': _date,
    'time': _time,
    'position': _position,
    'imageUrl': _imageUrl,
    'imagekey': _imagekey,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<HistoryModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<HistoryModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERUNIQUEID = amplify_core.QueryField(fieldName: "userUniqueId");
  static final LATITUDE = amplify_core.QueryField(fieldName: "latitude");
  static final LONGITUDE = amplify_core.QueryField(fieldName: "longitude");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final TIME = amplify_core.QueryField(fieldName: "time");
  static final POSITION = amplify_core.QueryField(fieldName: "position");
  static final IMAGEURL = amplify_core.QueryField(fieldName: "imageUrl");
  static final IMAGEKEY = amplify_core.QueryField(fieldName: "imagekey");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "History";
    modelSchemaDefinition.pluralName = "Histories";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: History.USERUNIQUEID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: History.LATITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: History.LONGITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: History.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: History.TIME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.time)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: History.POSITION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: History.IMAGEURL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: History.IMAGEKEY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _HistoryModelType extends amplify_core.ModelType<History> {
  const _HistoryModelType();
  
  @override
  History fromJson(Map<String, dynamic> jsonData) {
    return History.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'History';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [History] in your schema.
 */
class HistoryModelIdentifier implements amplify_core.ModelIdentifier<History> {
  final String id;

  /** Create an instance of HistoryModelIdentifier using [id] the primary key. */
  const HistoryModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'HistoryModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is HistoryModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}