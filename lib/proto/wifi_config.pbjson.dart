//
//  Generated code. Do not modify.
//  source: wifi_config.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use wiFiConfigMsgTypeDescriptor instead')
const WiFiConfigMsgType$json = {
  '1': 'WiFiConfigMsgType',
  '2': [
    {'1': 'TypeCmdGetStatus', '2': 0},
    {'1': 'TypeRespGetStatus', '2': 1},
    {'1': 'TypeCmdSetConfig', '2': 2},
    {'1': 'TypeRespSetConfig', '2': 3},
    {'1': 'TypeCmdApplyConfig', '2': 4},
    {'1': 'TypeRespApplyConfig', '2': 5},
  ],
};

/// Descriptor for `WiFiConfigMsgType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List wiFiConfigMsgTypeDescriptor = $convert.base64Decode(
    'ChFXaUZpQ29uZmlnTXNnVHlwZRIUChBUeXBlQ21kR2V0U3RhdHVzEAASFQoRVHlwZVJlc3BHZX'
    'RTdGF0dXMQARIUChBUeXBlQ21kU2V0Q29uZmlnEAISFQoRVHlwZVJlc3BTZXRDb25maWcQAxIW'
    'ChJUeXBlQ21kQXBwbHlDb25maWcQBBIXChNUeXBlUmVzcEFwcGx5Q29uZmlnEAU=');

@$core.Deprecated('Use cmdGetStatusDescriptor instead')
const CmdGetStatus$json = {
  '1': 'CmdGetStatus',
};

/// Descriptor for `CmdGetStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cmdGetStatusDescriptor = $convert.base64Decode(
    'CgxDbWRHZXRTdGF0dXM=');

@$core.Deprecated('Use respGetStatusDescriptor instead')
const RespGetStatus$json = {
  '1': 'RespGetStatus',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.espressif.Status', '10': 'status'},
    {'1': 'sta_state', '3': 2, '4': 1, '5': 14, '6': '.espressif.WifiStationState', '10': 'staState'},
    {'1': 'fail_reason', '3': 10, '4': 1, '5': 14, '6': '.espressif.WifiConnectFailedReason', '9': 0, '10': 'failReason'},
    {'1': 'connected', '3': 11, '4': 1, '5': 11, '6': '.espressif.WifiConnectedState', '9': 0, '10': 'connected'},
  ],
  '8': [
    {'1': 'state'},
  ],
};

/// Descriptor for `RespGetStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respGetStatusDescriptor = $convert.base64Decode(
    'Cg1SZXNwR2V0U3RhdHVzEikKBnN0YXR1cxgBIAEoDjIRLmVzcHJlc3NpZi5TdGF0dXNSBnN0YX'
    'R1cxI4CglzdGFfc3RhdGUYAiABKA4yGy5lc3ByZXNzaWYuV2lmaVN0YXRpb25TdGF0ZVIIc3Rh'
    'U3RhdGUSRQoLZmFpbF9yZWFzb24YCiABKA4yIi5lc3ByZXNzaWYuV2lmaUNvbm5lY3RGYWlsZW'
    'RSZWFzb25IAFIKZmFpbFJlYXNvbhI9Cgljb25uZWN0ZWQYCyABKAsyHS5lc3ByZXNzaWYuV2lm'
    'aUNvbm5lY3RlZFN0YXRlSABSCWNvbm5lY3RlZEIHCgVzdGF0ZQ==');

@$core.Deprecated('Use cmdSetConfigDescriptor instead')
const CmdSetConfig$json = {
  '1': 'CmdSetConfig',
  '2': [
    {'1': 'ssid', '3': 1, '4': 1, '5': 12, '10': 'ssid'},
    {'1': 'passphrase', '3': 2, '4': 1, '5': 12, '10': 'passphrase'},
    {'1': 'bssid', '3': 3, '4': 1, '5': 12, '10': 'bssid'},
    {'1': 'channel', '3': 4, '4': 1, '5': 5, '10': 'channel'},
  ],
};

/// Descriptor for `CmdSetConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cmdSetConfigDescriptor = $convert.base64Decode(
    'CgxDbWRTZXRDb25maWcSEgoEc3NpZBgBIAEoDFIEc3NpZBIeCgpwYXNzcGhyYXNlGAIgASgMUg'
    'pwYXNzcGhyYXNlEhQKBWJzc2lkGAMgASgMUgVic3NpZBIYCgdjaGFubmVsGAQgASgFUgdjaGFu'
    'bmVs');

