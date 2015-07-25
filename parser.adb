with TLS;
with Ada.Text_IO.Text_Streams;

procedure Parser
is
	CT : TLS.TLSCiphertext;
begin
	TLS.TLSCiphertext'Read (Ada.Text_IO.Text_Streams.Stream (Ada.Text_IO.Standard_Input), CT);

	Ada.Text_IO.Put (TLS.ContentType'Image(CT.typ));
	Ada.Text_IO.Put (" Version ");
	Ada.Text_IO.Put (TLS.uint8'Image(CT.version.major));
	Ada.Text_IO.Put (TLS.uint8'Image(CT.version.minor));
	Ada.Text_IO.Put (" Length ");
	Ada.Text_IO.Put (TLS.uint16'Image(CT.length));
end Parser;
