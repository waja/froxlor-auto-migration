# froxlor-auto-migration

A Debian package for automating [Froxlor](https://froxlor.org/) database [updates](https://docs.froxlor.org/latest/admin-guide/cli-scripts/#update) after upgrading the Froxlor debian package.

## ✅ Features

- ✅ Installs an **APT hook** in `/etc/apt/apt.conf.d/` to trigger on package upgrades  
- ✅ Deploys the **migration script** to `/usr/libexec/froxlor-auto-migration/db-migration.sh`  
- ✅ Ensures that **Froxlor migrations run once per version** automatically

## 🛠 Installation (local)

```bash
debuild -us -uc
sudo dpkg -i ../froxlor-auto-migration_*.deb
```

## 🔄 How it works

On every froxlor package upgrade, the hook checks whether a migration is needed — and runs it once per version if so.