@$core.Deprecated('Use respSetConfigDescriptor instead')
const RespSetConfig$json = {
  '1': 'RespSetConfig',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.espressif.Status', '10': 'status'},
  ],
};

/// Descriptor for `RespSetConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respSetConfigDescriptor = $convert.base64Decode(
    'Cg1SZXNwU2V0Q29uZmlnEikKBnN0YXR1cxgBIAEoDjIRLmVzcHJlc3NpZi5TdGF0dXNSBnN0YX'
    'R1cw==');

@$core.Deprecated('Use cmdApplyConfigDescriptor instead')
const CmdApplyConfig$json = {
  '1': 'CmdApplyConfig',
};

/// Descriptor for `CmdApplyConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cmdApplyConfigDescriptor = $convert.base64Decode(
    'Cg5DbWRBcHBseUNvbmZpZw==');

@$core.Deprecated('Use respApplyConfigDescriptor instead')
const RespApplyConfig$json = {
  '1': 'RespApplyConfig',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.espressif.Status', '10': 'status'},
  ],
};

/// Descriptor for `RespApplyConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respApplyConfigDescriptor = $convert.base64Decode(
    'Cg9SZXNwQXBwbHlDb25maWcSKQoGc3RhdHVzGAEgASgOMhEuZXNwcmVzc2lmLlN0YXR1c1IGc3'
    'RhdHVz');

@$core.Deprecated('Use wiFiConfigPayloadDescriptor instead')
const WiFiConfigPayload$json = {
  '1': 'WiFiConfigPayload',
  '2': [
    {'1': 'msg', '3': 1, '4': 1, '5': 14, '6': '.espressif.WiFiConfigMsgType', '10': 'msg'},
    {'1': 'cmd_get_status', '3': 10, '4': 1, '5': 11, '6': '.espressif.CmdGetStatus', '9': 0, '10': 'cmdGetStatus'},
    {'1': 'resp_get_status', '3': 11, '4': 1, '5': 11, '6': '.espressif.RespGetStatus', '9': 0, '10': 'respGetStatus'},
    {'1': 'cmd_set_config', '3': 12, '4': 1, '5': 11, '6': '.espressif.CmdSetConfig', '9': 0, '10': 'cmdSetConfig'},
    {'1': 'resp_set_config', '3': 13, '4': 1, '5': 11, '6': '.espressif.RespSetConfig', '9': 0, '10': 'respSetConfig'},
    {'1': 'cmd_apply_config', '3': 14, '4': 1, '5': 11, '6': '.espressif.CmdApplyConfig', '9': 0, '10': 'cmdApplyConfig'},
    {'1': 'resp_apply_config', '3': 15, '4': 1, '5': 11, '6': '.espressif.RespApplyConfig', '9': 0, '10': 'respApplyConfig'},
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `WiFiConfigPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wiFiConfigPayloadDescriptor = $convert.base64Decode(
    'ChFXaUZpQ29uZmlnUGF5bG9hZBIuCgNtc2cYASABKA4yHC5lc3ByZXNzaWYuV2lGaUNvbmZpZ0'
    '1zZ1R5cGVSA21zZxI/Cg5jbWRfZ2V0X3N0YXR1cxgKIAEoCzIXLmVzcHJlc3NpZi5DbWRHZXRT'
    'dGF0dXNIAFIMY21kR2V0U3RhdHVzEkIKD3Jlc3BfZ2V0X3N0YXR1cxgLIAEoCzIYLmVzcHJlc3'
    'NpZi5SZXNwR2V0U3RhdHVzSABSDXJlc3BHZXRTdGF0dXMSPwoOY21kX3NldF9jb25maWcYDCAB'
    'KAsyFy5lc3ByZXNzaWYuQ21kU2V0Q29uZmlnSABSDGNtZFNldENvbmZpZxJCCg9yZXNwX3NldF'
    '9jb25maWcYDSABKAsyGC5lc3ByZXNzaWYuUmVzcFNldENvbmZpZ0gAUg1yZXNwU2V0Q29uZmln'
    'EkUKEGNtZF9hcHBseV9jb25maWcYDiABKAsyGS5lc3ByZXNzaWYuQ21kQXBwbHlDb25maWdIAF'
    'IOY21kQXBwbHlDb25maWcSSAoRcmVzcF9hcHBseV9jb25maWcYDyABKAsyGi5lc3ByZXNzaWYu'
    'UmVzcEFwcGx5Q29uZmlnSABSD3Jlc3BBcHBseUNvbmZpZ0IJCgdwYXlsb2Fk');

