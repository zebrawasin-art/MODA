Imports System.Net.Sockets
Imports System.Text
Imports System.Net

Public Class WifiPrint
	Inherits System.Web.UI.Page

	' WiFi Properties
	Private Property WifiClient As TcpClient
		Get
			Return TryCast(Session("WifiClient"), TcpClient)
		End Get
		Set(value As TcpClient)
			Session("WifiClient") = value
		End Set
	End Property

	Private Property WifiStream As NetworkStream
		Get
			Return TryCast(Session("WifiStream"), NetworkStream)
		End Get
		Set(value As NetworkStream)
			Session("WifiStream") = value
		End Set
	End Property

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

		AddHandler btnWifiConnect.Click, AddressOf BtnWifiConnect_Click
		AddHandler btnWifiDisconnect.Click, AddressOf BtnWifiDisconnect_Click
		AddHandler btnPrint.Click, AddressOf BtnPrint_Click
	End Sub

	Private Sub UpdateConnectionStatus()
		' Update WiFi status
		If WifiClient IsNot Nothing AndAlso WifiClient.Connected Then
			lblWifiStatus.Text = "Connected"
			lblWifiStatus.CssClass = "status-value status-connected"
		Else
			lblWifiStatus.Text = "Disconnected"
			lblWifiStatus.CssClass = "status-value status-disconnected"
		End If
	End Sub

	' WiFi Connection Methods
	Private Sub BtnWifiConnect_Click(sender As Object, e As EventArgs)
		Try
			If String.IsNullOrWhiteSpace(txtWifiIP.Text) Then
				lblStatus.Text = "Please enter IP address."
				ClientScript.RegisterStartupScript(Me.GetType(), "Alert", "showError('Please enter IP address.'); log('Please enter IP address.', true);", True)
				Return
			End If

			' Disconnect existing connection
			If WifiClient IsNot Nothing Then
				Try
					If WifiStream IsNot Nothing Then WifiStream.Close()
					If WifiClient.Connected Then WifiClient.Close()
				Catch
				End Try
				WifiClient.Dispose()
				WifiClient = Nothing
				WifiStream = Nothing
			End If

			Dim ipAddress As IPAddress = Nothing
			If Not IPAddress.TryParse(txtWifiIP.Text, ipAddress) Then
				lblStatus.Text = "Invalid IP address format."
				ClientScript.RegisterStartupScript(Me.GetType(), "Alert", "showError('Invalid IP address format.'); log('Invalid IP address format.', true);", True)
				Return
			End If

			Dim port As Integer = 9100
			If Not Integer.TryParse(txtWifiPort.Text, port) Then
				port = 9100
			End If

			Try
				Dim client As New TcpClient()
				client.Connect(ipAddress, port)

				If client.Connected Then
					WifiClient = client
					WifiStream = client.GetStream()
					
					lblStatus.Text = $"Connected to WiFi: {txtWifiIP.Text}:{port}"
					UpdateConnectionStatus()
					ClientScript.RegisterStartupScript(Me.GetType(), "Success", $"showSuccess('WiFi connected successfully!'); log('WiFi connected to {txtWifiIP.Text}:{port}');", True)
				Else
					client.Close()
					lblStatus.Text = "WiFi connection failed."
					UpdateConnectionStatus()
					ClientScript.RegisterStartupScript(Me.GetType(), "Error", "showError('WiFi connection failed.'); log('WiFi connection failed.', true);", True)
				End If
			Catch wifiEx As Exception
				lblStatus.Text = $"WiFi connection error: {wifiEx.Message}"
				ClientScript.RegisterStartupScript(Me.GetType(), "Error", $"showError('WiFi connection error: {wifiEx.Message}'); log('WiFi connection error: {wifiEx.Message}', true);", True)
			End Try

		Catch ex As Exception
			lblStatus.Text = $"Connection error: {ex.Message}"
			ClientScript.RegisterStartupScript(Me.GetType(), "Error", $"showError('Connection error: {ex.Message}'); log('Connection error: {ex.Message}', true);", True)
		End Try
	End Sub

	Private Sub BtnWifiDisconnect_Click(sender As Object, e As EventArgs)
		Try
			If WifiStream IsNot Nothing Then
				WifiStream.Close()
				WifiStream = Nothing
			End If
			If WifiClient IsNot Nothing Then
				If WifiClient.Connected Then WifiClient.Close()
				WifiClient.Dispose()
				WifiClient = Nothing
			End If
			lblStatus.Text = "WiFi disconnected."
			UpdateConnectionStatus()
			ClientScript.RegisterStartupScript(Me.GetType(), "Info", "showInfo('WiFi disconnected.'); log('WiFi disconnected.');", True)
		Catch ex As Exception
			lblStatus.Text = $"WiFi disconnect error: {ex.Message}"
			ClientScript.RegisterStartupScript(Me.GetType(), "Error", $"showError('WiFi disconnect error: {ex.Message}'); log('WiFi disconnect error: {ex.Message}', true);", True)
		End Try
	End Sub

	Private Sub BtnPrint_Click(sender As Object, e As EventArgs)
		Try
			Dim zpl As String = txtZpl.Text
			If String.IsNullOrWhiteSpace(zpl) Then
				lblStatus.Text = "ZPL is empty."
				ClientScript.RegisterStartupScript(Me.GetType(), "Alert", "showError('ZPL is empty. Please enter ZPL code.'); log('ZPL is empty.', true);", True)
				Return
			End If

			' Check WiFi connection
			Dim wifiConnected As Boolean = WifiClient IsNot Nothing AndAlso WifiClient.Connected AndAlso WifiStream IsNot Nothing

			If wifiConnected Then
				' Use WiFi
				Try
					Dim data As Byte() = Encoding.UTF8.GetBytes(zpl)
					WifiStream.Write(data, 0, data.Length)
					WifiStream.Flush()
					lblStatus.Text = "Sent ZPL to printer via WiFi."
					ClientScript.RegisterStartupScript(Me.GetType(), "Success", "showSuccess('ZPL sent successfully via WiFi!'); log('ZPL sent successfully via WiFi');", True)
				Catch wifiEx As Exception
					lblStatus.Text = $"WiFi print error: {wifiEx.Message}"
					ClientScript.RegisterStartupScript(Me.GetType(), "Error", $"showError('WiFi print error: {wifiEx.Message}'); log('WiFi print error: {wifiEx.Message}', true);", True)
				End Try
			Else
				' No WiFi connection
				lblStatus.Text = "No WiFi connection. Please connect first."
				ClientScript.RegisterStartupScript(Me.GetType(), "Error", "showError('No WiFi connection. Please connect first.'); log('No WiFi connection. Please connect first.', true);", True)
			End If

		Catch ex As Exception
			lblStatus.Text = $"Print error: {ex.Message}"
			ClientScript.RegisterStartupScript(Me.GetType(), "Error", $"showError('Print error: {ex.Message}'); log('Print error: {ex.Message}', true);", True)
		End Try
	End Sub

	Protected Overrides Sub OnUnload(e As EventArgs)
		MyBase.OnUnload(e)
		Try
			' Clean up WiFi connection
			If WifiStream IsNot Nothing Then
				WifiStream.Close()
				WifiStream = Nothing
			End If
			If WifiClient IsNot Nothing Then
				If WifiClient.Connected Then WifiClient.Close()
				WifiClient.Dispose()
				WifiClient = Nothing
			End If
		Catch
		End Try
	End Sub
End Class
