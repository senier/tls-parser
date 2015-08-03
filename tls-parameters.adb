with TLS.Types;

package body TLS.Parameters
is
    procedure Read_CipherSuite
       (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
        Item   : out CipherSuite)
    is
        Value : TLS.Types.uint16;
    begin
        --  FIXME: Value make no sense. Invalid byte order?
        TLS.Types.uint16'Read (Stream, Value);
        begin
            Item := CipherSuite'Val (Value);
        exception
            when Constraint_Error => Item := INVALID;
        end;
    end Read_CipherSuite;

end TLS.Parameters;
