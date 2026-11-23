params ['_o'];if (isRemoteExecuted && {remoteExecutedOwner!=2}) exitWith {};if (isNull _o) exitWith {};
// Display cargo is a visual copy. Transfers go through the locker owner checks.
_o lockInventory true;
if !(_o getVariable ['TSL_inventoryLocked',false]) then {_o setVariable ['TSL_inventoryLocked',true];_o addEventHandler ['InventoryOpened',{true}];};
