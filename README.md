# `dnsmgr`

**dnsmgr** is a lightweight command-line tool for managing test domains. It helps you allocate, track, and manage domain-to-IP mappings for local development, safely updating `/etc/hosts` without interfering with your required entries.  

## Features

✨ **Easy Domain Management**
- Allocate domains from a pool automatically  
- Add specific domain → IP mappings  
- Release domains when no longer needed  
- List allocations per domain or globally  

🛡️ **Safe `/etc/hosts` Handling**
- Maintains its own managed block inside `/etc/hosts`  
- Never overwrites out-of-band entries  
- Clean add/remove operations with clear markers  

📊 **State Tracking**
- Persistent state storage in `~/.dnsmgr_state`  
- Track all domain allocations across reboots  
- Export mappings for Docker Compose or other tools  

🎨 **Beautiful CLI**
- Colorful, organized output  
- Progress indicators and status messages  

---

## Installation

```bash
# Clone the repository
git clone https://github.com/martencassel/dnsmgr/dnsmgr.git
cd dnsmgr

# Make the script executable
chmod +x dnsmgr

# (Optional) Install to your PATH
sudo cp dnsmgr /usr/local/bin/
```

---

## Usage

### Basic Commands

```bash
# Show help
dnsmgr

# Allocate next free domain from a pool
dnsmgr alloc --pool test1.local-test.test5.local --ip 127.0.0.1

# Add a specific domain → IP mapping
dnsmgr add myapp.local --ip 10.0.0.5

# List domains managed by dnsmgr
dnsmgr list

# Release a domain
dnsmgr release myapp.local

# Export domains for docker-compose
dnsmgr render-env --prefix MYAPP
```

---

## Examples

### Allocating Domains

```bash
$ dnsmgr alloc --pool app1.local-app5.local --ip 127.0.0.1
✓ Allocated app1.local → 127.0.0.1

$ dnsmgr alloc --pool app1.local-app5.local --ip 127.0.0.1
✓ Allocated app2.local → 127.0.0.1
```

### Adding Specific Domains

```bash
$ dnsmgr add mydb.local --ip 10.0.0.5
✓ Allocated mydb.local → 10.0.0.5
```

### Listing Allocations

```bash
$ dnsmgr list
Managed Domains
────────────────────────────
  mydb.local → 10.0.0.5
  app1.local → 127.0.0.1
  app2.local → 127.0.0.1
  (3 domain(s) allocated)
```

### Releasing Domains

```bash
$ dnsmgr release app1.local
✓ Released app1.local
```

### Environment Variable Export

```bash
$ dnsmgr render-env --prefix MYAPP
MYAPP_DOMAIN1=mydb.local
MYAPP_DOMAIN2=app2.local

# Use eval to export them to your shell
$ eval $(dnsmgr render-env --prefix MYAPP)
$ echo $MYAPP_DOMAIN1
mydb.local
```

---

## State File

All domain allocations are stored in `~/.dnsmgr_state`.  
Format: `<domain> <ip_address>`

Example:
```
mydb.local 10.0.0.5
app1.local 127.0.0.1
app2.local 127.0.0.1
```

---

## `/etc/hosts` Integration

`dnsmgr` manages a **dedicated block** in `/etc/hosts`:

```
# BEGIN DNSMGR
127.0.0.1 app1.local
127.0.0.1 app2.local
10.0.0.5 mydb.local
# END DNSMGR
```

This ensures your system’s existing `/etc/hosts` entries remain untouched.

---

## Use Cases

- **Container Networking**: Map test domains for Docker Compose services  
- **Testing Environments**: Quickly set up multiple domains for local testing  
- **Service Deployment**: Manage domain aliases for multiple services  
- **Development**: Create isolated domain environments  

---

## Troubleshooting

### Permission Denied
- Ensure the script is executable: `chmod +x dnsmgr`  
- You have `sudo` access (required for editing `/etc/hosts`)  

### Domains Not Resolving
- Verify `/etc/hosts` contains the managed block  
- Check that your system resolver is using `/etc/hosts`  

---

## License
MIT License — free to use in your projects!  

---
# dnsmgr
