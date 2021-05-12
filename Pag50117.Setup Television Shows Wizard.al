page 50117 "Load Television Shows Wizard"
{
    Caption = 'Load Television Shows';
    PageType = NavigatePage;

    layout
    {
        area(content)
        {
            group(StandardBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisibleG and not FinishActionEnabledG;
                field(MediaResourcesStandardG; MediaResourcesStandardG."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(FinishedBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisibleG and FinishActionEnabledG;
                field(MediaResourcesDoneG; MediaResourcesDoneG."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(step1)
            {
                Visible = Step1VisibleG;
                group(Welcome)
                {
                    Caption = 'Welcome to the Television Shows application!';
                    Visible = Step1VisibleG;
                    group(Welcome1)
                    {
                        Caption = '';
                        InstructionalText = 'This wizard will let you select which genre of television shows we should load for sample data.';
                    }
                }
                group(LetsGo)
                {
                    Caption = 'Let''s go!';
                    group(LetsGo1)
                    {
                        Caption = '';
                        InstructionalText = 'Press Next to continue.';
                    }
                }
            }
            group(step2)
            {
                Caption = '';
                InstructionalText = 'Select the genre(s) of television shows you want to load.';
                Visible = Step2VisibleG;

                field(Genre1SelectedG; Genre1SelectedG)
                {
                    Caption = 'Comedy';
                    ApplicationArea = All;
                }
                field(Genre2SelectedG; Genre2SelectedG)
                {
                    Caption = 'Drama';
                    ApplicationArea = All;
                }
                field(Genre3Selected; Genre3SelectedG)
                {
                    Caption = 'Family';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = BackActionEnabledG;
                Image = PreviousRecord;
                InFooterBar = true;
                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = NextActionEnabledG;
                Image = NextRecord;
                InFooterBar = true;
                trigger OnAction();
                begin
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = FinishActionEnabledG;
                Image = Approve;
                InFooterBar = true;
                trigger OnAction();
                begin
                    FinishAction();
                end;
            }
        }
    }

    trigger OnInit();
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage();
    begin
        UpdateTelevisionShowSetupToNotFinished();
        StepG := StepG::Start;
        EnableControls();
    end;

    var
        MediaRepositoryDoneG: Record "Media Repository";
        MediaRepositoryStandardG: Record "Media Repository";
        MediaResourcesDoneG: Record "Media Resources";
        MediaResourcesStandardG: Record "Media Resources";
        StepG: Option Start,Finish;
        BackActionEnabledG: Boolean;
        FinishActionEnabledG: Boolean;
        NextActionEnabledG: Boolean;
        Step1VisibleG: Boolean;
        Step2VisibleG: Boolean;
        TopBannerVisibleG: Boolean;
        Genre1SelectedG: Boolean;
        Genre2SelectedG: Boolean;
        Genre3SelectedG: Boolean;

    local procedure EnableControls();
    begin
        ResetControls();

        case StepG of
            StepG::Start:
                ShowStep1;
            StepG::Finish:
                ShowStep2;
        end;
    end;

    local procedure FinishAction();
    begin
        TestGenresSelected();
        LoadTelevisionShows();
        CurrPage.Close();
    end;

    local procedure NextStep(Backwards: Boolean);
    begin
        if Backwards then
            StepG := StepG - 1
        ELSE
            StepG := StepG + 1;

        EnableControls();
    end;

    local procedure ShowStep1();
    begin
        Step1VisibleG := true;

        FinishActionEnabledG := false;
        BackActionEnabledG := false;
    end;

    local procedure ShowStep2();
    begin
        Step2VisibleG := true;

        NextActionEnabledG := false;
        FinishActionEnabledG := true;
    end;

    local procedure ResetControls();
    begin
        FinishActionEnabledG := false;
        BackActionEnabledG := true;
        NextActionEnabledG := true;

        Step1VisibleG := false;
        Step2VisibleG := false;
    end;

    local procedure LoadTopBanners();
    begin
        if MediaRepositoryStandardG.GET('AssistedSetup-NoText-400px.png', FORMAT(CurrentClientType())) AND
           MediaRepositoryDoneG.GET('AssistedSetupDone-NoText-400px.png', FORMAT(CurrentClientType()))
        then
            if MediaResourcesStandardG.GET(MediaRepositoryStandardG."Media Resources Ref") AND
               MediaResourcesDoneG.GET(MediaRepositoryDoneG."Media Resources Ref")
            then
                TopBannerVisibleG := MediaResourcesDoneG."Media Reference".HasValue();
    end;

    local procedure TestGenresSelected()
    var
        NothingSelectedConfirmLbl: Label 'You did not select any genres so no data will be loaded. Are you sure you want to exit?';
    begin
        if (not Genre1SelectedG) and (not Genre2SelectedG) and (not Genre3SelectedG) then
            if not Confirm(NothingSelectedConfirmLbl, false) then
                Error('');
    end;

    local procedure LoadTelevisionShows();
    var
        LoadTelevisionShows: Codeunit "Load Television Shows";
    begin
        LoadTelevisionShows.LoadTelevisionShows(Genre1SelectedG, Genre2SelectedG, Genre3SelectedG);
    end;

    local procedure UpdateTelevisionShowSetupToNotFinished()
    var
        TelevisionShowSetup: Record "Television Show Setup";
    begin
        TelevisionShowSetup."Finished Assisted Setup" := false;
        TelevisionShowSetup.Modify();
    end;
}