with Ada.Text_IO;

with TLS.Types;

package body TLS.Messages
is
    procedure Read_uint8_div_2
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out uint8_div_2)
    is
        length : TLS.Types.uint8;
    begin
        TLs.Types.uint8'Read (Stream, length);
        Item := uint8_div_2 (length) / 2;
    end Read_uint8_div_2;

    procedure Read_CompressionMethod
        (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
         Item   : out CompressionMethod)
    is
        Value : TLS.Types.uint8;
    begin
        TLS.Types.uint8'Read (Stream, Value);
        begin
            Item := CompressionMethod'Enum_Val (Value);
        exception
            when Constraint_Error => Item := CM_INVALID;
        end;
    end Read_CompressionMethod;

end TLS.Messages;
