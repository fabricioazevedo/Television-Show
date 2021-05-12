codeunit 50120 "Customer Card Notification"
{
    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnAfterGetRecordEvent', '', false, false)]
    local procedure OnAfterGetRecordEvent(var Rec: Record Customer)
    begin
        HandleCustomerCardNotification(Rec."No.");
    end;

    local procedure HandleCustomerCardNotification(CustomerNoP: Code[20])
    begin
        if CustomerNoP = '' then
            exit;

        if not HasTelevisionEntries(CustomerNoP) then
            ShowCustomerCardNotification(CustomerNoP);
    end;

    local procedure HasTelevisionEntries(CustomerNoP: Code[20]): Boolean
    var
        CustomerTelevisionShowL: Record "Customer Television Show";
    begin
        CustomerTelevisionShowL.SetRange("Customer No.", CustomerNoP);
        exit(not CustomerTelevisionShowL.IsEmpty());
    end;

    local procedure ShowCustomerCardNotification(CustomerNoP: Code[20])
    var
        CustomerCardNotificationL: Notification;

    begin
        CustomerCardNotificationL.Message := StrSubstNo(NotificationMsgG, CustomerNoP);
        /*notification appear on the current page*/
        CustomerCardNotificationL.Scope := NotificationScope::LocalScope;
        CustomerCardNotificationL.SetData('CustomerNoL', CustomerNoP);
        CustomerCardNotificationL.AddAction(ActionYesTxtG, CODEUNIT::"Customer Card Notification", 'OpenCustomerTelevisionShows');
        CustomerCardNotificationL.Send();
    end;

    procedure OpenCustomerTelevisionShows(CustomerCardNotificationP: Notification)
    var
        CustomerTelevisionShowL: Record "Customer Television Show";
        CustomerTelevisionShowsL: Page "Customer Television Shows";
        CustomerNoL: Code[20];
    begin
        CustomerNoL := CustomerCardNotificationP.GetData('CustomerNoL');
        CustomerTelevisionShowL.SetRange("Customer No.", CustomerNoL);
        CustomerTelevisionShowsL.SetTableView(CustomerTelevisionShowL);
        CustomerTelevisionShowsL.Run();
    end;

    var
        NotificationMsgG: Label 'Customer %1 has no television shows. Do you want to set some up?';
        ActionYesTxtG: Label 'Yes';
}