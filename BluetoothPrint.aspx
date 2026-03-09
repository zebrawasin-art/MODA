<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BluetoothPrint.aspx.vb" Inherits="MODA.BluetoothPrint" %>
<!DOCTYPE html>
<html lang="th">
<head runat="server">
	<title>MODA Bluetooth Print - Zebra ZPL</title>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
	<script type="text/javascript" src="./BrowserPrint-3.1.250.min.js"></script>
	<style>
		:root {
			--primary-color: #0066cc;
			--secondary-color: #6c757d;
			--success-color: #28a745;
			--danger-color: #dc3545;
			--warning-color: #ffc107;
			--light-bg: #f0f2f5;
			--card-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
		}

		* { margin: 0; padding: 0; box-sizing: border-box; }
		
		body {
			font-family: 'Segoe UI', Roboto, Arial, sans-serif;
			background: var(--light-bg);
			min-height: 100vh;
			padding: 10px;
			color: #333;
		}
		
		.container {
			background: #ffffff;
			border-radius: 12px;
			box-shadow: var(--card-shadow);
			padding: 20px;
			max-width: 800px;
			margin: 0 auto;
		}
		
		.header {
			display: flex;
			align-items: center;
			justify-content: space-between;
			margin-bottom: 20px;
			padding-bottom: 15px;
			border-bottom: 1px solid #eee;
			flex-wrap: wrap;
			gap: 15px;
		}
		
		.logo {
			font-size: 1.4rem;
			font-weight: 700;
			display: flex;
			align-items: center;
			gap: 10px;
		}
		
		.logo i { color: var(--primary-color); }
		
		.nav-buttons { display: flex; gap: 8px; }
		
		.btn-nav {
			background: #f8f9fa;
			color: #333;
			border: 1px solid #ddd;
			padding: 8px 12px;
			border-radius: 6px;
			text-decoration: none;
			font-size: 0.85rem;
			display: flex;
			align-items: center;
			gap: 5px;
		}

		.card {
			background: #fff;
			border-radius: 8px;
			padding: 15px;
			margin-bottom: 15px;
			border: 1px solid #eee;
		}
		
		.section-title {
			font-size: 1rem;
			font-weight: 600;
			margin-bottom: 12px;
			display: flex;
			align-items: center;
			gap: 8px;
		}
		
		.info-box {
			background: #e7f3ff;
			border-left: 4px solid var(--primary-color);
			padding: 10px;
			margin-bottom: 15px;
			font-size: 0.8rem;
		}
		
		label {
			display: block;
			font-weight: 600;
			margin-bottom: 5px;
			font-size: 0.85rem;
		}
		
		select, textarea {
			width: 100%;
			padding: 10px;
			border: 1px solid #ddd;
			border-radius: 6px;
			font-size: 0.9rem;
		}
		
		.btn-grid {
			display: grid;
			grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
			gap: 10px;
			margin-top: 10px;
		}
		
		.btn {
			padding: 12px;
			border-radius: 6px;
			font-weight: 600;
			cursor: pointer;
			border: none;
			font-size: 0.85rem;
			display: flex;
			align-items: center;
			justify-content: center;
			gap: 8px;
		}
		
		.btn-primary { background: var(--primary-color); color: white; }
		.btn-success { background: var(--success-color); color: white; }
		.btn-secondary { background: var(--secondary-color); color: white; }
		.btn-warning { background: var(--warning-color); color: #212529; }
		
		.status-badge {
			padding: 4px 10px;
			border-radius: 20px;
			font-size: 0.7rem;
			font-weight: 700;
		}
		
		.status-connected { background: #d4edda; color: #155724; }
		.status-disconnected { background: #f8d7da; color: #721c24; }
		
		.zpl-editor { height: 150px; font-family: monospace; background: #f8f9fa; }
		.log-editor { height: 100px; font-family: monospace; background: #222; color: #0f0; font-size: 0.75rem; }

		.preview-box {
			text-align: center;
			padding: 10px;
			background: #f8f9fa;
			border: 1px dashed #ccc;
			border-radius: 8px;
		}

		.preview-box img { max-width: 100%; height: auto; }
		
		@media print {
			body * { visibility: hidden; }
			.preview-box, .preview-box img { visibility: visible; }
			.preview-box {
				position: absolute;
				left: 0;
				top: 0;
				width: 100%;
				height: 100%;
				display: flex;
				justify-content: center;
				align-items: center;
				background: white !important;
				border: none !important;
				padding: 0 !important;
			}
			.preview-box img { max-width: 100%; max-height: 100%; }
		}
	</style>
	<script type="text/javascript">
		var selected_device;
		var btChar; 
		var logEl;

		function log(msg) {
			const ts = new Date().toLocaleTimeString();
			if (logEl) {
				logEl.value += `[${ts}] ${msg}\n`;
				logEl.scrollTop = logEl.scrollHeight;
			}
			console.log(msg);
		}

		function updateStatus(msg, connected) {
			document.getElementById('lblStatus').textContent = msg;
			const badge = document.getElementById('statusBadge');
			badge.textContent = connected ? 'CONNECTED' : 'DISCONNECTED';
			badge.className = 'status-badge ' + (connected ? 'status-connected' : 'status-disconnected');
		}

		function setupBrowserPrint() {
			log('กำลังตรวจหา BrowserPrint...');
			BrowserPrint.getDefaultDevice("printer", function(device) {
				selected_device = device;
				log('พบเครื่องพิมพ์ BrowserPrint: ' + device.name);
				updateStatus('พร้อมใช้งาน (' + device.name + ')', true);
				
				var html_select = document.getElementById("selected_device");
				var option = document.createElement("option");
				option.text = device.name + " (Default)";
				option.value = device.uid;
				html_select.add(option);
			}, function(err) {
				log('ไม่พบ BrowserPrint service');
			});
		}

		async function connectBluetooth() {
			try {
				log('กำลังค้นหา Bluetooth Device...');
				const device = await navigator.bluetooth.requestDevice({
					filters: [{ services: ['000018f0-0000-1000-8000-00805f9b34fb'] }, { namePrefix: 'Zebra' }],
					optionalServices: ['000018f0-0000-1000-8000-00805f9b34fb']
				});

				log('กำลังเชื่อมต่อ GATT...');
				const server = await device.gatt.connect();
				const service = await server.getPrimaryService('000018f0-0000-1000-8000-00805f9b34fb');
				btChar = await service.getCharacteristic('00002af1-0000-1000-8000-00805f9b34fb');
				
				log('เชื่อมต่อ Bluetooth สำเร็จ: ' + device.name);
				updateStatus('เชื่อมต่อ Bluetooth แล้ว', true);
				
				device.addEventListener('gattserverdisconnected', () => {
					log('Bluetooth ตัดการเชื่อมต่อ');
					updateStatus('Disconnected', false);
					btChar = null;
				});
			} catch (err) {
				log('Bluetooth Error: ' + err.message);
				alert('เชื่อมต่อไม่สำเร็จ: ' + err.message);
			}
		}

		async function printZpl() {
			const zpl = document.getElementById('<%= txtZpl.ClientID %>').value;
			if (!zpl.trim()) return alert('กรุณาใส่ ZPL');

			if (btChar) {
				log('กำลังพิมพ์ผ่าน Web Bluetooth...');
				try {
					const encoder = new TextEncoder();
					const data = encoder.encode(zpl);
					const chunk = 20;
					for (let i = 0; i < data.length; i += chunk) {
						await btChar.writeValue(data.slice(i, i + chunk));
					}
					log('พิมพ์สำเร็จ (Bluetooth)');
					return;
				} catch (err) { log('Bluetooth Print Error: ' + err.message); }
			}

			if (selected_device) {
				log('กำลังพิมพ์ผ่าน BrowserPrint...');
				selected_device.send(zpl, () => log('พิมพ์สำเร็จ (BrowserPrint)'), (err) => log('Error: ' + err));
				return;
			}

			alert('กรุณาเชื่อมต่อเครื่องพิมพ์ก่อน');
		}

		function updatePreview() {
			const zpl = document.getElementById('<%= txtZpl.ClientID %>').value;
			const url = `https://api.labelary.com/v1/printers/8dpmm/labels/4x6/0/${encodeURIComponent(zpl)}`;
			document.getElementById('labelPreview').src = url;
			log('อัปเดต Preview แล้ว');
			localStorage.setItem('moda_latest_zpl', zpl);
		}

		function systemPrint() {
			const labelImg = document.getElementById('labelPreview');
			if (!labelImg || !labelImg.src) return alert('กรุณากด Preview ก่อนพิมพ์');
			
			const printWindow = window.open('', '_blank');
			printWindow.document.write('<html><head><title>Print Label</title><style>body{margin:0;display:flex;justify-content:center;align-items:center;height:100vh;} img{max-width:100%;max-height:100%;}</style></head><body>');
			printWindow.document.write('<img src="' + labelImg.src + '" onload="window.print();window.close();" />');
			printWindow.document.write('</body></html>');
			printWindow.document.close();
		}

		function init() {
			logEl = document.getElementById('log');
			const saved = localStorage.getItem('moda_latest_zpl');
			if (saved) document.getElementById('<%= txtZpl.ClientID %>').value = saved;

			document.getElementById('btnBluetooth').addEventListener('click', connectBluetooth);
			document.getElementById('btnPrint').addEventListener('click', printZpl);
			document.getElementById('btnPreview').addEventListener('click', updatePreview);
			document.getElementById('btnSystemPrint').addEventListener('click', systemPrint);

			setTimeout(setupBrowserPrint, 1000);
			updatePreview();
		}

		document.addEventListener('DOMContentLoaded', init);
	</script>
</head>
<body>
	<form id="form1" runat="server">
		<div class="container">
			<div class="header">
				<div class="logo"><i class="fab fa-bluetooth-b"></i> MODA Bluetooth</div>
				<div class="nav-buttons">
					<a href="WifiPrint.aspx" class="btn-nav"><i class="fas fa-wifi"></i> WiFi</a>
					<a href="Default.aspx" class="btn-nav"><i class="fas fa-home"></i> Home</a>
				</div>
			</div>

			<div class="info-box">
				<strong>Android:</strong> แนะนำให้ใช้ <b>Connect Bluetooth</b> (Web Bluetooth) หรือ <b>System Print</b> หาก BrowserPrint ไม่ทำงาน
			</div>

			<div class="card">
				<div class="section-title"><i class="fas fa-link"></i> เชื่อมต่อ</div>
				<label>เครื่องพิมพ์ (PC/App):</label>
				<select id="selected_device">
					<option value="">-- ตรวจหาอัตโนมัติ --</option>
				</select>
				<div class="btn-grid">
					<button type="button" id="btnBluetooth" class="btn btn-primary"><i class="fab fa-bluetooth"></i> Connect Bluetooth</button>
				</div>
			</div>

			<div class="card">
				<div class="section-title"><i class="fas fa-info-circle"></i> สถานะ: <span id="lblStatus">Idle</span></div>
				<span id="statusBadge" class="status-badge status-disconnected">DISCONNECTED</span>
			</div>

			<div class="card">
				<div class="section-title"><i class="fas fa-code"></i> ZPL Code</div>
				<asp:TextBox ID="txtZpl" runat="server" TextMode="MultiLine" CssClass="zpl-editor" Text="^XA
^PW600
^LL300
^FO40,40^A0N,40,40^FDMODA LABEL^FS
^FO40,90^A0N,28,28^FDPART NO: RCX316D005^FS
^FO40,130^A0N,28,28^FDBARCODE:^FS
^FO40,160^BCN,60,Y,N,N^FD123456789^FS
^PQ1,1,1,Y
^XZ" />
				<div class="btn-grid">
					<button type="button" id="btnPreview" class="btn btn-secondary"><i class="fas fa-eye"></i> Preview</button>
					<button type="button" id="btnPrint" class="btn btn-success"><i class="fas fa-print"></i> พิมพ์ ZPL</button>
					<button type="button" id="btnSystemPrint" class="btn btn-warning"><i class="fas fa-mobile-alt"></i> System Print</button>
				</div>
			</div>

			<div class="card">
				<div class="section-title"><i class="fas fa-image"></i> Label Preview</div>
				<div class="preview-box">
					<img id="labelPreview" src="" alt="Preview">
				</div>
			</div>

			<div class="card">
				<div class="section-title"><i class="fas fa-terminal"></i> Log</div>
				<textarea id="log" class="log-editor" readonly></textarea>
			</div>
		</div>
	</form>
</body>
</html>