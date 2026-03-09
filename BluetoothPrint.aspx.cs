using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BluetoothPrint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Set default ZPL code
            ZplCode.Text = @"^XA
^FX Top section with logo, name and address.
^CF0,60
^FO50,50^GB100,100,100^FS
^FO75,75^FR^GB100,100,100^FS
^FO93,93^GB40,40,40^FS
^FO220,50^FDIntershipping, Inc.^FS
^CF0,30
^FO220,115^FD1000 Shipping Lane^FS
^FO220,155^FDShelbyville TN 38102^FS
^FO220,195^FDUnited States (USA)^FS
^FO50,250^GB700,3,3^FS
^FX Second section with recipient address and permit information.
^CFA,30
^FO50,300^FDJohn Doe^FS
^FO50,340^FD100 Main Street^FS
^FO50,380^FDSpringfield TN 39021^FS
^FO50,420^FDUnited States (USA)^FS
^CFA,15
^FO600,300^GB150,150,3^FS
^FO638,340^FDPermit^FS
^FO638,390^FD123456^FS
^FO50,500^GB700,3,3^FS
^XZ";
            UpdateLabelImage();
        }
    }

    protected void UpdateButton_Click(object sender, EventArgs e)
    {
        UpdateLabelImage();
    }

    private void UpdateLabelImage()
    {
        try
        {
            var zpl = ZplCode.Text;
            var density = Density.SelectedValue;
            var width = Width.Text;
            var height = Height.Text;

            var url = string.Format("http://api.labelary.com/v1/printers/{0}dpmm/labels/{1}x{2}/0/", density, width, height);

            using (var client = new System.Net.WebClient())
                        {
                            client.Headers.Add("Accept", "image/png");
                            client.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
                            byte[] zplData = System.Text.Encoding.UTF8.GetBytes(zpl);
                            byte[] response = client.UploadData(url, "POST", zplData);
                            LabelImage.ImageUrl = "data:image/png;base64," + Convert.ToBase64String(response);
                        }
                    }
                    catch (Exception ex)
                    {
                        LabelImage.ImageUrl = null;
                        Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "\\'") + "');</script>");
                    }
        protected void PrintButton_Click(object sender, EventArgs e)
        {
            try
            {
                string logDirectory = Server.MapPath("~/Logs");
                if (!System.IO.Directory.Exists(logDirectory))
                {
                    System.IO.Directory.CreateDirectory(logDirectory);
                }

                string logFilePath = System.IO.Path.Combine(logDirectory, "PrintLog.txt");
                string logMessage = string.Format("[{0:yyyy-MM-dd HH:mm:ss}] - Bluetooth Label Printed. Density: {1}dpmm, Size: {2}x{3}", DateTime.Now, Density.SelectedValue, Width.Text, Height.Text);
                
                System.IO.File.AppendAllText(logFilePath, logMessage + Environment.NewLine);
            }
            catch (Exception ex)
            {
                // Optionally, handle logging errors, e.g., by showing a message to the user.
                Response.Write(string.Format("<script>alert('Failed to write to log: {0}');</script>", ex.Message.Replace("'", "\\'")));
            }
        }
    }
}