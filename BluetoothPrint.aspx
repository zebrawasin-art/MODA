<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="BluetoothPrint.aspx.vb" Inherits="MODA.BluetoothPrint" %>
<!DOCTYPE html>
<html lang="th">
<head runat="server">
	<title>Bluetooth Printer via Web Serial (Zebra / ZPL)</title>
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
			background: #f0f2f5;
			min-height: 100vh;
			padding: 20px;
			color: #333;
		}
		
		.container {
			background: #ffffff;
			border-radius: 10px;
			box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
			padding: 25px;
			max-width: 1000px;
			margin: 0 auto;
		}
		
		.header {
			display: flex;
			align-items: center;
			justify-content: space-between;
			margin-bottom: 25px;
			padding-bottom: 18px;
			border-bottom: 1px solid #e8e8e8;
		}
		
		.logo {
			font-size: 1.5rem;
			font-weight: 600;
			color: #333;
			display: flex;
			align-items: center;
			gap: 8px;
		}
		
		.logo i {
			font-size: 1.4rem;
			color: #0066cc;
		}
		
		.nav-buttons {
			display: flex;
			gap: 12px;
		}
		
		.back-btn, .switch-btn {
			background: #f0f0f0;
			color: #333;
			border: 1px solid #ddd;
			padding: 10px 18px;
			border-radius: 4px;
			cursor: pointer;
			text-decoration: none;
			transition: all 0.2s ease;
			display: flex;
			align-items: center;
			gap: 5px;
			font-size: 0.9rem;
			box-shadow: 0 2px 4px rgba(0,0,0,0.1);
		}
		
		.back-btn:hover, .switch-btn:hover {
			background: #e0e0e0;
			box-shadow: 0 4px 8px rgba(0,0,0,0.15);
		}
		
		.connection-section {
			background: #fff;
			border-radius: 6px;
			padding: 18px;
			margin-bottom: 20px;
			border: 1px solid #eaeaea;
			box-shadow: 0 1px 3px rgba(0,0,0,0.05);
		}
		
		.section-title {
			font-size: 1.2rem;
			font-weight: 600;
			color: #333;
			margin-bottom: 15px;
			display: flex;
			align-items: center;
		}
		
		.section-icon {
			font-size: 1.2rem;
			margin-right: 8px;
			color: #666;
		}
		
		.info-box {
			background: #f9f9f9;
			border: 1px solid #eee;
			border-radius: 4px;
			padding: 12px;
			margin-bottom: 15px;
			font-size: 0.9rem;
			color: #555;
		}
		
		.form-group {
			margin-bottom: 15px;
		}
		
		.form-row {
			display: grid;
			grid-template-columns: 1fr 1fr;
			gap: 15px;
			margin-bottom: 15px;
		}
		
		label {
			display: block;
			font-weight: 500;
			color: #555;
			margin-bottom: 5px;
			font-size: 0.9rem;
		}
		
		select {
			width: 100%;
			padding: 8px 12px;
			border: 1px solid #ddd;
			border-radius: 4px;
			font-size: 0.9rem;
			transition: all 0.2s ease;
			background: white;
		}
		
		select:focus {
			outline: none;
			border-color: #0066cc;
			box-shadow: 0 0 0 2px rgba(0, 102, 204, 0.1);
		}
		
		.btn-group {
			display: flex;
			gap: 10px;
			flex-wrap: wrap;
		}
		
		.btn {
			padding: 8px 15px;
			border: 1px solid transparent;
			border-radius: 4px;
			font-size: 0.9rem;
			font-weight: 500;
			cursor: pointer;
			transition: all 0.2s ease;
			text-decoration: none;
			display: inline-block;
			text-align: center;
		}
		
		.btn-primary {
			background: #0066cc;
			color: white;
			border-color: #0066cc;
		}
		
		.btn-primary:hover {
			background: #0055aa;
		}
		
		.btn-secondary {
			background: #f0f0f0;
			color: #333;
			border-color: #ddd;
		}
		
		.btn-secondary:hover {
			background: #e0e0e0;
		}
		
		.btn:disabled {
			background: #f0f0f0;
			color: #999;
			border-color: #ddd;
			cursor: not-allowed;
		}
		
		.status-section {
			background: #fff;
			border-radius: 6px;
			padding: 18px;
			margin-bottom: 20px;
			border: 1px solid #eaeaea;
			box-shadow: 0 1px 3px rgba(0,0,0,0.05);
		}
		
		.status-item {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 10px;
			padding: 8px 12px;
			background: #f9f9f9;
			border-radius: 4px;
		}
		
		.status-label {
			font-weight: 500;
			color: #555;
			font-size: 0.9rem;
		}
		
		.status-value {
			padding: 4px 12px;
			border-radius: 4px;
			font-weight: 500;
			font-size: 0.85rem;
		}
		
		.status-connected {
			background: #e6f4ea;
			color: #137333;
		}
		
		.status-disconnected {
			background: #fce8e6;
			color: #c5221f;
		}
		
		.zpl-section {
			background: #fff;
			border-radius: 6px;
			padding: 18px;
			margin-bottom: 20px;
			border: 1px solid #eaeaea;
			box-shadow: 0 1px 3px rgba(0,0,0,0.05);
		}
		
		.zpl-editor {
			width: 100%;
			height: 250px;
			padding: 12px;
			border: 1px solid #ddd;
			border-radius: 4px;
			font-family: 'Consolas', 'Monaco', monospace;
			font-size: 13px;
			resize: vertical;
			transition: all 0.2s ease;
			line-height: 1.5;
		}
		
		.zpl-editor:focus {
			outline: none;
			border-color: #0066cc;
			box-shadow: 0 0 0 2px rgba(0, 102, 204, 0.1);
		}
		
		.log-section {
			background: #fff;
			border-radius: 6px;
			padding: 18px;
			border: 1px solid #eaeaea;
			box-shadow: 0 1px 3px rgba(0,0,0,0.05);
		}
		
		.log-editor {
			width: 100%;
			height: 130px;
			padding: 12px;
			border: 1px solid #ddd;
			border-radius: 4px;
			font-family: 'Consolas', 'Monaco', monospace;
			font-size: 12px;
			background: #fafafa;
			resize: vertical;
			line-height: 1.4;
		}
		
		.alert {
			padding: 12px 18px;
			margin: 12px 0;
			border-radius: 4px;
			font-weight: 500;
			font-size: 0.9rem;
			box-shadow: 0 2px 8px rgba(0,0,0,0.1);
			animation: fadeIn 0.3s ease-in-out;
		}
		
		@keyframes fadeIn {
			from { opacity: 0; transform: translateY(-10px); }
			to { opacity: 1; transform: translateY(0); }
		}
		
		.alert-success {
			background: #e6f4ea;
			color: #137333;
			border-left: 4px solid #34a853;
		}
		
		.alert-error {
			background: #fce8e6;
			color: #c5221f;
			border-left: 4px solid #ea4335;
		}
		
		.alert-info {
			background: #e8f0fe;
			color: #1967d2;
			border-left: 4px solid #4285f4;
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
				gap: 10px;
				text-align: center;
			}
			
			.nav-buttons {
				flex-direction: column;
				width: 100%;
				gap: 8px;
			}
			
			.back-btn, .switch-btn {
				justify-content: center;
			}
		}
	</style>
	<script type="text/javascript">
		// Web Serial API for Bluetooth
		let btPort = null;
		let btWriter = null;

		// DOM elements will be initialized after document is loaded
		let btnBtConnect;
		let btnBtDisconnect;
		let btnPrintBt;
		let btStatusEl;
		let baudEl;
		let logEl;

		function log(message, isError = false) {
			const ts = new Date().toLocaleTimeString();
			logEl.value += `[${ts}] ${message}\n`;
			logEl.scrollTop = logEl.scrollHeight;
			btStatusEl.textContent = message;
			btStatusEl.className = isError ? 'small err' : 'small ok';
		}

		function setBtUiConnected(connected) {
			btnBtConnect.disabled = connected;
			btnBtDisconnect.disabled = !connected;
			btnPrintBt.disabled = !connected;
			baudEl.disabled = connected;
		}

		function ensureSecureContext() {
			if (!window.isSecureContext) {
				log('ต้องรันบน HTTPS หรือ http://localhost เท่านั้น (Web Serial ต้องการ Secure Context)', true);
			}
		}

		function checkSupport() {
			if (!('serial' in navigator)) {
				log('เบราว์เซอร์ไม่รองรับ Web Serial API (ใช้ Chrome 89+ / Edge 89+ บน Windows หรือ Android)', true);
				return false;
			}
			return true;
		}

		async function connectBt() {
			try {
				if (!checkSupport()) return;

				const baudRate = parseInt(baudEl.value, 10) || 9600;
				
				// เปิด dialog ให้ผู้ใช้เลือกพอร์ต
				btPort = await navigator.serial.requestPort({
					filters: [
						// สำหรับ Windows - COM ports
						{ usbVendorId: 0x0403, usbProductId: 0x6001 }, // FTDI
						{ usbVendorId: 0x10c4, usbProductId: 0xea60 }, // Silicon Labs
						{ usbVendorId: 0x1a86, usbProductId: 0x7523 }, // CH340
						// สำหรับ Android - Bluetooth SPP
						{ name: "Bluetooth" },
						{ name: "SPP" },
						{ name: "Serial" }
					]
				});

				// ตั้งค่า options สำหรับ Windows และ Android
				const options = {
					baudRate: baudRate,
					dataBits: 8,
					stopBits: 1,
					parity: "none",
					flowControl: "none"
				};

				await btPort.open(options);

				// ตั้งค่า writer จาก writable stream
				btWriter = btPort.writable.getWriter();
				setBtUiConnected(true);
				updateConnectionStatus();
				log(`Bluetooth Connected (baud ${baudRate})`);
			} catch (err) {
				log(`Bluetooth Connect error: ${err?.message || err}`, true);
				try { await disconnectBt(); } catch {}
			}
		}

		async function disconnectBt() {
			try {
				if (btWriter) {
					try { await btWriter.close(); } catch {}
					try { btWriter.releaseLock(); } catch {}
					btWriter = null;
				}
				if (btPort) {
					try { await btPort.close(); } catch {}
					btPort = null;
				}
				setBtUiConnected(false);
				updateConnectionStatus();
				log('Bluetooth Disconnected');
			} catch (err) {
				log(`Bluetooth Disconnect error: ${err?.message || err}`, true);
			}
		}

		async function printZplBt() {
			try {
				const zpl = document.getElementById('<%= txtZpl.ClientID %>').value || '';
				if (!zpl.trim()) {
					log('ZPL ว่างเปล่า', true);
					return;
				}

				// Check Bluetooth connection
				if (btPort && btWriter) {
					// Use Bluetooth
					const enc = new TextEncoder(); // UTF-8
					const bytes = enc.encode(zpl);
					await btWriter.write(bytes);
					log('ส่ง ZPL ไปยังเครื่องพิมพ์ผ่าน Bluetooth แล้ว');
				} else {
					log('ยังไม่ได้เชื่อมต่อ Bluetooth กรุณาเชื่อมต่อก่อน', true);
				}
			} catch (err) {
				log(`Print error: ${err?.message || err}`, true);
			}
		}

		function updateConnectionStatus() {
			// Update server-side labels
			const btStatus = document.getElementById('<%= lblBtStatus.ClientID %>');
			const status = document.getElementById('<%= lblStatus.ClientID %>');

			if (btPort && btWriter) {
				btStatus.textContent = "Connected";
				btStatus.className = "status-value status-connected";
			} else {
				btStatus.textContent = "Disconnected";
				btStatus.className = "status-value status-disconnected";
			}
		}

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

		function init() {
			// Initialize DOM elements
			btnBtConnect = document.getElementById('btnBtConnect');
			btnBtDisconnect = document.getElementById('btnBtDisconnect');
			btnPrintBt = document.getElementById('btnPrintBt');
			btStatusEl = document.getElementById('btStatus');
			baudEl = document.getElementById('baud');
			logEl = document.getElementById('log');
			
			ensureSecureContext();
			if (!checkSupport()) return;

			btnBtConnect.addEventListener('click', connectBt);
			btnBtDisconnect.addEventListener('click', disconnectBt);
			btnPrintBt.addEventListener('click', printZplBt);

			// เมื่อพอร์ตถูกถอด/เสียบ
			navigator.serial.addEventListener('disconnect', e => {
				if (e.target === btPort) {
					log('พอร์ตถูกถอดการเชื่อมต่อ', true);
					setBtUiConnected(false);
					updateConnectionStatus();
				}
			});

			// Initialize connection status
			updateConnectionStatus();
			log('พร้อมใช้งาน Web Serial API สำหรับเครื่องพิมพ์ Bluetooth');
		}

		document.addEventListener('DOMContentLoaded', init);
	</script>
