with TLS.Types;

package body TLS.Parameters
is
    procedure Read_CipherSuite
       (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
        Item   : out CipherSuite)
    is
        Value : TLS.Types.uint16;
    begin
        TLS.Types.uint16'Read (Stream, Value);
        begin
            Item := CipherSuite'Enum_Val (Value);
        exception
            when Constraint_Error => Item := INVALID;
        end;
    end Read_CipherSuite;

end TLS.Parameters;
