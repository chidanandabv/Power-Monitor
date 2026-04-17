# Power-Monitor
# ⚡ Power Failure Alert System (No Cost)

A lightweight monitoring solution to detect office power failures using simple network checks and send alerts to administrators.

This project is designed for **small to mid-sized environments** where budget constraints prevent the use of enterprise monitoring tools or dedicated UPS management systems.

---

## 📌 Overview

In many office setups, servers rely on UPS backup during power outages.  
However, if power is not restored within the backup window, it can lead to unexpected shutdowns and potential data loss.

This script provides a **simple and cost-effective way** to detect power failure and notify administrators in advance.

---

## ⚙️ How It Works

- The script continuously monitors multiple systems using **IP-based ping checks**
- Instead of relying on a single system, it checks **multiple devices for confirmation**
- If **all monitored systems go down** for a defined period:
  - It assumes a **power failure**
- Sends **email alerts** to configured recipients
- Maintains a **log file** for tracking events
- Uses **threshold logic** to avoid false alerts and alert spamming

---

## 🧠 Logic Flow

---

## 💻 Technologies Used

- **Python** (cross-platform implementation)
- **PowerShell** (optimized for Windows Server environments)

---

## 🚀 Features

- ✅ Multi-system verification (reduces false alerts)
- ✅ Email notification support
- ✅ Logging for monitoring and troubleshooting
- ✅ Lightweight and easy to deploy
- ✅ No additional hardware required
- ✅ No licensing cost

---

## 📂 Project Structure

---

## ⚙️ Configuration

### Update the following values in the script:

- Target IP addresses
- Email credentials (SMTP server, username, password)
- Alert recipients
- Check interval
- Failure threshold

---

## 🖥️ Deployment (Windows Server)

### Option 1: Task Scheduler
- Run script at system startup
- Ensures continuous monitoring

### Option 2: Windows Service (Recommended)
- Use tools like NSSM to run as a background service

---

## ⚠️ Limitations

- Depends on network availability
- Cannot detect power failure if network devices also go offline
- Not a replacement for enterprise UPS monitoring systems

---

## 💡 Recommended Improvements

- Add **Telegram alerts** for instant notifications
- Implement **auto shutdown logic** after delay
- Add **log rotation**
- Integrate with monitoring tools like Zabbix or PRTG

---

## 🤝 Contributing

Suggestions and improvements are welcome!

If you have a better or more efficient approach for low-cost power failure detection, feel free to contribute or open an issue.

---

## 📜 License

This project is open-source and free to use.

---

## 👨‍💻 Author

Developed as a practical solution for real-world system administration challenges in budget-constrained environments.
