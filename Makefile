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
	shellcheck -x install/common/*.sh install/macos/common/*.sh install/ubuntu/common/*.sh scripts/*.sh
