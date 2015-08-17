package TLS.Messages.Debug
is

    procedure Dump (Data : TLSPlaintext);

private

    procedure Dump (V : TLS.Messages.CompressionMethods);
    procedure Dump (V : TLS.Messages.CipherSuites);
    procedure Dump (V : TLS.Types.Vector16);
    procedure Dump (O : TLS.Types.Opaque16);
    procedure Dump (O : TLS.Types.Opaque8);
    procedure Dump (V : TLS.Types.uint8);

end TLS.Messages.Debug;
