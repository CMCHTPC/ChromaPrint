program TestProject;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, pl_synapse, Test,
  CP.SilenceRemover, CP.Def, CP.AudioProcessor, CP.FFT, CP.Chroma,
  CP.Fingerprint, CP.FeatureVectorConsumer;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TAPITestForm, APITestForm);
  Application.Run;
end.

