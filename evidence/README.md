# Evidence inventory

This directory is reserved for device-originated evidence and checksummed
copies. Do not commit proprietary firmware, private identifiers or partition
images without confirming redistribution rights and scrubbing secrets.

The user supplied that these files exist locally:

- `config.gz` — compressed stock kernel config.
- `report.txt` — device report.

They were not present in the GitHub repository at the paths checked during
source audit. Keep the original files unchanged when adding them; record
SHA-256 hashes and collection date in a separate manifest.

No stock boot, recovery, DTB, DTBO, vbmeta or complete firmware backup is
currently established for this project.
