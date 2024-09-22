# disk.s
### Disk r/w functions

## Functions
### diskRead()
Reads sectors from the disk

Arguments:
- AX - LBA address low
- BX - LBA address high
- CX - Sector count
- DL - Drive number
- DI - Destination

Returns:
- CF - 0 if success, 1 if failed

### diskWrites()
Writes sectors to the disk

Arguments:
- AX - LBA address low
- BX - LBA address high
- CX - Sector count
- DL - Drive number
- SI - Source

Returns:
- CF - 0 if success, 1 if failed

