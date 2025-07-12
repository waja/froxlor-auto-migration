# Makefile

all: test install

test:
	# Checking for syntax errors
	set -e; for SCRIPT in scripts/*; \
	do \
		sh -n $$SCRIPT; \
	done

	# Checking for bashisms (currently not failing, but only listing)
	if [ -x /usr/bin/checkbashisms ]; \
	then \
		checkbashisms scripts/* || true; \
	else \
		echo "WARNING: skipping bashism test - you need to install devscripts."; \
	fi

	if [ -x /usr/bin/shellcheck ]; \
	then \
		shellcheck scripts/* || true; \
	else \
		echo "WARNING: skipping shellcheck test - you need to install shellcheck."; \
	fi

install:
	install -d $(DESTDIR)/usr/libexec/froxlor-auto-migration/
	install -m 755 scripts/db-migration.sh $(DESTDIR)/usr/libexec/froxlor-auto-migration/db-migration.sh
	install -d $(DESTDIR)/etc/apt/apt.conf.d/
	install -m 644 config/99froxlor-migrate $(DESTDIR)/etc/apt/apt.conf.d/99froxlor-migrate

uninstall:
	# Uninstalling scripts
	rm -f $(DESTDIR)/usr/libexec/froxlor-auto-migration/db-migration.sh
	# Uninstalling configs
	rm -f $(DESTDIR)/etc/apt/apt.conf.d/99froxlor-migrate

reinstall: uninstall install
