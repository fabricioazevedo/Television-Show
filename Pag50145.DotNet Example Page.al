page 50145 "DotNet Example Page"
{
    PageType = ListPlus;
    ApplicationArea = All;
    UsageCategory = Tasks;
    //SourceTable = TableName;
    
    layout
    {
        area(Content)
        {
            group(Group)
            {
                field(Number; NumberG)
                {
                    Caption = 'Enter the base number: ';
                    ApplicationArea = All;
                    
                }

                field(Power; PowerG)
                {
                    Caption = 'Enter the power to be applied: ';
                    ApplicationArea = All;
                    
                }
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Calculate Power';
                
                trigger OnAction()
                var
                begin
                    Message(MessageTxtG, NumberG, PowerG,
                    CalculatePowerOfNumber(NumberG, PowerG))
                end;
            }
        }
    }

    local procedure CalculatePowerOfNumber(NumberP: Decimal; PowerP: Decimal) : Decimal
    var
        MathL: DotNet MyMathLib; 
        begin
            exit(MathL.Pow(NumberG, PowerG));
        end;
    
    var
        NumberG: Decimal;
        PowerG: Decimal;

        MessageTxtG: Label '%1 to the power of %2 is %3';
}