codeunit 50117 "Customers With Shows Filter"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Filter Tokens", 
    'OnResolveTextFilterToken', '', true, true)]
    local procedure FilterMyAccounts(TextToken: Text; var TextFilter: Text; var Handled: Boolean)
    var
        Customer: Record Customer;
        CustomerTelevisionShows: Record "Customer Television Show";
        CustWithShowsTokenTxt: Label 'CUSTWITHSHOWS';
        MaxCount: Integer;
    begin
        if StrPos(UpperCase(CustWithShowsTokenTxt), UpperCase(TextToken)) = 0 then
            exit;

        MaxCount := 2000;
        TextFilter := '';

        if Customer.FindSet() then begin
            repeat
                CustomerTelevisionShows.SetRange("Customer No.", Customer."No.");
                if not CustomerTelevisionShows.IsEmpty() then begin
                    MaxCount -= 1;

                    if TextFilter <> '' then
                        TextFilter += '|';

                    TextFilter += Customer."No.";
                end;
            until (Customer.Next() = 0) or (MaxCount <= 0);
        end;
    end;
}