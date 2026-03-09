Public Class BluetoothPrint
	Inherits System.Web.UI.Page

	Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
		If Not IsPostBack Then
			lblStatus.Text = "Idle"
			UpdateConnectionStatus()
			If String.IsNullOrWhiteSpace(txtZpl.Text) Then
				txtZpl.Text =
"^XA
~TA000
^PW600
^LL300
^FO40,40^A0N,40,40^FDIDENTIFY TAG^FS
^FO40,90^A0N,28,28^FDPART NO. RCX316D005^FS
^FO40,130^A0N,28,28^FDPART NAME. PLATE,SIDE(R) #1^FS
^FO40,170^A0N,28,28^FDQTY. 5 PCS^FS
^FO40,210^BQN,2,4^FDLA,RCX316D005^FS
^PQ1,1,1,Y
^XZ"
			End If
		End If
	End Sub

	Private Sub UpdateConnectionStatus()
		' Bluetooth status is managed by JavaScript Web Serial API
		lblBtStatus.Text = "Use Web Serial API"
		lblBtStatus.CssClass = "status-value status-disconnected"
	End Sub
End Class
