package TLS
is
	type uint8  is mod 2** 8;
	type uint16 is mod 2**16;

	type ContentType is (change_cipher_spec, alert, handshake, application_data);
	for ContentType use
		(change_cipher_spec => 20,
		 alert              => 21,
		 handshake          => 22,
		 application_data   => 23);

	type ProtocolVersion is
	record
		major : uint8;
		minor : uint8;
	end record;

	--  TLS 1.2
	version : constant ProtocolVersion := ProtocolVersion'(3, 3);

	type TLSCiphertext is
	record
		typ     : ContentType;	
		version : ProtocolVersion;
		length  : uint16;
	end record;

end TLS;
