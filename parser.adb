with TLS;
with Ada.Text_IO.Text_Streams;

procedure Parser
is
	PT : TLS.TLSPlaintext;
begin
	TLS.TLSPlaintext'Read (Ada.Text_IO.Text_Streams.Stream (Ada.Text_IO.Standard_Input), PT);

	Ada.Text_IO.Put (" Version ");
	Ada.Text_IO.Put (TLS.uint8'Image(PT.version.major));
	Ada.Text_IO.Put (TLS.uint8'Image(PT.version.minor));
	Ada.Text_IO.Put (" Length ");
	Ada.Text_IO.Put (TLS.uint16'Image(PT.length));
	Ada.Text_IO.Put (" Type ");
    Ada.Text_IO.Put (TLS.ContentType'Image(PT.ctype));
    case  PT.ctype is
        when TLS.ct_handshake =>
	        Ada.Text_IO.Put (" Handshake type ");
            Ada.Text_IO.Put (TLS.HandshakeType'Image(PT.ct_handshake.msg_type));
            case PT.ct_handshake.msg_type is
                when TLS.ht_client_hello =>
	                Ada.Text_IO.Put (" Version ");
                    Ada.Text_IO.Put (TLS.uint8'Image(PT.ct_handshake.ht_client_hello.ch_client_version.major));
	                Ada.Text_IO.Put (".");
                    Ada.Text_IO.Put (TLS.uint8'Image(PT.ct_handshake.ht_client_hello.ch_client_version.minor));
	                Ada.Text_IO.Put (" Random ");
                    Ada.Text_IO.Put (TLS.uint32'Image(PT.ct_handshake.ht_client_hello.ch_random.gmt_unix_time));
                when others => null;
            end case;
	        Ada.Text_IO.Put (" Length ");
            Ada.Text_IO.Put (TLS.uint24'Image(PT.ct_handshake.length));
        when others =>
	        Ada.Text_IO.Put (" <Not implemented> ");
    end case;
end Parser;
