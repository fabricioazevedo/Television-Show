tableextension 50110 CustomerExtension extends Customer
{
    fields
    {
        field(50100; "Television Viewing Country"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Canada,"United States","United Kingdom";
        }
    }
}