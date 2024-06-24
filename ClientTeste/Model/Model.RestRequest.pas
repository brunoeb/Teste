unit Model.RestRequest;

uses
  REST.Types, REST.Client,
  REST.Authenticator.Basic;


var
   RRestRequest : TRESTClient;

   function SetupConnection(ZConn:TZConnection):String;
   function Connect : TZConnection;
   procedure Disconnect;

interface

implementation

end.
