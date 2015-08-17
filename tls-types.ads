with Ada.Streams;

package TLS.Types
is
    type uint8 is range 0 .. 2**8 - 1;
    for uint8'Size use 8;

    type uint16 is range 0 .. 2**16 - 1;
    for uint16'Size use 16;

    procedure Read_UInt16
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out uint16);
    for uint16'Read use Read_UInt16;

    type uint24 is range 0 .. 2**24 - 1;

    procedure Read_UInt24
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out uint24);
    for uint24'Read use Read_UInt24;

    type uint32 is range 0 .. 2**32 - 1;

    procedure Read_UInt32
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out uint32);
    for uint32'Read use Read_UInt32;

    type Opaque8  is array (uint16 range <>) of uint8;
    type Opaque16 is array (uint16 range <>) of uint8;

    type Vector16 (length : uint16 := 0) is
    record
        data   : Opaque16 (1 .. length);
    end record;

    for Vector16 use
    record
        length at 0 range 0 .. 15;
    end record;

end TLS.Types;
