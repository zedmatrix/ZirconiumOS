
DRIVE ?= sda
UEFI ?= 1
FORCE ?= 0
YLFS ?= /mnt/ylfs
YBUILD ?= $(YLFS)/ybuild

install_ybuild := ca-bundle.crt magic.mgc pkg-install.sh yaml-get ystrip-static Ybuild ydatabase.yaml
install_scripts := Chapter_05/install-ch5.sh Chapter_06/install-ch6.sh Chapter_08/install-ch8.sh Chapter_09/install-ch9.sh

$(foreach v,drive uefi force, \
  $(if $($(v)), $(eval $(shell echo $(v) | tr a-z A-Z) := $($(v))) ) )

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

sources: prep
	@[ -d "$(YLFS)/ybuild" ] || mkdir -p $(LFS)/ybuild || exit 1
	@[ -d "$(YLFS)/ybuild/repos" ] || mkdir -p $(LFS)/ybuild/repos || exit 1
	@[ -d "$(YLFS)/ybuild/Chapter_09" ] || mkdir -p $(LFS)/ybuild/Chapter_09 || exit 1

	@cp -av "Chapter_05/repos/"* "$(YLFS)/ybuild/repos" || exit 1
	@cp -av "Chapter_06/repos/"* "$(YLFS)/ybuild/repos" || exit 1
	@cp -av "Chapter_07/repos/"* "$(YLFS)/ybuild/repos" || exit 1
	@cp -av "Chapter_07/"*.sh "$(YLFS)/ybuild/" || exit 1
	@cp -av "Chapter_08/repos/"* "$(YLFS)/ybuild/repos" || exit 1
	@cp -av "Chapter_09/repos/"* "$(YLFS)/ybuild/repos" || exit 1
	@cp -av "Chapter_09/"y*.sh "$(YLFS)/ybuild/Chapter_09" || exit 1
	@cp -av "Chapter_11/repos/"* "$(YLFS)/ybuild/repos" || exit 1
	@for file in $(install_ybuild); do \
		cp -av Chapter_03/$$file $(YLFS)/ybuild; \
	done

	@for file in $(install_scripts); do \
		install -vm755 $$file $(YLFS)/ybuild; \
	done

crosstools: pre sources
	cd $(YBUILD) && ./install-ch5.sh || exit 1
	cd $(YBUILD) && ./install-ch6.sh || exit 1
	cd $(YBUILD) && ./exec-lfs-chroot.sh 7-7-chapter-install.sh || exit 1

basesystem: prep sources
	cd $(YBUILD) && ./exec-lfs-chroot.sh install-ch8.sh || exit 1

extrapackages: prep sources
	cd $(YBUILD) && ./exec-lfs-chroot.sh install-ch9.sh || exit 1

.PHONY: all prep filesystem sources crosstools basesystem extrapackages
