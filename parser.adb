with TLS.Messages.Debug;
with Ada.Text_IO.Text_Streams;

procedure Parser
is
	PT : TLS.Messages.TLSPlaintext;
begin
	TLS.Messages.TLSPlaintext'Read (Ada.Text_IO.Text_Streams.Stream (Ada.Text_IO.Standard_Input), PT);
    TLS.Messages.Debug.Dump (PT);
end Parser;
