page 50120 "Television Show Card"
{
    PageType = Card;
    SourceTable = "Television Show";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(Synopsis; Synopsis)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    StyleExpr = 'Attention';
                }
                field("First Aired"; "First Aired")
                {
                    ApplicationArea = All;
                }
                field("Last Aired"; "Last Aired")
                {
                    ApplicationArea = All;
                }
                field("TVMaze ID"; "TVMaze ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DownloadEpisodes)
            {
                Caption = 'Download Episode Information';
                ApplicationArea = All;

                trigger OnAction();
                begin
                    DownloadEpisodes();
                end;
            }
        }
        area(Navigation)
        {
            action(TelevisionShowEpisodes)
            {
                Caption = 'Episodes';
                ApplicationArea = All;
                RunObject = page "Television Show Episodes";
                RunPageLink = "Television Show Code" = field (Code);
            }

            
            action(FINDTEST1)
            {
                Caption = 'Find Test';
                ApplicationArea = All;

                trigger OnAction();
                var
                    ItemRecL: Record "Item";
                begin
                    ItemRecL."No." := '1100';
                    if ItemRecL.Find('=') then
                        Message('Item No. %1.\Description: %2. Price: $%3', 
                        ItemRecL."No.", ItemRecL.Description, ItemRecL."Unit Price" )
                    else
                        Message('The item was not found.');
                end;

            }
        }
    }
}