# protobuf_comm

_protobuf_comm_ is a lightweight communication library for [Protocol Buffers](https://protobuf.dev/).

It supports messages written using proto 2 syntax and additionally requires every defined message to have a `CompType` enum containing a unique message ID (composed of a `COMP_ID` and `MSG_TYPE`), e.g., as shown below:

```proto
message SearchRequest {
  enum CompType {
    COMP_ID = 100;
    MSG_TYPE = 1;
  }
  required string query = 1;
}

```

Using this unique identifiers, _protobuf_comm_ defines a simple [framing protocol](#Framing Protocol) that it relies on to (de)-serialize messages.

## Protocol Buffers Overview 
Protocol Buffers (protobuf) are a data format used for serialisation of structured message data. 
The format is extensible and provides for basic data types, nesting, structure re-use, efficient serialization and deserialization, and variable-length lists.
The message types are defined in a special definition language akin to C/C++ structs.
In order to easily serialize and deserialize data in the protobuf format, special compilers are provided.
These take the protobuf message definition and automatically create code for creating and reading messages in the provided protobuf definitions in common languages like C++, Java or Python.

## Framing Protocol
Since serialized protobuf message do not contain information about the message length or type, or additional space for additional meta data like encryption-related information, a framing protocol is used which wraps the serialized protobuf messages and allows for easier handling of the messages on the receiver's side. The protocol consists of two parts, a protocol frame which contains the message-related meta data and a message header. 

Each message that is sent over the network is prepended by the headers. The receiver can use the definition of the header and the information contained within to read the following serialized protobuf message correctly. 

### Header Format
Header messages must be 4-byte-aligned, i.e. the addresses of the data entries is evenly divisible by 4.
The size of the _frame header_ message structure sums up to exactly eight bytes when sent over the network, the _message header_ will be exactly four bytes. All contained numbers must be encoded in network byte order (big endian, most significant bit first). The numbers are encoded as 8 (uint8 t), 16 (uint16 t) or 32 bit (uint32 t) unsigned integers respectively.

When sending a message over the network, first the protobuf message is serialized (to determine the payload size). Then the frame and message headers are prepared with the appropriate component ID, message type, and the payload size as just determined. Then the frame header is sent, possibly followed by an encryption IV, again followed by the message header and the serialized message. Examples of the message layout are provided in the following two figures:

<p align="center">
  <img src="https://github.com/fawkesrobotics/protobuf_comm/blob/main/images/protobuf_message_unencrypted.png?raw=true">
  <br><br>
  <b>Figure 1: </b> Packet layout diagram for unencrypted messages.
</p>

<p align="center">
  <img src="https://github.com/fawkesrobotics/protobuf_comm/blob/main/images/protobuf_message_encrypted.png?raw=true">
  <br><br>
  <b>Figure 2: </b> Packet layout diagram for encrypted messages.
</p>

### Frame Header

The frame header corresponds to the following C++ struct:
```
typedef struct {
  /// Frame header version
  uint8_t header_version ;
  /// One of PB_ENCRYPTION_ *
  uint8_t cipher ;
  /// reserved for future use
  uint8_t reserved_2 ;
  /// reserved for future use
  uint8_t reserved_3 ;
  /// payload size in bytes
  /// includes message and
  /// header , _not_ IV
  uint32_t payload_size ;
} frame_header_t ;
```

The following fields are contained:
- **protocol version**: The version of the protocol. The current protocol version is **2**
- **cipher:** Indicates the cipher suite that is used. The following values can be used: 

| Cipher | Byte | initialization vector size / Bytes |
| --- | --- | --- |
| NONE | 0x00 | 0 |
| AES_128_ECB | 0x01 | 0 |
| AES_128_CBC | 0x02 | 16 |
| AES_256_ECB | 0x03 | 0 |
| AES_256_CBC | 0x04 | 16 |

- **reserved:** Currently unused for future extensions. Bytes must be set to 0.
- **payload size:** Size in bytes of the following payload. This does include the message header and the serialized protobuf message. It does not include an encryption IV header (if required by cipher). The payload size must be encoded in network byte order (big-endian). </p>
The fields must be contained in the given sizes and order but do not need to be implemented as a C++ struct. 

### Message Header

The message header corresponds to the following C++ struct:
```
typedef struct {
  /// component id ;
  uint16_t component_id ;
  /// message type
  uint16_t msg_type ;
} message_header_t;
```
The following fields are contained: 
- **component ID:** General ID, general addressee of message. For refbox message must be set to 2000 (as encoded in the protobuf messages’ COMP ID field of the CompType enum. The component ID must be encoded in network byte order (big-endian).
- **message type:** Numeric message ID of the specific message serialized in the payload. Must be the ID encoded in the MSG TYPE field of the CompType enum. The message type is specific to the component ID. Different component IDs can have message of the same message type which are unrelated. The message type must be encoded in network byte order (big-endian).

### Encryption
The framing protocol supports per-message encryption based on a symmetric block cipher. For now, the supported encryption modes are based on AES with either 128 or 256 bit key length in either electronic code book (ECB) or cipher block chaining (CBC) mode.

An overview of the format of an encrypted message is given in the second figure above, contrasting the first figure which depicts an unencrypted message. It is similar to the unencrypted packet with two key differences. First, the initialization vector is placed between the frame and message headers. And second, the message header and protobuf payload are encrypted.

## Acknowledgements
_protobuf_comm_ was created by Tim Niemueller as a component for the [referee box](https://github.com/robocup-logistics/rcll-refbox/) of the [RoboCup Logistics League](https://ll.robocup.org/).
