#!/usr/bin/env python3

import asyncio
import socket
import json
import time
import websockets


PORT = 8765

# ==========================================================
# Prevent multiple printers jobs at the same time
# ==========================================================

print_lock = asyncio.Lock()


# ==========================================================
# Send ZPL to Zebra
# ==========================================================

def send_zpl_to_printer(ip, port, zpl):

    sock = None

    try:

        print(f"[TCP] Connecting {ip}:{port}")

        sock = socket.create_connection(
            (ip, port),
            timeout=5
        )

        print(f"[TCP] Connected {ip}:{port}")

        zpl_bytes = zpl.encode("ascii", errors="replace")

        print(f"[TCP] Sending {len(zpl_bytes)} bytes")

        sock.sendall(zpl_bytes)

        print("[TCP] ZPL sent")

        # Tell TCP we are finished sending
        try:
            sock.shutdown(socket.SHUT_WR)
        except Exception:
            pass

        return {
            "ok": True,
            "bytes": len(zpl_bytes)
        }

    except Exception as e:

        print(f"[TCP ERROR] {e}")

        return {
            "ok": False,
            "error": str(e)
        }

    finally:

        if sock:

            try:
                sock.close()
            except Exception:
                pass

        print(f"[TCP] Connection closed {ip}:{port}")


# ==========================================================
# WebSocket Handler
# ==========================================================

async def handler(ws):

    client = ws.remote_address

    print("=" * 60)
    print(f"[WS] Client connected: {client}")
    print("=" * 60)

    try:

        async for message in ws:

            # ------------------------------------------------
            # Parse JSON
            # ------------------------------------------------

            try:

                data = json.loads(message)

            except Exception:

                await ws.send(json.dumps({
                    "status": "error",
                    "message": "Invalid JSON"
                }))

                continue

            cmd = data.get("cmd")

            request_id = data.get(
                "requestId",
                str(int(time.time() * 1000))
            )

            print(
                f"[WS] Command={cmd} "
                f"RequestID={request_id}"
            )

            # ==================================================
            # CONNECT
            # ==================================================

            if cmd == "connect":

                ip = data.get("ip")
                port = int(data.get("port", 9100))

                if not ip:

                    await ws.send(json.dumps({
                        "status": "error",
                        "requestId": request_id,
                        "message": "Printer IP required"
                    }))

                    continue

                try:

                    print(
                        f"[CONNECT] Testing "
                        f"{ip}:{port}"
                    )

                    def test_connection():

                        s = socket.create_connection(
                            (ip, port),
                            timeout=5
                        )

                        s.close()

                    await asyncio.to_thread(
                        test_connection
                    )

                    print(
                        f"[CONNECT] OK "
                        f"{ip}:{port}"
                    )

                    await ws.send(json.dumps({
                        "status": "connected",
                        "requestId": request_id,
                        "ip": ip,
                        "port": port
                    }))

                except Exception as e:

                    print(
                        f"[CONNECT ERROR] {e}"
                    )

                    await ws.send(json.dumps({
                        "status": "error",
                        "requestId": request_id,
                        "message": str(e)
                    }))

            # ==================================================
            # PRINT
            # ==================================================

            elif cmd == "print":

                ip = data.get("ip")
                port = int(data.get("port", 9100))
                zpl = data.get("zpl")

                if not ip:

                    await ws.send(json.dumps({
                        "status": "error",
                        "requestId": request_id,
                        "message": "Printer IP required"
                    }))

                    continue

                if not zpl:

                    await ws.send(json.dumps({
                        "status": "error",
                        "requestId": request_id,
                        "message": "ZPL required"
                    }))

                    continue

                # ------------------------------------------------
                # Prevent simultaneous printing
                # ------------------------------------------------

                if print_lock.locked():

                    print(
                        f"[PRINT] Busy - "
                        f"RequestID={request_id}"
                    )

                    await ws.send(json.dumps({
                        "status": "busy",
                        "requestId": request_id,
                        "message": "Printer is busy"
                    }))

                    continue

                async with print_lock:

                    print("=" * 60)

                    print(
                        f"[PRINT] START "
                        f"RequestID={request_id}"
                    )

                    print(
                        f"[PRINT] Printer: "
                        f"{ip}:{port}"
                    )

                    print(
                        f"[PRINT] ZPL length: "
                        f"{len(zpl)}"
                    )

                    # Debug ZPL
                    print(
                        f"[PRINT] ZPL: "
                        f"{repr(zpl)}"
                    )

                    # ------------------------------------------------
                    # Send TCP in background thread
                    # ------------------------------------------------

                    result = await asyncio.to_thread(
                        send_zpl_to_printer,
                        ip,
                        port,
                        zpl
                    )

                    # ------------------------------------------------
                    # Result
                    # ------------------------------------------------

                    if result["ok"]:

                        print(
                            f"[PRINT] SUCCESS "
                            f"RequestID={request_id}"
                        )

                        await ws.send(json.dumps({
                            "status": "printed",
                            "requestId": request_id,
                            "ip": ip,
                            "port": port,
                            "bytes": result["bytes"]
                        }))

                    else:

                        print(
                            f"[PRINT] FAILED "
                            f"RequestID={request_id}"
                        )

                        await ws.send(json.dumps({
                            "status": "error",
                            "requestId": request_id,
                            "message": result["error"]
                        }))

                    print("=" * 60)

            # ==================================================
            # PING
            # ==================================================

            elif cmd == "ping":

                ip = data.get("ip")
                port = int(data.get("port", 9100))

                try:

                    start = time.time()

                    def ping_printer():

                        s = socket.create_connection(
                            (ip, port),
                            timeout=3
                        )

                        s.close()

                    await asyncio.to_thread(
                        ping_printer
                    )

                    ms = int(
                        (time.time() - start) * 1000
                    )

                    await ws.send(json.dumps({
                        "status": "ping",
                        "requestId": request_id,
                        "ip": ip,
                        "port": port,
                        "ms": ms
                    }))

                except Exception as e:

                    await ws.send(json.dumps({
                        "status": "error",
                        "requestId": request_id,
                        "message": str(e)
                    }))

            # ==================================================
            # UNKNOWN
            # ==================================================

            else:

                await ws.send(json.dumps({
                    "status": "error",
                    "requestId": request_id,
                    "message": f"Unknown command: {cmd}"
                }))

    except websockets.exceptions.ConnectionClosed as e:

        print(
            f"[WS] Connection closed: "
            f"{client} "
            f"{e}"
        )

    except Exception as e:

        print(
            f"[WS ERROR] {e}"
        )

    finally:

        print(
            f"[WS] Client disconnected: "
            f"{client}"
        )


# ==========================================================
# MAIN
# ==========================================================

async def main():

    print()
    print("=" * 60)
    print("       MODA ZPL WebSocket Proxy")
    print("=" * 60)
    print()
    print("WebSocket : ws://0.0.0.0:8765")
    print("Example PC   : ws://10.119.77.169:8765")
    print("Printer   : TCP 9100")
    print()
    print("Print Lock: ENABLED")
    print()
    print("Press Ctrl+C to stop")
    print("=" * 60)
    print()

    async with websockets.serve(
        handler,
        "0.0.0.0",
        PORT,
        ping_interval=20,
        ping_timeout=20,
        close_timeout=5
    ):

        await asyncio.Future()


# ==========================================================
# START
# ==========================================================

if __name__ == "__main__":

    try:

        asyncio.run(main())

    except KeyboardInterrupt:

        print()
        print("Proxy stopped.")