package body TLS.Messages
is
    procedure Read_uint8_div_2
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out uint8_div_2)
    is
        length : TLS.Types.uint8;
    begin
        TLS.Types.uint8'Read (Stream, length);
        Item := uint8_div_2 (length) / 2;
    end Read_uint8_div_2;

    procedure Read_TLSPlaintext
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out TLSPlaintext)
    is
        CT     : constant ContentType := ContentType'Input (Stream);
        Result : TLSPlaintext (CT);
    begin
        ProtocolVersion'Read (Stream, Result.Version);
        TLS.Types.uint16'Read (Stream, Result.Length);

        case CT is
            when ct_handshake => Handshake'Read (Stream, Result.ct_handshake);
            when others       => null;
        end case;
        Item := Result;
    end Read_TLSPlaintext;

    procedure Read_Extensions
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out Extensions)
    is
        Length : TLS.Types.uint16 := TLS.Types.uint16'Input (Stream);
        Result : Extensions (Length);
        Index, Extension_Length : TLS.Types.uint16;

        --  The 'type' and 'length' field of extensions have a size of 16 bit each, i.e. 4 bytes.
        Extension_Header_Length : constant := 4;
    begin
        Index := Result.Data'First;
        while Length > 0
        loop
            declare
                E : constant Extension := Extension'Input (Stream);
            begin
                case E.ET is
                    when ET_Signature_Algorithms => Extension_Length := E.supported_signature_algorithms.Length;
                    when others                  => Extension_Length := E.Unknown_Extension.Length;
                end case;
                Result.Data (Index) := E;
            end;
            Index := Index + 1;

            exit when Index > Result.Data'Last or Length < Extension_Length;
            Length := Length - Extension_Length - Extension_Header_Length;
        end loop;
        Item := Result;
    end Read_Extensions;

end TLS.Messages;
