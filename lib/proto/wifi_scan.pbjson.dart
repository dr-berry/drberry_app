//
//  Generated code. Do not modify.
//  source: wifi_scan.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use wiFiScanMsgTypeDescriptor instead')
const WiFiScanMsgType$json = {
  '1': 'WiFiScanMsgType',
  '2': [
    {'1': 'TypeCmdScanStart', '2': 0},
    {'1': 'TypeRespScanStart', '2': 1},
    {'1': 'TypeCmdScanStatus', '2': 2},
    {'1': 'TypeRespScanStatus', '2': 3},
    {'1': 'TypeCmdScanResult', '2': 4},
    {'1': 'TypeRespScanResult', '2': 5},
  ],
};

/// Descriptor for `WiFiScanMsgType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List wiFiScanMsgTypeDescriptor = $convert.base64Decode(
    'Cg9XaUZpU2Nhbk1zZ1R5cGUSFAoQVHlwZUNtZFNjYW5TdGFydBAAEhUKEVR5cGVSZXNwU2Nhbl'
    'N0YXJ0EAESFQoRVHlwZUNtZFNjYW5TdGF0dXMQAhIWChJUeXBlUmVzcFNjYW5TdGF0dXMQAxIV'
    'ChFUeXBlQ21kU2NhblJlc3VsdBAEEhYKElR5cGVSZXNwU2NhblJlc3VsdBAF');

@$core.Deprecated('Use cmdScanStartDescriptor instead')
const CmdScanStart$json = {
  '1': 'CmdScanStart',
  '2': [
    {'1': 'blocking', '3': 1, '4': 1, '5': 8, '10': 'blocking'},
    {'1': 'passive', '3': 2, '4': 1, '5': 8, '10': 'passive'},
    {'1': 'group_channels', '3': 3, '4': 1, '5': 13, '10': 'groupChannels'},
    {'1': 'period_ms', '3': 4, '4': 1, '5': 13, '10': 'periodMs'},
  ],
};

/// Descriptor for `CmdScanStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cmdScanStartDescriptor = $convert.base64Decode(
    'CgxDbWRTY2FuU3RhcnQSGgoIYmxvY2tpbmcYASABKAhSCGJsb2NraW5nEhgKB3Bhc3NpdmUYAi'
    'ABKAhSB3Bhc3NpdmUSJQoOZ3JvdXBfY2hhbm5lbHMYAyABKA1SDWdyb3VwQ2hhbm5lbHMSGwoJ'
    'cGVyaW9kX21zGAQgASgNUghwZXJpb2RNcw==');

@$core.Deprecated('Use respScanStartDescriptor instead')
const RespScanStart$json = {
  '1': 'RespScanStart',
};

/// Descriptor for `RespScanStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respScanStartDescriptor = $convert.base64Decode(
    'Cg1SZXNwU2NhblN0YXJ0');

@$core.Deprecated('Use cmdScanStatusDescriptor instead')
const CmdScanStatus$json = {
  '1': 'CmdScanStatus',
};

/// Descriptor for `CmdScanStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cmdScanStatusDescriptor = $convert.base64Decode(
    'Cg1DbWRTY2FuU3RhdHVz');

@$core.Deprecated('Use respScanStatusDescriptor instead')
const RespScanStatus$json = {
  '1': 'RespScanStatus',
  '2': [
    {'1': 'scan_finished', '3': 1, '4': 1, '5': 8, '10': 'scanFinished'},
    {'1': 'result_count', '3': 2, '4': 1, '5': 13, '10': 'resultCount'},
  ],
};

/// Descriptor for `RespScanStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respScanStatusDescriptor = $convert.base64Decode(
    'Cg5SZXNwU2NhblN0YXR1cxIjCg1zY2FuX2ZpbmlzaGVkGAEgASgIUgxzY2FuRmluaXNoZWQSIQ'
    'oMcmVzdWx0X2NvdW50GAIgASgNUgtyZXN1bHRDb3VudA==');

@$core.Deprecated('Use cmdScanResultDescriptor instead')
const CmdScanResult$json = {
  '1': 'CmdScanResult',
  '2': [
    {'1': 'start_index', '3': 1, '4': 1, '5': 13, '10': 'startIndex'},
    {'1': 'count', '3': 2, '4': 1, '5': 13, '10': 'count'},
  ],
};

/// Descriptor for `CmdScanResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cmdScanResultDescriptor = $convert.base64Decode(
    'Cg1DbWRTY2FuUmVzdWx0Eh8KC3N0YXJ0X2luZGV4GAEgASgNUgpzdGFydEluZGV4EhQKBWNvdW'
    '50GAIgASgNUgVjb3VudA==');