</head>
<body>
	<form id="form1" runat="server">
		<div class="container">
			<div class="header">
				<div class="logo"><i class="fab fa-bluetooth-b"></i> Bluetooth Printer via Web Serial (Zebra / ZPL)</div>
				<div class="nav-buttons">
					<a href="WifiPrint.aspx" class="switch-btn"><i class="fas fa-wifi"></i> สลับไปใช้ WiFi</a>
					<a href="Default.aspx" class="back-btn"><i class="fas fa-home"></i> หน้าหลัก</a>
				</div>
			</div>
			
			<!-- Connection Section -->
			<div class="connection-section">
				<div class="section-title">
					<span class="section-icon"><i class="fas fa-plug"></i></span>
					การเชื่อมต่อ Bluetooth
				</div>
				<div class="info-box">
					<strong>คำแนะนำการใช้งาน:</strong><br/>
					• ใช้งานกับ Chrome/Edge บน Windows และต้องจับคู่เครื่องพิมพ์ผ่าน Bluetooth ก่อน<br/>
					• กดปุ่ม Connect เพื่อเลือกพอร์ต COM ของเครื่องพิมพ์<br/>
					• ค่า baud rate มาตรฐานของ Bluetooth SPP คือ 115200
				</div>
				<div class="form-row">
					<div class="form-group">
						<label for="baud">Baud Rate:</label>
						<select id="baud">
							<option value="9600">9600</option>
							<option value="19200">19200</option>
							<option value="38400">38400</option>
							<option value="57600">57600</option>
							<option value="115200" selected>115200</option>
						</select>
					</div>
					<div class="form-group">
						<label>Status:</label>
						<span id="btStatus" style="font-size: 0.9rem; color: #666;">Ready to connect</span>
					</div>
				</div>
				<div class="btn-group">
					<button type="button" id="btnBtConnect" class="btn btn-primary">Connect</button>
					<button type="button" id="btnBtDisconnect" class="btn btn-secondary" disabled>Disconnect</button>
					<button type="button" id="btnPrintBt" class="btn btn-primary" disabled>Print</button>
				</div>
			</div>
			
			<!-- Status Section -->
			<div class="status-section">
				<div class="section-title">
					<span class="section-icon"><i class="fas fa-chart-line"></i></span>
					สถานะการเชื่อมต่อ
				</div>
				<div class="status-item">
					<span class="status-label">Bluetooth Status:</span>
					<asp:Label ID="lblBtStatus" runat="server" Text="Disconnected" CssClass="status-value status-disconnected" />
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
					ZPL
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
		</div>
	</form>
</body>
</html>
