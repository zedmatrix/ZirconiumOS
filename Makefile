SHELL := /bin/bash
DRIVE ?= sda
UEFI ?= 1
FORCE ?= 0
YLFS ?= /mnt/ylfs
YBLD ?= $(YLFS)/ybuild
YBUILD_RELEASE ?= systemd
.NOTPARALLEL:

$(foreach v,drive uefi force, \
  $(if $($(v)), $(eval $(shell echo $(v) | tr a-z A-Z) := $($(v))) ) )

install_ybuild := ca-bundle.crt magic.mgc pkg-install.sh yaml-get ystrip-static Ybuild ydatabase.yaml ydest-strip-x64.sh
install_scripts := Chapter_02/ybase_header.sh Chapter_02/ylfs-environment.sh Chapter_05/install-ch5.sh Chapter_06/install-ch6.sh \
 Chapter_08/install-ch8.sh Chapter_09/install-ch9.sh

all: prep filesystem sources crosstools basesystem extrapackages

prep:
	@echo "Preparing $(DRIVE) with $(YLFS)"
	@[ $(UEFI) -eq 1 ] && echo "With UEFI $(UEFI)" || echo "With MBR $(UEFI)"
	@[ $(FORCE) -eq 1 ] && echo "Force Formatting $(FORCE)" || echo "Not Force the Filesystem"

filesystem: prep
	@[ -f Chapter_02/1-install-filesystem.sh ] && \
		Chapter_02/1-install-filesystem.sh $(DRIVE) \
		$(if $(UEFI),uefi,) \
		$(if $(FORCE),force,) || exit 1
	@[ -f Chapter_02/2-install-directories.sh ] && Chapter_02/2-install-directories.sh $(DRIVE) || exit 1

directories:
	@[ -d "$(YBLD)" ] || mkdir -p $(YBLD) || exit 1
	@[ -d "$(YBLD)/repos" ] || mkdir -p $(YBLD)/repos || exit 1
	@[ -d "$(YBLD)/Chapter_09" ] || mkdir -p $(YBLD)/Chapter_09 || exit 1
	@cp -av "$(PWD)/Makefile" "$(YBLD)"
	@cp -av "Chapter_05/repos/"* "$(YBLD)/repos" || exit 1
	@cp -av "Chapter_06/repos/"* "$(YBLD)/repos" || exit 1
	@cp -av "Chapter_07/repos/"* "$(YBLD)/repos" || exit 1
	@cp -av "Chapter_07/"*.sh "$(YBLD)/prepare" || exit 1
	@cp -av "Chapter_08/repos/"* "$(YBLD)/repos" || exit 1
	@cp -av "Chapter_09/repos/"* "$(YBLD)/repos" || exit 1
	@cp -av "Chapter_09/"y*.sh "$(YBLD)/Chapter_09" || exit 1
	@cp -av "Chapter_10/repos/"* "$(YBLD)/repos" || exit 1
	@cp -av "Chapter_10/"*.sh "$(YBLD)/prepare" || exit 1
	@for file in $(install_ybuild); do \
		cp -av Chapter_03/$$file $(YBLD); \
	done

	@for file in $(install_scripts); do \
		install -vm755 $$file $(YBLD)/prepare; \
	done

sources:
	cp -nv "Chapter_03/sources"/* $(YBLD)/sources

crosstools:
	cd $(YBLD)/prepare && $(YBLD)/prepare/install-ch5.sh
	cd $(YBLD)/prepare && $(YBLD)/prepare/install-ch6.sh
	cd $(YBLD) && $(YBLD)/prepare/exec-lfs-chroot.sh prepare/7-7-chapter-install.sh

basesystem:
	cd $(YBLD) && $(YBLD)/prepare/exec-lfs-chroot.sh prepare/install-ch8.sh

extrapackages:
	cd $(YBLD) && $(YBLD)/prepare/exec-lfs-chroot.sh prepare/install-ch9.sh

.PHONY: all prep filesystem directories sources crosstools basesystem extrapackages
