with TLS.Debug;
with Ada.Text_IO.Text_Streams;

procedure Parser
is
	PT : TLS.TLSPlaintext;
begin
	TLS.TLSPlaintext'Read (Ada.Text_IO.Text_Streams.Stream (Ada.Text_IO.Standard_Input), PT);
    TLS.Debug.Dump (PT);
end Parser;