@$core.Deprecated('Use wiFiScanResultDescriptor instead')
const WiFiScanResult$json = {
  '1': 'WiFiScanResult',
  '2': [
    {'1': 'ssid', '3': 1, '4': 1, '5': 12, '10': 'ssid'},
    {'1': 'channel', '3': 2, '4': 1, '5': 13, '10': 'channel'},
    {'1': 'rssi', '3': 3, '4': 1, '5': 5, '10': 'rssi'},
    {'1': 'bssid', '3': 4, '4': 1, '5': 12, '10': 'bssid'},
    {'1': 'auth', '3': 5, '4': 1, '5': 14, '6': '.espressif.WifiAuthMode', '10': 'auth'},
  ],
};

/// Descriptor for `WiFiScanResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wiFiScanResultDescriptor = $convert.base64Decode(
    'Cg5XaUZpU2NhblJlc3VsdBISCgRzc2lkGAEgASgMUgRzc2lkEhgKB2NoYW5uZWwYAiABKA1SB2'
    'NoYW5uZWwSEgoEcnNzaRgDIAEoBVIEcnNzaRIUCgVic3NpZBgEIAEoDFIFYnNzaWQSKwoEYXV0'
    'aBgFIAEoDjIXLmVzcHJlc3NpZi5XaWZpQXV0aE1vZGVSBGF1dGg=');

@$core.Deprecated('Use respScanResultDescriptor instead')
const RespScanResult$json = {
  '1': 'RespScanResult',
  '2': [
    {'1': 'entries', '3': 1, '4': 3, '5': 11, '6': '.espressif.WiFiScanResult', '10': 'entries'},
  ],
};

/// Descriptor for `RespScanResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respScanResultDescriptor = $convert.base64Decode(
    'Cg5SZXNwU2NhblJlc3VsdBIzCgdlbnRyaWVzGAEgAygLMhkuZXNwcmVzc2lmLldpRmlTY2FuUm'
    'VzdWx0UgdlbnRyaWVz');

@$core.Deprecated('Use wiFiScanPayloadDescriptor instead')
const WiFiScanPayload$json = {
  '1': 'WiFiScanPayload',
  '2': [
    {'1': 'msg', '3': 1, '4': 1, '5': 14, '6': '.espressif.WiFiScanMsgType', '10': 'msg'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.espressif.Status', '10': 'status'},
    {'1': 'cmd_scan_start', '3': 10, '4': 1, '5': 11, '6': '.espressif.CmdScanStart', '9': 0, '10': 'cmdScanStart'},
    {'1': 'resp_scan_start', '3': 11, '4': 1, '5': 11, '6': '.espressif.RespScanStart', '9': 0, '10': 'respScanStart'},
    {'1': 'cmd_scan_status', '3': 12, '4': 1, '5': 11, '6': '.espressif.CmdScanStatus', '9': 0, '10': 'cmdScanStatus'},
    {'1': 'resp_scan_status', '3': 13, '4': 1, '5': 11, '6': '.espressif.RespScanStatus', '9': 0, '10': 'respScanStatus'},
    {'1': 'cmd_scan_result', '3': 14, '4': 1, '5': 11, '6': '.espressif.CmdScanResult', '9': 0, '10': 'cmdScanResult'},
    {'1': 'resp_scan_result', '3': 15, '4': 1, '5': 11, '6': '.espressif.RespScanResult', '9': 0, '10': 'respScanResult'},
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `WiFiScanPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wiFiScanPayloadDescriptor = $convert.base64Decode(
    'Cg9XaUZpU2NhblBheWxvYWQSLAoDbXNnGAEgASgOMhouZXNwcmVzc2lmLldpRmlTY2FuTXNnVH'
    'lwZVIDbXNnEikKBnN0YXR1cxgCIAEoDjIRLmVzcHJlc3NpZi5TdGF0dXNSBnN0YXR1cxI/Cg5j'
    'bWRfc2Nhbl9zdGFydBgKIAEoCzIXLmVzcHJlc3NpZi5DbWRTY2FuU3RhcnRIAFIMY21kU2Nhbl'
    'N0YXJ0EkIKD3Jlc3Bfc2Nhbl9zdGFydBgLIAEoCzIYLmVzcHJlc3NpZi5SZXNwU2NhblN0YXJ0'
    'SABSDXJlc3BTY2FuU3RhcnQSQgoPY21kX3NjYW5fc3RhdHVzGAwgASgLMhguZXNwcmVzc2lmLk'
    'NtZFNjYW5TdGF0dXNIAFINY21kU2NhblN0YXR1cxJFChByZXNwX3NjYW5fc3RhdHVzGA0gASgL'
    'MhkuZXNwcmVzc2lmLlJlc3BTY2FuU3RhdHVzSABSDnJlc3BTY2FuU3RhdHVzEkIKD2NtZF9zY2'
    'FuX3Jlc3VsdBgOIAEoCzIYLmVzcHJlc3NpZi5DbWRTY2FuUmVzdWx0SABSDWNtZFNjYW5SZXN1'
    'bHQSRQoQcmVzcF9zY2FuX3Jlc3VsdBgPIAEoCzIZLmVzcHJlc3NpZi5SZXNwU2NhblJlc3VsdE'
    'gAUg5yZXNwU2NhblJlc3VsdEIJCgdwYXlsb2Fk');

