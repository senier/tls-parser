with Ada.Text_IO;

package body TLS.Debug is

    procedure Dump (Data : TLSPlaintext)
    is
    begin
	    Ada.Text_IO.Put (" Version ");
	    Ada.Text_IO.Put (TLS.uint8'Image(Data.version.major));
	    Ada.Text_IO.Put (TLS.uint8'Image(Data.version.minor));
	    Ada.Text_IO.Put (" Length ");
	    Ada.Text_IO.Put (TLS.uint16'Image(Data.length));
	    Ada.Text_IO.Put (" Type ");
        Ada.Text_IO.Put (TLS.ContentType'Image(Data.ctype));
        case  Data.ctype is
            when TLS.ct_handshake =>
	            Ada.Text_IO.Put (" Handshake type ");
                Ada.Text_IO.Put (TLS.HandshakeType'Image(Data.ct_handshake.msg_type));
                case Data.ct_handshake.msg_type is
                    when TLS.ht_client_hello =>
	                    Ada.Text_IO.Put (" Version ");
                        Ada.Text_IO.Put (TLS.uint8'Image(Data.ct_handshake.ht_client_hello.ch_client_version.major));
	                    Ada.Text_IO.Put (".");
                        Ada.Text_IO.Put (TLS.uint8'Image(Data.ct_handshake.ht_client_hello.ch_client_version.minor));
	                    Ada.Text_IO.Put (" Random ");
                        Ada.Text_IO.Put (TLS.uint32'Image(Data.ct_handshake.ht_client_hello.ch_random.gmt_unix_time));
                    when others => null;
                end case;
	            Ada.Text_IO.Put (" Length ");
                Ada.Text_IO.Put (TLS.uint24'Image(Data.ct_handshake.length));
            when others =>
	            Ada.Text_IO.Put (" <Not implemented> ");
        end case;
    end Dump;

end TLS.Debug;
