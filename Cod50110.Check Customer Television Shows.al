codeunit 50110 "Check Cust. Television Shows"
{
    procedure CheckCustomerTelevisionShows(CustomerNo: Code[20])
    begin
        ValidateFavoriteShowExists(CustomerNo);
    end;

    local procedure ValidateFavoriteShowExists(CustomerNo: Code[20])
    var
        CustomerTelevisionShow: Record "Customer Television Show";
    begin
        CustomerTelevisionShow.SetRange("Customer No.", CustomerNo);
        CustomerTelevisionShow.SetRange(Favorite, true);
        if CustomerTelevisionShow.IsEmpty() then
            Error(NoFavoriteShowErr, CustomerNo);
    end;

    var
        NoFavoriteShowErr: Label 'You need to define a favorite television show for Customer %1.';

}