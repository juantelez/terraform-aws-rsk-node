Ansible
=======

Tasks
-----

Installs and a configure a _released_ `rskj` version.

- Installs the right OpenJDK
- Adds `rsk` user for running `rskj`
- Creates required directories and sets the right ownership
- Fetches released RSK version and checks its PGP signature
- Fetches a specific build of RSK available in some artifacts repo
- Copies configuration files
- Adds `rsk` SystemD service and ensures it's up and running

The following `group_vars` are used by this role:

- `rsk_network`: the symbolic name of the network. Must be one of
  `MainNet`, `TestNet` or `RegTest`.
- `rsk_blockchain_name`: the name of the network as expected by
  `blockchain.config.name` configuration option. Must be one of `main`,
  `testnet` or `regtest`.

Files
-----

- `AEIDELMAN.txt`, `rsk-release-signing-key.asc`: PGP signing keys
- `logback.xml`: logging configuration file.

Handlers
--------

- `Restart RSK`: triggered on JAR change or configurations changes

Templates
---------

- `node.conf.j2`: `rskj` config file. Sets `blockchain.name` and
  `database.dir`, overrides default `peer.connection.timeout`, adds
  host's DNS name and all its IP addresses for RPC. 
- `rsk.env.j2`: options for overriding `rsk.system` SystemD unit file
  values, to avoid running `systemctl daemon-reload` after modifying
  the service file.
  `{{ inventory_hostname }}/rsk.env.j2`
- `rsk.system.j2`: SystemD unit file for RSK.

Vars
----

- `openjdk_version`: either `8` or `11`
- `rskj_install_dir`: where `rsk.jar` is stored
- `rskj_workdir`: where to download RSK JAR and PGP keys for
  verification
- `rskj_cfg_dir`: where RSK config files are stored
- `rskj_data_dir`: where RSK DB is stored
- `rskj_logs_dir`: where RSK logs are stored

- `rskj_release_download_base_url`: URLs to fetch the JAR

- `rskj_version_number`, `rskj_version_codename`: the RSK release
  version number and codename, used to compute the release tag and the
  release JAR name
- `rskj_release_tag`, `rskj_download_jar`: computed from previous
