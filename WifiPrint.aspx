<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WifiPrint.aspx.vb" Inherits="MODA.WifiPrint" %>
<!DOCTYPE html>
<html lang="th">
<head runat="server">
	<title>MODA - WiFi Printing</title>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
	<style>
		* {
			margin: 0;
			padding: 0;
			box-sizing: border-box;
		}
		
		body {
			font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
			background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
			min-height: 100vh;
			padding: 20px;
		}
		
		.container {
			background: rgba(255, 255, 255, 0.95);
			backdrop-filter: blur(10px);
			border-radius: 20px;
			box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
			padding: 30px;
			max-width: 1000px;
			margin: 0 auto;
		}
		
		.header {
			display: flex;
			align-items: center;
			justify-content: space-between;
			margin-bottom: 30px;
			padding-bottom: 20px;
			border-bottom: 2px solid #f0f0f0;
		}
		
		.logo {
			font-size: 2rem;
			font-weight: 700;
			color: #4CAF50;
			display: flex;
			align-items: center;
			gap: 10px;
		}
		
		.logo i {
			font-size: 1.8rem;
		}
		
		.nav-buttons {
			display: flex;
			gap: 15px;
		}
		
		.back-btn, .switch-btn {
			background: #4CAF50;
			color: white;
			border: none;
			padding: 10px 20px;
			border-radius: 25px;
			cursor: pointer;
			text-decoration: none;
			transition: all 0.3s ease;
			display: flex;
			align-items: center;
			gap: 8px;
		}
		
		.back-btn:hover, .switch-btn:hover {
			background: #45a049;
			transform: translateY(-2px);
		}
		
		.switch-btn {
			background: #2196F3;
		}
		
		.switch-btn:hover {
			background: #1976D2;
		}
		
		.connection-section {
			background: #f8f9fa;
			border-radius: 15px;
			padding: 25px;
			margin-bottom: 25px;
			border-left: 5px solid #4CAF50;
		}
		
		.section-title {
			font-size: 1.5rem;
			font-weight: 600;
			color: #333;
			margin-bottom: 20px;
			display: flex;
			align-items: center;
		}
		
		.section-icon {
			font-size: 1.8rem;
			margin-right: 10px;
		}
		
		.form-group {
			margin-bottom: 20px;
		}
		
		.form-row {
			display: grid;
			grid-template-columns: 1fr 1fr;
			gap: 20px;
			margin-bottom: 20px;
		}
		
		label {
			display: block;
			font-weight: 600;
			color: #555;
			margin-bottom: 8px;
		}
		
		input[type="text"], input[type="number"] {
			width: 100%;
			padding: 12px 15px;
			border: 2px solid #e0e0e0;
			border-radius: 10px;
			font-size: 1rem;
			transition: all 0.3s ease;
		}
		
		input[type="text"]:focus, input[type="number"]:focus {
			outline: none;
			border-color: #4CAF50;
			box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
		}
		
		.btn-group {
			display: flex;
			gap: 15px;
			flex-wrap: wrap;
		}
		
		.btn {
			padding: 12px 25px;
			border: none;
			border-radius: 25px;
			font-size: 1rem;
			font-weight: 600;
			cursor: pointer;
			transition: all 0.3s ease;
			text-decoration: none;
			display: inline-block;
			text-align: center;
		}
		
		.btn-primary {
			background: #4CAF50;
			color: white;
		}
		
		.btn-primary:hover {
			background: #45a049;
			transform: translateY(-2px);
		}
		
		.btn-secondary {
			background: #6c757d;
			color: white;
		}
		
		.btn-secondary:hover {
			background: #5a6268;
			transform: translateY(-2px);
		}
		
		.btn:disabled {
			background: #ccc;
			cursor: not-allowed;
			transform: none;
		}
		
		.status-section {
			background: #e8f5e8;
			border-radius: 15px;
			padding: 20px;
			margin-bottom: 25px;
		}
		
		.status-item {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 10px;
		}
		
		.status-label {
			font-weight: 600;
			color: #555;
		}
		
		.status-value {
			padding: 5px 15px;
			border-radius: 20px;
			font-weight: 600;
		}
		
		.status-connected {
			background: #d4edda;
			color: #155724;
		}
		
		.status-disconnected {
			background: #f8d7da;
			color: #721c24;
		}
		
		.zpl-section {
			background: #f8f9fa;
			border-radius: 15px;
			padding: 25px;
			margin-bottom: 25px;
		}
		
		.zpl-editor {
			width: 100%;
			height: 300px;
			padding: 15px;
			border: 2px solid #e0e0e0;
			border-radius: 10px;
			font-family: 'Consolas', 'Monaco', monospace;
			font-size: 14px;
			resize: vertical;
			transition: all 0.3s ease;
		}
		
		.zpl-editor:focus {
			outline: none;
			border-color: #4CAF50;
			box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
		}
		
		.log-section {
			background: #f8f9fa;
			border-radius: 15px;
			padding: 25px;
		}
		
		.log-editor {
			width: 100%;
			height: 150px;
			padding: 15px;
			border: 2px solid #e0e0e0;
			border-radius: 10px;
			font-family: 'Consolas', 'Monaco', monospace;
			font-size: 12px;
			background: #fff;
			resize: vertical;
		}
		
		.alert {
			padding: 15px 20px;
			margin: 15px 0;
			border-radius: 10px;
			font-weight: 600;
		}
		
		.alert-success {
			background: #d4edda;
			color: #155724;
			border: 1px solid #c3e6cb;
		}
		
		.alert-error {
			background: #f8d7da;
			color: #721c24;
			border: 1px solid #f5c6cb;
		}
		
		.alert-info {
			background: #d1ecf1;
			color: #0c5460;
			border: 1px solid #bee5eb;
		}
		
		@media (max-width: 768px) {
			.form-row {
				grid-template-columns: 1fr;
			}
			
			.btn-group {
				flex-direction: column;
			}
			
			.header {
				flex-direction: column;
				gap: 15px;
				text-align: center;
			}
			
			.nav-buttons {
				flex-direction: column;
				width: 100%;
			}
			
			.back-btn, .switch-btn {
				justify-content: center;
			}
		}
	</style>
	<script type="text/javascript">
		function showAlert(message, type) {
			var alertDiv = document.createElement('div');
			alertDiv.className = 'alert alert-' + type;
			alertDiv.innerHTML = message;
			alertDiv.style.position = 'fixed';
			alertDiv.style.top = '20px';
			alertDiv.style.right = '20px';
			alertDiv.style.zIndex = '9999';
			alertDiv.style.minWidth = '300px';
			alertDiv.style.boxShadow = '0 4px 6px rgba(0,0,0,0.1)';
			
			document.body.appendChild(alertDiv);
			
			setTimeout(function() {
				alertDiv.remove();
			}, 5000);
		}
		
		function showSuccess(message) {
			showAlert(message, 'success');
		}
		
		function showError(message) {
			showAlert(message, 'error');
		}
		
		function showInfo(message) {
			showAlert(message, 'info');
		}
		
		function log(message, isError = false) {
			const logEl = document.getElementById('log');
			const ts = new Date().toLocaleTimeString();
			logEl.value += `[${ts}] ${message}\n`;
			logEl.scrollTop = logEl.scrollHeight;
		}
	</script>
