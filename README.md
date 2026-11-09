# Telephony: Asterisk VoIP Lab

A hands-on VoIP lab built on Asterisk. It runs as an **isolated instance** from its own folder, so it never touches `/etc/asterisk`.

**Features**
- Two SIP endpoints (100 and 101) using PJSIP
- Direct extension-to-extension calls
- A simple IVR menu (dial 200, press 1 for ext 100, 2 for ext 101)

## Requirements
- Linux (tested on Kali) with `asterisk` installed: `sudo apt install asterisk`
- Two softphones (Linphone, Zoiper, MicroSIP) on the same LAN
- Git

## Setup

1. Clone the repo

git clone https://github.com/CyberAssaassin/telephony.git
cd telephony


2. Create your real config files from the templates

cp etc/pjsip.conf.example etc/pjsip.conf
sed “s|/home/YOUR_USER|$HOME|g” asterisk.conf.example > asterisk.conf

   Then edit `etc/pjsip.conf` and replace each `CHANGE_ME` with a password.
   Also check that the paths in `asterisk.conf` point to your cloned folder
   (they default to `$HOME/asterisk-lab`).

3. Copy Asterisk's default configs (existing files are not overwritten)

sudo cp -n /etc/asterisk/*.conf etc/
sudo chown -R $USER:$USER .


4. Create the runtime folders

mkdir -p run log/cdr-csv spool


5. Stop the system Asterisk service, if running

sudo systemctl stop asterisk


6. Start the lab (no sudo)

asterisk -C “$PWD/asterisk.conf” -cvvv

   Wait for `Asterisk Ready.`

## Connect the softphones

| Field | Phone 1 | Phone 2 |
|---|---|---|
| Username | 100 | 101 |
| Password | from `pjsip.conf` | from `pjsip.conf` |
| Server | `<your-ip>:5070` | `<your-ip>:5070` |
| Transport | UDP | UDP |

Find your IP with `ip -4 a`. The port is **5070**, not the default 5060.

Verify in the Asterisk console:

pjsip show endpoints

Both endpoints should show `Not in use`.

## Test
- Dial **101** from phone 100 (and the reverse): direct call
- Dial **200**: the IVR plays a greeting, then press 1 or 2

## Stop the lab
In the Asterisk console:

core stop gracefully


## Troubleshooting

| Problem | Cause |
|---|---|
| Phone won't register | Wrong IP or port (5070), or wrong password |
| `Failed to authenticate` in the log | Password mismatch; avoid auto-capitalizing keyboards |
| `Address already in use` | System Asterisk is still running |
| No audio | Phones on different networks, or a firewall blocking RTP |
| `modules.conf missing` at startup | Step 3 was skipped |

Use `pjsip set logger on` in the console to see SIP messages live.

## Repo layout

asterisk.conf.example paths for the isolated instance
etc/pjsip.conf.example endpoints (template, no real passwords)
etc/extensions.conf dialplan and IVR
start.sh helper to start the lab

`pjsip.conf`, `asterisk.conf`, and runtime folders are git-ignored.

## Roadmap
- [x] PJSIP endpoints and softphone registration
- [x] IVR menu
- [ ] Call queues (call center)
- [ ] Voicemail
- [ ] Call recording and CDR reports
- [ ] Django dashboard via AMI/ARI
