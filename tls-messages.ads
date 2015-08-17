with Ada.Streams;

with TLS.Types;
with TLS.Parameters;

use type TLS.Types.uint16;

package TLS.Messages
is
    --  FIXME: Replace enums by numerals + constants
    --  FIXME: Correct casing
    --  FIXME: Check all sizes at all levels

    type ContentType is
        (ct_change_cipher_spec,
         ct_alert,
         ct_handshake,
         ct_application_data,
         ct_invalid);

    for ContentType use
        (ct_change_cipher_spec =>  20,
         ct_alert              =>  21,
         ct_handshake          =>  22,
         ct_application_data   =>  23,
         ct_invalid            => 255);
    for ContentType'Size use 8;

    type ProtocolVersion is
    record
        major : TLS.Types.uint8;
        minor : TLS.Types.uint8;
    end record;

    for ProtocolVersion use
    record
        major at 0 range 0 .. 7;
        minor at 1 range 0 .. 7;
    end record;

    --  TLS 1.2
    version : constant ProtocolVersion := ProtocolVersion'(3, 3);

    ----------------
    --  Extension --
    ----------------

    type HashAlgorithm is (HA_None, HA_MD5, HA_SHA1, HA_SHA224, HA_SHA256, HA_SHA384, HA_SHA512, HA_Invalid);
    for HashAlgorithm use
        (HA_None    =>   0,
         HA_MD5     =>   1,
         HA_SHA1    =>   2,
         HA_SHA224  =>   3,
         HA_SHA256  =>   4,
         HA_SHA384  =>   5,
         HA_SHA512  =>   6,
         HA_Invalid => 255);
    for HashAlgorithm'Size use 8;

    type SignatureAlgorithm is (SA_Anonymous, SA_RSA, SA_DSA, SA_ECDSA, SA_Invalid);
    for SignatureAlgorithm use
        (SA_Anonymous =>   0,
         SA_RSA       =>   1,
         SA_DSA       =>   2,
         SA_ECDSA     =>   3,
         SA_Invalid   => 255);
    for SignatureAlgorithm'Size use 8;

    type SignatureAndHashAlgorithm is
    record
        hash      : HashAlgorithm;
        signature : SignatureAlgorithm;
    end record;

    type SignatureAndHashAlgorithmsList is array (TLS.Types.uint16 range <>) of SignatureAndHashAlgorithm;

    type SignatureAndHashAlgorithms (Length : TLS.Types.uint16 := 0) is
    record
        supported_signature_algorithms : SignatureAndHashAlgorithmsList (1 .. Length);
    end record;

    --  FIXME: Add other extensions from [TLSEXT]
    type ExtensionType is range 0 .. 2**16 - 1;
    for ExtensionType'Size use 16;

    ET_Signature_Algorithms : constant ExtensionType := 0;
    ET_Invalid              : constant ExtensionType := 2**16 - 1;

    type Extension (ET : ExtensionType := ET_Invalid) is
    record
        case ET is
            when ET_Signature_Algorithms => supported_signature_algorithms : SignatureAndHashAlgorithms;
            when others                  => null;
        end case;
    end record;

    type ExtensionList is array (TLS.Types.uint16 range <>) of Extension;

    type Extensions (Length : TLS.Types.uint16 := 0) is
    record
        Data : ExtensionList (1 .. Length);
    end record;

    procedure Read_Extensions
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out Extensions);
    for Extensions'Read use Read_Extensions;

    --------------------
    --  Client Hello  --
    --------------------

    type uint8_div_2 is new TLS.Types.uint8;

    procedure Read_uint8_div_2
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out uint8_div_2);
    for uint8_div_2'Read use Read_uint8_div_2;

    type CipherList is array (uint8_div_2 range <>) of TLS.Parameters.CipherSuite;

    --  FIXME: Check whether length of 0 really leads to an empty list

    type CipherSuites (length : uint8_div_2 := 0) is
    record
        cs_data : CipherList (1 .. length);
    end record;

    type CompressionMethod is (CM_NULL, CM_DEFLATE, CM_INVALID);
    for CompressionMethod use
       (CM_NULL    =>   0,
        CM_DEFLATE =>   1,
        CM_INVALID => 255);
    for CompressionMethod'Size use 8;

    procedure Read_CompressionMethod
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out CompressionMethod);
    for CompressionMethod'Read use Read_CompressionMethod;

    type CompressionList is array (TLS.Types.uint8 range <>) of CompressionMethod;

    type CompressionMethods (length : TLS.Types.uint8 := 0) is
    record
        cm_data : CompressionList (1 .. length);
    end record;

    for CipherSuites use
    record
        length at 0 range 0 .. 7;
    end record;

    type Random is
    record
        gmt_unix_time : TLS.Types.uint32;
        random_bytes  : TLS.Types.Opaque8 (1 .. 28);
    end record;

    type ClientHello
    is
    record
        ch_client_version      : ProtocolVersion;
        ch_random              : Random;
        ch_session_id          : TLS.Types.Vector16;
        ch_cipher_suites       : CipherSuites;
        ch_compression_methods : CompressionMethods;
    end record;

    --------------------------
    --  Handshake messages  --
    --------------------------

    --  Handshake message type
    type HandshakeType is
        (ht_hello_request,
         ht_client_hello,
         ht_server_hello,
         ht_certificate,
         ht_server_key_exchange,
         ht_certificate_request,
         ht_server_hello_done,
         ht_certificate_verify,
         ht_client_key_exchange,
         ht_finished,
         ht_invalid);
    for HandshakeType use
        (ht_hello_request       =>   0,
         ht_client_hello        =>   1,
         ht_server_hello        =>   2,
         ht_certificate         =>  11,
         ht_server_key_exchange =>  12,
         ht_certificate_request =>  13,
         ht_server_hello_done   =>  14,
         ht_certificate_verify  =>  15,
         ht_client_key_exchange =>  16,
         ht_finished            =>  20,
         ht_invalid             => 255);
    for HandshakeType'Size use 8;

    --  Handshake type
    type Handshake
        (Msg_Type : HandshakeType := ht_invalid)
    is
    record
        length : TLS.Types.uint24;
        case Msg_Type is
            when ht_hello_request       => null;
            when ht_client_hello        => ht_client_hello : ClientHello;
                                           ht_extensions   : Extensions (10);
            when ht_server_hello        => null;
            when ht_certificate         => null;
            when ht_server_key_exchange => null;
            when ht_certificate_request => null;
            when ht_server_hello_done   => null;
            when ht_certificate_verify  => null;
            when ht_client_key_exchange => null;
            when ht_finished            => null;
            when ht_invalid             => null;
        end case;
    end record;

    for Handshake use
    record
        Msg_type at 0 range 0 ..  7;
        Length   at 1 range 0 .. 23;
    end record;

    --------------------
    --  TLS Plaintext --
    --------------------

    type TLSPlaintext
        (ctype             : ContentType := ct_invalid)
    is
    record
        version   : ProtocolVersion;
        length    : TLS.Types.uint16;

        case ctype is
            when ct_invalid            => null;
            when ct_change_cipher_spec => null; --  ct_change_cipher_spec : ChangeCipherSpec;
            when ct_alert              => null;
            when ct_handshake          => ct_handshake          : Handshake;
            when ct_application_data   => null;
        end case;
    end record;

    for TLSPlaintext use
    record
        ctype   at 0 range 0 ..  7;
        version at 1 range 0 .. 15;
        length  at 3 range 0 .. 15;
    end record;

    procedure Read_TLSPlaintext
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out TLSPlaintext);
    for TLSPlaintext'Read use Read_TLSPlaintext;

    pragma Pack (TLSPlaintext);

end TLS.Messages;
