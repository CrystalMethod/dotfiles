.PHONY: setup
setup:
	mise install
	prek install

.PHONY: test
test:
	TARGET_OS=macos bash ./scripts/run_unit_test.sh

.PHONY: format
format:
	shfmt --indent 4 --space-redirects --diff .

.PHONY: lint
lint:
	shellcheck install/common/*.sh install/macos/common/*.sh scripts/*.sh
