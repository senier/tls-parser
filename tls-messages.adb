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

end TLS.Messages;
