codeunit 50121 "Download Episode Information"
{
    procedure DownloadTvShowEpisodes(TelevisionShowP: Record "Television Show")
    begin
        if EpisodeEntriesExist(TelevisionShowP.Code) then
            DeleteExistingEpisodes(TelevisionShowP.Code);

        DownloadEpisodes(TelevisionShowP);
        ShowSuccessMessage();
    end;

    local procedure EpisodeEntriesExist(TelevisionShowCodeP: Code[20]): Boolean
    var
        TelevisionShowEpisodeL: Record "Television Show Episode";
    begin
        TelevisionShowEpisodeL.SetRange("Television Show Code", TelevisionShowCodeP);
        exit(not TelevisionShowEpisodeL.IsEmpty());
    end;

    local procedure DeleteExistingEpisodes(TelevisionShowCodeP: Code[20])
    var
        TelevisionShowEpisodeL: Record "Television Show Episode";
    begin
        TelevisionShowEpisodeL.SetRange("Television Show Code", TelevisionShowCodeP);
        TelevisionShowEpisodeL.DeleteAll();
    end;

    local procedure ShowSuccessMessage()
    var
        
    begin
        if GuiAllowed() then
            Message(SuccessMessageTxtG);
    end;

    local procedure DownloadEpisodes(TelevisionShowP: Record "Television Show")
    var
        ClientL: HttpClient;
        ResponseMessageL: HttpResponseMessage;
        JsonArrayL: JsonArray;
        JsonTokenL: JsonToken;
        JsonObjectL: JsonObject;
        JsonContentTextL: Text;
        UrlL: Text;
        
        Counter: Integer;
    begin
        If TelevisionShowP."TVMaze ID" = 0 then
            Error(MissingIdErrG, TelevisionShowP.FieldCaption("TVMaze ID"));
        UrlL := 'http://api.tvmaze.com/shows/' + Format(TelevisionShowP."TVMaze ID") + '/episodes';
        ClientL.Get(UrlL, ResponseMessageL);
        if not ResponseMessageL.IsSuccessStatusCode() then
            Error(RequestErrG, ResponseMessageL.HttpStatusCode, ResponseMessageL.ReasonPhrase);
        ResponseMessageL.Content().ReadAs(JsonContentTextL);
        if not JsonArrayL.ReadFrom(JsonContentTextL) then
            Error(WrongFormatErrG);
        for Counter := 0 to JsonArrayL.Count() - 1 do begin
            JsonArrayL.Get(Counter, JsonTokenL);
            JsonObjectL := JsonTokenL.AsObject();
            CreateTelevisionShowEpisodeEntry(TelevisionShowP, JsonObjectL)
        end;
    end;

    local procedure CreateTelevisionShowEpisodeEntry(TelevisionShowP: Record "Television Show"; JsonObjectP: JsonObject)
    var
        TelevisionShowEpisodeP: Record "Television Show Episode";
        JsonTokenL: JsonToken;
    begin
        TelevisionShowEpisodeP.Init();

        TelevisionShowEpisodeP."Television Show Code" := TelevisionShowP.Code;

        GetJsonToken(JsonObjectP, 'id', JsonTokenL);
        TelevisionShowEpisodeP."Episode ID" := JsonTokenL.AsValue().AsInteger();

        GetJsonToken(JsonObjectP, 'name', JsonTokenL);
        TelevisionShowEpisodeP.Name := CopyStr(JsonTokenL.AsValue().AsText(), 
        1, MaxStrLen(TelevisionShowEpisodeP.Name));

        GetJsonToken(JsonObjectP, 'season', JsonTokenL);
        TelevisionShowEpisodeP."Season No." := JsonTokenL.AsValue().AsInteger();

        GetJsonToken(JsonObjectP, 'number', JsonTokenL);
        TelevisionShowEpisodeP."Episode No." := JsonTokenL.AsValue().AsInteger();

        GetJsonToken(JsonObjectP, 'airdate', JsonTokenL);
        TelevisionShowEpisodeP."Air Date" := JsonTokenL.AsValue().AsDate();

        GetJsonToken(JsonObjectP, 'summary', JsonTokenL);
        TelevisionShowEpisodeP.Summary := CopyStr(JsonTokenL.AsValue().AsText(), 
        1, MaxStrLen(TelevisionShowEpisodeP.Summary));

        TelevisionShowEpisodeP.Insert();
    end;

    local procedure GetJsonToken(JsonObjectL: JsonObject; KeyTextP: Text; var JsonToken: JsonToken)
    var
        
    begin
        if not JsonObjectL.Get(KeyTextP, JsonToken) then
            error(CannotFindKeyErrG, KeyTextP);
    end;

    var
        CannotFindKeyErrG: Label 'Cannot find the following key: %1';
        MissingIdErrG: Label 'You must populate the %1 before you can download episodes.';
        RequestErrG: Label 'An error ocurred when trying to get the episodes:\\%1:\\%2';
        WrongFormatErrG: Label 'The response is not formatted correctly.';
        SuccessMessageTxtG: Label 'Episode information has been downloaded.';
}