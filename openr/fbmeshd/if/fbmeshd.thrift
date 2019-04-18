/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

namespace cpp2 openr.fbmeshd.thrift
namespace py3 fbmeshd

exception MeshServiceError {
  1: string message
} (message = "message")

//typedef list<Mesh> (cpp.type = "std::vector<Mesh>") MeshList

typedef map<string, i32>
(cpp.type = "std::unordered_map<std::string, int32_t>") PeerMetrics

typedef i32 (cpp2.type = "int32_t") UInt32
typedef i64 (cpp2.type = "uint64_t") MacAddress // network byte order
typedef byte (cpp2.type = "uint8_t") u8
typedef i32 (cpp2.type = "uint32_t") u32
typedef i64 (cpp2.type = "uint64_t") u64

struct SeparaPayload {
  1: MacAddress domain
  2: i32 metricToGate
  3: MacAddress desiredDomain
  4: optional bool enabled = true
}

struct Mesh {
  4: i32 frequency
  6: i32 channelWidth
  7: i32 centerFreq1
  12: optional i32 centerFreq2
  14: optional i32 txPower
}

struct MpathEntry {
  1: MacAddress dest
  2: MacAddress nextHop
  3: u64 sn
  4: u32 metric
  5: u64 expTime
  7: u8 hopCount
  8: bool isRoot
  9: bool isGate
}

service MeshService {
  list<string> getPeers(1: string ifName)
    throws (1: MeshServiceError error)

  PeerMetrics getMetrics(1: string ifName)
    throws (1: MeshServiceError error)

  Mesh getMesh(1: string ifName)
    throws (1: MeshServiceError error)

  void setMetricOverride(1: string macAddress, 2: UInt32 metric)
  UInt32 getMetricOverride(1: string macAddress)
  i32 clearMetricOverride(1: string macAddress)

  list<MpathEntry> dumpMpath();
}

struct MeshPathFramePANN {
  1: MacAddress origAddr
  2: u64 origSn
  3: u8 hopCount
  4: u8 ttl
  6: MacAddress targetAddr
  7: u32 metric
  8: bool isGate
  9: bool replyRequested
}