</head>
<body>
	<form id="form1" runat="server">
		<div class="container">
			<div class="header">
				<div class="logo"><i class="fas fa-wifi"></i> WiFi Printing (Zebra ZQ521)</div>
				<div class="nav-buttons">
					<a href="BluetoothPrint.aspx" class="switch-btn"><i class="fas fa-bluetooth-b"></i> สลับไปใช้ Bluetooth</a>
					<a href="Default.aspx" class="back-btn"><i class="fas fa-home"></i> หน้าหลัก</a>
				</div>
			</div>
			
			<!-- Connection Section -->
			<div class="connection-section">
				<div class="section-title">
					<span class="section-icon"><i class="fas fa-network-wired"></i></span>
					การเชื่อมต่อ WiFi
				</div>
				<div class="info-box" style="background: #e8f5e8; border: 1px solid #c3e6cb; border-radius: 10px; padding: 15px; margin-bottom: 20px; font-size: 0.9rem; color: #155724;">
					<strong>คำแนะนำการใช้งาน:</strong><br/>
					• เครื่องพิมพ์ Zebra ZQ521 ต้องเชื่อมต่อกับเครือข่าย WiFi เดียวกันกับเครื่องคอมพิวเตอร์<br/>
					• ตรวจสอบ IP Address ของเครื่องพิมพ์จากการพิมพ์หน้าการตั้งค่าเครือข่าย<br/>
					• Port มาตรฐานของเครื่องพิมพ์ Zebra คือ 9100
				</div>
				<div class="form-row">
					<div class="form-group">
						<label for="txtWifiIP">IP Address:</label>
						<asp:TextBox ID="txtWifiIP" runat="server" placeholder="192.168.1.100" />
					</div>
					<div class="form-group">
						<label for="txtWifiPort">Port:</label>
						<asp:TextBox ID="txtWifiPort" runat="server" Text="9100" />
					</div>
				</div>
				<div class="btn-group">
					<asp:Button ID="btnWifiConnect" runat="server" Text="เชื่อมต่อ WiFi" CssClass="btn btn-primary" />
					<asp:Button ID="btnWifiDisconnect" runat="server" Text="ตัดการเชื่อมต่อ" CssClass="btn btn-secondary" />
				</div>
			</div>
			
			<!-- Status Section -->
			<div class="status-section">
				<div class="section-title">
					<span class="section-icon"><i class="fas fa-chart-line"></i></span>
					สถานะการเชื่อมต่อ
				</div>
				<div class="status-item">
					<span class="status-label">WiFi Status:</span>
					<asp:Label ID="lblWifiStatus" runat="server" Text="Disconnected" CssClass="status-value status-disconnected" />
				</div>
				<div class="status-item">
					<span class="status-label">Status:</span>
					<asp:Label ID="lblStatus" runat="server" Text="Idle" CssClass="status-value" />
				</div>
			</div>
			
			<!-- ZPL Section -->
			<div class="zpl-section">
				<div class="section-title">
					<span class="section-icon"><i class="fas fa-code"></i></span>
					ZPL Code Editor
				</div>
				<asp:TextBox ID="txtZpl" runat="server" TextMode="MultiLine" CssClass="zpl-editor" Text="^XA
