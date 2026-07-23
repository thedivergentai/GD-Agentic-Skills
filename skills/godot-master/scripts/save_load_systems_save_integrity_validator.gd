# save_integrity_validator.gd
extends RefCounted
class_name SaveIntegrityValidator

## Rolling backup + SHA-256 integrity check before trusting a save slot.
## Pair with save_migration_manager.gd and save_system_encryption.gd.

static func create_backup(primary_path: String, backup_path: String) -> bool:
	if not FileAccess.file_exists(primary_path):
		return false
	return DirAccess.copy_absolute(primary_path, backup_path) == OK


static func verify_sha256(path: String, expected_hash: String) -> bool:
	if expected_hash.is_empty() or not FileAccess.file_exists(path):
		return false
	return FileAccess.get_sha256(path) == expected_hash


static func safe_write_with_backup(
	primary_path: String,
	backup_path: String,
	write_callable: Callable
) -> bool:
	create_backup(primary_path, backup_path)
	return write_callable.call() == OK
