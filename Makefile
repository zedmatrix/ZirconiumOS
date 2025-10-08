
DRIVE ?= a
UEFI ?= 1
FORCE ?= 0
LFS ?= /mnt/lfs
YBUILD ?= $(LFS)/ybuild

install_ybuild := ca-bundle.crt yaml-install.sh Ybuild ydatabase.yaml
install_scripts := Chapter_05/install-ch5.sh Chapter_06/install-ch6.sh Chapter_08/install-ch8.sh Chapter_09/install-ch9.sh

$(foreach v,drive uefi force, \
  $(if $($(v)), $(eval $(shell echo $(v) | tr a-z A-Z) := $($(v))) ) )

all: prep filesystem sources crosstools basesystem extrapackages

prep:
	@echo "Preparing $(DRIVE) with $(LFS)"
	@[ $(UEFI) -eq 1 ] && echo "With UEFI $(UEFI)" || echo "With MBR $(UEFI)"
	@[ $(FORCE) -eq 1 ] && echo "Force Formatting $(FORCE)" || echo "Not Force the Filesystem"

filesystem: prep
	@[ -f Chapter_02/1-install-filesystem.sh ] && \
		Chapter_02/1-install-filesystem.sh $(DRIVE) \
		$(if $(UEFI),uefi,) \
		$(if $(FORCE),force,) || exit 1
	@[ -f Chapter_02/2-install-directories.sh ] && Chapter_02/2-install-directories.sh $(DRIVE) || exit 1

sources: filesystem
	@[ -d "$(LFS)/ybuild" ] || mkdir -p $(LFS)/ybuild || exit 1
	@[ -d "$(LFS)/ybuild/repos" ] || mkdir -p $(LFS)/ybuild/repos || exit 1
	@[ -d "$(LFS)/ybuild/Chapter_09" ] || mkdir -p $(LFS)/ybuild/Chapter_09 || exit 1

	@cp -av "Chapter_03/repos/"* "$(LFS)/ybuild/repos" || exit 1
	@cp -av "Chapter_07/"*.sh "$(LFS)/ybuild/" || exit 1
	@cp -av "Chapter_09/repos/"* "$(LFS)/ybuild/repos" || exit 1
	@cp -av "Chapter_09/"y*.sh "$(LFS)/ybuild/Chapter_09" || exit 1
	@cp -av "Chapter_11/repos/"* "$(LFS)/ybuild/repos" || exit 1
	@for file in $(install_ybuild); do \
		cp -av Chapter_03/$$file $(LFS)/ybuild; \
	done

	@for file in $(install_scripts); do \
		install -vm755 $$file $(LFS)/ybuild; \
	done

crosstools: sources
	cd $(YBUILD) && ./install-ch5.sh || exit 1
	cd $(YBUILD) && ./install-ch6.sh || exit 1
	cd $(YBUILD) && ./exec-lfs-chroot.sh 7-7-chapter-install.sh || exit 1

basesystem: crosstools
	cd $(YBUILD) && ./exec-lfs-chroot.sh install-ch8.sh || exit 1

extrapackages: basesystem
	cd $(YBUILD) && ./exec-lfs-chroot.sh install-ch9.sh || exit 1

.PHONY: all prep filesystem sources crosstools basesystem extrapackages
