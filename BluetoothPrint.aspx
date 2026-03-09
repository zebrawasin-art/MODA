<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BluetoothPrint.aspx.cs" Inherits="BluetoothPrint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bluetooth Print</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Bluetooth Print</h1>

            <div style="display: flex;">
                <div style="margin-right: 20px;">
                    <asp:Image ID="LabelImage" runat="server" Width="400" />
                </div>
                <div>
                    <div style="margin-bottom: 10px;">
                        <label>Print Density:</label>
                        <asp:DropDownList ID="Density" runat="server">
                            <asp:ListItem Text="6 dpmm (152 dpi)" Value="6"></asp:ListItem>
                            <asp:ListItem Text="8 dpmm (203 dpi)" Value="8" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="12 dpmm (300 dpi)" Value="12"></asp:ListItem>
                            <asp:ListItem Text="24 dpmm (600 dpi)" Value="24"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div style="margin-bottom: 10px;">
                        <label>Label Size:</label>
                        <asp:TextBox ID="Width" runat="server" Text="4" Width="50"></asp:TextBox>
                        x
                        <asp:TextBox ID="Height" runat="server" Text="6" Width="50"></asp:TextBox>
                    </div>
                    <div style="margin-bottom: 10px;">
                        <label>ZPL Code:</label><br />
                        <asp:TextBox ID="ZplCode" runat="server" TextMode="MultiLine" Rows="10" Columns="50"></asp:TextBox>
                    </div>
                    <asp:Button ID="UpdateButton" runat="server" Text="Update" OnClick="UpdateButton_Click" />
                    <asp:Button ID="PrintButton" runat="server" Text="Print Label" OnClick="PrintButton_Click" OnClientClick="return printLabel();" />
                </div>
            </div>
        </div>
    </form>

    <script>
        function printLabel() {
            var labelImage = document.getElementById('<%=LabelImage.ClientID%>');
            if (labelImage && labelImage.src) {
                var printWindow = window.open('', '', 'height=600,width=800');
                printWindow.document.write('<html><head><title>Print Label</title></head><body>');
                printWindow.document.write('<img src="' + labelImage.src + '" />');
                printWindow.document.write('</body></html>');
                printWindow.document.close();
                printWindow.focus();
                printWindow.print();
                printWindow.close();
                return true; // Allow server-side event to fire
            } else {
                alert('No label image to print.');
                return false; // Prevent server-side event
            }
        }
    </script>

</body>
</html>