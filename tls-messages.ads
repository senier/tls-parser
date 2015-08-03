with System;
with Ada.Streams;

with TLS.Types;
with TLS.Parameters;

package TLS.Messages
is
    --  FIXME: Implement custom 'Read operation for enumtypes to
    --  shield from invalid values (make every undefined value
    --  result in the Invalid element)

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

    --------------------
    --  Client Hello  --
    --------------------

    type uint8_div_2 is new TLS.Types.uint8;

    procedure Read_uint8_div_2
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out uint8_div_2);
    for uint8_div_2'Read use Read_uint8_div_2;

    type CipherList is array (uint8_div_2 range <>) of TLS.Parameters.CipherSuite;

    -- FIXME: Check whether length of 0 really leads to an empty list

    type CipherSuites (length : uint8_div_2 := uint8_div_2'Last) is
    record
        cs_data : CipherList (1..length);
    end record;

    for CipherSuites use
    record
        length at 0 range 0 .. 7;
    end record;

    type Random is
    record
        gmt_unix_time : TLS.Types.uint32;
        random_bytes  : TLS.Types.Opaque8 (1..28);
    end record;

    type ClientHello
    is
    record
        ch_client_version    : ProtocolVersion;
        ch_random            : Random;
        ch_session_id        : TLS.Types.Vector16;
        ch_cipher_suites     : CipherSuites;
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
    type Handshake (msg_type : HandshakeType := ht_invalid) is
    record
        length : TLS.Types.uint24;
        case msg_type is
            when ht_hello_request       => null;
            when ht_client_hello        => ht_client_hello : ClientHello;
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
        msg_type at 0 range 0 ..  7;
        length   at 1 range 0 .. 23;
    end record;

    -------------------------
    --  Change Cipher Spec --
    -------------------------

    --------------------
    --  TLS Plaintext --
    --------------------

    type TLSPlaintext
        (ctype  : ContentType := ct_invalid)
    is
    record
        version : ProtocolVersion;
        length  : TLS.Types.uint16;
        case ctype is
            when ct_invalid            => null;
            when ct_change_cipher_spec => null; --ct_change_cipher_spec : ChangeCipherSpec;
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

    pragma Pack (TLSPlaintext);

end TLS.Messages;
