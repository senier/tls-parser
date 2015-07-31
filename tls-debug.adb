with Ada.Text_IO;

package body TLS.Debug is

    package IIO is new Ada.Text_IO.Integer_IO (uint8);

    procedure Dump (V : uint8)
    is
    begin
        Ada.Text_IO.Put (V'Img(2..V'Img'Last));
    end Dump;

    procedure Dump (O : Opaque)
    is
        Buffer : String (1..6);
    begin
        for Element of O
        loop
            IIO.Put (To => Buffer, Item => Element, Base => 16);
            if Element > 16#F#
            then
                Ada.Text_IO.Put (Buffer (4..5));
            else
                Ada.Text_IO.Put ("0");
                Ada.Text_IO.Put (Buffer (5..5));
            end if;
        end loop;
    end Dump;

    procedure Dump (V : Vector16)
    is
    begin
        Dump (V.Data);
    end Dump;

    procedure Dump (Data : TLSPlaintext)
    is
    begin
	    Ada.Text_IO.Put ("Version ");
	    Dump (Data.version.major);
	    Ada.Text_IO.Put (".");
	    Dump (Data.version.minor);
	    Ada.Text_IO.New_Line;

	    Ada.Text_IO.Put ("Length");
	    Ada.Text_IO.Put_Line (TLS.uint16'Image(Data.length));

	    Ada.Text_IO.Put ("Type ");
        Ada.Text_IO.Put_Line (TLS.ContentType'Image(Data.ctype));

        case  Data.ctype is
            when TLS.ct_handshake =>
	            Ada.Text_IO.Put ("   Handshake Type ");
                Ada.Text_IO.Put_Line (TLS.HandshakeType'Image(Data.ct_handshake.msg_type));
	            Ada.Text_IO.Put ("   Handshake Length");
                Ada.Text_IO.Put_Line (TLS.uint24'Image(Data.ct_handshake.length));
                case Data.ct_handshake.msg_type is
                    when TLS.ht_client_hello =>
	                    Ada.Text_IO.Put ("      Client Version ");
                        Dump (Data.ct_handshake.ht_client_hello.ch_client_version.major);
	                    Ada.Text_IO.Put (".");
                        Dump (Data.ct_handshake.ht_client_hello.ch_client_version.minor);
	                    Ada.Text_IO.New_Line;

	                    Ada.Text_IO.Put_Line ("      Random");
	                    Ada.Text_IO.Put      ("         UNIX time: ");
                        Ada.Text_IO.Put_Line (TLS.uint32'Image(Data.ct_handshake.ht_client_hello.ch_random.gmt_unix_time));
	                    Ada.Text_IO.Put      ("         Random Bytes: ");
                        Dump (Data.ct_handshake.ht_client_hello.ch_random.random_bytes);
	                    Ada.Text_IO.New_Line;

                    when others => null;
                end case;
            when others =>
	            Ada.Text_IO.Put (" <Not implemented> ");
        end case;
    end Dump;

end TLS.Debug;