^TA000
^PW600
^LL300
^FO40,40^A0N,40,40^FDIDENTIFY TAG^FS
^FO40,90^A0N,28,28^FDPART NO. RCX316D005^FS
^FO40,130^A0N,28,28^FDPART NAME. PLATE,SIDE(R) #1^FS
^FO40,170^A0N,28,28^FDQTY. 5 PCS^FS
^FO40,210^BQN,2,4^FDLA,RCX316D005^FS
^PQ1,1,1,Y
^XZ" />
			</div>
			
			<!-- Log Section -->
			<div class="log-section">
				<div class="section-title">
					<span class="section-icon"><i class="fas fa-list-alt"></i></span>
					Log
				</div>
				<textarea id="log" class="log-editor" readonly></textarea>
			</div>
			
			<!-- Print Button -->
			<div style="text-align: center; margin-top: 25px;">
				<asp:Button ID="btnPrint" runat="server" Text="พิมพ์ ZPL ไปยัง Zebra ZQ521" CssClass="btn btn-primary" style="font-size: 1.2rem; padding: 15px 40px;" />
				<script>
					document.addEventListener('DOMContentLoaded', function() {
						const printBtn = document.getElementById('<%= btnPrint.ClientID %>');
						printBtn.innerHTML = '<i class="fas fa-print" style="margin-right: 10px;"></i>' + printBtn.innerHTML;
					});
				</script>
			</div>
		</div>
	</form>
</body>
</html>
