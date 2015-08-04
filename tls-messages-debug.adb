with Ada.Text_IO;

with TLS.Types;
with TLS.Messages;

use type TLS.Types.uint8;

package body TLS.Messages.Debug is

    package IIO is new Ada.Text_IO.Integer_IO (TLS.Types.uint8);

    procedure Dump (V : TLS.Types.uint8)
    is
    begin
        Ada.Text_IO.Put (V'Img(2..V'Img'Last));
    end Dump;

    procedure Dump (O : TLS.Types.Opaque8)
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

    procedure Dump (O : TLS.Types.Opaque16)
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

    procedure Dump (V : TLS.Types.Vector16)
    is
    begin
        Dump (V.Data);
    end Dump;

    procedure Dump (V : TLS.Messages.CipherSuites)
    is
    begin
        for Element of V.cs_data
        loop
            Ada.Text_IO.Put ("         ");
            Ada.Text_IO.Put_Line (Element'Img);
        end loop;
    end Dump;

    procedure Dump (V : TLS.Messages.CompressionMethods)
    is
    begin
        for Element of V.cm_data
        loop
            Ada.Text_IO.Put ("         ");
            Ada.Text_IO.Put_Line (Element'Img);
        end loop;
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
	    Ada.Text_IO.Put_Line (TLS.Types.uint16'Image(Data.length));

	    Ada.Text_IO.Put ("Type ");
        Ada.Text_IO.Put_Line (TLS.Messages.ContentType'Image(Data.ctype));

        case  Data.ctype is
            when TLS.Messages.ct_handshake =>
	            Ada.Text_IO.Put ("   Handshake Type ");
                Ada.Text_IO.Put_Line (TLS.Messages.HandshakeType'Image(Data.ct_handshake.msg_type));
	            Ada.Text_IO.Put ("   Handshake Length");
                Ada.Text_IO.Put_Line (TLS.Types.uint24'Image(Data.ct_handshake.length));
                case Data.ct_handshake.msg_type is
                    when TLS.Messages.ht_client_hello =>
	                    Ada.Text_IO.Put ("      Client Version ");
                        Dump (Data.ct_handshake.ht_client_hello.ch_client_version.major);
	                    Ada.Text_IO.Put (".");
                        Dump (Data.ct_handshake.ht_client_hello.ch_client_version.minor);
	                    Ada.Text_IO.New_Line;

	                    Ada.Text_IO.Put_Line ("      Random");
	                    Ada.Text_IO.Put      ("         UNIX time: ");
                        Ada.Text_IO.Put_Line (TLS.Types.uint32'Image(Data.ct_handshake.ht_client_hello.ch_random.gmt_unix_time));
	                    Ada.Text_IO.Put      ("         Random Bytes: ");
                        Dump (Data.ct_handshake.ht_client_hello.ch_random.random_bytes);
	                    Ada.Text_IO.New_Line;
	                    Ada.Text_IO.Put      ("      Session ID: ");
                        Dump (Data.ct_handshake.ht_client_hello.ch_session_id);
	                    Ada.Text_IO.New_Line;
	                    Ada.Text_IO.Put_Line ("      Ciphers: ");
                        Dump (Data.ct_handshake.ht_client_hello.ch_cipher_suites);
	                    Ada.Text_IO.New_Line;
	                    Ada.Text_IO.Put_Line ("      Compression: ");
                        Dump (Data.ct_handshake.ht_client_hello.ch_compression_methods);
	                    Ada.Text_IO.New_Line;

                    when others => null;
                end case;
            when others =>
	            Ada.Text_IO.Put (" <Not implemented> ");
        end case;
    end Dump;

end TLS.Messages.Debug;
