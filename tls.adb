with Ada.Text_IO;

package body TLS
is
    procedure Read_UInt16
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out uint16)
    is
        v1, v2 : uint8;
    begin
        uint8'Read (Stream, v1);
        uint8'Read (Stream, v2);
        Item := uint16 (v1) * 2**8 + uint16 (v2);
    end Read_UInt16;

    procedure Read_UInt24
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out uint24)
    is
        v1, v2, v3 : uint8;
    begin
        uint8'Read (Stream, v1);
        uint8'Read (Stream, v2);
        uint8'Read (Stream, v3);
        Item := uint24 (v1) * 2**16 + uint24 (v2) * 2**8 + uint24 (v3);
    end Read_UInt24;

    procedure Read_UInt32
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out uint32)
    is
        v1, v2, v3, v4 : uint8;
    begin
        uint8'Read (Stream, v1);
        uint8'Read (Stream, v2);
        uint8'Read (Stream, v3);
        uint8'Read (Stream, v4);
        Item := uint32 (v1) * 2**24 + uint32 (v2) * 2**16 + uint32 (v3) * 2**8 + uint32 (v4);
    end Read_UInt32;

end TLS;
