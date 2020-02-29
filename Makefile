coreos-installer:
	docker run \
		--rm \
		-v $$PWD:/var/host \
		rustlang/rust:nightly-buster \
		bash -c "cargo install coreos-installer --version $$VERSION && cp \$$CARGO_HOME/bin/coreos-installer /var/host/"