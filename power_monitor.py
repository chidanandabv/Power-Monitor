import subprocess
import time
import smtplib
from email.mime.text import MIMEText

TARGET_IPS = [
    "192.168.10.88",
    "192.168.10.198",
    "192.168.10.133",
    "192.168.10.155"
]

CHECK_INTERVAL = 60 #seconds
FAIL_THRESHOLD = 60   # consecutive checks

EMAIL = "example@email.com"
PASSWORD = "Pssword"
SMTP_SERVER = "smtp.office365.com"
SMTP_PORT = 587

fail_count = 0
alert_sent = False


def ping(ip):
    """Ping a single IP"""
    try:
        result = subprocess.run(
            ["ping", "-n", "1", ip],
            capture_output=True,
            text=True
        )

        output = result.stdout.lower()

        return "ttl=" in output

    except Exception as e:
        print(f"Ping error ({ip}):", e)
        return False


def check_all_systems():
    """Check all IPs and return number of DOWN systems"""
    down_count = 0

    for ip in TARGET_IPS:
        if ping(ip):
            print(f"✅ {ip} UP")
        else:
            print(f"❌ {ip} DOWN")
            down_count += 1

    return down_count


def send_email():
    try:
        TO_EMAILS = [
            "example@email.com",
            "example@email.com",
            "example@email.com",
            "example@email.com"
        ]

        msg = MIMEText(
            "⚠️ ALERT: This is an automated email due to a power failure in the office."
            " The system administrator may don't aware of this alert. If you receive this message, please inform them via phone call.."
        )

        msg['Subject'] = "🚨 Power Failure Alert"
        msg['From'] = "example@email.com"
        msg['To'] = ", ".join(TO_EMAILS)

        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(EMAIL, PASSWORD)

        server.sendmail(EMAIL, TO_EMAILS, msg.as_string())
        server.quit()

        print("✅ Alert email sent")

    except Exception as e:
        print("❌ Email error:", e)


print("🚀 Monitoring started...")

while True:
    down_systems = check_all_systems()
    total_systems = len(TARGET_IPS)

    print(f"Down systems: {down_systems}/{total_systems}")

   
    if down_systems == total_systems:
        fail_count += 1
        print(f"Failure count: {fail_count}/{FAIL_THRESHOLD}")

        if fail_count >= FAIL_THRESHOLD and not alert_sent:
            send_email()
            alert_sent = True

    else:
        print("✅ Not a power failure (some systems still UP)")
        fail_count = 0
        alert_sent = False

    time.sleep(CHECK_INTERVAL)